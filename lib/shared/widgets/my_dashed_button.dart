import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyDashedButton extends StatelessWidget {
  const MyDashedButton({
    super.key,
    this.text,
    this.child,
    this.width,
    this.height = 44,
    required this.onTap,
  });

  final String? text;
  final Widget? child;
  final double? width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          width: width,
          height: height,
          padding: const .symmetric(horizontal: 16),
          alignment: .center,
          child: child ?? MyText(text: text ?? "", fontSize: 13),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColors.border
      ..strokeWidth = 1
      ..style = .stroke;

    void dash(Offset start, Offset end) {
      final total = (end - start).distance;
      final direction = (end - start) / total;
      for (double d = 0; d < total; d += 7) {
        final stop = (d + 4) > total ? total : d + 4;
        canvas.drawLine(start + direction * d, start + direction * stop, paint);
      }
    }

    dash(.zero, Offset(size.width, 0));
    dash(Offset(size.width, 0), Offset(size.width, size.height));
    dash(Offset(size.width, size.height), Offset(0, size.height));
    dash(Offset(0, size.height), .zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
