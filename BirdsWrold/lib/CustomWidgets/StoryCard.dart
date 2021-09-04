import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.aspectRatio);
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
              image: NetworkImage(imagePath), fit: BoxFit.cover),
          ),
        ),
        Text(

          title,
          textAlign: TextAlign.center,
          style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black),
        ),
      ],
    );
  }
}
