import 'package:flutter/material.dart';

class BaseAvatar extends StatelessWidget {
  final String imageUrl;
  final double? radius;
  final String? fallbackText;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final BoxShape? shape;
  final bool? isEdit;
  final VoidCallback? onEdit;

  const BaseAvatar({
    super.key,
    required this.imageUrl,
    this.radius,
    this.fallbackText,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.onTap,
    this.shape,
    this.isEdit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = radius ?? 24;
    final isNetworkImage = imageUrl.isNotEmpty && imageUrl.startsWith('http');

    final imageWidget = isNetworkImage
        ? ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: avatarSize * 2,
              height: avatarSize * 2,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: avatarSize * 2,
                  height: avatarSize * 2,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _fallbackAvatar(avatarSize);
              },
            ),
          )
        : _fallbackAvatar(avatarSize);

    final avatarWithEdit = Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: imageWidget,
        ),
        if (isEdit == true)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: avatarSize * 0.6,
                height: avatarSize * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black54, width: 1),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: avatarSize * 0.4,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
      ],
    );

    return SizedBox(
      width: avatarSize * 2,
      height: avatarSize * 2,
      child: isEdit == true ? avatarWithEdit : imageWidget,
    );
  }

  Widget _fallbackAvatar(double avatarSize) {
    return Container(
      width: avatarSize * 2,
      height: avatarSize * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape ?? BoxShape.circle,
      ),
      child: Text(
        fallbackText?.toUpperCase() ?? '?',
        style: TextStyle(
          fontSize: avatarSize * 0.9,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
