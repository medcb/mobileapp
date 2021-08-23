import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/widgets/photo_crop_screen.dart';

class PhotoShutterScreenArguments {
  final Function(RecipePhotoData)? completion;

  PhotoShutterScreenArguments({this.completion});
}

class PhotoShutterScreen extends StatefulWidget {
  const PhotoShutterScreen({Key? key, required this.arguments})
      : super(key: key);

  final PhotoShutterScreenArguments arguments;

  @override
  _PhotoShutterScreenState createState() => _PhotoShutterScreenState();
}

class _PhotoShutterScreenState extends State<PhotoShutterScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_controller == null || _controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _onNewCameraSelected(_controller!.description);
      }
    }
  }

  void _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.length > 0) {
        _onNewCameraSelected(_cameras![0]);
      }
    } on CameraException catch (err) {
      print(err);
    }
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        print('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (err) {
      print(err);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _takePicture() async {
    if (_controller == null) return;
    try {
      final image = await _controller!.takePicture();
      Navigator.pushReplacementNamed(
        context,
        RouteName.photoCrop,
        arguments: PhotoCropScreenArguments(
          image.path,
          completion: widget.arguments.completion,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  void _selectFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Navigator.pushReplacementNamed(
          context,
          RouteName.photoCrop,
          arguments: PhotoCropScreenArguments(
            image.path,
            completion: widget.arguments.completion,
          ),
        );
      }
    } catch (err) {
      print(err);
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Builder(
            builder: (context) {
              if (!(_controller?.value.isInitialized ?? false)) {
                return Container(
                  color: CashbackColors.photoBackgroundColor,
                );
              }
              return Stack(
                children: [
                  Container(
                    color: CashbackColors.photoBackgroundColor,
                  ),
                  Center(
                    child: CameraPreview(_controller!),
                  ),
                  // CameraPreview(_controller!),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: IconButton(
                            onPressed: _takePicture,
                            icon: Image.asset(
                              'assets/images/camera_shutter_button.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: (constraints.maxWidth / 2 - 58) / 2,
                    bottom: 14,
                  ),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: IconButton(
                      onPressed: _selectFromGallery,
                      icon: Image.asset(
                        'assets/images/camera_gallery_button.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: _goBack,
                iconSize: 24,
                icon: Image.asset(
                  'assets/images/back_circle_icon.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
