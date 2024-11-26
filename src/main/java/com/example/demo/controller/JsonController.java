package com.example.demo.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.entity.MovieReview;
import com.example.demo.entity.TVReview;
import com.example.demo.repository.MovieReviewRepository;
import com.example.demo.repository.TVReviewRepository;
import com.example.demo.service.JsonDataLoader;

@RestController
public class JsonController {
    private final JsonDataLoader jsonDataLoader;
    private final MovieReviewRepository movieReviewRepository;
    private final TVReviewRepository tvReviewRepository;

    public JsonController(JsonDataLoader jsonDataLoader, MovieReviewRepository movieReviewRepository, TVReviewRepository tvReviewRepository) {
        this.jsonDataLoader = jsonDataLoader;
        this.movieReviewRepository = movieReviewRepository;
        this.tvReviewRepository = tvReviewRepository;
    }

    @GetMapping("/movie-data")
    public List<MovieReview> getMovieData() {
        return jsonDataLoader.loadDataFromJsonForMovie();
    }

    @GetMapping("/TV-data")
    public List<TVReview> getTVData() {
        return jsonDataLoader.loadDataFromJsonForTV();
    }

    @PostMapping("/movie-data")
    public ResponseEntity<String> saveMoviesToDb() {
        // JSON 데이터를 엔티티 리스트로 로드
        List<MovieReview> movieReviews = jsonDataLoader.loadDataFromJsonForMovie();

        // 엔티티를 DB에 저장
        movieReviewRepository.saveAll(movieReviews);

        return ResponseEntity.ok("Movies saved successfully!");
    }
    
    @PostMapping("/TV-data")
    public ResponseEntity<String> saveTvsToDb() {
        // JSON 데이터를 엔티티 리스트로 로드
        List<TVReview> tvReviews = jsonDataLoader.loadDataFromJsonForTV();

        // 엔티티를 DB에 저장
        tvReviewRepository.saveAll(tvReviews);

        return ResponseEntity.ok("TVs saved successfully!");
    }
}
