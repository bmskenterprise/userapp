// lib/widgets/image_slider.dart
//import 'dart:convert';
import 'package:bmsk_userapp/services/SliderService.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';


class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}


class _ImageSliderState extends State<ImageSlider> {
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSliderImages();
  }
  /*Future<void> fetchImages() async {
    final response = await http.get(Uri.parse('https://yourapi.com/images'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Assuming API returns a list of image URLs
      setState(() {
        imageUrls = data.cast<String>();
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }*/

  Future getSliderImages ()async {
    List<String> urls=await SliderService().fetchSliderURLs();
    setState(() {
      imageUrls = urls;
    });
  }
  @override
  Widget build(BuildContext context) {
    /*if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

      return const Center(child: Text('No images found.'));*/

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items:
        imageUrls.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          );
        }).toList(),
    );
  }
}
