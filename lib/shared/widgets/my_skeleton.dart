import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class MySkeleton extends StatelessWidget {
  const MySkeleton({super.key, this.width, this.height = 16});

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: height, color: MyColors.selected);
  }
}
