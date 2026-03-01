import 'package:flutter/material.dart';
import '../../../../../shared/widgets/cached_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductGallery extends StatefulWidget {
  final List<String> images;
  final String productId;

  const ProductGallery({
    super.key,
    required this.images,
    required this.productId,
  });

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 500,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 550, // Full mobile optimized height
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return CachedImage(
                imageUrl: widget.images[index],
                fit: BoxFit.cover,
              );
            },
          ),

          if (widget.images.length > 1)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.images.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: const Color(0xFF202020),
                    dotColor: const Color(0xFF202020).withValues(alpha: 0.3),
                    dotHeight: 4,
                    dotWidth: 8,
                    spacing: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
