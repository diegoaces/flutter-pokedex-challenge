import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PokeballLoading extends StatefulWidget {
  const PokeballLoading({super.key});

  @override
  State<PokeballLoading> createState() => _PokeballLoadingState();
}

class _PokeballLoadingState extends State<PokeballLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Transform.rotate(
          angle: math.pi / 2, // 90 degrees
          child: SvgPicture.asset(
            'assets/svg/pokeball.svg',
            width: 155,
            height: 155,
          ),
        ),
      ),
    );
  }
}
