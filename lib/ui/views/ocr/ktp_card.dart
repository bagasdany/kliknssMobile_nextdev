import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:kliknss77/application/style/constants.dart';
import 'package:kliknss77/application/style/icon_constants.dart';
import 'package:kliknss77/ui/views/ocr/camera_capture.dart';
import 'package:kliknss77/ui/views/ocr/ktp_overlay.dart';

import 'package:lottie/lottie.dart';

import 'dart:ffi';
import 'dart:io';

import 'dart:typed_data';

import 'dart:io' as io;

import 'package:flutter/scheduler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);

typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

Future<Image?> convertYUV420toImage(CameraImage image) async {
  try {
    final int width = image.width;
    final int height = image.height;

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final pixelColor = image.planes[0].bytes[y * width + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        img.data[y * width + x] =
            (0xFF << 24) | (pixelColor << 16) | (pixelColor << 8) | pixelColor;
      }
    }

    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    List<int> png = pngEncoder.encodeImage(img);
    Uint8List bytes = Uint8List.fromList(png);
    return Image.memory(bytes);
  } catch (e) {
    return null;
  }
}

Future<Image?> convertYUV420toImageColor(CameraImage image) async {
  try {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;

    //print("uvRowStride: " + uvRowStride.toString());
    //print("uvPixelStride: " + uvPixelStride.toString());

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
      }
    }

    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    List<int> png = pngEncoder.encodeImage(img);
    Uint8List bytes = Uint8List.fromList(png);
    return Image.memory(bytes);
  } catch (e) {}
  return null;
}

class KTPCard extends StatefulWidget {
  final Function(List<int>, String?)? onChanged;

  const KTPCard({Key? key, this.onChanged}) : super(key: key);

  @override
  _KTPCard createState() => _KTPCard();
}

class _KTPCard extends State<KTPCard> {
  Image? _image;
  dynamic isLoading;

  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();

  late Convert conv;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      conv = convertImageLib
          .lookup<NativeFunction<convert_func>>('convertImage')
          .asFunction<Convert>();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  imglib.Image? convertImage(CameraImage image) {
    //print('########1212##1231# image ${image.width} ${image.height}');

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

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: Lottie.asset(
              IconConstants.loaderIcon,
            ),
          )
        : InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KTPDetectorView()),
              );
              if (result != null) {
                CameraImage? cameraImage = result['cameraImage'];
                File? file = result['file'];

                if (cameraImage != null) {
                  imglib.Image? img = convertImage(cameraImage);

                  int imgWidth = img!.width;
                  int imgHeight = img.height;
                  if (imgWidth > 800) {
                    img = imglib.copyResize(img,
                        width: 1200,
                        height: (imgHeight / imgWidth * 800).round());
                  }
                  imglib.encodeJpg(img);
                  int w = (imgWidth * .95).round();
                  int h = ((w / 1.586) * 1.1).round();
                  int x = ((imgWidth - w) / 2).round();
                  int y = (imgHeight * .22).round();
                  //print("imgWidth: ${imgWidth}, imgHeight: ${imgHeight}, w: ${w}, h: ${h}, x: ${x}, y: ${y}");
                  img = imglib.copyCrop(img, x, y, w, h);

                  List<int> jpg = imglib.encodeJpg(img);
                  Uint8List bytes = Uint8List.fromList(jpg);

                  /*XFile xfile = XFile.fromData(bytes);
          int xfileLength = File(xfile.path).lengthSync();
          print("XFile ${xfile.path}, size: ${xfileLength}");*/

                  setState(() {
                    _image = Image.memory(bytes);
                  });

                  widget.onChanged!(jpg, result['ktpNumber']);
                } else if (file != null) {
                  setState(() {
                    _image = Image.file(
                      file,
                    );
                  });

                  List<int> jpg = file.readAsBytesSync();

                  widget.onChanged!(jpg, '');

                  // print("proses manual 11");
                  // setState(() {
                  //   isLoading = true;
                  // });
                  // // dynamic image = imglib.decodeImage(jpge);

                  // print("proses manual 12");
                  // var images =
                  //     await decodeImageFromList(file.readAsBytesSync());

                  // print("proses manual 13");
                  // var maxWidth = 1200;
                  // var scale = maxWidth / _image!.width!;
                  // var newHeight = (_image!.height! * scale).round();
                  // print("ktpImageBytesImages $images");

                  // print("proses manual 14");
                  // dynamic jpgresize;
                  // if (images.width > 800) {
                  //   jpgresize = imglib.copyResize(_image!,
                  //       width: maxWidth, height: newHeight);
                  // } else {
                  //   jpgresize = image;
                  // }

                  // print("proses manual 15");

                  // print("ktpImageBytes111 $jpgresize");
                  // dynamic jpg = imglib.encodeJpg(jpgresize, quality: 80);

                  // print("proses manual 16");
                  // // dynamic jpg = imglib.copyResize(jpgs, width: 800);
                  // print("ktpImageBytes222 $jpg");

                  //  List<int> jpge = file.readAsBytesSync();
                  // dynamic image = imglib.decodeImage(jpge);
                  // dynamic compressjpg = imglib.encodeJpg(image, quality: 80);
                  // dynamic jpg = imglib.copyResize(compressjpg, width: 800);
                  // widget.onChanged!(jpg, '');

                  //            Image image = decodeImage(file.readAsBytesSync());
                  // image = copyResize(image, width: 1200);
                  // List<int> compressed = encodePng(image);
                  // await File(file.path.replaceAll(".xfile", "_compressed.xfile"))
                  //     .writeAsBytes(compressed);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Constants.gray.shade100,
                  border: Border.all(color: Constants.gray.shade200),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Constants.spacing3))),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.586,
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
                                  scale: 4.5,
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
}

