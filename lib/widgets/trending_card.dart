import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TrendingCard extends StatefulWidget {
  const TrendingCard({super.key, required this.trending, required this.genre});

  final dynamic trending;
  final List<String> genre;

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;
  double gyroX = 0;
  double gyroY = 0;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    )..reverse();
    _animationX = Tween<double>(begin: 0, end: gyroX/50).animate(controller);
    _animationY = Tween<double>(begin: 0, end: gyroY/50).animate(controller);
    gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval).listen(
      (GyroscopeEvent event) {
        if (event.x != gyroX || event.y != gyroY) {
          setState(() {
            _animationX = Tween<double>(begin: gyroX/10, end: event.x/10).animate(controller);
            _animationY = Tween<double>(begin: gyroY/10, end: event.y/10).animate(controller);
            gyroX = event.x;
            gyroY = event.y;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> genreItems = [];
    for (var i = 0; i < widget.genre.length; i++) {
      genreItems.add(
        Text(
          widget.genre[i],
          style: const TextStyle(color: Colors.white),
        ),
      );
      if (i != widget.genre.length - 1) {
        genreItems.add(const SizedBox(
          width: 10,
        ));
        genreItems.add(
          const Icon(
            Icons.brightness_1,
            color: Colors.white,
            size: 5,
          ),
        );
        genreItems.add(const SizedBox(
          width: 10,
        ));
      }
    }
    return AnimatedBuilder(
      animation: Listenable.merge([_animationX, _animationY]),
      builder: (ctx, child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_animationX.value)
          ..rotateY(_animationY.value),
        alignment: FractionalOffset.center,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Stack(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    '${dotenv.env['TMDB_IMAGE_URL']}${widget.trending['poster_path']}',
                width: double.infinity,
                height: 500,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    // color: Colors.black,
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: genreItems,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  foregroundColor: Colors.black,
                                ),
                                label: const Text("Play"),
                                icon: const Icon(Icons.play_arrow),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      105,
                                      117,
                                      117,
                                      117,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    foregroundColor: Colors.white),
                                label: const Text("My List"),
                                icon: const Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
