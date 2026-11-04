import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../shared/utils/my_colors.dart';
import '../../../../../shared/utils/my_fonts.dart';
import '../../../../../shared/utils/my_input_formatters.dart';
import '../../../../../shared/widgets/my_button.dart';
import '../../../../../shared/widgets/my_dashed_button.dart';
import '../../../../../shared/widgets/my_icon_button.dart';
import '../../../../../shared/widgets/my_panel.dart';
import '../../../../../shared/widgets/my_switch.dart';
import '../../../../../shared/widgets/my_text.dart';
import '../../../../../shared/widgets/my_text_form_field.dart';
import '../../product_detail_controller.dart';

class TPDProdVar extends StatelessWidget {
  const TPDProdVar({super.key, required this.controller});

  final ProductDetailController controller;

  List<TextInputFormatter> get _numberFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    NoLeadingZeroTextInputFormatter(),
  ];

  String _sizeLabel(int index) => index < controller.sizeTags.length
      ? controller.sizeTags[index].text
      : "All size";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [_sizes(), _prices(), _stocks()],
    );
  }

  Widget _sizes() {
    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          MySectionTitle(text: "Ukuran"),
          MyText(
            text:
                "Label bebas. Menghapus ukuran akan meminta konfirmasi lebih dulu.",
            color: MyColors.primary60,
            fontSize: 13,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: .center,
            children: [
              MyText(text: "Preset", color: MyColors.primary60, fontSize: 12),
              ...ProductDetailController.sizePresets.entries.map(
                (preset) => InkWell(
                  onTap: () => controller.applySizePreset(labels: preset.value),
                  child: Container(
                    height: 36,
                    padding: const .symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: .all(color: MyColors.line),
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: MyText(text: preset.key, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: .center,
              children: [
                ...List.generate(controller.sizeTags.length, (index) {
                  return Container(
                    height: 44,
                    padding: const .only(left: 10, right: 6),
                    decoration: BoxDecoration(
                      color: MyColors.selected,
                      border: .all(color: MyColors.secondary),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      spacing: 6,
                      children: [
                        SizedBox(
                          width: 72,
                          child: MyTextFormFieldNoBorder(
                            controller: controller.sizeTags[index],
                            textAlign: .left,
                            fontSize: 15,
                            fontWeight: .w700,
                          ),
                        ),
                        InkWell(
                          onTap: () => controller.removeSizeTag(index: index),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: MyColors.primary60,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(
                  width: 220,
                  child: MyTextFormField(
                    controller: controller.txtNewSize,
                    hintText: "Contoh: 3XL, 30, All size",
                    keyboardType: .text,
                    onFieldSubmitted: (_) => controller.addSizeTag(),
                  ),
                ),
                MyButton(
                  text: "Tambah",
                  fontSize: 13,
                  onTap: () => controller.addSizeTag(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prices() {
    return MyPanel(
      child: Obx(
        () => Column(
          crossAxisAlignment: .start,
          spacing: 16,
          children: [
            MySectionTitle(text: "Harga per ukuran"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: .center,
              children: [
                MyText(
                  text: "Harga dasar",
                  color: MyColors.primary60,
                  fontSize: 13,
                ),
                SizedBox(
                  width: 140,
                  child: MyTextFormField(
                    controller: controller.txtBasePrice,
                    keyboardType: .number,
                    inputFormatters: _numberFormatters,
                  ),
                ),
                MyButton(
                  text: "Samakan semua",
                  fontSize: 13,
                  color: Colors.transparent,
                  textColor: MyColors.secondary,
                  borderColor: MyColors.border,
                  onTap: () => controller.applyBasePrice(),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                MySwitch(
                  value: controller.isPricePerColor.value,
                  onChanged: (value) =>
                      controller.togglePricePerColor(value: value),
                ),
                Flexible(
                  child: MyText(
                    text: "Harga berbeda per warna",
                    color: MyColors.primary60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (controller.isPricePerColor.value)
              _matrix(isPrice: true)
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  controller.colorTags.first.stockCells.length,
                  (index) => SizedBox(
                    width: 170,
                    child: ListenableBuilder(
                      listenable: index < controller.sizeTags.length
                          ? controller.sizeTags[index]
                          : controller.txtBasePrice,
                      builder: (context, _) => MyTextFormField(
                        controller:
                            controller.colorTags.first.stockCells[index].price,
                        label: _sizeLabel(index),
                        required: true,
                        keyboardType: .number,
                        inputFormatters: _numberFormatters,
                        onChanged: (value) =>
                            controller.setSizePrice(index: index, value: value),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stocks() {
    return MyPanel(
      child: Column(
        crossAxisAlignment: .start,
        spacing: 16,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: .spaceBetween,
              crossAxisAlignment: .center,
              spacing: 16,
              runSpacing: 12,
              children: [
                MySectionTitle(text: "Stok per warna × ukuran"),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: .center,
                  children: [
                    MyText(
                      text: "Isi semua sel kosong",
                      color: MyColors.primary60,
                      fontSize: 13,
                    ),
                    SizedBox(
                      width: 72,
                      child: MyTextFormField(
                        controller: controller.txtFillQty,
                        keyboardType: .number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    MyButton(
                      text: "Terapkan",
                      fontSize: 13,
                      color: Colors.transparent,
                      textColor: MyColors.secondary,
                      borderColor: MyColors.border,
                      onTap: () => controller.fillEmptyStock(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(() {
            controller.colorTags.length;
            controller.sizeTags.length;
            return _matrix(isPrice: false);
          }),
          MyDashedButton(
            width: 150,
            text: "+ Tambah warna",
            onTap: () => controller.addColorTag(),
          ),
        ],
      ),
    );
  }

  Widget _matrix({required bool isPrice}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const nameWidth = 220.0;
        const totalWidth = 56.0;
        final count = controller.colorTags.first.stockCells.length;
        final free =
            (constraints.maxWidth - nameWidth - totalWidth - (count + 2) * 8) /
            (count == 0 ? 1 : count);
        final cellWidth = free < 76.0 ? 76.0 : free;

        return SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                spacing: 8,
                children: [
                  SizedBox(
                    width: nameWidth,
                    child: MyTableLabel(text: "Warna"),
                  ),
                  ...List.generate(
                    count,
                    (index) => SizedBox(
                      width: cellWidth,
                      child: index < controller.sizeTags.length
                          ? ListenableBuilder(
                              listenable: controller.sizeTags[index],
                              builder: (context, _) =>
                                  MyTableLabel(text: _sizeLabel(index)),
                            )
                          : MyTableLabel(text: _sizeLabel(index)),
                    ),
                  ),
                  SizedBox(
                    width: totalWidth,
                    child: isPrice ? null : MyTableLabel(text: "Total"),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ...List.generate(controller.colorTags.length, (colorIndex) {
                final tag = controller.colorTags[colorIndex];

                return Container(
                  padding: const .symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: MyColors.lineSoft)),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: nameWidth,
                        child: Row(
                          spacing: 6,
                          children: [
                            Expanded(
                              child: MyTextFormField(
                                controller: tag.txtName,
                                hintText: "Nama warna",
                                keyboardType: .text,
                                textInputAction: .next,
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: MyTextFormField(
                                controller: tag.txtHex,
                                hintText: "#A3241F",
                                keyboardType: .text,
                                textInputAction: .next,
                              ),
                            ),
                            MyIconButton(
                              icon: Icons.delete_outline_rounded,
                              tooltip: "Hapus warna",
                              size: 32,
                              iconSize: 16,
                              color: MyColors.primary60,
                              onTap: controller.colorTags.length > 1
                                  ? () => controller.removeColorTag(
                                      index: colorIndex,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      ...List.generate(count, (cellIndex) {
                        if (cellIndex >= tag.stockCells.length) {
                          return SizedBox(width: cellWidth);
                        }
                        final cell = tag.stockCells[cellIndex];
                        final txt = isPrice ? cell.price : cell.qty;

                        return SizedBox(
                          width: cellWidth,
                          child: ListenableBuilder(
                            listenable: txt,
                            builder: (context, _) {
                              final isEmptyStock = !isPrice && txt.text == "0";

                              return MyTextFormField(
                                controller: txt,
                                keyboardType: .number,
                                textColor: isEmptyStock
                                    ? MyColors.redText
                                    : MyColors.secondary,
                                borderColor: isEmptyStock
                                    ? MyColors.red
                                    : MyColors.border,
                                inputFormatters: isPrice
                                    ? _numberFormatters
                                    : [FilteringTextInputFormatter.digitsOnly],
                                textInputAction: .next,
                              );
                            },
                          ),
                        );
                      }),
                      SizedBox(
                        width: totalWidth,
                        child: isPrice
                            ? null
                            : ListenableBuilder(
                                listenable: Listenable.merge(
                                  tag.stockCells.map((cell) => cell.qty),
                                ),
                                builder: (context, _) {
                                  final total = controller.rowTotal(tag: tag);

                                  return MyText(
                                    text: "$total",
                                    color: total == 0
                                        ? MyColors.redText
                                        : MyColors.secondary,
                                    fontFamily: MyFonts.archivo,
                                    fontWeight: .w700,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
