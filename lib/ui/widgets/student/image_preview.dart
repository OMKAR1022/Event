import 'package:flutter/material.dart';
import '../../../utils/screen_size.dart';
import '../network_aware_image.dart';


class ImagePreview extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onClose;

  const ImagePreview({
    Key? key,
    required this.imageUrl,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Center(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              NetworkAwareImage(
                height: ScreenSize.height(context, 1.5),
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

