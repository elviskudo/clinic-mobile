import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:websafe_svg/websafe_svg.dart';

class PhotoProfile extends StatelessWidget {
  const PhotoProfile({super.key, this.url, this.size, this.onPressed});

  final String? url;
  final double? size;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    var imageUrl =
        url ?? 'https://api.dicebear.com/8.x/notionists/svg?seed=johndoe';

    return GestureDetector(
      onTap: onPressed ?? () => context.push('/account/settings'),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(999),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: CircleAvatar(
            radius: size ?? 20,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: imageUrl.contains('api.dicebear.com') ||
                    imageUrl.contains('svg')
                ? WebsafeSvg.network(imageUrl, fit: BoxFit.cover)
                : CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
