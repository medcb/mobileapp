import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

class ImageRectSelector extends StatefulWidget {
  const ImageRectSelector({
    Key? key,
    required this.image,
    required this.rectColor,
    this.onRectChange,
  }) : super(key: key);

  final Image image;
  final Color rectColor;
  final Function(Rect)? onRectChange;

  @override
  _ImageRectSelectorState createState() => _ImageRectSelectorState();
}

class _ImageRectSelectorState extends State<ImageRectSelector>
    with TickerProviderStateMixin {
  late ui.Image image;
  Size? _canvasSize;
  Size? imageSize;

  late Rect cropRect;
  bool _isMovingTopCorner = false;
  bool _isMovingLeftCorner = false;

  late Offset _startingFocalPoint;
  late Offset _previousOffset;
  Offset? _zeroZoomOffset;
  Offset? _offset;

  Offset? _previousMoveCornerOffset;

  late double _previousScale;
  double _scale = 1; // multiplier applied to scale the full image

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _scaleAnimationController;
  late AnimationController _offsetAnimationController;

  final double _minImageSize = 20;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _offsetAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    widget.image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        image = info.image;
        setState(() {
          imageSize =
              Size(info.image.width.toDouble(), info.image.height.toDouble());
          cropRect = Offset.zero & imageSize!;

          if (widget.onRectChange != null) {
            widget.onRectChange!(cropRect);
          }
        });
      }),
    );
  }

  void _handleScaleStart(ScaleStartDetails d) {
    if (d.pointerCount == 1) {
      double widthScale = _canvasSize!.width / imageSize!.width;
      double heightScale = _canvasSize!.height / imageSize!.height;
      double targetScale = _scale * min(widthScale, heightScale);

      _isMovingLeftCorner =
          cropRect.center.dx * targetScale > d.localFocalPoint.dx - _offset!.dx;
      _isMovingTopCorner =
          cropRect.center.dy * targetScale > d.localFocalPoint.dy - _offset!.dy;

      _previousMoveCornerOffset =
          d.localFocalPoint; //Offset(cropRect.left, cropRect.top);
    } else {
      _startingFocalPoint = d.localFocalPoint;
      _previousOffset = _offset ?? Offset.zero;
      _previousScale = _scale;
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails d) {
    if (d.pointerCount == 1) {
      double widthScale = _canvasSize!.width / imageSize!.width;
      double heightScale = _canvasSize!.height / imageSize!.height;
      double targetScale = _scale * min(widthScale, heightScale);

      final dx =
          (d.localFocalPoint.dx - _previousMoveCornerOffset!.dx) / targetScale;
      final dy =
          (d.localFocalPoint.dy - _previousMoveCornerOffset!.dy) / targetScale;

      setState(() {
        cropRect = Rect.fromLTRB(
          min(max(cropRect.left + (_isMovingLeftCorner ? dx : 0), 0),
              cropRect.right - _minImageSize),
          min(max(cropRect.top + (_isMovingTopCorner ? dy : 0), 0),
              cropRect.bottom - _minImageSize),
          max(
              min(cropRect.right + (_isMovingLeftCorner ? 0 : dx),
                  imageSize!.width),
              cropRect.left + _minImageSize),
          max(
              min(cropRect.bottom + (_isMovingTopCorner ? 0 : dy),
                  imageSize!.height),
              cropRect.top + _minImageSize),
        );
        if (widget.onRectChange != null) {
          widget.onRectChange!(cropRect);
        }
      });
      _previousMoveCornerOffset = d.localFocalPoint;
    } else {
      double newScale = _previousScale * d.scale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset =
          (_startingFocalPoint - _previousOffset) / _previousScale;
      final Offset newOffset = d.localFocalPoint - normalizedOffset * newScale;

      setState(() {
        _scale = newScale;
        _offset = newOffset;
      });
    }
  }

  void _handleScaleEnd(ScaleEndDetails d) {
    _previousMoveCornerOffset = null;
    final scale = _scale;
    if (scale < 1) {
      _scaleAnimationController.reset();
      _offsetAnimationController.reset();
      _scaleAnimation =
          Tween<double>(begin: scale, end: 1).animate(_scaleAnimationController)
            ..addListener(() {
              setState(() {});
            });
      _offsetAnimation = Tween<Offset>(begin: _offset, end: _zeroZoomOffset)
          .animate(_offsetAnimationController)
            ..addListener(() {
              setState(() {});
            });
      _scale = 1;
      _offset = _zeroZoomOffset;
      _scaleAnimationController.forward();
      _offsetAnimationController.forward();
    }
    if (scale > 5) {
      _scaleAnimationController.reset();
      _scaleAnimation =
          Tween<double>(begin: scale, end: 5).animate(_scaleAnimationController)
            ..addListener(() {
              setState(() {});
            });
      _scale = 5;
      _scaleAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CashbackColors.photoBackgroundColor,
        child: imageSize == null
            ? Container()
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onScaleEnd: _handleScaleEnd,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _canvasSize =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    if (_zeroZoomOffset == null) {
                      if (imageSize!.aspectRatio >
                          (constraints.maxWidth / constraints.maxHeight)) {
                        double imageHeight =
                            constraints.maxWidth / imageSize!.aspectRatio;
                        _offset = Offset(
                            0, (constraints.maxHeight - imageHeight) / 2);
                      } else {
                        double imageWidth =
                            constraints.maxHeight * imageSize!.aspectRatio;
                        _offset =
                            Offset((constraints.maxWidth - imageWidth) / 2, 0);
                      }
                      _zeroZoomOffset = _offset!;
                    }
                    return CustomPaint(
                      child: Container(),
                      foregroundPainter: _ZoomableImagePainter(
                        image: image,
                        offset: _offsetAnimationController.isAnimating
                            ? _offsetAnimation.value
                            : _offset!,
                        scale: _scaleAnimationController.isAnimating
                            ? _scaleAnimation.value
                            : _scale,
                        cropRect: cropRect,
                        rectColor: widget.rectColor,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class _ZoomableImagePainter extends CustomPainter {
  const _ZoomableImagePainter({
    required this.image,
    required this.offset,
    required this.scale,
    required this.cropRect,
    required this.rectColor,
  });

  final ui.Image image;
  final Offset offset;
  final double scale;
  final Rect cropRect;
  final Color rectColor;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    double widthScale = canvasSize.width / imageSize.width;
    double heightScale = canvasSize.height / imageSize.height;
    double targetScale = scale * min(widthScale, heightScale);

    Size targetSize = imageSize * targetScale;
    Rect cropTarget = Rect.fromLTWH(
      offset.dx + cropRect.left * targetScale,
      offset.dy + cropRect.top * targetScale,
      cropRect.width * targetScale,
      cropRect.height * targetScale,
    );

    paintImage(
      canvas: canvas,
      rect: offset & targetSize,
      image: image,
      fit: BoxFit.fill,
    );

    var paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = rectColor;
    canvas.drawRect(cropTarget, paint);

    final double verticalThird = (cropTarget.bottom - cropTarget.top) / 3;
    canvas.drawLine(
      Offset(cropTarget.left, cropTarget.top + verticalThird),
      Offset(cropTarget.right, cropTarget.top + verticalThird),
      paint,
    );
    canvas.drawLine(
      Offset(cropTarget.left, cropTarget.top + verticalThird * 2),
      Offset(cropTarget.right, cropTarget.top + verticalThird * 2),
      paint,
    );

    final double horizontalThird = (cropTarget.right - cropTarget.left) / 3;
    canvas.drawLine(
      Offset(cropTarget.left + horizontalThird, cropTarget.top),
      Offset(cropTarget.left + horizontalThird, cropTarget.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(cropTarget.left + horizontalThird * 2, cropTarget.top),
      Offset(cropTarget.left + horizontalThird * 2, cropTarget.bottom),
      paint,
    );

    paint.strokeWidth = 4;
    var path = Path()
      ..moveTo(cropTarget.left, min(cropTarget.top + 24, cropTarget.bottom))
      ..lineTo(cropTarget.left, cropTarget.top)
      ..lineTo(min(cropTarget.left + 24, cropTarget.right), cropTarget.top)
      ..moveTo(max(cropTarget.right - 24, cropTarget.left), cropTarget.top)
      ..lineTo(cropTarget.right, cropTarget.top)
      ..lineTo(cropTarget.right, min(cropTarget.top + 24, cropTarget.bottom))
      ..moveTo(cropTarget.right, max(cropTarget.bottom - 24, cropTarget.top))
      ..lineTo(cropTarget.right, cropTarget.bottom)
      ..lineTo(max(cropTarget.right - 24, cropTarget.left), cropTarget.bottom)
      ..moveTo(min(cropTarget.left + 24, cropTarget.right), cropTarget.bottom)
      ..lineTo(cropTarget.left, cropTarget.bottom)
      ..lineTo(cropTarget.left, max(cropTarget.bottom - 24, cropTarget.top));
    canvas.drawPath(path, paint);
  }

  @override
  bool? hitTest(ui.Offset position) {
    return super.hitTest(position);
  }

  @override
  bool shouldRepaint(_ZoomableImagePainter old) {
    return old.image != image || old.offset != offset || old.scale != scale;
  }
}
