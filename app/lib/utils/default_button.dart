import 'package:app/utils/app_tap.dart';
import 'package:app/utils/gaps.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.onPressed,
    required this.text,
    this.textStyle,
    super.key,
  });
  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return AppTap(
      onTap: onPressed,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(Spacings.px12),
            ),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(Spacings.px12),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
            ),
          ),
          Positioned(
            top: 12,
            child: Padding(
              padding: const EdgeInsets.only(left: Spacings.px8),
              child: Image.asset(
                'assets/icons/ninja_white.png',
                width: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
