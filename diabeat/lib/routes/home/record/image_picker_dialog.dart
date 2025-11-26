import 'package:diabeat/util.dart' as util;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog._();

  static Future<ImageSource?> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ImagePickerDialog._(),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('選擇來源', textAlign: TextAlign.center),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () {
            context.pop(ImageSource.camera);
          },
          style: util.filledPageButtonStyle(),
          label: const Text('拍照'),
          icon: const Icon(Icons.camera_alt_rounded),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          onPressed: () {
            context.pop(ImageSource.gallery);
          },
          style: util.tonalPageButtonStyle(context),
          icon: const Icon(Icons.photo_rounded),
          label: const Text('圖庫'),
        ),
      ],
    ),
  );
}
