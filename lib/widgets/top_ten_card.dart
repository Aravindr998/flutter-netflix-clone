import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class TopTenCard extends StatelessWidget {
  const TopTenCard({super.key, required this.content, required this.index});
  final String index;
  final dynamic content;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          width: 140,
          height: 160,
        ),
        Positioned(
          left: 0,
          bottom: -10,
          child: Text(
            index,
            style: GoogleFonts.bungeeOutline(
              color: Colors.white,
              fontSize: 100,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: '${dotenv.env['TMDB_IMAGE_URL']}${content['poster_path']}',
              width: 95,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
