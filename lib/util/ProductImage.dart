import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? urlPath;

  const ProductImage({super.key, this.urlPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            decoration: _buildBoxDecoration(),
            constraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
            // width: double.infinity, esto hace que ocupe todo el ancho
            height: 450,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                ),
                child: _getImage(urlPath) /*FadeInImage(
                  placeholder: AssetImage("assets/images/placeholder.png"),
                  image: NetworkImage("https://placehold.co/400x300/png"),
                  fit: BoxFit.cover
              ),*/
                )));
  }
}

Widget _getImage(String? urlPath) {
  if (urlPath == null) {
    return const Image(
      image: AssetImage("assets/images/placeholder.png"),
      fit: BoxFit.contain,
    );
  }
  return Image.file(File(urlPath), fit: BoxFit.contain);
}

BoxDecoration _buildBoxDecoration() {
  return const BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45), topRight: Radius.circular(45),bottomLeft: Radius.circular(45),
        bottomRight: Radius.circular(45)),
      boxShadow: [
        BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 5))
      ]);
} //BoxDecoration
