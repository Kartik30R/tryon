import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TryOnPage extends StatefulWidget {
  final String wannaUrl; // <-- Accept the URL
  const TryOnPage({Key? key, required this.wannaUrl}) : super(key: key);

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  late final WebViewController _controller;
  bool _isWebViewReady = false;
  final GlobalKey _screenshotKey = GlobalKey();
  String? _response;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    if (Platform.isAndroid) {
      AndroidWebViewController.enableDebugging(true);
    }
    await _requestPermissions();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isWebViewReady = true);
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.wannaUrl), // <-- Use the passed-in URL
      );

    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setOnPlatformPermissionRequest(
        (request) async => await request.grant(),
      );
      await androidController.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  Future<void> _runAnalysis() async {
    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final imageBytes = await _captureScreenshot();
      if (imageBytes == null) throw Exception("Screenshot failed.");

      final result = await _getAiResponse(imageBytes);
      setState(() {
        _response = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<Uint8List?> _captureScreenshot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      RenderRepaintBoundary? boundary =
          _screenshotKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint("Screenshot boundary not found.");
        return null;
      }
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Screenshot error: $e");
      return null;
    }
  }

  Future<String> _getAiResponse(Uint8List imageBytes) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) return "API key missing.";

    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
    
const prompt = """
    You are a friendly and supportive fashion companion, analyzing an AR virtual try-on image (AR model can be cloths , watches , shoes, scaft, jewellery).
    The person in the image is digitally wearing an item (like clothing, shoes, a scarf, or jewelry) through AR. Imagine it's a real item they're trying on.

    Your tone should be positive, encouraging, and conversational, like a best friend giving helpful advice.
    
    If the item looks great, say so! (e.g., "Wow, this color is fantastic on you!"). 
    If it doesn't seem like a perfect match, be gentle and suggest alternatives (e.g., "This is a nice piece, but I think a warmer tone might make your features pop even more.").
    
    Focus on how the item complements their natural appearance. Avoid mentioning AR, fit, or size.

    Your response MUST begin *directly* with `**Suitability:**` and follow the format precisely. Do not add any greeting or preamble before it.

    **Suitability:** [Your friendly analysis on how the item's color, style, and vibe work with their features and complexion. Be positive or offer gentle alternatives.]
    **Occasions:** * [Occasion 1 e.g., "A casual brunch with friends"]
    * [Occasion 2 e.g., "Date night!"]
    * [Occasion 3 e.g., "Just looking stylish at the office"]
    **Completing the Look:**
    * **Bottoms:** [Friendly suggestions for pants, skirts, etc. that would match]
    * **Shoes:** [Friendly suggestions for footwear that would match]
    * **Accessories:** [Friendly suggestions for jewelry, bags, etc. to complete the look]
    """;

    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/png', imageBytes),
      ])
    ]);
    return response.text ?? "No response from AI.";
  }

 Widget _buildStyledResponse(String text) {
  final lines = text.split('\n');
  final boldRegex = RegExp(r'\*\*(.*?)\*\*'); // matches **text**

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: lines.map((line) {
      if (line.trim().isEmpty) return const SizedBox(height: 8);

      // Bullet points (* )
      if (line.trim().startsWith('* ')) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ',
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              Expanded(
                child: Text(
                  line.trim().substring(2),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      }

      // Bold markdown (**text** inside line)
      final spans = <TextSpan>[];
      var lastIndex = 0;
      for (final match in boldRegex.allMatches(line)) {
        if (match.start > lastIndex) {
          spans.add(TextSpan(
            text: line.substring(lastIndex, match.start),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ));
        }
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
        lastIndex = match.end;
      }

      if (lastIndex < line.length) {
        spans.add(TextSpan(
          text: line.substring(lastIndex),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: RichText(text: TextSpan(children: spans)),
      );
    }).toList(),
  );
}

  @override
  Widget build(BuildContext context) {
    final sheetHeight = _response == null && !_isLoading
        ? 200.0
        : MediaQuery.of(context).size.height * 0.45;

    return Scaffold(
      body: SafeArea(
        child: RepaintBoundary(
          key: _screenshotKey,
          child: Stack(
            children: [
              _isWebViewReady
                  ? WebViewWidget(controller: _controller)
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  height: sheetHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, -3),
                      )
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _isLoading
                      ? Center(
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: Colors.pinkAccent,
                            rightDotColor: Colors.blueAccent,
                            size: 50,
                          ),
                        )
                      : _response == null
                          ? FloatingActionButton.extended(
                              backgroundColor: Colors.black,
                              onPressed: _runAnalysis,
                              icon: const Icon(Icons.style, color: Colors.white),
                              label: const Text(
                                "Ask your AI Stylist",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: _buildStyledResponse(_response!),
                            ),
                ),
              ),
              Container(height: 50,width: double.infinity, color: Colors.white, child:Center(child: Text("TRYON", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),))),
            ],
          ),
        ),
      ),
    );
  }
}
