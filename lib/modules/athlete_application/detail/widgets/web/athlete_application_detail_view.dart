import 'package:flutter/material.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/utils/my_utility.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../athlete_application_detail_controller.dart';

class AthleteApplicationDetailView extends StatelessWidget {
  const AthleteApplicationDetailView({super.key, required this.controller});

  final AthleteApplicationDetailController controller;

  @override
  Widget build(BuildContext context) {
    final application = controller.application.value;

    return Column(
      crossAxisAlignment: .start,
      children: [
        MyText(
          text: "APPLICATION DETAIL",
          fontSize: 24,
          fontFamily: MyFonts.libreBaskerville,
        ),
        SizedBox(height: 24),
        _DetailField(label: "Name", value: application?.name),
        _DetailField(label: "Email", value: application?.email),
        _DetailField(label: "Phone", value: application?.phone),
        _DetailField(label: "City", value: application?.city),
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
        _DetailField(label: "Reason", value: application?.reason),
        _DetailField(label: "Status", value: application?.status),
        _DetailField(
          label: "Created At",
          value: application?.createdAt == null
              ? null
              : formatDate(val: application!.createdAt),
        ),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value, this.onTap});

  final String label;
  final dynamic value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value.toString().trim().isNotEmpty;

    return Padding(
      padding: const .only(bottom: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MyText(text: label, color: MyColors.primary80, fontSize: 12),
          SizedBox(height: 4),
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
