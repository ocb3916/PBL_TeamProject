package com.example.demo.repository;

import com.example.demo.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.math.BigDecimal;

public interface MovieRepository extends JpaRepository<Movie, Integer> {

    // 영화 제목으로 영화 조회
    List<Movie> findByName(String name);

    // 감독 이름으로 영화 조회
    List<Movie> findByDirector(String director);

    // 특정 등급 이상의 영화 조회
    List<Movie> findByMovieRatingGreaterThan(BigDecimal rating);

    // 제목에 특정 문자열이 포함된 영화 조회
    List<Movie> findByNameContaining(String keyword);
}
