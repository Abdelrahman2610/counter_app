import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportService {
  static final ScreenshotController screenshotController =
      ScreenshotController();

  static Future<void> shareCounterAsText(String name, int value) async {
    final text =
        '''
🔢= Counter: $name
📊 Current Value: $value
📱 Shared from Advanced Counter App
    ''';

    await Share.share(text);
  }

  static Future<void> shareCounterAsImage(Widget widget) async {
    try {
      final Uint8List? image = await screenshotController.captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 100),
      );

      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/counter_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        await Share.shareXFiles([
          XFile(imagePath),
        ], text: 'Check out my counter!');
      }
    } catch (e) {
      print('Error sharing image: $e');
    }
  }
}
