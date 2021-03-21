import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameOne extends StatefulWidget {

  final Size imageSize;
  final double pieceWidth;
  final double pieceHeight;
  final Widget piece;
  final double imgWidth;
  final double imgHeight;
  final Size screenSize;


  GameOne({
    Key key,
    this.imageSize,
    this.piece,
    this.pieceWidth,
    this.pieceHeight,
    this.imgWidth,
    this.imgHeight,
    this.screenSize,
  }) : super(key: key);

  @override
  _GameOneState createState() => _GameOneState();
}

class _GameOneState extends State<GameOne> {
  double top;
  double left;
  bool isMovable = true;

  @override
  void initState() {
    super.initState();

    if (top == null) {
      top = 0;
    }
    if (left == null) {
      left = widget.screenSize.width/2 ;//- (widget.pieceWidth / 2).toDouble();
    }

    Timer.periodic(Duration(milliseconds: 500), (timer) {

      top += 10;

      if(top >= (widget.screenSize.height - 200 - widget.pieceHeight)){
        timer.cancel();
        return;
      }

      setState(() {});

    });


  }

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: top,
      left: left,
      width: widget.imgWidth,
      child: widget.piece,
    );
  }
}
