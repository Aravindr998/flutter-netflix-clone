import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExclusiveCard extends StatelessWidget {
  const ExclusiveCard({super.key, required this.trendingItem});
  final dynamic trendingItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              '${dotenv.env['TMDB_IMAGE_URL']}${trendingItem['poster_path']}',
              fit: BoxFit.cover,
              width: 150,
              height: 280,
            ),
          )
        ],
      ),
    );
  }
}
