package com.example.demo.service;

import com.example.demo.entity.Movie;
import com.example.demo.entity.Movie.AgeRating;
import com.example.demo.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class MovieService {

    @Autowired
    private MovieRepository movieRepository;

    // 모든 영화 조회
    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }

    // 영화 ID로 영화 조회
    public Movie getMovieById(Integer id) {
        return movieRepository.findById(id).orElse(null);
    }

    // 영화 저장 또는 업데이트
    public Movie saveMovie(Movie movie) {
        return movieRepository.save(movie);
    }

    // 영화 삭제
    public void deleteMovie(Integer id) {
        movieRepository.deleteById(id);
    }

    // 영화 제목으로 영화 조회
    public List<Movie> getMoviesByName(String name) {
        return movieRepository.findByName(name);
    }

    // 감독 이름으로 영화 조회
    public List<Movie> getMoviesByDirector(String director) {
        return movieRepository.findByDirector(director);
    }

    // 특정 등급 이상의 영화 조회
    public List<Movie> getMoviesByRatingGreaterThan(BigDecimal rating) {
        return movieRepository.findByMovieRatingGreaterThan(rating);
    }

    // 제목에 특정 문자열이 포함된 영화 조회
    public List<Movie> getMoviesByNameContaining(String keyword) {
        return movieRepository.findByNameContaining(keyword);
    }

    // 스코어에 따라 내림차순으로 정렬된 영화 조회
    public List<Movie> getMoviesSortedByScore() {
        return movieRepository.findAllByOrderByScoreDesc();
    }

    // 특정 연령 등급의 영화 조회
    public List<Movie> getMoviesByAgeRating(AgeRating ageRating) {
        return movieRepository.findByAgeRating(ageRating);
    }
}
