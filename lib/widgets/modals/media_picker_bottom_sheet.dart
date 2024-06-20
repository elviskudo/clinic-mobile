import 'dart:async';

import 'package:clinic/providers/permission.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Future<XFile?> showMediaPickerBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  CropStyle cropStyle = CropStyle.circle,
}) async {
  FutureOr<XFile?> show() async {
    return await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => MediaPickerBottomSheet(cropStyle: cropStyle),
      showDragHandle: true,
    );
  }

  XFile? pickedFile;

  final isGranted = await ref.watch(mediaPermissionProvider.future);

  if (!isGranted) {
    ref.read(mediaPermissionProvider.notifier).ask(
      onGranted: () async {
        pickedFile = await show();
      },
    );
  } else {
    pickedFile = await show();
  }

  return pickedFile;
}

class MediaPickerBottomSheet extends HookWidget {
  const MediaPickerBottomSheet({
    super.key,
    this.cropStyle = CropStyle.circle,
  });

  final CropStyle cropStyle;

  void pickFile(BuildContext context, {required ImageSource source}) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (file == null) throw Exception('Image file cannot be empty!');

      await ImageCropper().cropImage(
        sourcePath: file.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 80,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(cropStyle: cropStyle, showCropGrid: false),
          IOSUiSettings(cropStyle: cropStyle),
        ],
      ).then(
        (image) {
          if (image == null) throw Exception('Image file cannot be empty!');
          Navigator.pop<XFile?>(context, XFile(image.path));
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      // ignore: use_build_context_synchronously
      Navigator.pop<XFile?>(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: PhosphorIcon(
              PhosphorIconsRegular.images,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('media_picker_list_tile.gallery')),
            onTap: () => pickFile(context, source: ImageSource.gallery),
          ),
          ListTile(
            leading: PhosphorIcon(
              PhosphorIconsRegular.camera,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(context.tr('media_picker_list_tile.camera')),
            onTap: () => pickFile(context, source: ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
