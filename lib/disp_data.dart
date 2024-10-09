import 'package:flutter/material.dart';
import 'package:galaryapp/get_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that displays a gallery of images fetched from the Pixabay API.
///
/// The [ImageGallery] class fetches images from the Pixabay API and displays them
/// in a scrollable grid. As the user scrolls down, more images are loaded automatically.

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

// State for the [ImageGallery] widget that manages image fetching and pagination.

class _ImageGalleryState extends State<ImageGallery> {
  /// Service class responsible for interacting with the Pixabay API.
  final PixabayService _pixabayService = PixabayService();

  /// A list that stores the images fetched from the Pixabay API.
  final List<dynamic> _images = [];

  /// The current page number used for pagination when fetching images
  int _page = 1;

  /// A boolean that indicates whether the app is currently loading more images.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// Loads images from the Pixabay API.
  ///
  /// Fetches images from the Pixabay API based on the current page and appends them
  /// to the existing image list. It also manages the loading state to prevent duplicate
  /// requests while scrolling.
  Future<void> _loadImages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newImages = await _pixabayService.fetchImages('nature', _page);
      setState(() {
        _images.addAll(newImages);
        _page++;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      /// Builds the app bar with a curved bottom and customized title.
      ///
      /// The app bar has a background color of teal, white foreground text, and
      /// uses the Poppins font for the title. The bottom of the app bar is curved
      /// to create a rounded aesthetic.
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 25, 166, 154),
        foregroundColor: Colors.white,
        title: Text('Pixabay Image Gallery',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900)),
      ),

      /// Builds the grid layout for displaying the images.
      ///
      /// The layout adapts based on the width of the device and adjusts the number
      /// of columns dynamically.
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadImages();
          }
          return true;
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width ~/ 150).toInt(),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            final image = _images[index];
            return GridTile(
              footer: GridTileBar(
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_outline,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${image['likes']}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700,
                              
                                fontSize: 12
                              ),
                              
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye,
                        size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${image['views']}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700,
                              fontSize: 12
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              child: Image.network(image['webformatURL'], fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }
}
