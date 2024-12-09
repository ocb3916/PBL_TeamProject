import 'package:flutter/material.dart';
import '../data/review_data.dart';
import '../model/review_model.dart';
import '../uikit/widgets/top_bar.dart';
import '../constants/colors.dart';
import '../uikit/widgets/review_card.dart';
import 'edit_review_screen.dart';
import '../data/movie_data.dart';  // 영화 데이터를 가져오기 위해 추가
import '../model/movie_model.dart';  // 영화 모델 클래스

class UserReviewScreen extends StatefulWidget {
  final String userId;

  UserReviewScreen({required this.userId});

  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  List<MovieReview> _userReviews = [];  // 수정된 모델
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserReviews();
  }

  fetchUserReviews() async {
    var reviewData = MovieReviewData();  // 수정된 데이터 클래스
    try {
      _userReviews = await reviewData.fetchReviewsForUser(widget.userId);
      print('Reviews fetched: ${_userReviews.length}'); // 리뷰 개수 출력
    } catch (e) {
      print("Error fetching user reviews: $e");
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
      backgroundColor: AppColors.background, // 배경 색상 설정
      appBar: TopBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _userReviews.length,
        itemBuilder: (context, index) {
          final review = _userReviews[index];
          return FutureBuilder<MovieModel>(
            future: fetchMovieById(review.tmdbId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading movie data'));
              }
              final movie = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ReviewCard(
                  nickname: review.nickname,
                  rating: review.rating.toDouble(),  // 수정된 부분
                  reviewTitle: review.reviewTitle,
                  movieTitle: movie?.title ?? 'Unknown Title',  // 영화 타이틀 사용
                  moviePosterUrl: 'https://image.tmdb.org/t/p/w500/${movie?.posterPath}', // 영화 포스터 URL 사용
                  review: review.review,
                  likes: review.upvotes,
                  onTap: () {
                    print("리뷰 카드 클릭됨");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReviewScreen(review: review),
                      ),
                    ).then((updatedReview) {
                      if (updatedReview != null) {
                        setState(() {
                          _userReviews[index] = updatedReview;
                        });
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
