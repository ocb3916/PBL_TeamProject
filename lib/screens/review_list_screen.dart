// review_list_screen.dart
import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart';
import '../constants/colors.dart';
import '../uikit/widgets/review_card.dart';

class ReviewListScreen extends StatelessWidget {
  final List<Map<String, String>> _reviewData = [
    {
      'profileImageUrl': 'https://via.placeholder.com/50',
      'nickname': '사용자1',
      'rating': '4.5',
      'review': '영화가 너무 재미있었습니다!',
      'movieTitle': '영화 제목 1',
      'moviePosterUrl': 'https://via.placeholder.com/100x150',
    },
    {
      'profileImageUrl': 'https://via.placeholder.com/50',
      'nickname': '사용자2',
      'rating': '5.0',
      'review': '최고의 경험이었습니다!',
      'movieTitle': '영화 제목 2',
      'moviePosterUrl': 'https://via.placeholder.com/100x150',
    },
    // 추가적인 리뷰 데이터...
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경 색상 설정
      appBar: TopBar(),
      body: ListView.builder(
        itemCount: _reviewData.length,
        itemBuilder: (context, index) {
          final review = _reviewData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ReviewCard(
              profileImageUrl: review['profileImageUrl']!,
              nickname: review['nickname']!,
              rating: double.parse(review['rating']!), // 문자열을 double로 변환
              review: review['review']!,
              movieTitle: review['movieTitle']!,
              moviePosterUrl: review['moviePosterUrl']!,
              onTap: () {
                // 리뷰 카드 클릭 시 이벤트 처리 (예: 상세화면으로 이동)
                // 현재는 같은 화면으로 이동하도록 되어 있음
              },
            ),
          );
        },
      ),
    );
  }
}
