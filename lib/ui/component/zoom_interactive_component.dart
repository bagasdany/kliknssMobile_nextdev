import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kliknss77/ui/shimmer/banner_shimmer.dart';


class ZoomInteractive extends StatefulWidget {
  dynamic url;
  int? state;
  dynamic tipe;
  ZoomInteractive({Key? key, this.url, this.state, this.tipe})
      : super(key: key);

  @override
  State<ZoomInteractive> createState() => _ZoomInteractiveState();
}

class _ZoomInteractiveState extends State<ZoomInteractive>
    with TickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  late TransformationController controller2;
  late AnimationController animationController2;
  Animation<Matrix4>? animation2;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() => controller.value = animation!.value);
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   // AppDialog.openUrl(message?.data['target']);
    //   controller2 = TransformationController();
    //   animationController2 = AnimationController(
    //       vsync: this, duration: const Duration(milliseconds: 200))
    //     ..addListener(() => controller2.value = (animation2 ??
    //             Matrix4Tween(
    //               begin: controller2.value,
    //               end: Matrix4.identity(),
    //             ).animate(CurvedAnimation(
    //                 parent: animationController2, curve: Curves.easeIn)))
    //         .value);
    // });
    animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animationController2.addListener(() {
      final animation = animation2 ??
          Matrix4Tween(
            begin: controller2.value,
            end: Matrix4.identity(),
          ).animate(CurvedAnimation(
              parent: animationController2, curve: Curves.easeIn));

      controller2.value = animation.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    // animationController2.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward(from: 0);
  }

  void resetAnimation2() {
    animation2 = Matrix4Tween(
      begin: controller2.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: animationController2, curve: Curves.easeIn));
    animationController2.forward(from: 0);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (controller.value != Matrix4.identity()) {
      setState(() {
        controller.value = Matrix4.identity();
      });
    } else {
      final position = _doubleTapDetails?.localPosition;
      // For a 3x zoom
      setState(() {
        controller.value = Matrix4.identity()
          ..translate(-position!.dx * 2, -position.dy * 2)
          ..scale(3.0);
      });
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height * .7;
    return widget.tipe == "asset"
        ? GestureDetector(
            onDoubleTap: () {
              print("ondouble tap");
              _handleDoubleTap();
            },
            onTap: () {
              resetAnimation();
            },
            onDoubleTapDown: _handleDoubleTapDown,
            child: InteractiveViewer(
              transformationController: controller,
              panEnabled: false, // Set it to false,
              clipBehavior: Clip.hardEdge,
              boundaryMargin: const EdgeInsets.all(10),
              minScale: 1,
              maxScale: 10,
              child: Image.asset(
                widget.url ?? "",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/kliknss.png",
                    // width: width,
                  );
                },
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              decoration: const BoxDecoration(
          //      image: DecorationImage(
          //   image: AssetImage("assets/images/splash_juni_bg.png"),
          //   fit: BoxFit.cover,
          // ),
              ),
              child: widget.state == 2
                  ? BannerShimmer(aspectRatio: 1 / 1)
                  : GestureDetector(
                      onDoubleTap: () {
                        print("ondouble tap");
                        _handleDoubleTap();
                      },
                      onTap: () {
                        resetAnimation();
                      },
                      onDoubleTapDown: _handleDoubleTapDown,
                      child: InteractiveViewer(
                        transformationController: controller,
                        panEnabled: false, // Set it to false,
                        clipBehavior: Clip.hardEdge,
                        boundaryMargin: const EdgeInsets.all(10),
                        minScale: 1,
                        maxScale: 10,
                        child: widget.url == null || widget.url == ""
                            ? Image.asset('assets/icon/noimage.png')
                            : CachedNetworkImage(
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: BannerShimmer(
                                              aspectRatio: 1 / 1,
                                            )),
                                imageUrl: widget.url,
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/icon/noimage.png'),
                              ),
                      ),
                    ),
            ),
          );
  }
}
