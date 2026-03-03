import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ApiUtils {
  ApiUtils._();

  static OverlayEntry? _loaderEntry;

  static Widget loader() {
    return const SpinKitFadingCircle(color: Colors.black, size: 30);
  }

  static void showLoaderDialog({required BuildContext context}) {
    if (_loaderEntry != null) return;

    final overlayContext = Get.overlayContext ?? context;
    final overlay = Overlay.maybeOf(overlayContext, rootOverlay: true);
    if (overlay == null) return;
    _loaderEntry = OverlayEntry(
      builder:
          (_) => const Stack(
            children: [
              ModalBarrier(dismissible: false, color: Color(0x33000000)),
              Center(child: SpinKitFadingCircle(color: Colors.black, size: 30)),
            ],
          ),
    );
    overlay.insert(_loaderEntry!);
  }

  static Future<void> hideLoaderDialog() async {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }
}
