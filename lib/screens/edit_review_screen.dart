import 'package:flutter/material.dart';
import '../constants/colors.dart';

import '../SessionManager.dart';
import '../data/review_data.dart';
import '../model/review_model.dart';

class EditReviewScreen extends StatefulWidget {
  final MovieReview? review;
  EditReviewScreen({this.review});

  @override
  _EditReviewScreenState createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  late TextEditingController _reviewController;
  late TextEditingController _titleController;
  double? _rating;
  late bool _isEdit;

  final MovieReviewData _reviewData = MovieReviewData();
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _isEdit = widget.review != null && widget.review!.id != 0;
    _reviewController = TextEditingController(text: widget.review?.review ?? '');
    _titleController = TextEditingController(text: widget.review?.reviewTitle ?? '');
    _rating = widget.review?.rating.toDouble() ?? 0.0;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _saveReview() async {
    final currentUser = await _sessionManager.getCurrentUser();
    final userId = currentUser?.id ?? "unknown_user";
    final nickname = currentUser?.nickname ?? 'unknown_nickname';
    print('User ID: $userId, Nickname: $nickname');

    final newReview = MovieReview(
      id: _isEdit ? widget.review!.id : 0,
      userId: userId,
      nickname: nickname,
      review: _reviewController.text,
      rating: _rating?.toInt() ?? 0,
      upvotes: _isEdit ? widget.review!.upvotes : 0,
      downvotes: _isEdit ? widget.review!.downvotes : 0,
      reviewDate: DateTime.now(),
      reviewTitle: _titleController.text,
      tmdbId: widget.review?.tmdbId ?? 0,
    );

    try {
      MovieReview? response;
      if (_isEdit && widget.review!.id != 0) {
        final int reviewId = widget.review!.id;
        print('Updating review with ID: $reviewId');
        response = await _reviewData.createOrUpdateReview(newReview);
      } else {
        List<MovieReview> existingReviews = await _reviewData.fetchReviewsForUser(userId);
        bool reviewExists = existingReviews.any((review) => review.tmdbId == newReview.tmdbId);

        if (reviewExists) {
          print('이미 이 영화에 대한 리뷰를 작성하셨습니다.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미 이 영화에 대한 리뷰를 작성하셨습니다.')),
          );
          return;
        }
        print('Creating new review');
        response = await _reviewData.createOrUpdateReview(newReview);
      }

      print('Review saved for user: $userId'); // 로그 추가
      Navigator.pop(context, response);
    } catch (e) {
      print('Error saving review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 저장에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  void _deleteReview() async {
    if (!_isEdit || widget.review == null || widget.review!.id == 0) return;
    try {
      final int reviewId = widget.review!.id;
      await _reviewData.deleteReview(reviewId);
      Navigator.of(context).pop(null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 삭제에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? '리뷰 편집' : '리뷰 작성',
          style: TextStyle(color: AppColors.textWhite),
        ),
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: '리뷰 제목을 입력하세요.',
                hintStyle: TextStyle(color: AppColors.textGray),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              style: TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: '리뷰 내용을 입력하세요.',
                hintStyle: TextStyle(color: AppColors.textGray),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '별점: ${_rating?.toStringAsFixed(1) ?? '0.0'}',
              style: TextStyle(color: AppColors.textWhite),
            ),
            Slider(
              value: _rating ?? 0.0,
              onChanged: (newRating) {
                setState(() {
                  _rating = newRating;
                });
              },
              min: 0,
              max: 10,  // 별점 최대치를 10으로 변경
              divisions: 10,
              activeColor: AppColors.textWhite,
              inactiveColor: AppColors.textGray,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveReview,
              child: Text('저장하기'),
            ),
            if (_isEdit)
              SizedBox(height: 16),
            if (_isEdit)
              ElevatedButton(
                onPressed: _deleteReview,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('리뷰 삭제'),
              ),
          ],
        ),
      ),
    );
  }
}
