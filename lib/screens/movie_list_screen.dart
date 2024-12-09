import 'package:flutter/material.dart';
import 'package:untitled1/constants/colors.dart';
import 'package:untitled1/constants/genre.dart';
import 'package:untitled1/model/movie_model.dart';
import '../data/movie_data.dart';
import '../uikit/widgets/movie_card.dart';
import '../uikit/widgets/top_bar.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<MovieModel> _movies = [];
  Set<int> _movieIds = Set(); // 영화 ID를 저장하는 Set 추가
  List<int> _selectedGenres = [];
  String _sortBy = 'latest'; // 기본 정렬 기준
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    var data = MovieData();
    try {
      List<MovieModel> newMovies;

      // 정렬 기준에 따라 영화 데이터 가져오기
      switch (_sortBy) {
        case 'latest':
          newMovies = await data.fetchMoviesBySort('primary_release_date.desc', pageCount: data.defaultPageCount);
          break;
        case 'popular':
          newMovies = await data.fetchMoviesBySort('popularity.desc', pageCount: data.defaultPageCount);
          break;
        case 'topRated':
          newMovies = await data.fetchMoviesBySort('vote_average.desc', pageCount: data.defaultPageCount);
          break;
        default:
          throw Exception("Invalid sortBy option");
      }

      // 장르 필터링
      newMovies = newMovies.where((movie) {
        if (_selectedGenres.isEmpty) return true;
        int matchCount = movie.genreIds.where((id) => _selectedGenres.contains(id)).length;
        return matchCount > 0;
      }).toList();

      // 날짜별 정렬 추가
      if (_sortBy == 'latest') {
        newMovies.sort((a, b) => DateTime.parse(b.releaseDate).compareTo(DateTime.parse(a.releaseDate)));
      }

      setState(() {
        for (var movie in newMovies) {
          if (!_movieIds.contains(movie.id)) {
            _movies.add(movie);
            _movieIds.add(movie.id); // 중복을 피하기 위해 ID 저장
          }
        }
        _isLoading = false;

        // 전체 목록을 다시 정렬
        if (_sortBy == 'latest') {
          _movies.sort((a, b) => DateTime.parse(b.releaseDate).compareTo(DateTime.parse(a.releaseDate)));
        }
      });
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(), // TopBar 사용
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // 장르 필터
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: genreMap.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text('#${entry.value}'),
                        selected: _selectedGenres.contains(entry.key),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedGenres.add(entry.key);
                            } else {
                              _selectedGenres.remove(entry.key);
                            }
                            _movies.clear(); // 필터링 결과에 따라 목록 초기화
                            _movieIds.clear(); // 중복 제거를 위한 ID 목록 초기화
                            fetchMovies(); // 필터링된 영화 목록 가져오기
                          });
                        },
                      ),
                    );
                  }).toList(),
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
                      DropdownMenuItem(
                          value: 'latest',
                          child: Text('최신순',
                              style: TextStyle(color: AppColors.textWhite))),
                      DropdownMenuItem(
                          value: 'popular',
                          child: Text('인기순',
                              style: TextStyle(color: AppColors.textWhite))),
                      DropdownMenuItem(
                          value: 'topRated',
                          child: Text('별점 높은 순',
                              style: TextStyle(color: AppColors.textWhite))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                        _movies.clear();
                        _movieIds.clear(); // 중복 제거를 위한 ID 목록 초기화
                        fetchMovies();
                      });
                    },
                  ),
                ],
              ),
            ),
            // 영화 리스트
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  childAspectRatio: 2 / 3, // 너비 대비 높이를 조정하여 비율을 설정
                ),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return Container(
                    padding: EdgeInsets.all(0),
                    child: MovieCard(
                      title: movie.title,
                      image: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                      releaseInfo:
                      '${movie.releaseDate} · ${movie.originalLanguage}',
                      movieId: movie.id,
                      // 영화 ID 전달
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movieId: movie.id),
                          ),
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
    );
  }
}
