import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/core/base_controller.dart';
import '../../data/models/order/wa_order_model.dart';
import '../../data/models/products/list_products_model.dart';
import '../../shared/utils/my_parsing_currency.dart';
import '../../shared/utils/my_utility.dart';
import '../../shared/widgets/my_confirm_dialog.dart';
import 'widgets/order_manual_dialog.dart';

class OrderController extends BaseController {
  static const statuses = {
    "new": "Baru masuk",
    "awaiting_payment": "Menunggu bayar",
    "paid": "Dibayar · dikemas",
    "shipped": "Dikirim",
    "done": "Selesai",
  };
  static const couriers = ["JNE", "J&T", "SiCepat", "Lainnya"];

  final res = <WaOrderModel>[].obs;
  var selected = Rxn<WaOrderModel>();

  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var isTableReady = true.obs;

  var txtShippingFee = TextEditingController();
  var txtAwb = TextEditingController();
  var selectedCourier = RxnString();

  var txtManualName = TextEditingController();
  var txtManualPhone = TextEditingController();
  var txtManualAddress = TextEditingController();
  var txtManualCode = TextEditingController();
  var productOptions = <ListProductsModel>[].obs;
  var manualRows = <OrderManualRow>[].obs;

  int countOf({required String status}) =>
      res.where((e) => e.status == status).length;

  String statusLabel(dynamic status) => status == "cancelled"
      ? "Dibatalkan"
      : statuses[status] ?? "${status ?? "-"}";

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  fetchApi() async {
    isLoading.value = true;

    final req = await orderRepo.listOrders();
    await req.responseHandler(
      res: (res) {
        isTableReady.value = true;
        this.res.value = (res as List)
            .map((e) => WaOrderModel.fromJson(e))
            .toList();

        final id = selected.value?.id;
        final fresh = this.res.where((e) => e.id == id);
        selected.value = fresh.isEmpty ? null : fresh.first;
      },
      err: (err) => isTableReady.value = false,
    );

    isLoading.value = false;
  }

  void selectOrder({required WaOrderModel item}) {
    selected.value = item;
    txtShippingFee.text = item.shippingFee == null
        ? ""
        : "${(item.shippingFee as num).toInt()}";
    txtAwb.text = "${item.awb ?? ""}";
    selectedCourier.value = item.courier;
  }

  void selectCourier({required String value}) => selectedCourier.value = value;

  Future<bool> _save({String? status}) async {
    var isSuccess = true;

    final req = await orderRepo.updateOrder(
      id: selected.value!.id,
      shippingFee: num.tryParse(txtShippingFee.text.trim()),
      courier: selectedCourier.value,
      awb: txtAwb.text.trim().isEmpty ? null : txtAwb.text.trim(),
      status: status,
    );
    await req.responseHandler(
      res: (res) {},
      err: (err) {
        isSuccess = false;
        showErrSnackbar(msg: err);
      },
    );

    return isSuccess;
  }

  Future<void> save() async {
    isLoadingAction.value = true;
    final isSuccess = await _save();
    if (isSuccess) await fetchApi();
    isLoadingAction.value = false;

    if (isSuccess) showSnackbar(msg: "Order berhasil disimpan");
  }

