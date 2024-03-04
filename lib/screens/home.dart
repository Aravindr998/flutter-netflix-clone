import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:netflix_clone/api/network_request.dart';
import 'package:netflix_clone/widgets/exclusive_card.dart';
import 'package:netflix_clone/widgets/top_ten_card.dart';
import 'package:netflix_clone/widgets/trending_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var error = "";
  late dynamic trending;
  late List<String> genre;
  late List<dynamic> trendingList;

  Future<void> _getTrendingCardDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = "";
      });
      const genreUrl =
          'https://api.themoviedb.org/3/genre/movie/list?language=en';
      const url =
          'https://api.themoviedb.org/3/trending/movie/day?language=en-US';
      final headers = {
        'Authorization': 'Bearer ${dotenv.env['TMDB_BEARER_TOKEN']}',
        'accept': 'application/json',
      };

      final genreData =
          await NetworkRequest(genreUrl, headers: headers).sendRequest();

      final data =
          await NetworkRequest(url, headers: headers, method: HttpMethods.get)
              .sendRequest();

      setState(() {
        genre = (genreData['genres'] as List)
            .where(
                (item) => data['results'][1]['genre_ids'].contains(item['id']))
            .map<String>((item) => item['name'] as String)
            .toList();
        trending = data['results'][1];
        trendingList = data['results'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = "Something went wrong, Please try again later";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTrendingCardDetails();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );
    if (error.isNotEmpty) {
      content = Center(
        child: Text(error),
      );
    }
    if (!isLoading && error.isEmpty) {
      content = SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                    ),
                    child: const Text(
                      'TV Shows',
                      style:
                          TextStyle(color: Color.fromARGB(255, 181, 200, 211)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                    ),
                    child: const Text(
                      'Movies',
                      style:
                          TextStyle(color: Color.fromARGB(255, 181, 200, 211)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            color: Color.fromARGB(255, 181, 200, 211),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromARGB(255, 181, 200, 211),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TrendingCard(
                trending: trending,
                genre: genre,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Only on Netflix",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: trendingList.length,
                itemBuilder: (ctx, index) {
                  return ExclusiveCard(trendingItem: trendingList[index]);
                },
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Top 10 Movies",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (ctx, index) {
                  return TopTenCard(
                    content: trendingList[index],
                    index: (index + 1).toString(),
                  );
                },
                separatorBuilder: (ctx, index) => const SizedBox(
                  width: 5,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 26, 50, 69),
            Color.fromARGB(255, 25, 25, 25),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text(
            'For User',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(child: content),
      ),
    );
  }
}
