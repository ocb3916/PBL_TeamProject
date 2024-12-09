import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../data/movie_watch_history_data.dart';
import '../model/movie_model.dart';
import '../model/movie_watch_history.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_detail_screen.dart';

class WatchedMoviesScreen extends StatefulWidget {
  final String userId;

  WatchedMoviesScreen({required this.userId});

  @override
  _WatchedMoviesScreenState createState() => _WatchedMoviesScreenState();
}

class _WatchedMoviesScreenState extends State<WatchedMoviesScreen> {
  List<MovieModel> _watchedMovies = [];
  bool _isLoading = true;
  final MovieWatchHistoryData _movieWatchHistoryData = MovieWatchHistoryData();
  final MovieData _movieData = MovieData();

  @override
  void initState() {
    super.initState();
    _fetchWatchedMovies();
  }

  void _fetchWatchedMovies() async {
    try {
      List<MovieWatchHistory> movieWatchHistories = await _movieWatchHistoryData.fetchMovieWatchHistories(widget.userId);
      List<MovieModel> movieModels = [];
      for (var history in movieWatchHistories) {
        MovieModel movie = await _movieData.fetchMovieById(history.tmdbId);
        movieModels.add(movie);
      }
      setState(() {
        _watchedMovies = movieModels;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching watched movies: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteWatchedMovie(int id) async {
    try {
      await _movieWatchHistoryData.deleteMovieWatchHistory(id);
      setState(() {
        _watchedMovies.removeWhere((movie) => movie.id == id);
      });
    } catch (e) {
      print("Error deleting watched movie: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('시청 기록에서 삭제하는 데 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // 상단 바 사용
      body: Container(
        color: AppColors.background,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '시청기록', // 제목
                style: TextStyle(color: AppColors.textWhite, fontSize: 24),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  childAspectRatio: 2 / 3, // 비율 설정
                ),
                itemCount: _watchedMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        MovieCard(
                          title: _watchedMovies[index].title,
                          image: Image.network(
                            'https://image.tmdb.org/t/p/w500${_watchedMovies[index].posterPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                          releaseInfo: '${_watchedMovies[index].releaseDate} · ${_watchedMovies[index].originalLanguage}',
                          movieId: _watchedMovies[index].id,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(movieId: _watchedMovies[index].id),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteWatchedMovie(_watchedMovies[index].id);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
