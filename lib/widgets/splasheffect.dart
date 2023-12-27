import 'package:flutter/material.dart';

class SplashEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const SplashEffect(this.child, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
