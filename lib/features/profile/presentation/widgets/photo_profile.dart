import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../store.dart';

class PhotoProfile extends RearchConsumer {
  const PhotoProfile({
    super.key,
    this.size = 20,
    this.onPressed,
  });

  final double size;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (pp, placeholder) = use(avatar$);
    final avatar = pp ?? placeholder;

    return Skeletonizer(
      enabled: pp == null,
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: pp != null
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Skeleton.leaf(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: CircleAvatar(
                radius: size,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                child: avatar.contains('http')
                    ? avatar.contains('api.dicebear.com') ||
                            avatar.contains('svg')
                        ? WebsafeSvg.network(avatar, fit: BoxFit.cover)
                        : Image.network(avatar, fit: BoxFit.cover)
                    : Image.file(File(avatar)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
