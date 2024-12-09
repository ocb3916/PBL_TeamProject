import 'package:flutter/material.dart';
import '../data/review_data.dart';
import '../model/review_model.dart';
import '../uikit/widgets/top_bar.dart';
import '../constants/colors.dart';
import '../uikit/widgets/review_list_item.dart';

class MovieReviewListScreen extends StatefulWidget {
  final int movieId;

  MovieReviewListScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieReviewListScreenState createState() => _MovieReviewListScreenState();
}

class _MovieReviewListScreenState extends State<MovieReviewListScreen> {
  final MovieReviewData _reviewData = MovieReviewData();  // 수정된 데이터 클래스
  List<MovieReview> _reviews = [];  // 수정된 모델
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  _fetchReviews() async {
    try {
      _reviews = await _reviewData.fetchReviewsForMovie(widget.movieId);
    } catch (e) {
      print("Error fetching movie reviews: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TopBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          final review = _reviews[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ReviewListItem(
              nickname: review.nickname,
              reviewTitle: review.reviewTitle,
              rating: review.rating.toDouble(),  // 수정된 부분
              review: review.review,
              likes: review.upvotes,
              onTap: () {
                // 리뷰 카드 클릭 시 이벤트 처리
              },
            ),
          );
        },
      ),
    );
  }
}
