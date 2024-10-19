import 'package:flutter/material.dart';
import 'package:untitled1/model/movie_model.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/review_card.dart';
import '../uikit/widgets/movie_card.dart';
import '../constants/genre.dart';
import '../uikit/widgets/top_bar.dart';


class MovieDetailScreen extends StatefulWidget {

  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<MovieModel> _similarMovies = [];
  bool _isLoading = true;
  MovieModel? _movieDetail;

  @override
  void initState() {
    super.initState();
    fetchMovieDetail();
    getSimilarMovies();
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
      // 에러 처리
      print("Error fetching similar movies: $e");
    }
    setState(() {});
  }

  List<String> getGenreTags(List<int> genreIds) {
    _movieDetail.toString();
    print(genreIds);
    return genreIds.map((id) => genreMap[id] ?? "Unknown").toList();
  }



  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: TopBar(), // TopBar 사용
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
                          'https://image.tmdb.org/t/p/w500${_movieDetail!.backdropPath}',),
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
                          Colors.transparent
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
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                // 관심 목록에 추가 로직
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // 리뷰 작성 화면으로 이동 로직
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                // 시청 기록에 추가 로직
                              },
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
                              style: TextStyle(color: AppColors.textWhite), // 텍스트 색상 설정
                            ),
                            backgroundColor: Colors.grey, // Chip 배경색 설정 (선택 사항)
                          ))
                              .toList(),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              // getGenreTags(_movieDetail!.genreIds)
              //     .map((genre) => Chip(
              //     label: Text(
              //       '#$genre',
              //       style: TextStyle(color: AppColors.textWhite), // 텍스트 색상 설정
              //     )
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_movieDetail!.releaseDate} · ${_movieDetail!.originalLanguage}',
                      style: TextStyle(fontSize: 16,color: AppColors.textWhite),),
                    SizedBox(height: 8),
                    Text('평균 별점: ${_movieDetail!.voteAverage}',
                      style: TextStyle(fontSize: 16,color: AppColors.textWhite),),

                    SizedBox(height: 8),
                    Text(
                      _movieDetail!.overview,
                      style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                    ),
                    SizedBox(height: 16),

                    SubTitle(title: '한줄평'),
                    SizedBox(
                      height: 100, // 카드 높이에 따라 조정
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ReviewCard(
                              profileImageUrl: 'https://via.placeholder.com/50',
                              nickname: '사용자 $index',
                              rating: 4.5,
                              review: '이 영화는 정말 좋았습니다!',
                              movieTitle: '영화 제목 $index',
                              moviePosterUrl: 'https://via.placeholder.com/100x150',
                              onTap: () {
                                // 상세 리뷰 페이지로 이동
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
                                'https://image.tmdb.org/t/p/w500${_similarMovies[index]
                                    .posterPath}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                              releaseInfo: '${_similarMovies[index]
                                  .releaseDate} · ${_similarMovies[index]
                                  .originalLanguage}',
                              movieId: _similarMovies[index].id,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      MovieDetailScreen(
                                          movieId: _similarMovies[index].id)),
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
