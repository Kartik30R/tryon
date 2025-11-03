 import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {

  final GlobalKey _screenshotKey = GlobalKey();

  String _aiResponse = "Tap the AI button to analyze the screen...";
  bool _isLoading = false;


 final String _prompt = """
You are an AI Stylist. This is an AR try-on; treat the virtual garment as if it's real.
give answer directly in below format
Provide your analysis in this exact format:
**Suitability:** [Your analysis of whether it suits the user, considering color, fit, and style]

**Occasions:** [A brief intro to the occasions]
* [Occasion 1]
* [Occasion 2]
* [Occasion 3]

**Completing the Look:**
* **Bottoms:** [Your suggestions for pants/bottoms, including types and colors]
* **Shoes:** [Your suggestions for shoes, including types and colors]


give answer directly in above format
""";

  Future<void> _analyzeScreen() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "Capturing screen...";
    });

    try {

      final Uint8List? imageBytes = await _captureScreenshot();

      if (imageBytes == null) {
        throw Exception("Could not capture screenshot.");
      }

      setState(() {
        _aiResponse = "Analyzing image...";
      });


      final String response = await _getAiResponse(imageBytes);

      setState(() {
        _aiResponse = response;
      });
    } catch (e) {
      setState(() {
        _aiResponse = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<Uint8List?> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing screenshot: $e");
      return null;
    }
  }


  Future<String> _getAiResponse(Uint8List imageBytes) async {

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      return "API Key not found.";
    }



    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );


    final imagePart = DataPart('image/png', imageBytes);


    final promptPart = TextPart(_prompt);


    final response = await model.generateContent([
      Content.multi([promptPart, imagePart])
    ]);

    return response.text ?? "No response from AI.";
  }

  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
      key: _screenshotKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AI Screen Reader"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "User Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.person_pin, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 10),
              const Text("Username: @flutter_dev"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Edit Profile"),
              ),
              const SizedBox(height: 40),


              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _aiResponse,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _analyzeScreen,
          tooltip: 'Analyze Screen',
          child: _isLoading ? const SizedBox.shrink() : const Icon(Icons.remove_red_eye_rounded),
        ),
      ),
    );
  }
}