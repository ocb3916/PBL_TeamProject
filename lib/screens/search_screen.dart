import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../data/movie_data.dart';
import '../model/movie_model.dart';
import '../uikit/widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<MovieModel> _topRatedMovies = [];
  List<MovieModel> _filteredMovies = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _searchController.addListener(_onSearchChanged);
  }

  _fetchMovies() async {
    try {
      MovieData movieData = MovieData();
      _topRatedMovies = await movieData.fetchTopRatedMovie();
      setState(() {
        _isLoading = false;
        _filteredMovies = _topRatedMovies;
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // 실패 시에도 로딩 종료
      });
      // 예외를 다루는 코드 추가 가능
    }
  }

  _onSearchChanged() {
    setState(() {
      final query = _searchController.text;
      _filteredMovies = _topRatedMovies
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '영화, TV 프로그램, 인물을 검색해보세요',
                prefixIcon: Icon(Icons.search,color: AppColors.textWhite),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
                style: TextStyle(color:AppColors.textWhite)
            ),

            SizedBox(height: 10),
            Expanded(
              child:
              _isLoading ? Center(child: CircularProgressIndicator()) : _buildMovieList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList() {
    if (_filteredMovies.isEmpty) {
      return Center(child: Text('결과가 없습니다.',style: TextStyle(color:AppColors.textWhite)));
    }

    return ListView.builder(
      itemCount: _filteredMovies.length,
      itemBuilder: (context, index) {
        final movie = _filteredMovies[index];
        return MovieCard(
          title: movie.title,
          image: Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          releaseInfo: movie.releaseDate,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailScreen()),
            );
          },
        );
      },
    );
  }
}
