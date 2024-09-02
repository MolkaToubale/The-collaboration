import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoading extends StatelessWidget {
  final double size;

  const MyLoading({
    Key? key,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.blue,
          size: size,
        ),
      ),
    );
  }
}

class MyLoadingRing extends StatelessWidget {
  final double size;

  const MyLoadingRing({
    Key? key,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitRing(
          lineWidth: 3,
          color: Colors.blue,
          size: size,
        ),
      ),
    );
  }
}
