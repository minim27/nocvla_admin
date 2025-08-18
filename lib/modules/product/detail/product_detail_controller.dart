import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/data/models/master/colors_model.dart';
import 'package:nocvla_admin/data/models/master/size_model.dart';
import 'package:nocvla_admin/data/models/master/type_model.dart';
import 'package:nocvla_admin/data/models/products/product_detail_model.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_params.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../app/core/base_controller.dart';
import '../../../shared/utils/my_utility.dart';

class ProductDetailController extends BaseController {
  var resProduct = <ProductDetailModel>[];
  var resType = <TypeModel>[];
  var resSize = <SizeModel>[];
  var resColor = <ColorsModel>[];

  var gender = <Map<String, dynamic>>[
    {"name": "Male", "value": "m"},
    {"name": "Female", "value": "f"},
    {"name": "Unisex", "value": "u"},
  ];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();
  var txtIdentity = TextEditingController();
  var selectedGender = {}.obs;
  var selectedType = {}.obs;
  var txtDescription = TextEditingController();
  var txtGallery = <RxString>[].obs;

  QuillController quillController = QuillController.basic();

  var selectedSize = <String>[].obs;
  var selectedColor = <Map<String, dynamic>>[].obs;

  final regPriceCtrls = <String, TextEditingController>{}.obs;
  final discPriceCtrls = <String, TextEditingController>{}.obs;
  final stockCtrls = <String, TextEditingController>{}.obs;
  final printPrimaryCtrls = <String, TextEditingController>{}.obs;
  final printSecondaryCtrls = <String, TextEditingController>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    for (final c in regPriceCtrls.values) {
      c.dispose();
    }
    for (final c in discPriceCtrls.values) {
      c.dispose();
    }
    for (final c in stockCtrls.values) {
      c.dispose();
    }
    for (final c in printPrimaryCtrls.values) {
      c.dispose();
    }
    for (final c in printSecondaryCtrls.values) {
      c.dispose();
    }
    super.onClose();
  }

  fetchApi() async {
    isLoading.value = true;

    var reqType = await typeRepo.list();
    var reqSize = await sizeRepo.list();
    var reqColor = await colorsRepo.list();

    await reqType.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          resType.add(TypeModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );
    await reqSize.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          resSize.add(SizeModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );
    await reqColor.responseHandler(
      res: (res) {
        for (var data in res["data"]) {
          resColor.add(ColorsModel.fromJson(data));
        }
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    ProductDetailParams params = ProductDetailParams.fromMap(Get.parameters);

    if (params.slug == null) {
      txtGallery.add("".obs);
    } else {
      var reqProduct = await productRepo.detailProduct(slug: params.slug);
      await reqProduct.responseHandler(
        res: (res) {
          resProduct.add(ProductDetailModel.fromJson(res["data"]));

          txtName.text = resProduct[0].name;
          txtIdentity.text = resProduct[0].identity;
          selectedGender.value = {
            "name": resProduct[0].gender["name"],
            "value": resProduct[0].gender["value"],
          };
          selectedType.value = {
            "id": resProduct[0].type["id"],
            "title": resProduct[0].type["name"],
          };
          // txtDescription.text = resProduct[0].description;
          final rawDescription = resProduct[0].description;

          try {
            // coba decode sebagai delta JSON
            final decoded = jsonDecode(rawDescription);

            // kalau berhasil dan berupa List, anggap dia delta
            if (decoded is List) {
              final delta = Delta.fromJson(decoded);
              quillController = QuillController(
                document: Document.fromDelta(delta),
                selection: const TextSelection.collapsed(offset: 0),
              );
            } else {
              // fallback ke plain text
              quillController = QuillController(
                document: Document()..insert(0, rawDescription),
                selection: const TextSelection.collapsed(offset: 0),
              );
            }
          } catch (e) {
            // jsonDecode gagal → berarti plain text
            quillController = QuillController(
              document: Document()..insert(0, rawDescription),
              selection: const TextSelection.collapsed(offset: 0),
            );
          }

          for (var data in resProduct[0].gallery) {
            txtGallery.add((data ?? "").toString().obs);
          }
          txtGallery.add("".obs);

          for (var size in resProduct[0].variation) {
            final sizeName = size["name"];
            selectedSize.add(sizeName);

            final iSize = resSize.indexWhere((s) => s.name == size["name"]);
            if (iSize != -1) {
              resSize[iSize].selected.value = true;
            }

            for (var color in size["color"]) {
              final hex = color["hex"];
              final name = color["name"];
              final iColorSelected = selectedColor.indexWhere(
                (c) => c['hex'] == hex,
              );

              if (iColorSelected == -1) {
                final iColor = resColor.indexWhere((s) => s.name == name);
                if (iColor != -1) {
                  resColor[iColor].selected.value = true;
                }
                selectedColor.add({'hex': hex, 'name': name});
              }
            }
          }

          for (var size in resProduct[0].variation) {
            final sizeName = size["name"];

            for (var color in size["color"]) {
              final hex = color["hex"];

              for (var print in color["print"]) {
                final k = keyFor(sizeName, hex);

                regPriceCtrls[k] = TextEditingController(
                  text: print["price"]["regular"].toString(),
                );
                discPriceCtrls[k] = TextEditingController(
                  text: print["price"]["discount"].toString(),
                );
                stockCtrls[k] = TextEditingController(
                  text: print["stock"].toString(),
                );
                printPrimaryCtrls[k] = TextEditingController(
                  text: print["primary_hex"].toString(),
                );
                printSecondaryCtrls[k] = TextEditingController(
                  text: print["secondary_hex"].toString(),
                );
              }
            }
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    isLoading.value = false;
  }

  String keyFor(String size, String hex) => '$size|$hex';

  TextEditingController _ensure(
    Map<String, TextEditingController> map,
    String key,
  ) {
    return map.putIfAbsent(key, () => TextEditingController());
  }

  void generateControllers() {
    final needed = <String>{};

    for (final size in selectedSize) {
      for (final c in selectedColor) {
        final hex = c['hex']!;
        final k = keyFor(size, hex);
        needed.add(k);
        _ensure(regPriceCtrls, k);
        _ensure(discPriceCtrls, k);
        _ensure(stockCtrls, k);
        _ensure(printPrimaryCtrls, k);
        _ensure(printSecondaryCtrls, k);
      }
    }

    void prune(Map<String, TextEditingController> map) {
      final removeKeys = map.keys.where((k) => !needed.contains(k)).toList();
      for (final k in removeKeys) {
        map[k]?.dispose();
        map.remove(k);
      }
    }

    prune(regPriceCtrls);
    prune(discPriceCtrls);
    prune(stockCtrls);
    prune(printPrimaryCtrls);
    prune(printSecondaryCtrls);

    // pastikan UI refresh
    regPriceCtrls.refresh();
    discPriceCtrls.refresh();
    stockCtrls.refresh();
    printPrimaryCtrls.refresh();
    printSecondaryCtrls.refresh();
  }

  void addImage({required int index}) async {
    await selectImageFrom(
      variable: txtGallery[index],
      isLoading: isLoadingAction,
      gallery: true,
    );

    if (txtGallery[index].value != "" && index < 9) txtGallery.add("".obs);
  }

  selectGender({required Map<String, dynamic> val}) =>
      selectedGender.value = {"name": val["name"], "value": val["value"]};

  selectType({required TypeModel res}) =>
      selectedType.value = {"id": res.id, "title": res.title};

  selectSize({required int index}) {
    resSize[index].selected.value = !resSize[index].selected.value;
    final name = resSize[index].name;
    if (selectedSize.contains(name)) {
      selectedSize.remove(name);
    } else {
      selectedSize.add(name);
    }
    generateControllers();
  }

  // ✅ perbaiki toggle color (hapus/cek berdasarkan hex, bukan Map identity)
  selectColor({required int index}) {
    if (selectedSize.isEmpty) return showErrSnackbar(msg: "Please select Size");
    resColor[index].selected.value = !resColor[index].selected.value;

    final hex = resColor[index].hex;
    final name = resColor[index].name;
    final i = selectedColor.indexWhere((c) => c['hex'] == hex);

    if (i == -1) {
      selectedColor.add({'hex': hex, 'name': name});
    } else {
      selectedColor.removeAt(i);
    }
    generateControllers();
  }

  void save() async {
    isLoadingAction.value = true;

    List<Map<String, dynamic>> variations = [];

    for (final size in selectedSize) {
      List<Map<String, dynamic>> colors = [];

      for (final c in selectedColor) {
        final hex = c['hex']!;
        final k = keyFor(size, hex);

        colors.add({
          "name": c["name"],
          "hex": hex,
          "print": [
            {
              "primary_hex": formatHex(printPrimaryCtrls[k]!.text),
              "secondary_hex": formatHex(printSecondaryCtrls[k]!.text),
              "stock": int.tryParse(stockCtrls[k]?.text ?? '') ?? 0,
              "price_regular": int.tryParse(regPriceCtrls[k]?.text ?? '') ?? 0,
              "price_discount":
                  int.tryParse(discPriceCtrls[k]?.text ?? '') ?? 0,
            },
          ],
        });
      }
      variations.add({"size": size, "color": colors});
    }

    final delta = quillController.document.toDelta();
    final converter = QuillDeltaToHtmlConverter(delta.toJson());
    final htmlDesc = converter.convert();

    var body = {
      "name": txtName.text,
      "identity": txtIdentity.text,
      "gender": selectedGender["value"],
      "type_id": selectedType["id"],
      "description": htmlDesc,
      "gallery": txtGallery
          .where((e) => e.value.trim().isNotEmpty)
          .map((e) => e.value)
          .toList(),
      "variation": variations,
    };
    print(jsonEncode(body));

    ProductDetailParams params = ProductDetailParams.fromMap(Get.parameters);

    if (params.id == null) {
      var req = await productRepo.addProduct(data: body);
      await req.responseHandler(
        res: (res) {
          Get.back();
          showSnackbar(msg: res["message"]);
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    } else {
      var req = await productRepo.addProduct(data: body);
      await req.responseHandler(
        res: (res) {
          Get.back();
          showSnackbar(msg: res["message"]);
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    isLoadingAction.value = false;
  }
}
