import 'package:flutter/material.dart';
import 'package:untitled1/constants/colors.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/top_bar.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<String> _selectedGenres = [];
  String _sortBy = 'latest'; // 기본 정렬 기준

  // 더미 영화 데이터를 생성합니다.
  List<Map<String, dynamic>> _movies = List.generate(20, (index) => {
    'title': '영화 제목 ${index + 1}',
    'imageUrl': 'https://via.placeholder.com/100x150',
    'releaseDate': '2023-05-${(index + 1).toString().padLeft(2, '0')}',
    'voteAverage': 5.0 + index * 0.5 // 임의의 평점 추가 (5.0, 5.5, 6.0, ...)
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // TopBar 사용
      body:
    Container(
    color: AppColors.background,
    child: Column(
        children: [
          // 장르 필터
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Action', 'Comedy', 'Horror', 'Drama', 'Sci-Fi']
                    .map((genre) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text('#$genre'),
                    selected: _selectedGenres.contains(genre),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
          // 정렬 기준 선택
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  dropdownColor: AppColors.cardBackground,
                  value: _sortBy,
                  items: [
                    DropdownMenuItem(value: 'latest', child: Text('최신순', style: TextStyle(color: AppColors.textWhite))),
                    DropdownMenuItem(value: 'popular', child: Text('인기순',style: TextStyle(color: AppColors.textWhite))),
                    DropdownMenuItem(value: 'topRated', child: Text('별점 높은 순',style: TextStyle(color: AppColors.textWhite))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortMovies(); // 정렬 메소드 호출
                    });
                  },
                ),
              ],
            ),
          ),
          // 영화 리스트
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.43,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _movies.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return MovieCard(
                  title: _movies[index]['title'],
                  image: Image.network(
                    _movies[index]['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                  releaseInfo: _movies[index]['releaseDate'],
                  onTap: () {
                    // 클릭 시 동작할 코드
                  },
                );
              },
            ),
          ),
        ],
      ),
    )
    );
  }

  // 영화 정렬 메소드
  void _sortMovies() {
    if (_sortBy == 'latest') {
      _movies.sort((a, b) => DateTime.parse(b['releaseDate']).compareTo(DateTime.parse(a['releaseDate'])));
    } else if (_sortBy == 'popular') {
      // 이곳에 인기순 정렬 로직을 추가
      // 예: 랜덤 또는 향상된 무작위 값을 기준으로 정렬할 수 있습니다.
      _movies.shuffle(); // 예시로 무작위로 섞기
    } else if (_sortBy == 'topRated') {
      _movies.sort((a, b) => b['voteAverage'].compareTo(a['voteAverage'])); // 별점 높은 순서로 정렬
    }
  }
}
