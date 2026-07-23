import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:nocvla_admin/modules/product/detail/product_detail_params.dart';

import '../../../app/core/base_controller.dart';
import '../../../data/models/products/add_products_model.dart';
import '../../../data/models/products/product_type_model.dart';
import '../../../shared/utils/my_utility.dart';
import '../../../shared/widgets/my_confirm_dialog.dart';

class ProductDetailController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();
  var txtColor = TextEditingController();
  var txtUrlShopee = TextEditingController();
  var txtUrlTiktokShop = TextEditingController();
  var txtUrlTokped = TextEditingController();

  QuillController quillController = QuillController.basic();

  var resTypes = <ProductTypeModel>[].obs;
  var selectedType = Rxn<ProductTypeModel>();

  var gallery = <GalleryImage>[].obs;
  var stockRows = <Map<String, TextEditingController>>[].obs;

  ProductDetailParams get params => ProductDetailParams.fromMap(Get.parameters);
  bool get isDuplicating => params.id == null && params.duplicateId != null;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    txtName.dispose();
    txtColor.dispose();
    txtUrlShopee.dispose();
    txtUrlTiktokShop.dispose();
    txtUrlTokped.dispose();
    quillController.dispose();
    for (final row in stockRows) {
      row["size"]?.dispose();
      row["qty"]?.dispose();
      row["price"]?.dispose();
    }
    super.onClose();
  }

  fetchApi() async {
    isLoading.value = true;

    final reqTypes = await productsRepo.listProductTypes();
    await reqTypes.responseHandler(
      res: (res) {
        resTypes.value = (res as List)
            .map((e) => ProductTypeModel.fromJson(e))
            .toList();
      },
      err: (err) => showErrSnackbar(msg: err),
    );

    final sourceId = params.id ?? params.duplicateId;

    if (sourceId != null) {
      final reqDetail = await productsRepo.detailProduct(id: sourceId);
      await reqDetail.responseHandler(
        res: (res) {
          final product = AddProductsModel.fromJson(res);

          txtName.text = product.name ?? "";
          txtColor.text = product.color ?? "";
          txtUrlShopee.text = product.shopeeUrl ?? "";
          txtUrlTiktokShop.text = product.tiktokUrl ?? "";
          txtUrlTokped.text = product.tokopediaUrl ?? "";

          for (final type in resTypes) {
            if (type.id == product.productTypeId) {
              selectedType.value = type;
              break;
            }
          }

          final rawDescription = product.description;
          if (rawDescription != null && rawDescription.toString().isNotEmpty) {
            try {
              final delta = Delta.fromJson(jsonDecode(rawDescription));
              quillController = QuillController(
                document: Document.fromDelta(delta),
                selection: const TextSelection.collapsed(offset: 0),
              );
            } catch (e) {
              quillController = QuillController(
                document: Document()..insert(0, rawDescription.toString()),
                selection: const TextSelection.collapsed(offset: 0),
              );
            }
          }

          for (final image in product.images ?? []) {
            gallery.add(GalleryImage(existingPath: image.imageUrl));
          }

          for (final v in product.variation ?? []) {
            addStockRow(
              size: v.size?.toString(),
              qty: v.qty?.toString(),
              price: v.price?.toString(),
            );
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    if (stockRows.isEmpty) addStockRow();

    isLoading.value = false;
  }

  void selectType({required ProductTypeModel res}) => selectedType.value = res;

  void addStockRow({String? size, String? qty, String? price}) {
    stockRows.add({
      "size": TextEditingController(text: size),
      "qty": TextEditingController(text: qty),
      "price": TextEditingController(text: price),
    });
  }

  Future<void> removeStockRow({required int index}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Baris Stok?");
    if (!confirmed) return;

    stockRows[index]["size"]?.dispose();
    stockRows[index]["qty"]?.dispose();
    stockRows[index]["price"]?.dispose();
    stockRows.removeAt(index);
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.bytes == null) continue;
      gallery.add(GalleryImage(newBytes: file.bytes, newFileName: file.name));
    }
  }

  Future<void> removeImage({required int index}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Gambar?");
    if (!confirmed) return;

    gallery.removeAt(index);
  }

  void reorderGallery({required int oldIndex, required int newIndex}) {
    final item = gallery.removeAt(oldIndex);
    gallery.insert(newIndex, item);
  }

  Future<void> save() async {
    if (gallery.isEmpty) {
      return showErrSnackbar(msg: "Foto produk wajib diisi");
    }
    if (txtName.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Nama produk wajib diisi");
    }
    if (txtColor.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Warna wajib diisi");
    }
    if (selectedType.value == null) {
      return showErrSnackbar(msg: "Type wajib diisi");
    }

    isLoadingAction.value = true;

    final delta = quillController.document.toDelta();
    final body = {
      "name": txtName.text,
      "color": txtColor.text,
      "description": jsonEncode(delta.toJson()),
      "shopee_url": txtUrlShopee.text,
      "tiktok_url": txtUrlTiktokShop.text,
      "tokopedia_url": txtUrlTokped.text,
      "product_type_id": selectedType.value?.id,
    };

    var hasError = false;
    String? productId = params.id;

    if (productId == null) {
      final reqAdd = await productsRepo.addProduct(body: body);
      await reqAdd.responseHandler(
        res: (res) => productId = AddProductsModel.fromJson(res).id,
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    } else {
      final reqUpdate = await productsRepo.updateProduct(
        id: productId,
        body: body,
      );
      await reqUpdate.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (hasError || productId == null) {
      isLoadingAction.value = false;
      return;
    }

    final imageRows = <Map<String, dynamic>>[];
    for (var i = 0; i < gallery.length; i++) {
      final image = gallery[i];
      String? path = image.existingPath;

      if (path == null && image.newBytes != null) {
        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${image.newFileName!}";
        final reqUpload = await productsRepo.uploadImage(
          bytes: image.newBytes!,
          fileName: fileName,
        );
        await reqUpload.responseHandler(
          res: (res) => path = res,
          err: (err) {
            hasError = true;
            showErrSnackbar(msg: err);
          },
        );
      }

      if (path != null) {
        imageRows.add({"image_url": path, "sort_order": i});
      }
    }

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    if (params.id != null) {
      final reqDeleteImages = await productsRepo.deleteProductImages(
        productId: productId!,
      );
      await reqDeleteImages.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );

      final reqDeleteStocks = await productsRepo.deleteProductStocks(
        productId: productId!,
      );
      await reqDeleteStocks.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    if (hasError) {
      isLoadingAction.value = false;
      return;
    }

    if (imageRows.isNotEmpty) {
      final reqImages = await productsRepo.addImages(
        body: imageRows
            .map((row) => {"product_id": productId, ...row})
            .toList(),
      );
      await reqImages.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    final stockBody = stockRows
        .where((row) => row["size"]!.text.trim().isNotEmpty)
        .map(
          (row) => {
            "product_id": productId,
            "size": row["size"]!.text,
            "qty": int.tryParse(row["qty"]!.text) ?? 0,
            "price": double.tryParse(row["price"]!.text) ?? 0,
          },
        )
        .toList();

    if (stockBody.isNotEmpty) {
      final reqStocks = await productsRepo.addStocks(body: stockBody);
      await reqStocks.responseHandler(
        res: (res) {},
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    }

    isLoadingAction.value = false;

    if (hasError) return;

    Get.back();
    showSnackbar(msg: "Produk berhasil disimpan");
  }
}

class GalleryImage {
  final String? existingPath;
  final Uint8List? newBytes;
  final String? newFileName;

  GalleryImage({this.existingPath, this.newBytes, this.newFileName});
}