  Future<void> sendTotal() async {
    final order = selected.value!;
    final fee = num.tryParse(txtShippingFee.text.trim());

    if (fee == null) return showErrSnackbar(msg: "Ongkir wajib diisi");
    if ("${order.customerPhone ?? ""}".trim().isEmpty) {
      return showErrSnackbar(msg: "Nomor pembeli belum ada");
    }

    isLoadingAction.value = true;
    final isSuccess = await _save(
      status: order.status == "new" ? "awaiting_payment" : null,
    );
    if (isSuccess) await fetchApi();
    isLoadingAction.value = false;

    if (!isSuccess) return;

    final current = selected.value!;
    final text = StringBuffer()
      ..writeln("Halo ${current.customerName ?? ""}, order ${current.code}:")
      ..writeln(current.itemSummary)
      ..writeln()
      ..writeln("Subtotal: ${parsingCurrency(current.subtotal ?? 0)}");
    if (((current.discount ?? 0) as num) > 0) {
      text.writeln("Diskon: - ${parsingCurrency(current.discount)}");
    }
    text
      ..writeln("Ongkir: ${parsingCurrency(fee)}")
      ..write("Total: ${parsingCurrency(current.total)}");

    final phone = "${current.customerPhone}"
        .replaceAll(RegExp(r"\D"), "")
        .replaceFirst(RegExp(r"^0"), "62");

    await launchUrl(
      Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(text.toString())}",
      ),
      webOnlyWindowName: "_blank",
    );
  }

  Future<void> markPaid() async {
    final confirmed = await showMyConfirmDialog(
      title: "Tandai Dibayar?",
      message: "Stok produk akan berkurang sesuai item order ini.",
      confirmText: "Dibayar",
    );
    if (!confirmed) return;

    isLoadingAction.value = true;
    var isSuccess = await _save();

    if (isSuccess) {
      final req = await orderRepo.markPaid(id: selected.value!.id);
      await req.responseHandler(
        res: (res) {},
        err: (err) {
          isSuccess = false;
          showErrSnackbar(msg: err);
        },
      );
    }

    await fetchApi();
    isLoadingAction.value = false;
  }

  Future<void> markShipped() async {
    if (txtAwb.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Nomor resi wajib diisi");
    }

    isLoadingAction.value = true;
    await _save(status: "shipped");
    await fetchApi();
    isLoadingAction.value = false;
  }

  Future<void> markDone() async {
    isLoadingAction.value = true;
    await _save(status: "done");
    await fetchApi();
    isLoadingAction.value = false;
  }

  Future<void> cancel() async {
    final confirmed = await showMyConfirmDialog(
      title: "Batalkan Order?",
      message: "Stok dikembalikan bila order ini sudah ditandai dibayar.",
      confirmText: "Batalkan",
    );
    if (!confirmed) return;

    isLoadingAction.value = true;

    final req = await orderRepo.cancel(id: selected.value!.id);
    await req.responseHandler(
      res: (res) {},
      err: (err) => showErrSnackbar(msg: err),
    );

    await fetchApi();
    isLoadingAction.value = false;
  }

  Future<void> openManual() async {
    isLoadingAction.value = true;

    final req = await productsRepo.listProducts();
    await req.responseHandler(
      res: (res) => productOptions.value = (res as List)
          .map((e) => ListProductsModel.fromJson(e))
          .toList(),
      err: (err) => showErrSnackbar(msg: err),
    );

    isLoadingAction.value = false;

    txtManualName.clear();
    txtManualPhone.clear();
    txtManualAddress.clear();
    txtManualCode.clear();
    manualRows.value = [OrderManualRow()];

    await Get.dialog(const OrderManualDialog(), barrierDismissible: false);
  }

  void addManualRow() => manualRows.add(OrderManualRow());

  void removeManualRow({required int index}) => manualRows.removeAt(index);

  void selectManualColor({
    required int index,
    required ListProductsModel value,
  }) {
    manualRows[index].color.value = value;
    manualRows[index].size.value = null;
  }

  void selectManualSize({required int index, required String value}) =>
      manualRows[index].size.value = value;

  Future<void> submitManual() async {
    if (txtManualName.text.trim().isEmpty ||
        txtManualPhone.text.trim().isEmpty) {
      return showErrSnackbar(msg: "Nama dan nomor pembeli wajib diisi");
    }

    final items = <Map<String, dynamic>>[];
    for (final row in manualRows) {
      final qty = int.tryParse(row.txtQty.text.trim()) ?? 0;
      if (row.color.value == null || row.size.value == null || qty <= 0) {
        return showErrSnackbar(msg: "Lengkapi produk, ukuran, dan jumlah");
      }
      items.add({
        "color_id": row.color.value!.id,
        "size": row.size.value,
        "qty": qty,
      });
    }

    isLoadingAction.value = true;
    var isSuccess = true;

    final req = await orderRepo.createOrder(
      items: items,
      athleteCode: txtManualCode.text.trim(),
      customerName: txtManualName.text.trim(),
      customerPhone: txtManualPhone.text.trim(),
      address: txtManualAddress.text.trim(),
    );
    await req.responseHandler(
      res: (res) {},
      err: (err) {
        isSuccess = false;
        showErrSnackbar(msg: err);
      },
    );

    isLoadingAction.value = false;

    if (!isSuccess) return;

    Get.back();
    await fetchApi();
    showSnackbar(msg: "Order berhasil dicatat");
  }
}

class OrderManualRow {
  var color = Rxn<ListProductsModel>();
  var size = RxnString();
  var txtQty = TextEditingController(text: "1");
}
