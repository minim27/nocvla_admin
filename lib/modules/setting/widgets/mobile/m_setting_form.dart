import 'package:flutter/material.dart';

import '../../../../shared/widgets/my_button.dart';
import '../../../../shared/widgets/my_panel.dart';
import '../../../../shared/widgets/my_text_form_field.dart';
import '../../setting_controller.dart';

class MSettingForm extends StatelessWidget {
  const MSettingForm({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    final instagram = MyTextFormField(
      controller: controller.txtInstagram,
      label: "Instagram",
      hintText: "@nocvla",
      keyboardType: .text,
    );
    final tiktok = MyTextFormField(
      controller: controller.txtTiktok,
      label: "TikTok",
      hintText: "@nocvla",
      keyboardType: .text,
    );
    final email = MyTextFormField(
      controller: controller.txtEmail,
      label: "Email kontak",
      keyboardType: .emailAddress,
    );
    final discord = MyTextFormField(
      controller: controller.txtDiscord,
      label: "Discord (LINK_DISCORD)",
      keyboardType: .url,
    );

    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          MySectionTitle(text: "Pengaturan toko"),
          MyTextFormField(
            controller: controller.txtWaNumber,
            label: "Nomor WhatsApp order",
            hintText: "62xxxxxxxxxx",
            keyboardType: .phone,
          ),
          MyTextFormField(
            controller: controller.txtWaTemplate,
            label:
                "Template pesan WhatsApp. Pakai {item} {warna} {ukuran} {qty} {harga} (diulang per barang), {nama penerima} {WA penerima} {alamat penerima} {notes} {kode} {subtotal} {diskon} {total}. Baris yang isiannya kosong tidak ditampilkan",
            hintText:
                "Halo NOCVLA, saya mau order:\n\n• {item} [{warna}, {ukuran}] x{qty}\n\nNama Penerima: {nama penerima}",
            maxLines: 8,
            keyboardType: .multiline,
          ),
          instagram,
          tiktok,
          email,
          discord,
          MyTextFormField(
            controller: controller.txtMarketplace,
            label:
                "Link toko marketplace (default bila produk tidak punya link)",
            keyboardType: .url,
          ),
          MyTextFormField(
            controller: controller.txtShopee,
            label: "Link tombol Beli di Shopee (Home dan footer)",
            keyboardType: .url,
          ),
          MyTextFormField(
            controller: controller.txtTiktokShop,
            label: "Link tombol Beli di TikTok Shop (Home dan footer)",
            keyboardType: .url,
          ),
          MyTextFormField(
            controller: controller.txtTokopedia,
            label: "Link tombol Beli di Tokopedia (Home dan footer)",
            keyboardType: .url,
          ),
          MyButton(
            text: "Simpan pengaturan",
            fontSize: 13,
            onTap: () => controller.save(),
          ),
        ],
      ),
    );
  }
}
