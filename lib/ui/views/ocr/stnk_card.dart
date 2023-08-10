import 'dart:math';
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/ui/views/ocr/camera_capture.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;


import 'dart:typed_data';

class StnkCard extends StatefulWidget {
  final Function(List<int>)? onChanged;

  const StnkCard({Key? key, this.onChanged}) : super(key: key);

  @override
  State<StnkCard> createState() => _StnkCardState();
}

class _StnkCardState extends State<StnkCard> {
  Image? _image;
  int tipe = 0;
  ObjectDetector? _objectDetector;
  late Convert conv;
  bool _processing = false;
  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      conv = convertImageLib
          .lookup<NativeFunction<convert_func>>('convertImage')
          .asFunction<Convert>();
    }

    //_initializeDetector(DetectionMode.stream);
  }

  void _initializeDetector(DetectionMode mode) async {
    const path = 'assets/ml/kliknss-2909222059.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        double height = MediaQuery.of(context).size.height * .88;
        double width = height / 2.8;

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraCapture(
                  title: 'Foto STNK',
                  captureDisabled: false,
                  overlay: Container(
                    decoration: ShapeDecoration(
                      shape: StnkShapeBorder(
                          cutOutHeight: height, cutOutWidth: width),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0,
                            left: 10,
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: Container(
                                  width: (MediaQuery.of(context).size.height),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(
                                            Constants.spacing4),
                                        child: const Text(
                                            'Posisikan STNK didalam kotak dan tekan tombol kamera',
                                            style: TextStyle(
                                                fontFamily:
                                                    Constants.primaryFontBold)),
                                        color: const Color.fromRGBO(
                                            255, 255, 255, .7),
                                      )
                                    ],
                                  ),
                                )))
                      ],
                    ),
                  ),
                  onImage: (inputImage, manual, cameraImage, file) async {
                    if (manual == 2) {
                      setState(() {
                        tipe = manual;
                      });

                      Navigator.of(context).pop({
                        'inputImage': inputImage,
                        'cameraImage': cameraImage
                      });
                    } else if (manual == 3) {
                      setState(() {
                        tipe = manual;
                      });

                      Navigator.of(context).pop({
                        'inputImage': inputImage,
                        'cameraImage': cameraImage,
                        'file': file,
                      });
                    } else {
                      if (inputImage != null) {
                        detect(inputImage);
                      }
                    }
                  })),
        );

        if (result != null && tipe == 2) {
          CameraImage cameraImage = result['cameraImage'];
          imglib.Image? img = convertImage(cameraImage);

          img = imglib.copyRotate(img!, 270);

          int imgWidth = img.width;
          int imgHeight = img.height;

          if (imgWidth > 800) {
            img = imglib.copyResize(img,
                width: 1200, height: (imgHeight / imgWidth * 800).round());
            imgWidth = img.width;
            imgHeight = img.height;
          }

          int w = (imgWidth * .88).round();
          int h = (w / 2.8).round();
          int x = ((imgWidth - w) / 2).round();
          int y = ((imgHeight - h) / 2).round();
          img = imglib.copyCrop(img, x, y, w, h);
          List<int> jpg = imglib.encodeJpg(img);
          Uint8List bytes = Uint8List.fromList(jpg);

          setState(() {
            _image = Image.memory(bytes);
          });

          widget.onChanged!(jpg);
        } else if (result != null && tipe == 3) {
          setState(() {
            _image = Image.file(
              result['file'],
            );
          });

          List<int> jpg = result['file'].readAsBytesSync();

          widget.onChanged!(jpg);

          // dynamic image = imglib.decodeImage(jpge);
          // var images =
          //     await decodeImageFromList(result['file'].readAsBytesSync());
          // var maxWidth = 1200;
          // var scale = maxWidth / image.width;
          // var newHeight = (image.height * scale).round();
          // dynamic jpgresize;
          // if (images.width > 800) {
          //   jpgresize =
          //       imglib.copyResize(image, width: maxWidth, height: newHeight);
          // } else {
          //   jpgresize = image;
          // }

          // dynamic jpg = imglib.encodeJpg(jpgresize, quality: 80);

          // dynamic jpg = imglib.copyResize(jpgs, width: 800);

          // Uint8List imgbytes = await result['file'].readAsBytes();

          // setState(() {
          //   _image = Image.memory(imgbytes);

          //   Image.file(result['file']);

          //   widget.onChanged!(imgbytes);
          // });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Constants.gray.shade100,
            border: Border.all(color: Constants.gray.shade200),
            borderRadius:
                const BorderRadius.all(Radius.circular(Constants.spacing3))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 2.8,
        // ignore: prefer_if_null_operators
        child: _image != null
            ? _image
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _image != null
                      ? Container()
                      : Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            'assets/images/takecamera.png',
                            scale: 6.5,
                          ),
                        ),
                  _image != null
                      ? Container()
                      : Text(
                          'Ketuk untuk mengambil gambar',
                          style: TextStyle(
                            fontSize: Constants.fontSizeLg,
                            color: Constants.gray.shade300,
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  imglib.Image? convertImage(CameraImage image) {
    imglib.Image? img;

    if (Platform.isAndroid) {
      // Allocate memory for the 3 planes of the image
      Pointer<Uint8> p = calloc<Uint8>(image.planes[0].bytes.length);
      Pointer<Uint8> p1 = calloc<Uint8>(image.planes[1].bytes.length);
      Pointer<Uint8> p2 = calloc<Uint8>(image.planes[2].bytes.length);

      // Assign the planes data to the pointers of the image
      Uint8List pointerList = p.asTypedList(image.planes[0].bytes.length);
      Uint8List pointerList1 = p1.asTypedList(image.planes[1].bytes.length);
      Uint8List pointerList2 = p2.asTypedList(image.planes[2].bytes.length);
      pointerList.setRange(
          0, image.planes[0].bytes.length, image.planes[0].bytes);
      pointerList1.setRange(
          0, image.planes[1].bytes.length, image.planes[1].bytes);
      pointerList2.setRange(
          0, image.planes[2].bytes.length, image.planes[2].bytes);

      // Call the convertImage function and convert the YUV to RGB
      Pointer<Uint32> imgP = conv(
          p,
          p1,
          p2,
          image.planes[1].bytesPerRow,
          image.planes[1].bytesPerPixel!,
          image.planes[0].bytesPerRow,
          image.height);

      // Get the pointer of the data returned from the function to a List
      List<int> imgData =
          imgP.asTypedList((image.planes[0].bytesPerRow * image.height));
      // Generate image from the converted data
      img = imglib.Image.fromBytes(
          image.height, image.planes[0].bytesPerRow, imgData);

      // Free the memory space allocated
      // from the planes and the converted data
      calloc.free(p);
      calloc.free(p1);
      calloc.free(p2);
      calloc.free(imgP);
    } else if (Platform.isIOS) {
      img = imglib.Image.fromBytes(
        image.planes[0].bytesPerRow ~/ 4,
        image.height,
        image.planes[0].bytes,
        format: imglib.Format.bgra,
      );
    }

    return img;
  }

  Future<void> detect(InputImage inputImage) async {
    if (_objectDetector == null || _processing == true) return;

    _processing = true;

    final objects = await _objectDetector!.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      for (final DetectedObject detectedObject in objects) {
        for (final Label label in detectedObject.labels) {}
      }
    }

    _processing = false;
  }
}

class StnkShapeBorder extends ShapeBorder {
  const StnkShapeBorder({
    this.borderColor = Colors.white,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 90),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 200,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 560;

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;

    final borderOffset = borderWidth / 2;
    final _borderLength =
        borderLength > min(cutOutHeight, cutOutHeight) / 2 + borderWidth * 2
            ? borderWidthSize / 2
            : borderLength;
    final _cutOutWidth =
        cutOutWidth < width ? cutOutWidth : width - borderOffset;
    final _cutOutHeight =
        cutOutHeight < height ? cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    double rxL = rect.left + width / 2 - _cutOutWidth / 2 + borderOffset;
    double rxT = -cutOutBottomOffset +
        rect.top +
        height / 2 -
        _cutOutHeight / 2 +
        borderOffset;
    double rxW = _cutOutWidth - borderOffset * 2;
    double rxH = _cutOutHeight - borderOffset * 2;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutWidth / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2 -
          _cutOutHeight / 2 +
          borderOffset,
      _cutOutWidth - borderOffset * 2,
      _cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + _borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + _borderLength,
          cutOutRect.top + _borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.bottom - _borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - _borderLength,
          cutOutRect.left + _borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return StnkShapeBorder(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);

typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);
