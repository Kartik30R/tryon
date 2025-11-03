import 'dart:io';  

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

  import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';



class TryOnPage extends StatefulWidget {
  const TryOnPage({Key? key}) : super(key: key);

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  late final WebViewController _controller;
  bool _isWebViewReady = false;  

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
          onWebResourceError: (error) {
            debugPrint("WebView error: ${error.description}");
            debugPrint("WebView error code: ${error.errorCode}");
            debugPrint("WebView error URL: ${error.url}");
          },
          onPageStarted: (url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (url) {
            debugPrint("Page finished loading: $url");

            if (mounted) {
              setState(() {
                _isWebViewReady = true;
              });
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://wanna-clothes.ar.wanna.fashion/?mode=vto&showonboarding=3d&modelid=WNCLO01&startwithid=WNCLO01',
        ),
      );
    

    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      

      androidController.setOnPlatformPermissionRequest(
        (request) async {
          debugPrint('Granting web permission for: ${request.types}');
          await request.grant();
        },
      );
      
   
   
      await androidController.setMediaPlaybackRequiresUserGesture(false);
    } else if (_controller.platform is WebKitWebViewController) {

    }
  }


  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
    
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;
    debugPrint("Camera permission status: $cameraStatus");
    debugPrint("Microphone permission status: $micStatus");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(

        child: _isWebViewReady
            ? Container(child: Stack(
              children: [
                 WebViewWidget(controller: _controller),
                Container(height: 60,color: Colors.white,),
 Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          "Bottom Toolbar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),               
              ],
            ))
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

