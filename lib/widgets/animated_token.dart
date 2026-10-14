import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/tv_sizes.dart';

class AnimatedToken extends StatelessWidget {
  final String value;
  final Color color;

  const AnimatedToken({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final fontSize = TvSizes.tokenNumber(context);

    return AnimatedFlipCounter(
      value: int.tryParse(value.trim()) ?? 0,
      //value: int.tryParse(value) ?? 0,
      duration: const Duration(milliseconds: 500),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
