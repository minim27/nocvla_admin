import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class MPDProdMarket extends StatelessWidget {
  const MPDProdMarket({super.key, required this.controller});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          MySectionTitle(text: "Link marketplace (toko NOCVLA)"),
          _field(label: "Shopee", type: "shopee", txt: controller.txtUrlShopee),
          _field(
            label: "TikTok Shop",
            type: "tiktok",
            txt: controller.txtUrlTiktokShop,
          ),
          _field(
            label: "Tokopedia",
            type: "tokopedia",
            txt: controller.txtUrlTokped,
          ),
          MyText(
            text: "Link affiliate per atlet diatur di menu Atlet & Pendaftar.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required String type,
    required TextEditingController txt,
  }) {
    return ListenableBuilder(
      listenable: txt,
      builder: (context, _) {
        final error = marketplaceUrlError(type: type, url: txt.text);

        return Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            MyTextFormField(
              controller: txt,
              label: label,
              keyboardType: .url,
              textInputAction: .next,
              borderColor: error == null ? MyColors.border : MyColors.redText,
            ),
            if (error != null)
              MyText(text: error, color: MyColors.redText, fontSize: 12)
            else if (txt.text.trim().isNotEmpty)
              MyText(
                text: "Domain sesuai",
                color: MyColors.green,
                fontSize: 12,
              ),
          ],
        );
      },
    );
  }
}
