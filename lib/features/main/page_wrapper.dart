import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final BoxDecoration? backgroundDecoration;

  const PageWrapper(
      {super.key, required this.child, this.backgroundDecoration});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration,
        child: SafeArea(child: child));
  }
}
