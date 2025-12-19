import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
              height: 180,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade200,
              height: 180,
              child: const Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}