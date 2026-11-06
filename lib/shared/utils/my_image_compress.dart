import 'dart:async';
import 'dart:js_interop';
import 'dart:math';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Memperkecil gambar sebelum upload. Foto menjadi JPEG, PNG transparan tetap
/// PNG. Bila gagal atau hasilnya tidak lebih kecil, file asli dipakai.
Future<({Uint8List bytes, String fileName})> compressImage({
  required Uint8List bytes,
  required String fileName,
  int maxSize = 1600,
}) async {
  final original = (bytes: bytes, fileName: fileName);
  final dot = fileName.lastIndexOf(".");
  final ext = dot < 0 ? "" : fileName.substring(dot + 1).toLowerCase();

  if (bytes.lengthInBytes < 300 * 1024) return original;
  if (!const ["jpg", "jpeg", "png", "webp"].contains(ext)) return original;

  try {
    final bitmap = await web.window
        .createImageBitmap(web.Blob([bytes.toJS].toJS))
        .toDart;
    final scale = min(1.0, maxSize / max(bitmap.width, bitmap.height));
    final width = (bitmap.width * scale).round();
    final height = (bitmap.height * scale).round();

    final canvas = web.HTMLCanvasElement()
      ..width = width
      ..height = height;
    final context = canvas.getContext("2d") as web.CanvasRenderingContext2D;
    context.drawImage(bitmap, 0, 0, width, height);
    bitmap.close();

    var hasAlpha = false;
    if (ext == "png") {
      final pixels = context.getImageData(0, 0, width, height).data.toDart;
      for (var i = 3; i < pixels.length; i += 4) {
        if (pixels[i] < 255) {
          hasAlpha = true;
          break;
        }
      }
    }

    final completer = Completer<web.Blob?>();
    canvas.toBlob(
      ((web.Blob? blob) => completer.complete(blob)).toJS,
      hasAlpha ? "image/png" : "image/jpeg",
      0.85.toJS,
    );
    final blob = await completer.future;
    if (blob == null) return original;

    final result = (await blob.arrayBuffer().toDart).toDart.asUint8List();
    if (result.lengthInBytes >= bytes.lengthInBytes) return original;

    final name = dot < 0 ? fileName : fileName.substring(0, dot);
    return (bytes: result, fileName: "$name.${hasAlpha ? "png" : "jpg"}");
  } catch (_) {
    return original;
  }
}
