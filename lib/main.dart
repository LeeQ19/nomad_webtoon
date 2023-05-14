import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

typedef JsonMap = Map<String, dynamic>;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
        shadowColor: const Color(0xFF323232),
        primaryColorLight: const Color(0xFFF8D748),
        primaryColorDark: const Color(0x88888888),
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          labelMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
          titleLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w900,
            color: Color(0xFFEFEFEF),
          ),
          titleMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEFEFEF),
          ),
          titleSmall: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEFEFEF),
          ),
          bodyMedium: TextStyle(
            fontSize: 20.0,
            color: Color(0xFFEFEFEF),
            height: 1.4,
          ),
          bodySmall: TextStyle(
            fontSize: 18.0,
            color: Color(0xFFACACAC),
          ),
        ),
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Future<List<MovieModel>> populars = ApiService.getPopular();
  final Future<List<MovieModel>> playing = ApiService.getPlaying();
  final Future<List<MovieModel>> coming = ApiService.getComing();
  static const listHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      "Popular Movies",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: listHeight,
                  child: FutureBuilder(
                    future: populars,
                    builder: (context, snapshot) {
                      return _makeList(snapshot, prefix: 'A', span: 2);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      "Now in Cinemas",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: listHeight,
                  child: FutureBuilder(
                    future: playing,
                    builder: (context, snapshot) {
                      return _makeList(snapshot, prefix: 'B');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      "Coming Soon",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: listHeight,
                  child: FutureBuilder(
                    future: coming,
                    builder: (context, snapshot) {
                      return _makeList(snapshot, prefix: 'C');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListView _makeList(AsyncSnapshot<List<MovieModel>> snapshot, {String prefix = '', int span = 1}) {
    const width = 144.0;
    const defaultLength = 4;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data?.length ?? defaultLength,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return MovieCard(
          width: width * span,
          movie: snapshot.data?[index],
          prefix: prefix,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20),
    );
  }
}

class MovieCard extends StatelessWidget {
  final double width;
  final MovieModel? movie;
  final String prefix;

  const MovieCard({
    super.key,
    required this.width,
    required this.movie,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, PageRouteBuilder(pageBuilder: (context, _, __) => DetailView(movie: movie!, prefix: prefix))),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.3),
                  )
                ],
                color: Theme.of(context).shadowColor,
              ),
              child: Poster(
                tag: "$prefix${movie?.id}",
                poster: movie?.poster,
                width: width,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                movie?.title ?? "...",
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Poster extends StatelessWidget {
  final String? poster, tag;
  final double width;
  static const height = 162.0;

  const Poster({
    super.key,
    required this.poster,
    required this.tag,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    const baseUrl = "https://image.tmdb.org/t/p/w500/";

    if (poster == null) {
      return SizedBox(width: width, height: height);
    }

    return SizedBox(
      height: height,
      child: Hero(
        tag: tag ?? '',
        child: Image.network(
          "$baseUrl$poster",
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final MovieModel movie;
  final String prefix;
  static const baseUrl = "https://image.tmdb.org/t/p/w500/";

  const DetailView({
    super.key,
    required this.movie,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final Future<DetailModel?> detail = ApiService.getMovie(movie.id);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            "Back to list",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
      body: FutureBuilder(
        future: detail,
        builder: (context, snapshot) {
          final data = snapshot.data ??
              DetailModel(
                id: movie.id,
                title: movie.title,
                poster: movie.poster,
                overview: "...",
                homepage: "",
                rank: 0,
                genres: [],
              );

          return Hero(
            tag: "$prefix${data.id}",
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("$baseUrl${data.poster}"),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        for (int i = 0; i < 10; i++)
                          Icon(
                            Icons.star_rate_rounded,
                            color: i < data.rank
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).primaryColorDark,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (String genre in data.genres)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              genre,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Storyline",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            data.overview,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => launchUrl(Uri.parse(data.homepage)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColorLight,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Buy Ticket",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieModel {
  int id;
  String title, poster;

  MovieModel.fromJson(JsonMap json)
      : id = json['id'],
        title = json['title'],
        poster = json['poster_path'];
}

class DetailModel {
  int id;
  String poster, title, overview, homepage;
  double rank;
  List<String> genres;

  DetailModel({
    required this.id,
    required this.title,
    required this.poster,
    required this.overview,
    required this.homepage,
    required this.rank,
    required this.genres,
  });

  DetailModel.fromJson(JsonMap json)
      : id = json['id'],
        title = json['title'],
        poster = json['poster_path'],
        overview = json['overview'],
        homepage = json['homepage'],
        rank = json['vote_average'],
        genres = (json['genres'] as Iterable).map((e) => e['name'] as String).toList();
}

class ApiService {
  static const _baseUrl = "https://movies-api.nomadcoders.workers.dev/";

  static List<MovieModel> _getResults(String body) {
    final JsonMap decoded = jsonDecode(body);
    final List resultsDecoded = decoded['results'];
    final List<MovieModel> results = resultsDecoded.map((e) => MovieModel.fromJson(e)).toList();

    return results;
  }

  static Future<List<MovieModel>> getPopular() async {
    final url = Uri.parse("${_baseUrl}popular");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return _getResults(res.body);
    }

    return [];
  }

  static Future<List<MovieModel>> getPlaying() async {
    final url = Uri.parse("${_baseUrl}now-playing");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return _getResults(res.body);
    }

    return [];
  }

  static Future<List<MovieModel>> getComing() async {
    final url = Uri.parse("${_baseUrl}coming-soon");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return _getResults(res.body);
    }

    return [];
  }

  static Future<DetailModel?> getMovie(int id) async {
    final url = Uri.parse("${_baseUrl}movie?id=$id");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return DetailModel.fromJson(jsonDecode(res.body));
    }

    return null;
  }
}
