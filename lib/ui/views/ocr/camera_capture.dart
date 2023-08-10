import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/application/style/icon_constants.dart';
import 'package:lottie/lottie.dart';


List<CameraDescription> cameras = [];

enum ScreenMode { liveFeed, gallery }

class CameraCapture extends StatefulWidget {
  CameraCapture(
      {Key? key,
      required this.title,
      required this.onImage,
      this.overlay,
      this.text,
      this.isLoading,
      this.onScreenModeChanged,
      this.captureDisabled = true,
      this.captureHidden = false,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  bool? isLoading;
  final Widget? overlay;
  final String? text;
  final Function(
          InputImage? inputImage, int type, CameraImage? image, dynamic file)
      onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;
  bool captureDisabled;
  bool captureHidden;

  @override
  _CameraCaptureState createState() => _CameraCaptureState();
}

class _CameraCaptureState extends State<CameraCapture>
    with WidgetsBindingObserver {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  dynamic _image;
  // dynamic isLoading;
  String? _path;
  ImagePicker? _imagePicker;
  int _cameraIndex = 0;
  final bool _allowPicker = true;
  bool _manualCapture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _imagePicker = ImagePicker();

    availableCameras().then((_cameras) {
      cameras = _cameras;

      if (cameras.any(
        (element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90,
      )) {
        _cameraIndex = cameras.indexOf(
          cameras.firstWhere((element) =>
              element.lensDirection == widget.initialDirection &&
              element.sensorOrientation == 90),
        );
      } else {
        _cameraIndex = cameras.indexOf(
          cameras.firstWhere(
            (element) => element.lensDirection == widget.initialDirection,
          ),
        );
      }

      _startLiveFeed();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? Scaffold(
            backgroundColor: Constants.pink,
            body: Center(
              child: Lottie.asset(
                IconConstants.loaderIcon,
              ),
            ),
          )
        : Scaffold(
            /*appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _switchScreenMode,
                child: Icon(
                  _mode == ScreenMode.liveFeed
                      ? Icons.photo_library_outlined
                      : (Platform.isIOS
                      ? Icons.camera_alt_outlined
                      : Icons.camera),
                ),
              ),
            ),
        ],
      ),*/
            body: widget.isLoading == true
                ? Center(
                    child: Lottie.asset(
                      IconConstants.loaderIcon,
                    ),
                  )
                : _body(),
            floatingActionButton:
                !widget.captureHidden ? _floatingActionButton() : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  Widget? _floatingActionButton() {
    if (_mode == ScreenMode.gallery) return null;
    if (cameras.length == 1) return null;

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
              height: 70.0,
              width: 70.0,
              child: FloatingActionButton(
                backgroundColor: widget.captureDisabled
                    ? const Color.fromRGBO(255, 255, 255, .4)
                    : Constants.primaryColor,
                child: Icon(
                  Platform.isIOS ? Icons.camera_alt_outlined : Icons.camera,
                  size: 40,
                  color: widget.captureDisabled
                      ? Colors.transparent
                      : Colors.white,
                ),
                onPressed: widget.captureDisabled
                    ? null
                    : () async {
                        _manualCapture = true;
                      },
              )),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            width: 70.0,
            height: 70.0,
            child: InkWell(
              child: const Icon(
                Icons.image,
                size: 40,
                color: Colors.white,
              ),
              onTap: () async {
                _getImage(ImageSource.gallery);
              },
            ),
          ),
        )
      ],
    );

    return Container(
        height: 70.0,
        width: 70.0,
        color: Colors.yellow,
        child: FloatingActionButton(
          child: Icon(
            Platform.isIOS ? Icons.camera_alt_outlined : Icons.camera,
            size: 40,
            color:
                widget.captureDisabled ? Colors.white : Constants.primaryColor,
          ),
          onPressed: widget.captureDisabled
              ? null
              : () async {
                  _manualCapture = true;
                },
        ));
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller == null || _controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),
          if (widget.overlay != null) widget.overlay!,
          Positioned(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset('assets/svg/close.svg',
                    width: 36, height: 36, color: Constants.white),
              ),
              top: 24,
              right: 12)
        ],
      ),
    );
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                ],
              ),
            )
          : const Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: const Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: const Text('Take a picture'),
          onPressed: () => _getImage(ImageSource.camera),
        ),
      ),
      if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              '${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
        ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    _stopLiveFeed();

    final pickedFile = await _imagePicker?.pickImage(
        source: source, imageQuality: 80, maxWidth: 1200);

    _startLiveFeed();
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  void _switchScreenMode() {
    _image = null;
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;

      _stopLiveFeed();
    } else {
      _mode = ScreenMode.liveFeed;
      _startLiveFeed();
    }
    if (widget.onScreenModeChanged != null) {
      widget.onScreenModeChanged!(_mode);
    }
    setState(() {});
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];

    _controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    await _controller?.initialize();

    if (widget.isLoading == true) {}

    if (!mounted) {
      return;
    }

    _controller?.startImageStream(_processCameraImage);

    setState(() {});
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;

    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
      widget.isLoading = true;
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);

    setState(() {
      widget.isLoading = true;
    });

    // widget.onImage(inputImage, _manualCapture ? 2 : 1, image, null);
    widget.onImage(inputImage, 3, null, _image);
  }

  Future _processCameraImage(CameraImage image) async {
    if (_controller == null) return;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    if (_manualCapture) {
      await _stopLiveFeed();
    }

    widget.onImage(inputImage, _manualCapture ? 2 : 1, image, null);
  }
}
