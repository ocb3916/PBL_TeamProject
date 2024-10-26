package com.example.demo.repository;

import com.example.demo.entity.Genre;
import com.example.demo.entity.Movie;
import com.example.demo.entity.GenreList;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GenreRepository extends JpaRepository<Genre, Integer> {

    // 특정 영화에 속한 모든 장르를 조회
    List<Genre> findByMovie(Movie movie);

    // 특정 장르 목록에 속한 모든 영화 조회
    List<Genre> findByGenreList(GenreList genreList);

    // 특정 영화와 특정 장르 목록에 해당하는 장르 조회
    List<Genre> findByMovieAndGenreList(Movie movie, GenreList genreList);
}

