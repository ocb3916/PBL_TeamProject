import 'package:flutter/material.dart';
import '../SharedPreference.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../data/favorite_movie_data.dart';
import '../model/movie_model.dart';
import '../model/favorite_movie_model.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_detail_screen.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  final String userId;

  FavoriteMoviesScreen({required this.userId});

  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  List<MovieModel> _favoriteMovies = [];
  bool _isLoading = true;
  final FavoriteMovieData _favoriteMovieData = FavoriteMovieData();
  final MovieData _movieData = MovieData();

  @override
  void initState() {
    super.initState();
    _fetchFavoriteMovies();
  }

  void _fetchFavoriteMovies() async {
    try {
      List<FavoriteMovie> favoriteMovies = await _favoriteMovieData.fetchFavoriteMovies(widget.userId);
      List<MovieModel> movieModels = [];
      for (var favorite in favoriteMovies) {
        MovieModel movie = await _movieData.fetchMovieById(favorite.tmdbId);
        movieModels.add(movie);
      }
      setState(() {
        _favoriteMovies = movieModels;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching favorite movies: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteFavoriteMovie(int id) async {
    try {
      await _favoriteMovieData.deleteFavoriteMovie(id);
      setState(() {
        _favoriteMovies.removeWhere((movie) => movie.id == id);
      });
    } catch (e) {
      print("Error deleting favorite movie: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('관심목록에서 삭제하는 데 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
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
                '관심목록',
                style: TextStyle(color: AppColors.textWhite, fontSize: 24),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: _favoriteMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        MovieCard(
                          title: _favoriteMovies[index].title,
                          image: Image.network(
                            'https://image.tmdb.org/t/p/w500${_favoriteMovies[index].posterPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                          releaseInfo: '${_favoriteMovies[index].releaseDate} · ${_favoriteMovies[index].originalLanguage}',
                          movieId: _favoriteMovies[index].id,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(movieId: _favoriteMovies[index].id),
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
                              _deleteFavoriteMovie(_favoriteMovies[index].id);
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
