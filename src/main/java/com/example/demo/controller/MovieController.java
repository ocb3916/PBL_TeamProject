package com.example.demo.controller;

import com.example.demo.entity.Movie;
import com.example.demo.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/movies")
public class MovieController {

    @Autowired
    private MovieService movieService;

    // 모든 영화 조회
    @GetMapping
    public List<Movie> getAllMovies() {
        return movieService.getAllMovies();
    }

    // 영화 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable Integer id) {
        Movie movie = movieService.getMovieById(id);
        if (movie != null) {
            return ResponseEntity.ok(movie);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 영화 생성 또는 업데이트
    @PostMapping
    public Movie createOrUpdateMovie(@RequestBody Movie movie) {
        return movieService.saveMovie(movie);
    }

    // 영화 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMovie(@PathVariable Integer id) {
        movieService.deleteMovie(id);
        return ResponseEntity.noContent().build();
    }

    // 영화 제목으로 조회
    @GetMapping("/title/{name}")
    public List<Movie> getMoviesByName(@PathVariable String name) {
        return movieService.getMoviesByName(name);
    }

    // 감독 이름으로 영화 조회
    @GetMapping("/director/{director}")
    public List<Movie> getMoviesByDirector(@PathVariable String director) {
        return movieService.getMoviesByDirector(director);
    }

    // 특정 등급 이상의 영화 조회
    @GetMapping("/rating/{rating}")
    public List<Movie> getMoviesByRatingGreaterThan(@PathVariable BigDecimal rating) {
        return movieService.getMoviesByRatingGreaterThan(rating);
    }

    // 제목에 특정 문자열이 포함된 영화 조회
    @GetMapping("/search/{keyword}")
    public List<Movie> getMoviesByNameContaining(@PathVariable String keyword) {
        return movieService.getMoviesByNameContaining(keyword);
    }
}

