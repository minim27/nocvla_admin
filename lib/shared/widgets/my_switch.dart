import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class MySwitch extends StatelessWidget {
  const MySwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: Semantics(
        toggled: value,
        enabled: onChanged != null,
        child: InkWell(
          onTap: onChanged == null ? null : () => onChanged!(!value),
          child: Container(
            width: 44,
            height: 24,
            padding: const .symmetric(horizontal: 3),
            alignment: value ? .centerRight : .centerLeft,
            color: value ? MyColors.red : MyColors.line,
            child: Container(
              width: 18,
              height: 18,
              color: value ? MyColors.white : MyColors.primary60,
            ),
          ),
        ),
      ),
    );
  }
}
