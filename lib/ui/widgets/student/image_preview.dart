import 'package:flutter/material.dart';

import '../network_aware_image.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;
  //final VoidCallback onClose;

  const ImagePreview({
    Key? key,
    required this.imageUrl,
  //  required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     // onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'preview_$imageUrl',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: NetworkAwareImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          /*  Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
              //  onPressed: onClose,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

