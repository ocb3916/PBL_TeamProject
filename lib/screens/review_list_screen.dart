import 'package:flutter/material.dart';
import '../uikit/widgets/top_bar.dart';
import '../constants/colors.dart';

class ReviewListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      'profileImageUrl': 'https://via.placeholder.com/50',
      'nickname': '칸데르니아',
      'rating': 5,
      'review': '전개가 빠르고 흥미진진해서 눈을 뗄 수가 없어요!',
      'likes': 703,
    },
    // 추가적인 리뷰 데이터
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 배경 색상 설정
      appBar: TopBar(),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(review['profileImageUrl']),
                ),
                title: Text(
                  review['nickname'],
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(review['rating'], (index) => Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      )),
                    ),
                    SizedBox(height: 4),
                    Text(
                      review['review'],
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_up, color: Colors.orange),
                    Text(
                      review['likes'].toString(),
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
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
