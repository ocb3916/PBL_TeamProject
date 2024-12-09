import 'package:flutter/material.dart';
import '../SharedPreference.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../data/movie_watch_history_data.dart'; // 수정된 데이터 클래스
import '../data/favorite_movie_data.dart';
import '../data/review_data.dart';
import '../model/cast_model.dart';
import '../model/movie_model.dart'; // 수정된 모델 클래스
import '../model/favorite_movie_model.dart';
import '../model/movie_watch_history.dart';
import '../model/review_model.dart';
import '../uikit/widgets/more_button.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/review_list_item.dart';
import '../uikit/widgets/movie_card.dart';
import '../constants/genre.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_review_list_screen.dart';
import 'edit_review_screen.dart';
import 'login_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<MovieReview> _reviewData = [];
  List<MovieModel> _similarMovies = [];
  bool _isLoading = true;
  MovieModel? _movieDetail;
  List<CastModel> _castList = [];
  bool _isFavorite = false;
  bool _isWatched = false;

  final FavoriteMovieData _favoriteMovieData = FavoriteMovieData();
  final MovieWatchHistoryData _movieWatchHistoryData = MovieWatchHistoryData();
  final MovieReviewData _movieReviewData = MovieReviewData();

  @override
  void initState() {
    super.initState();
    fetchMovieDetail();
    getSimilarMovies();
    fetchCastDetails();
    fetchReviewsForMovie();
    checkIfFavorite();
    checkIfWatched();
  }

  Future<bool> isLoggedIn() async {
    final userId = SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
    return userId != null;
  }

  Future<String?> getUserId() async {
    return SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
  }

  void navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  fetchMovieDetail() async {
    var data = MovieData();
    try {
      _movieDetail = await data.fetchMovieDetail(widget.movieId);
    } catch (e) {
      print("Error fetching movie detail: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  getSimilarMovies() async {
    var data = MovieData();
    try {
      _similarMovies = await data.fetchSimilarMovies(widget.movieId);
    } catch (e) {
      print("Error fetching similar movies: $e");
    }
    setState(() {});
  }

  fetchCastDetails() async {
    var data = MovieData();
    try {
      _castList = await data.fetchCastDetails(widget.movieId);
    } catch (e) {
      print("Error fetching cast details: $e");
    }
    setState(() {});
  }

  fetchReviewsForMovie() async {
    try {
      _reviewData = await _movieReviewData.fetchReviewsForMovie(widget.movieId);  // 특정 영화의 리뷰 가져오기
    } catch (e) {
      print("Error fetching reviews: $e");
    }
    setState(() {});
  }

  checkIfFavorite() async {
    if (await isLoggedIn()) {
      final userId = await getUserId();
      final favoriteMovies = await _favoriteMovieData.fetchFavoriteMovies(userId!);
      final favoriteMovie = favoriteMovies.firstWhere(
            (movie) => movie.tmdbId == widget.movieId,
        orElse: () => FavoriteMovie(id: 0, tmdbId: widget.movieId, userId: userId),
      );
      if (favoriteMovie.id != 0) {
        setState(() {
          _isFavorite = true;
        });
      }
    }
  }

  checkIfWatched() async {
    if (await isLoggedIn()) {
      final userId = await getUserId();
      final movieWatchHistories = await _movieWatchHistoryData.fetchMovieWatchHistories(userId!);
      final watchHistory = movieWatchHistories.firstWhere(
            (movie) => movie.tmdbId == widget.movieId,
        orElse: () => MovieWatchHistory(id: 0, tmdbId: widget.movieId, userId: userId),
      );
      if (watchHistory.id != 0) {
        setState(() {
          _isWatched = true;
        });
      }
    }
  }

  addOrRemoveFavorite() async {
    if (await isLoggedIn()) {
      final userId = await SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
      if (_isFavorite) {
        // 관심 목록에서 삭제
        final favoriteMovies = await _favoriteMovieData.fetchFavoriteMovies(userId!);
        final favoriteMovie = favoriteMovies.firstWhere((movie) => movie.tmdbId == widget.movieId);
        await _favoriteMovieData.deleteFavoriteMovie(favoriteMovie.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('관심 목록에서 삭제되었습니다!')),
        );
      } else {
        // 관심 목록에 추가
        await _favoriteMovieData.addFavoriteMovie(widget.movieId, userId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('관심 목록에 추가되었습니다!')),
        );
      }
      _isFavorite = !_isFavorite;
      setState(() {});
    } else {
      navigateToLoginScreen();
    }
  }

  addOrRemoveWatched() async {
    if (await isLoggedIn()) {
      final userId = await SharePrefManager.pref.getString(SharedPrefConst.USER_ID);
      if (_isWatched) {
        // 시청 기록에서 삭제
        final movieWatchHistories = await _movieWatchHistoryData.fetchMovieWatchHistories(userId!);
        final watchHistory = movieWatchHistories.firstWhere((movie) => movie.tmdbId == widget.movieId);
        await _movieWatchHistoryData.deleteMovieWatchHistory(watchHistory.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시청 기록에서 삭제되었습니다!')),
        );
      } else {
        // 시청 기록에 추가
        await _movieWatchHistoryData.addMovieWatchHistory(widget.movieId, userId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('시청 기록에 추가되었습니다!')),
        );
      }
      _isWatched = !_isWatched;
      setState(() {});
    } else {
      navigateToLoginScreen();
    }
  }

  addOrEditReview() async {
    if (await isLoggedIn()) {
      final userId = await getUserId();
      final nickname = SharePrefManager.pref.getString(SharedPrefConst.USER_NICKNAME) ?? 'unknown_nickname';

      List<MovieReview> reviews = await _movieReviewData.fetchReviewsForUser(userId!);
      MovieReview? userReview = reviews.firstWhere(
            (review) => review.tmdbId == widget.movieId,
        orElse: () => MovieReview(
          id: 0,
          userId: userId!,
          nickname: nickname,  // 현재 사용자 닉네임 사용
          review: '',
          rating: 0,
          upvotes: 0,
          downvotes: 0,
          reviewDate: DateTime.now(),
          reviewTitle: _movieDetail!.title,
          tmdbId: widget.movieId,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditReviewScreen(
            review: userReview,
          ),
        ),
      );
    } else {
      navigateToLoginScreen();
    }
  }

  List<String> getGenreTags(List<int> genreIds) {
    return genreIds.map((id) => genreMap[id] ?? "Unknown").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${_movieDetail!.backdropPath}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${_movieDetail!.posterPath}',
                    height: 150,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitle(title: _movieDetail!.title),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : null,
                            ),
                            onPressed: addOrRemoveFavorite,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: addOrEditReview,
                          ),
                          IconButton(
                            icon: Icon(
                              _isWatched ? Icons.visibility : Icons.visibility_off,
                              color: _isWatched ? Colors.green : null,
                            ),
                            onPressed: addOrRemoveWatched,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: getGenreTags(_movieDetail!.genreIds)
                            .map((genre) => Chip(
                          label: Text(
                            '#$genre',
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                          backgroundColor: Colors.grey,
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_movieDetail!.releaseDate} · ${_movieDetail!.originalLanguage}',
                    style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '평균 별점: ${_movieDetail!.voteAverage}',
                    style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _movieDetail!.overview,
                    style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                  ),
                  SubTitle(title: '출연진'),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _castList.length > 5 ? 5 : _castList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  'https://image.tmdb.org/t/p/w200${_castList[index].profilePath}',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _castList[index].name,
                                style: TextStyle(color: AppColors.textWhite),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _castList[index].character,
                                style: TextStyle(color: AppColors.textWhite),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubTitle(title: '한줄평'),
                      MoreButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieReviewListScreen(
                                movieId: widget.movieId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: _reviewData.length,
                      itemBuilder: (context, index) {
                        final review = _reviewData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ReviewListItem(
                            nickname: review.nickname,
                            rating: review.rating.toDouble(),
                            review: review.review,
                            reviewTitle: review.reviewTitle,
                            likes: review.upvotes,
                            onTap: () {
                              // 리뷰 카드 클릭 시 이벤트 처리
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  SubTitle(title: '비슷한 영화'),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _similarMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: MovieCard(
                            title: _similarMovies[index].title,
                            image: Image.network(
                              'https://image.tmdb.org/t/p/w500${_similarMovies[index].posterPath}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                            releaseInfo: '${_similarMovies[index].releaseDate} · ${_similarMovies[index].originalLanguage}',
                            movieId: _similarMovies[index].id,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    movieId: _similarMovies[index].id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
