import 'package:flutter/material.dart';
import 'package:untitled1/constants/colors.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final Widget image;
  final String releaseInfo;
  final int movieId; // 영화 ID 추가
  final VoidCallback onTap; // 콜백 함수 이름을 변경하여 명확하게

  const MovieCard({
    Key? key,
    required this.title,
    required this.image,
    required this.releaseInfo,
    required this.movieId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 클릭 시의 동작
      child: Container(
        width: 140, // 카드의 너비 설정
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 200, // 이미지의 높이 설정
                width: 140, // 이미지의 너비 설정
                child: image,
              ),
            ),
            SizedBox(height: 8),
            // 제목 텍스트
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // 글자 크기 조정
                color: AppColors.textWhite,
              ),
              maxLines: 1, // 한 줄에 최대 2줄
              overflow: TextOverflow.ellipsis, // 오버플로우 발생 시 점 3개로 표시
            ),
            SizedBox(height: 4), // 제목과 날짜 사이의 공간
            // 출시 정보 텍스트
            Text(
              releaseInfo,
              style: TextStyle(fontSize: 12, color: AppColors.textWhite),
              maxLines: 1, // 한 줄에 최대 1줄
              overflow: TextOverflow.ellipsis, // 오버플로우 발생 시 점 3개로 표시
            ),
          ],
        ),
      ),
    );
  }
}
