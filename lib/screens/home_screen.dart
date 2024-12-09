import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../data/review_data.dart';
import '../model/movie_model.dart';
import '../model/review_model.dart';
import '../uikit/widgets/more_button.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/recommendation_card.dart';
import '../uikit/widgets/review_card.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_detail_screen.dart';
import 'movie_list_screen.dart';
import 'review_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieModel> _TrendingMovies = [];
  List<MovieModel> _NetflixMovies = [];
  List<MovieModel> _DisneyPlusMovies = [];
  List<MovieReview> _reviewData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getMovieData();
    fetchNetflixMovies();
    fetchDisneyPlusMovies();
    fetchLatestReviews(); // 최신 리뷰 데이터 가져오기
  }

  DateTime? parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      print("Invalid date format: $date");
      return null;
    }
  }

  Future<void> getMovieData() async {
    try {
      var data = MovieData();
      List<MovieModel> movies = await data.fetchTrendingMovies();

      // 유효한 날짜 형식과 유효하지 않은 날짜 형식 분리
      List<MovieModel> validDateMovies = [];
      List<MovieModel> invalidDateMovies = [];

      for (var movie in movies) {
        if (parseDate(movie.releaseDate) != null) {
          validDateMovies.add(movie);
        } else {
          invalidDateMovies.add(movie);
        }
      }

      // 유효한 날짜 형식만 정렬
      validDateMovies.sort((a, b) => parseDate(b.releaseDate)!.compareTo(parseDate(a.releaseDate)!));

      // 유효하지 않은 날짜 형식의 영화 포함하여 합치기
      movies = validDateMovies + invalidDateMovies;

      setState(() {
        _TrendingMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> fetchNetflixMovies() async {
    try {
      var data = MovieData();
      List<MovieModel> movies = await data.fetchNetflixMovies();
      movies.sort((a, b) =>
          DateTime.parse(b.releaseDate).compareTo(DateTime.parse(a.releaseDate)));
      setState(() {
        _NetflixMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching Wavve movies: $e");
    }
  }

  Future<void> fetchDisneyPlusMovies() async {
    try {
      var data = MovieData();
      List<MovieModel> movies = await data.fetchDisneyPlusMovies();
      movies.sort((a, b) =>
          DateTime.parse(b.releaseDate).compareTo(DateTime.parse(a.releaseDate)));
      setState(() {
        _DisneyPlusMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching Wavve movies: $e");
    }
  }

  Future<void> fetchLatestReviews() async {
    try {
      var reviewData = MovieReviewData();
      _reviewData = await reviewData.fetchReviewsSortedUpvotes(); // 좋아요 수 내림차순으로 정렬된 리뷰 가져오기
      print("Reviews fetched: ${_reviewData.length}"); // 리뷰 개수 로그 추가
    } catch (e) {
      print("Error fetching reviews: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<MovieModel> fetchMovieById(int movieId) async {
    var data = MovieData();
    return await data.fetchMovieDetail(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubTitle(title: '오늘의 트렌드'),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _TrendingMovies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MovieCard(
                        title: _TrendingMovies[index].title,
                        image: Image.network(
                          'https://image.tmdb.org/t/p/w500/${_TrendingMovies[index].posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                        releaseInfo:
                        '${_TrendingMovies[index].releaseDate} · ${_TrendingMovies[index].originalLanguage}',
                        movieId: _TrendingMovies[index].id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  movieId: _TrendingMovies[index].id,
                                )),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubTitle(title: '최신 한줄평'),
                  MoreButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewListScreen()),
                    );
                  }),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: Future.wait(
                    _reviewData.take(3).map((review) async { // 여기서 3개의 리뷰만 가져오도록 수정
                      MovieModel movie = await fetchMovieById(review.tmdbId);
                      print("Fetched movie for review ID ${review.id}: ${movie.title}"); // 로그 추가
                      return {
                        'review': review,
                        'movie': movie,
                      };
                    }).toList(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print("Error in FutureBuilder: ${snapshot.error}"); // 로그 추가
                      return Center(child: Text('Error loading reviews'));
                    }
                    if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                      print("No data or empty list"); // 로그 추가
                      return Center(child: Text('No reviews found'));
                    }
                    List<Map<String, dynamic>> reviewMovieData = snapshot.data!;
                    return ListView.builder(
                      itemCount: reviewMovieData.length, // 여기도 3개의 리뷰만 표시하도록 수정
                      itemBuilder: (context, index) {
                        final review = reviewMovieData[index]['review'] as MovieReview;
                        final movie = reviewMovieData[index]['movie'] as MovieModel;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ReviewCard(
                            nickname: review.nickname,
                            rating: review.rating.toDouble(),
                            review: review.review,
                            reviewTitle: review.reviewTitle,
                            movieTitle: movie.title,
                            moviePosterUrl: 'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                            likes: review.upvotes,
                            onTap: () {
                              // 리뷰 카드 클릭 시 이벤트 처리 (예: 상세화면으로 이동)
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              SubTitle(title: '넷플릭스 영화 순위'),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _NetflixMovies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MovieCard(
                        title: _NetflixMovies[index].title,
                        image: Image.network(
                          'https://image.tmdb.org/t/p/w500/${_NetflixMovies[index].posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                        releaseInfo:
                        '${_NetflixMovies[index].releaseDate} · ${_NetflixMovies[index].originalLanguage}',
                        movieId: _NetflixMovies[index].id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                movieId: _NetflixMovies[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),
              SubTitle(title: '디즈니플러스 영화 순위'),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _DisneyPlusMovies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: MovieCard(
                        title: _DisneyPlusMovies[index].title,
                        image: Image.network(
                          'https://image.tmdb.org/t/p/w500/${_DisneyPlusMovies[index].posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                        releaseInfo:
                        '${_DisneyPlusMovies[index].releaseDate} · ${_DisneyPlusMovies[index].originalLanguage}',
                        movieId: _DisneyPlusMovies[index].id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(
                                movieId: _DisneyPlusMovies[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16), // 추천 섹션과 버튼 간의 간격 추가
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cardBackground,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieListScreen()),
                    );
                  },
                  child: Text(
                    '더 많은 작품 보러가기',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
