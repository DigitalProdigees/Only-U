import 'package:flutter/material.dart';
import 'package:only_u/app/data/constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.title,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/imgs/btnBG.png"), // your bg image
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8), // optional rounding
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon != null
                  ? SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(icon!, fit: BoxFit.contain),
                    )
                  : SizedBox(),
              const SizedBox(width: 8),
              Text(
                title,
                style: normalBodyStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
