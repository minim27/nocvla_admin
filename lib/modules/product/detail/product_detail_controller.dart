import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/data/models/master/colors_model.dart';
import 'package:nocvla_admin/data/models/master/size_model.dart';
import 'package:nocvla_admin/data/models/master/type_model.dart';

import '../../../app/core/base_controller.dart';
import '../../../shared/utils/my_utility.dart';

class ProductDetailController extends BaseController {
  var resType = <TypeModel>[];
  var resSize = <SizeModel>[];
  var resColor = <ColorsModel>[];

  var gender = <Map<String, dynamic>>[
    {"name": "Male", "value": "m"},
    {"name": "Female", "value": "f"},
  ];

  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();
  var txtIdentity = TextEditingController();
  var selectedGender = {}.obs;
  var selectedType = {}.obs;
  var txtDescription = TextEditingController();
  var txtGallery = <RxString>[].obs;

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

    txtGallery.add("".obs);
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
    // isLoadingAction.value = true;

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

    var body = {
      "name": txtName.text,
      "identity": txtIdentity.text,
      "gender": selectedGender["value"],
      "type_id": selectedType["id"],
      "description": txtDescription.text,
      "gallery": txtGallery
          .where((e) => e.value.trim().isNotEmpty)
          .map((e) => e.value)
          .toList(),
      "variation": variations,
    };
    print(jsonEncode(body));

    isLoadingAction.value = false;
  }
}
