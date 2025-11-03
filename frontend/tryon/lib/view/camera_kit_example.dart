import 'package:flutter/material.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';

class CameraKitExample extends StatefulWidget {
  final String lensId; // 👈 Add this line

  const CameraKitExample({super.key, required this.lensId}); // 👈 Require lensId

  @override
  State<CameraKitExample> createState() => _CameraKitExampleState();
}

class _CameraKitExampleState extends State<CameraKitExample>
    implements CameraKitFlutterEvents {
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);

    // 👇 Automatically open the camera with this lens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cameraKitFlutterImpl.openCameraKitWithSingleLens(
       groupId: "5b29451d-1ba0-403c-92cd-614b5eb54be9",

        lensId: widget.lensId,
        isHideCloseButton: false,
      );
    });
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    final filePath = result['path'] as String?;
    final fileType = result['type'] as String?;
    debugPrint('Captured: $filePath ($fileType)');
  }

  @override
  void receivedLenses(List<Lens> lensList) {
    debugPrint('Received ${lensList.length} lenses');
  }

  @override
  Widget build(BuildContext context) {
    // simple loader / fallback
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
