import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/tv_sizes.dart';
import 'animated_token.dart';

class TokenBox extends StatelessWidget {
  final String token;
  final Color color;

  const TokenBox({super.key, required this.token, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [AnimatedToken(value: token, color: color)],
          ),
        ),
      ),
    );
  }
}
