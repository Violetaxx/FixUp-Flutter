import 'package:flutter/material.dart';

class FixUpButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;

  const FixUpButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed ?? () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            side: const BorderSide(color: Color(0xFFCB9E50)),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFCB9E50),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCB9E50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}