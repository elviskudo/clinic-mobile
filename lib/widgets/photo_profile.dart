import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class PhotoProfile extends StatelessWidget {
  const PhotoProfile({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(999),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: CircleAvatar(
          child: WebsafeSvg.network(
            url ?? 'https://api.dicebear.com/8.x/notionists/svg?seed=johndoe',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
