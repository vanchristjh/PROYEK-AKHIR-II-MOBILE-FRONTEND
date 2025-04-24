import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 24.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(
        Icons.person,
        size: radius * 1.2,
        color: Colors.grey[800],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.person,
          size: radius * 1.2,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}