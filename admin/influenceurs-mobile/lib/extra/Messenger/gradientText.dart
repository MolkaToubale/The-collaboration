import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    required this.gradient,
    required this.size,
    this.textStyle,
  });

  final String text;
  final Gradient gradient;
  final double size;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle == null
            ? TextStyle(
                // The color must be set to white for this to work
                color: Colors.white,
                fontSize: size,
                fontWeight: FontWeight.bold,
              )
            : textStyle,
      ),
    );
  }
}
