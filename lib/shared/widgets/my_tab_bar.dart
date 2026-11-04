import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import 'my_text.dart';

class MyDragScrollBehavior extends MaterialScrollBehavior {
  const MyDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class MyTabItem {
  const MyTabItem({required this.label, this.count, this.isAlert = false});

  final String label;
  final int? count;
  final bool isAlert;
}

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<MyTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: MyColors.line)),
      ),
      child: ScrollConfiguration(
        behavior: const MyDragScrollBehavior(),
        child: SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == selectedIndex;

              return InkWell(
                onTap: () => onTap(index),
                child: Container(
                  height: 48,
                  padding: const .symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? MyColors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      MyText(
                        text: item.label.toUpperCase(),
                        color: isActive
                            ? MyColors.secondary
                            : MyColors.primary60,
                        fontFamily: MyFonts.archivoNarrow,
                        fontSize: 13,
                        fontWeight: .w700,
                        letterSpacing: 1.56,
                      ),
                      if (item.count != null)
                        Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: const .symmetric(horizontal: 4),
                          alignment: .center,
                          color: (item.isAlert && item.count! > 0)
                              ? MyColors.red
                              : MyColors.line,
                          child: MyText(
                            text: "${item.count}",
                            color: (item.isAlert && item.count! > 0)
                                ? MyColors.white
                                : MyColors.secondary,
                            fontSize: 11,
                            fontWeight: .w600,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