class KTPDetectorView extends StatefulWidget {
  @override
  _KTPDetectorView createState() => _KTPDetectorView();
}

class _KTPDetectorView extends State<KTPDetectorView> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  late ObjectDetector _objectDetector;
  bool _canProcess = false;
  bool _isBusy = false;
  dynamic isLoading;
  String? _text;
  bool objectDetected = false;
  int state = 0;

  @override
  void initState() {
    super.initState();

    _initializeDetector(DetectionMode.stream);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector.close();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            backgroundColor: Constants.white,
            body: Center(
              child: Lottie.asset(
                IconConstants.loaderIcon,
              ),
            ),
          )
        : CameraCapture(
            title: 'Foto KTP',
            overlay: KtpOverlay(
              borderColor:
                  objectDetected ? Constants.primaryColor : Colors.white,
              state: state,
            ),
            text: _text,
            isLoading: isLoading,
            captureDisabled: state < 2,
            onImage: (inputImage, manual, cameraImage, file) async {
              if (manual == 2) {
                Navigator.of(context).pop({
                  'ktpNumber': '',
                  'inputImage': inputImage,
                  'cameraImage': cameraImage
                });
              } else if (manual == 3) {
                setState(() {
                  isLoading = true;
                });

                Navigator.of(context).pop({
                  'ktpNumber': '',
                  'inputImage': inputImage,
                  'cameraImage': cameraImage,
                  'file': file
                });
              } else {
                if (isLoading == true) {
                  setState(() {
                    isLoading = true;
                  });
                }

                if (inputImage != null && await processImage(inputImage)) {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context).pop({
                      'ktpNumber': _text,
                      'inputImage': inputImage,
                      'cameraImage': cameraImage
                    });
                  });
                }
              }
            },
            onScreenModeChanged: _onScreenModeChanged,
            initialDirection: CameraLensDirection.back,
          );
  }

  void _onScreenModeChanged(ScreenMode mode) {
    switch (mode) {
      case ScreenMode.gallery:
        _initializeDetector(DetectionMode.single);
        return;

      case ScreenMode.liveFeed:
        _initializeDetector(DetectionMode.stream);
        return;
    }
  }

  void _initializeDetector(DetectionMode mode) async {
    const path = 'assets/ml/kliknss-2909222059.tflite';
    //const path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  Future<bool> processImage(InputImage inputImage) async {
    if (!_canProcess) return false;
    if (_isBusy) return false;
    _isBusy = true;

    bool detected = false;

    final objects = await _objectDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      for (final DetectedObject detectedObject in objects) {
        for (final Label label in detectedObject.labels) {
          //print('###################Detected: ${label.text} ${label.confidence}\n');

          if (label.text == "ktp" && label.confidence > 0.8707) {
            //if(label.text == "Driver's license" && label.confidence > .4){

            await _objectDetector.close();

            setState(() {
              objectDetected = true;
              state = 2;
            });
            Future.delayed(const Duration(milliseconds: 3000), () async {
              setState(() {
                state = 3;
              });
            });

            final recognizedText =
                await _textRecognizer.processImage(inputImage);
            for (final textBlock in recognizedText.blocks) {
              //print('Text: ${textBlock.text}');

              RegExp regex = RegExp(r'^\d{16}$');
              if (textBlock.text.length == 16 &&
                  regex.hasMatch(textBlock.text)) {
                _text = textBlock.text;
                detected = true;
                //print("KTP: ${_text}");
                break;
              }
            }

            if (detected) {
              break;
            }
          }
        }
      }
    } else {
      String text = 'Objects found: ${objects.length}\n\n';
      for (final object in objects) {
        text +=
            'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
      }
      _text = text;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }

    return detected;
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
