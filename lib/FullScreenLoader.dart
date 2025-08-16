import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5, // Value between 0.0 (fully transparent) and 1.0 (fully opaque)
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}