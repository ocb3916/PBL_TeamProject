import 'package:flutter/material.dart';
import 'package:untitled1/model/movie_model.dart';
import '../data/movie_data.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/review_card.dart';
import '../uikit/widgets/movie_card.dart';


class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<MovieModel> _toprateMovie = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getMovieData();
  }

  getMovieData() async {
    var data = MovieData();
    _toprateMovie = await data.fetchTopRatedMovie();
    setState(() {
      _isLoading = false;
    }); // UI 업데이트
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영화 상세 정보'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/400x250'),
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
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
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
                    'https://via.placeholder.com/100x150',
                    height: 150,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitle(title: '영화 제목'),
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
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('개봉 날짜 · 국가', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('평균 별점: ★★★★★', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: ['#드라마', '#로맨스', '#액션', '#코미디'].map((genre) => Chip(label: Text(genre))).toList(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '줄거리 요약: 영화 줄거리가 여기에 표시됩니다.',
                    style: TextStyle(fontSize: 16),
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

                  SubTitle(title: '추천 작품'),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: MovieCard(
                            title: '비슷한 영화 제목 $index',
                            image: Image.network(
                              'https://image.tmdb.org/t/p/w500${_toprateMovie[index].posterPath}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                            releaseInfo: '2024 · 한국',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MovieDetailScreen()),
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

