import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> _imageUrls = [
    'https://cdn.builder.io/api/v1/image/assets/TEMP/964fc44421c35fe3f8eb851d8e5d32c146b19cdb311656cafdaf14efe5823e7d?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
    'https://cdn.builder.io/api/v1/image/assets/TEMP/ec13e632de02150f7dbf231eda821b0f390e48b6737e1c63ba1fd8a193a85499?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
    'https://cdn.builder.io/api/v1/image/assets/TEMP/b1ffc9d6d113745a8acf5b1d93056b47546178efe2d9fdfad970dcc397635935?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
    'https://cdn.builder.io/api/v1/image/assets/TEMP/3d9f280731bddbc33de90abaf03fbcd2f08a4d0fadc2e2e75d094414c2261841?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
    'https://cdn.builder.io/api/v1/image/assets/TEMP/77ed09dee4a1978219264787c6afaf0a1d893673ad01208f24985109272551f2?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Adjust the height to fit your layout
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Carousel with images
          PageView.builder(
            itemCount: _imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return AspectRatio(
                aspectRatio: 0.908,
                child: Image.network(
                  _imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              );
            },
          ),
          // Dots indicator
          Positioned(
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: _currentIndex == index ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
