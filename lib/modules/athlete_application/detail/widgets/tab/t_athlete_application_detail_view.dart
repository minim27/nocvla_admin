import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_status_badge.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_application_detail_controller.dart';

class TAthleteApplicationDetailView extends StatelessWidget {
  const TAthleteApplicationDetailView({super.key, required this.controller});

  final AthleteApplicationDetailController controller;

  @override
  Widget build(BuildContext context) {
    final application = controller.application.value;
    final badge = switch (application?.status) {
      "approved" => MyStatusBadge(text: "Diterima", color: MyColors.green),
      "rejected" => MyStatusBadge(text: "Ditolak", color: MyColors.redText),
      _ => MyStatusBadge(text: "Pending", color: MyColors.yellow),
    };

    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              MySectionTitle(text: "Data pendaftar"),
              badge,
            ],
          ),
          Wrap(
            spacing: 24,
            runSpacing: 20,
            children: [
              _DetailField(label: "Email", value: application?.email),
              _DetailField(label: "Telepon", value: application?.phone),
              _DetailField(label: "Kota", value: application?.city),
              _DetailField(
                label: "Fokus latihan",
                value: application?.trainingFocus,
              ),
              _DetailField(
                label: "Foto diri",
                value: application?.photoPath == null ? null : "Lihat foto",
                onTap: controller.openPhoto,
              ),
              _DetailField(
                label: "Instagram",
                value: application?.instagramUsername,
                onTap: controller.openInstagram,
              ),
              _DetailField(
                label: "TikTok",
                value: application?.tiktokUsername,
                onTap: controller.openTiktok,
              ),
              _DetailField(
                label: "Tanggal daftar",
                value: application?.createdAt == null
                    ? null
                    : formatDate(val: application!.createdAt),
              ),
            ],
          ),
          _DetailField(
            label: "Alasan",
            value: application?.reason,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.onTap,
    this.width = 300,
  });

  final String label;
  final dynamic value;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value.toString().trim().isNotEmpty;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: .start,
        spacing: 6,
        children: [
          MyText(text: label, color: MyColors.primary60, fontSize: 13),
          GestureDetector(
            onTap: hasValue ? onTap : null,
            child: MyText(
              text: hasValue ? value.toString() : "-",
              fontWeight: .w500,
              decoration: (onTap != null && hasValue)
                  ? TextDecoration.underline
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
