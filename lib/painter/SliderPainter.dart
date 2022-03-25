import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_builder/painter/utils.dart';
class SliderPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double sweepAngle;
  final Color selectionColor;

  late Offset initHandler;
  late Offset endHandler;
  late Offset center;
  late double radius;

  ui.Image? startImage;
 //late ui.Image endImage;



  SliderPainter(
      {required this.startAngle,
        required this.endAngle,
        required this.sweepAngle,
         this.startImage,
        required this.selectionColor,});

  @override
  void paint(Canvas canvas, Size size)async {
    if (startAngle == 0.0 && endAngle == 0.0) return;

    Paint progress = _getPaint(color: selectionColor);

    center = Offset(size.width / 2, size.height / 2);
    radius = min(size.width / 2, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + startAngle, sweepAngle, false, progress);

    Paint handler = _getPaint(color: selectionColor, style: PaintingStyle.fill);
    Paint handlerOutter = _getPaint(color: selectionColor, width: 2.0);



    // draw handlers


    //canvas.clipPath(path);

    initHandler = radiansToCoordinates(center, -pi / 2 + startAngle, radius);


    if(startImage!=null)
      canvas.drawImage(startImage!,initHandler, handler);

      //  canvas.drawCircle(initHandler, 8.0, handler);
    canvas.drawCircle(initHandler, 12.0, handlerOutter);

    endHandler = radiansToCoordinates(center, -pi / 2 + endAngle, radius);

    if(startImage!=null)
    canvas.drawImage(startImage!, endHandler, handler);

    //canvas.drawCircle(endHandler, 8.0, handler);
    canvas.drawCircle(endHandler, 12.0, handlerOutter);
    


  }



  Future<ui.Image> getImage(String path) async {
    var completer = Completer<ImageInfo>();
    var img = new NetworkImage(path);
    img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }


  Paint _getPaint({required Color color, double? width, PaintingStyle? style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? 12.0;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


