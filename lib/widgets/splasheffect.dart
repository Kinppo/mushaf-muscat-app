import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

   SplashEffect(
    
     this.child, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: child,
        onTap: onTap,
      ),
    );
  }
}