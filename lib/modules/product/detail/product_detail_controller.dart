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
import '../../../data/models/products/list_products_model.dart';
import '../../../data/models/products/product_type_model.dart';
import '../../../shared/utils/my_utility.dart';
import '../../../shared/widgets/my_confirm_dialog.dart';

class ProductDetailController extends BaseController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;

  var txtName = TextEditingController();
  var txtUrlShopee = TextEditingController();
  var txtUrlTiktokShop = TextEditingController();
  var txtUrlTokped = TextEditingController();

  QuillController quillController = QuillController.basic();

  var resTypes = <ProductTypeModel>[].obs;
  var selectedType = Rxn<ProductTypeModel>();

  var sizeTags = <TextEditingController>[].obs;
  var colorTags = <ProductColorTag>[].obs;

  ProductDetailParams get params => ProductDetailParams.fromMap(Get.parameters);
  bool get isEditing => params.id != null;
  bool get isDuplicating => params.id == null && params.duplicateId != null;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  @override
  void onClose() {
    txtName.dispose();
    txtUrlShopee.dispose();
    txtUrlTiktokShop.dispose();
    txtUrlTokped.dispose();
    quillController.dispose();
    for (final tag in sizeTags) {
      tag.dispose();
    }
    for (final tag in colorTags) {
      tag.dispose();
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
      final reqDetail = await productsRepo.detailProductWithColors(
        id: sourceId,
      );
      await reqDetail.responseHandler(
        res: (res) {
          _populateSharedFields(AddProductsModel.fromProductJson(res));

          for (final c in (res["colors"] as List? ?? [])) {
            colorTags.add(
              _buildColorTag(
                id: isEditing ? c["id"] : null,
                name: c["name"],
                images: (c["images"] as List?)
                    ?.map((e) => ProductImagesModel.fromJson(e))
                    .toList(),
                variation: (c["variation"] as List?)
                    ?.map((e) => ProductVariationModel.fromJson(e))
                    .toList(),
              ),
            );
          }
        },
        err: (err) => showErrSnackbar(msg: err),
      );
    }

    if (colorTags.isEmpty) addColorTag();

    isLoading.value = false;
  }

  void _populateSharedFields(AddProductsModel product) {
    txtName.text = product.productName ?? "";
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
  }

  void _ensureSizeTag(String size) {
    if (sizeTags.any((t) => t.text == size)) return;

    sizeTags.add(TextEditingController(text: size));
    for (final tag in colorTags) {
      tag.stockCells.add(StockCell());
    }
  }

  ProductColorTag _buildColorTag({
    String? id,
    String? name,
    List<ProductImagesModel>? images,
    List<ProductVariationModel>? variation,
  }) {
    for (final v in variation ?? []) {
      final size = v.size?.toString();
      if (size != null && size.isNotEmpty) _ensureSizeTag(size);
    }

    final tag = ProductColorTag()..id = id;
    tag.txtName.text = name ?? "";
    for (final image in images ?? []) {
      tag.gallery.add(GalleryImage(existingPath: image.imageUrl));
    }

    final cellCount = sizeTags.isEmpty ? 1 : sizeTags.length;
    for (var i = 0; i < cellCount; i++) {
      final cell = StockCell();
      final sizeLabel = sizeTags.isEmpty ? null : sizeTags[i].text;
      for (final v in variation ?? []) {
        if ((v.size?.toString() ?? "") == (sizeLabel ?? "")) {
          cell.qty.text = v.qty?.toString() ?? "";
          cell.price.text = v.price?.toString() ?? "";
          break;
        }
      }
      tag.stockCells.add(cell);
    }

    return tag;
  }

  void selectType({required ProductTypeModel res}) => selectedType.value = res;

  void addSizeTag() {
    sizeTags.add(TextEditingController());
    for (final tag in colorTags) {
      if (sizeTags.length > tag.stockCells.length) {
        tag.stockCells.add(StockCell());
      }
    }
  }

  Future<void> removeSizeTag({required int index}) async {
    final confirmed = await showMyConfirmDialog(
      title: "Hapus Ukuran Ini?",
      message:
          "Kolom stok utk ukuran ini akan hilang dari semua warna. Data yang sudah dihapus tidak bisa dikembalikan.",
    );
    if (!confirmed) return;

    sizeTags[index].dispose();
    sizeTags.removeAt(index);

    for (final tag in colorTags) {
      if (tag.stockCells.length > 1 && index < tag.stockCells.length) {
        tag.stockCells.removeAt(index).dispose();
      }
    }
  }

  void addColorTag() {
    final tag = ProductColorTag();
    final cellCount = sizeTags.isEmpty ? 1 : sizeTags.length;
    for (var i = 0; i < cellCount; i++) {
      tag.stockCells.add(StockCell());
    }
    colorTags.add(tag);
  }

  Future<void> removeColorTag({required int index}) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Warna Ini?");
    if (!confirmed) return;

    colorTags[index].dispose();
    colorTags.removeAt(index);
  }

  Future<void> pickImage({required int colorIndex}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (file.bytes == null) continue;
      colorTags[colorIndex].gallery.add(
        GalleryImage(newBytes: file.bytes, newFileName: file.name),
      );
    }
  }

  Future<void> removeImage({
    required int colorIndex,
    required int imageIndex,
  }) async {
    final confirmed = await showMyConfirmDialog(title: "Hapus Gambar?");
    if (!confirmed) return;

    colorTags[colorIndex].gallery.removeAt(imageIndex);
  }

  void reorderGallery({
    required int colorIndex,
    required int oldIndex,
    required int newIndex,
  }) {
    final gallery = colorTags[colorIndex].gallery;
    final item = gallery.removeAt(oldIndex);
    gallery.insert(newIndex, item);
  }

  Map<String, dynamic> _sharedFieldsBody(Delta delta) => {
    "name": txtName.text,
    "description": jsonEncode(delta.toJson()),
    "shopee_url": txtUrlShopee.text,
    "tiktok_url": txtUrlTiktokShop.text,
    "tokopedia_url": txtUrlTokped.text,
    "product_type_id": selectedType.value?.id,
  };

  Future<void> save() async {
    if (colorTags.isEmpty) {
      return showErrSnackbar(msg: "Minimal harus ada 1 warna");
    }
    if (txtName.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Nama produk wajib diisi");
    }
    if (selectedType.value == null) {
      return showErrSnackbar(msg: "Type wajib diisi");
    }
    for (final tag in colorTags) {
      if (tag.txtName.text.trim().isEmpty) {
        return showErrSnackbar(msg: "Nama warna wajib diisi");
      }
      if (tag.gallery.isEmpty) {
        return showErrSnackbar(
          msg: "Foto utk warna \"${tag.txtName.text}\" wajib diisi",
        );
      }
      for (final cell in tag.stockCells) {
        if (cell.qty.text.trim().isEmpty || cell.price.text.trim().isEmpty) {
          return showErrSnackbar(
            msg: "Harga & Stok wajib diisi utk semua kombinasi warna & ukuran",
          );
        }
      }
    }

    isLoadingAction.value = true;
    var hasError = false;

    final delta = quillController.document.toDelta();
    final productBody = _sharedFieldsBody(delta);

    String? productId = params.id;

    if (productId == null) {
      final reqAdd = await productsRepo.addProduct(body: productBody);
      await reqAdd.responseHandler(
        res: (res) => productId = res["id"],
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );
    } else {
      final reqUpdate = await productsRepo.updateProduct(
        id: productId,
        body: productBody,
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

    final String resolvedProductId = productId!;

    if (isEditing) {
      var oldColorIds = <String>[];
      final reqOldColors = await productsRepo.listProductColorIds(
        productId: resolvedProductId,
      );
      await reqOldColors.responseHandler(
        res: (res) =>
            oldColorIds = (res as List).map((row) => row["id"] as String).toList(),
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );

      if (hasError) {
        isLoadingAction.value = false;
        return;
      }

      for (final oldColorId in oldColorIds) {
        final reqDelImages = await productsRepo.deleteProductImages(
          productColorId: oldColorId,
        );
        await reqDelImages.responseHandler(
          res: (res) {},
          err: (err) {
            hasError = true;
            showErrSnackbar(msg: err);
          },
        );

        final reqDelStocks = await productsRepo.deleteProductStocks(
          productColorId: oldColorId,
        );
        await reqDelStocks.responseHandler(
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

      final reqDeleteColors = await productsRepo.deleteProductColorsByProduct(
        productId: resolvedProductId,
      );
      await reqDeleteColors.responseHandler(
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

    for (final tag in colorTags) {
      final reqAddColor = await productsRepo.addColor(
        body: {"product_id": resolvedProductId, "name": tag.txtName.text},
      );

      String? colorId;
      await reqAddColor.responseHandler(
        res: (res) => colorId = res["id"],
        err: (err) {
          hasError = true;
          showErrSnackbar(msg: err);
        },
      );

      if (hasError || colorId == null) break;
      final String resolvedColorId = colorId!;

      final imageRows = <Map<String, dynamic>>[];
      for (var i = 0; i < tag.gallery.length; i++) {
        final image = tag.gallery[i];
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
          imageRows.add({
            "product_color_id": resolvedColorId,
            "image_url": path,
            "sort_order": i,
          });
        }
      }

      if (hasError) break;

      if (imageRows.isNotEmpty) {
        final reqImages = await productsRepo.addImages(body: imageRows);
        await reqImages.responseHandler(
          res: (res) {},
          err: (err) {
            hasError = true;
            showErrSnackbar(msg: err);
          },
        );
      }

      if (hasError) break;

      final stockBody = <Map<String, dynamic>>[];
      for (var i = 0; i < tag.stockCells.length; i++) {
        final cell = tag.stockCells[i];
        stockBody.add({
          "product_color_id": resolvedColorId,
          "size": sizeTags.isEmpty ? null : sizeTags[i].text,
          "qty": int.tryParse(cell.qty.text) ?? 0,
          "price": double.tryParse(cell.price.text) ?? 0,
        });
      }

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

      if (hasError) break;
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

class StockCell {
  var qty = TextEditingController();
  var price = TextEditingController();

  void dispose() {
    qty.dispose();
    price.dispose();
  }
}

class ProductColorTag {
  String? id;
  var txtName = TextEditingController();
  var gallery = <GalleryImage>[].obs;
  var stockCells = <StockCell>[].obs;

  void dispose() {
    txtName.dispose();
    for (final cell in stockCells) {
      cell.dispose();
    }
  }
}
