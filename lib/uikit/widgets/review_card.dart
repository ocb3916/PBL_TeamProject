import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ReviewCard extends StatelessWidget {
  final String nickname;
  final double rating; // 10점 만점의 평점
  final String review;
  final String reviewTitle; // 리뷰 제목 추가
  final String movieTitle;
  final String moviePosterUrl;
  final int likes;
  final Function() onTap;

  const ReviewCard({
    Key? key,
    required this.nickname,
    required this.rating,
    required this.review,
    required this.reviewTitle, // 리뷰 제목 인자 추가
    required this.movieTitle,
    required this.moviePosterUrl,
    required this.likes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 10점 만점의 평점을 5점 만점으로 변환
    double starsRating = rating / 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  moviePosterUrl,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
                SizedBox(height: 4),
                SizedBox(
                  width: 100, // 이 값을 조정하여 제목이 잘 보이도록 합니다.
                  child: Text(
                    movieTitle,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true, // 줄바꿈을 위한 속성 추가
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    reviewTitle, // 리뷰 제목 표시
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < starsRating.ceil() ? Icons.star : Icons.star_border,
                        color: index < starsRating.ceil() ? Colors.yellow : Colors.grey,
                        size: 16,
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${rating.toStringAsFixed(1)} 점", // 소수점 하나까지 표시
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    review,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "좋아요 $likes",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
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
