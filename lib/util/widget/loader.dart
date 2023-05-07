import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liceth_app/util/animation/curves/spinkit_pump_curve.dart';
import 'package:liceth_app/util/widget/faded_image.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: SpinKitPumpCurve())))
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/chosen_one.png', fit: BoxFit.cover),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
        Positioned.fill(
            child: Center(
                child: FadedWidgetRadial(
          stops: [
            0,
            0.4 + _animation.value * 0.3,
            1,
          ],
          opacities: [1, 0.4 + _animation.value * 0.3, 0],
          child: Image.asset('assets/images/chosen_one.png',
              width: 180, height: 180, fit: BoxFit.cover),
        ))),
      ],
    );
  }
}

Widget getFullScreenLoader() {
  return const Scaffold(
    body: Loader(),
  );
}
