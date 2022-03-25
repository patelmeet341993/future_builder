import 'package:flutter/material.dart';
import 'package:future_builder/painter/utils.dart';

import 'dart:ui' as ui;
import 'BasePainter.dart';
import 'SliderPainter.dart';


class CircularSliderPaint extends StatefulWidget {

  final int init;
  final int end;
  final int intervals;
  final Function onSelectionChange;
  final Color baseColor;
  final Color selectionColor;
  final Widget child;
  final ui.Image? im;


  CircularSliderPaint(
      {required this.intervals,
        required this.init,
        required this.end,
        required this.child,
        required this.onSelectionChange,
        required this.baseColor,
        this.im,
        required this.selectionColor});


  @override
  _CircularSliderPaintState createState() => _CircularSliderPaintState();
}

class _CircularSliderPaintState extends State<CircularSliderPaint> {


  bool _isInitHandlerSelected = false;
  bool _isEndHandlerSelected = false;

  SliderPainter? _painter;

  /// start angle in radians where we need to locate the init handler
  double _startAngle=10;

  /// end angle in radians where we need to locate the end handler
  double _endAngle=50;

  /// the absolute angle in radians representing the selection
  double _sweepAngle=1000;

  @override
  void initState() {
    super.initState();
    print("circluar init");
    _calculatePaintData();
  }



  // we need to update this widget both with gesture detector but
  // also when the parent widget rebuilds itself
  @override
  void didUpdateWidget(CircularSliderPaint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.init != widget.init || oldWidget.end != widget.end) {
      _calculatePaintData();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("circular rebuild");
    _calculatePaintData();
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: BasePainter(
            baseColor: widget.baseColor,
           // selectionColor: widget.selectionColor
        ),
        foregroundPainter: _painter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: widget.child,
        ),
      ),
    );
  }

  void _calculatePaintData() {
    double initPercent = valueToPercentage(widget.init, widget.intervals);
    double endPercent = valueToPercentage(widget.end, widget.intervals);
    double sweep = getSweepAngle(initPercent, endPercent);

    _startAngle = percentageToRadians(initPercent);
    _endAngle = percentageToRadians(endPercent);
    _sweepAngle = percentageToRadians(sweep.abs());

    print("slider painter : im null : ${widget.im==null}");
    _painter = SliderPainter(
      startAngle: _startAngle,
      endAngle: _endAngle,
      sweepAngle: _sweepAngle,
      selectionColor: widget.selectionColor,
      startImage: widget.im,
    );
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (!_isInitHandlerSelected && !_isEndHandlerSelected) {
      return;
    }
    if (_painter!.center == null) {
      return;
    }
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var position = renderBox!.globalToLocal(details.globalPosition);

    var angle = coordinatesToRadians(_painter!.center, position);
    var percentage = radiansToPercentage(angle);
    var newValue = percentageToValue(percentage, widget.intervals);

    if (_isInitHandlerSelected) {
      widget.onSelectionChange(newValue, widget.end);
    } else {
      widget.onSelectionChange(widget.init, newValue);
    }
  }

  _onPanEnd(_) {
    _isInitHandlerSelected = false;
    _isEndHandlerSelected = false;
  }

  _onPanDown(DragDownDetails details) {
    if (_painter == null) {
      return;
    }
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var position = renderBox!.globalToLocal(details.globalPosition);
    if (position != null) {
      _isInitHandlerSelected = isPointInsideCircle(
          position, _painter!.initHandler, 12.0);
      if (!_isInitHandlerSelected) {
        _isEndHandlerSelected = isPointInsideCircle(
            position, _painter!.endHandler, 12.0);
      }
    }
  }

}
