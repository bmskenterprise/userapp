import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../providers/ApiProvider.dart';
import '../widgets/Toast.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;


class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}


class _ImageSliderState extends State<ImageSlider> {
  //List<String> imageUrls = [];
  bool isLoading = true;

  /*@override
  void initState() {
    super.initState();
    //getSliderImages();
  }*/
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

  /*Future getSliderImages ()async {
    List<String> urls=await ApiService().fetchSliderURLs();
    setState(() {
      imageUrls = urls;
    });
  }*/
  @override
  Widget build(BuildContext context) {
    /*if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }*/

    final api = context.watch<ApiProvider>();//const Center(child: Text('No images found.'));*/
//Toast({'message':api.sliderImages?[0].toString(),'success':true});
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          //height: 100.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          aspectRatio: 4/3
        ),
        items:
          api.sliderImages!.map((String url) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    //width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
      ),
    );
  }
}
