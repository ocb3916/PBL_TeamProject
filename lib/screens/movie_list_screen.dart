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
  List<int> _selectedGenres = [];
  String _sortBy = 'latest'; // 기본 정렬 기준
  bool _isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    var data = MovieData();
    try {
      List<MovieModel> newMovies;

      if (_sortBy == 'latest') {
        newMovies = await data.fetchNowPlayingMovie();
      } else if (_sortBy == 'popular') {
        newMovies = await data.fetchPopularMovie();
      } else if (_sortBy == 'topRated') {
        newMovies = await data.fetchTopRatedMovie();
      } else {
        throw Exception("Invalid sortBy option");
      }

      newMovies = newMovies.where((movie) {
        if (_selectedGenres.isEmpty) return true;
        int matchCount =
            movie.genreIds.where((id) => _selectedGenres.contains(id)).length;
        return matchCount > 0;
      }).toList();

      // 선택된 해시태그와 많이 매칭되는 순으로 정렬
      newMovies.sort((a, b) {
        int matchCountA =
            a.genreIds.where((id) => _selectedGenres.contains(id)).length;
        int matchCountB =
            b.genreIds.where((id) => _selectedGenres.contains(id)).length;
        return matchCountB.compareTo(matchCountA); // 매칭 개수 많은 순
      });

      setState(() {
        _movies.addAll(newMovies); // 가져온 데이터 추가
        _isLoading = false;
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
                            _currentPage = 1; // 페이지 번호 초기화
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
                        _currentPage = 1;
                        fetchMovies();
                      });
                    },
                  ),
                ],
              ),
            ),
            // 영화 리스트
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    // ListView 맨 끝에 도달 시 페이지 번호 증가 및 다음 페이지 불러오기
                    _currentPage += 1;
                    fetchMovies();
                  }
                  return true;
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0,
                    childAspectRatio: 2/3, // 너비 대비 높이를 조정하여 비율을 설정

                  ),
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(0),
                      child: MovieCard(
                        title: _movies[index].title,
                        image: Image.network(
                          'https://image.tmdb.org/t/p/w500${_movies[index].posterPath}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                        releaseInfo:
                            '${_movies[index].releaseDate} · ${_movies[index].originalLanguage}',
                        movieId: _movies[index].id,
                        // 영화 ID 전달
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movieId: _movies[index].id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
