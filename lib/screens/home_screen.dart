import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../model/movie_model.dart';
import '../uikit/widgets/more_button.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/recommendation_card.dart';
import '../uikit/widgets/review_card.dart';
import '../uikit/widgets/sub_title.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_detail_screen.dart';
import 'movie_list_screen.dart';
import 'review_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieModel> _NowPlayingMovie = [];
  bool _isLoading = true;

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
  void initState() {
    super.initState();
    getMovieData();
  }

  getMovieData() async {
    var data = MovieData();
    _NowPlayingMovie = await data.fetchNowPlayingMovie();
    _NowPlayingMovie.sort((a, b) => DateTime.parse(b.releaseDate).compareTo(DateTime.parse(a.releaseDate)));
    setState(() {
      _isLoading = false;
    }); // UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: TopBar(),
        body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    SubTitle(title: '최신 인기 콘텐츠'),
    SizedBox(
    height: 250,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _NowPlayingMovie.length,
    itemBuilder: (context, index) {
    if (_NowPlayingMovie.isEmpty) {
    return Center(child: CircularProgressIndicator());
    }
    return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: MovieCard(
    title: _NowPlayingMovie[index].title,
    image: Image.network(
    'https://image.tmdb.org/t/p/w500/${_NowPlayingMovie[index].posterPath}',
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
    },
    ),
    releaseInfo: '${_NowPlayingMovie[index].releaseDate} · ${_NowPlayingMovie[index].originalLanguage}',
    movieId: _NowPlayingMovie[index].id,
      onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: _NowPlayingMovie[index].id,)),
    );
    },
    ),
    );
    },
    ),
    ),
    SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    SubTitle(title: '최신 한줄평'),
    MoreButton(onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ReviewListScreen()),
    );
    }),
    ],
    ),
    SizedBox(height: 8),
    SizedBox(
    height: 300,
      child: ListView.builder(
        itemCount: _reviewData.length,
        itemBuilder: (context, index) {
          final review = _reviewData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
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
    ),
      SizedBox(height: 16), // 한줄평 섹션과 추천 섹션 간의 간격 추가
      SubTitle(title: '당신을 위한 추천'),
      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: RecommendationCard(
                imageUrl: 'https://via.placeholder.com/216x122',
                impressiveQuote: '인상적인 대사',
                briefContent: '이 영화는 정말 대단합니다!',
                onTap: () {


                },
              ),
            );
          },
        ),
      ),
      SizedBox(height: 16), // 추천 섹션과 버튼 간의 간격 추가
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieListScreen()),
            );
          },
          child: Text(
            '더 많은 작품 보러가기',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
    ),
    ),
        ),
    );
  }
}
