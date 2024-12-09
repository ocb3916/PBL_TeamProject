import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ReviewListItem extends StatelessWidget {
  final String nickname;
  final double rating; // 10점 만점의 평점
  final String review;
  final String reviewTitle; // 리뷰 제목 추가
  final int likes;
  final Function() onTap;

  const ReviewListItem({
    Key? key,
    required this.nickname,
    required this.rating,
    required this.review,
    required this.reviewTitle, // 리뷰 제목 인자 추가
    required this.likes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
        padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(8),
    ),
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
                children: [
                  // 10점 만점의 평점을 5점 만점으로 변환하여 별점 표시
                  ...List.generate(5, (index) {
                    return Icon(
                      index < (rating / 2).ceil() ? Icons.star : Icons.star_border,
                      color: index < (rating / 2).ceil() ? Colors.yellow : Colors.grey,
                      size: 16,
                    );
                  }),
                  SizedBox(width: 8),
                  Text(
                    "${rating.toStringAsFixed(1)} 점", // 소수점 하나까지 표시
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                  ),
                ],
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
              Row(
                children: [
                  Text(
                    "좋아요 $likes",
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

