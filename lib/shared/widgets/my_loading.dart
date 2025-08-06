import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/my_colors.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({
    super.key,
    this.isStack = false,
    this.size = 50,
    this.backgroundColor = MyColors.primary,
  });

  final bool isStack;
  final double size;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isStack == false)
          ? backgroundColor
          : backgroundColor.withValues(alpha: 0.50),
      child: Center(
        child: SpinKitCircle(color: MyColors.secondary, size: size),
      ),
    );
  }
}

class MyMoreLoading extends StatelessWidget {
  const MyMoreLoading({super.key, this.backgroundColor, this.isStack = false});

  final Color? backgroundColor;
  final bool? isStack;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitCircle(color: MyColors.secondary, size: 30),
    );
  }
}
