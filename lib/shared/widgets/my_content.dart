import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import '../utils/my_parsing_currency.dart';
import 'my_image.dart';
import 'my_text.dart';

class MyProduct extends StatelessWidget {
  const MyProduct({
    super.key,
    required this.image,
    required this.text,
    required this.price,
    required this.stock,
    required this.isDisc,
    required this.onTap,
  });

  final String image, text;
  final int price, stock;
  final bool isDisc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 180 / 200,
                child: MyImage(image: image, alignment: Alignment.topCenter),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  color: MyColors.primary.withValues(alpha: 0.3),
                  width: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: stock > 0 ? MyColors.green : MyColors.yellow,
                          ),
                        ),
                      ),
                      Flexible(
                        child: MyText(
                          text: stock > 0
                              ? "IN STOCK - READY TO SHIP"
                              : "SOLD OUT - PRE ORDER",
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isDisc,
                child: Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6, 1, 6, 2),
                    color: MyColors.red,
                    child: MyText(
                      text: "DISC",
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: text.toUpperCase(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8),
                MyText(
                  text: parsingCurrency(price),
                  color: MyColors.red,
                  fontSize: 12,
                  fontFamily: MyFonts.libreBaskerville,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
