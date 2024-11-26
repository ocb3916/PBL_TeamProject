package com.example.demo.service;

import com.example.demo.dto.MovieReviewDTO;
import com.example.demo.dto.TVReviewDTO;
import com.example.demo.entity.MovieReview;
import com.example.demo.entity.TVReview;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

@Service
public class JsonDataLoader {
    private final ObjectMapper objectMapper = new ObjectMapper();

    public List<MovieReview> loadDataFromJsonForMovie() {
        try {
            // JSON 파일에서 데이터 읽기
            File file = new File("src/main/resources/popular_movies_reviews.json");
            // JSON -> DTO
            List<MovieReviewDTO> dtoList = objectMapper.readValue(file, new TypeReference<List<MovieReviewDTO>>() {});
            // DTO -> Entity
            return convertDtoToEntityForMovie(dtoList);
        } catch (IOException e) {
            throw new RuntimeException("JSON 데이터를 읽는 중 오류 발생", e);
        }
    }

    public List<TVReview> loadDataFromJsonForTV() {
        try {
            // JSON 파일에서 데이터 읽기
            File file = new File("src/main/resources/popular_tv_series_reviews.json");
            // JSON -> DTO
            List<TVReviewDTO> dtoList = objectMapper.readValue(file, new TypeReference<List<TVReviewDTO>>() {});
            // DTO -> Entity
            return convertDtoToEntityForTV(dtoList);
        } catch (IOException e) {
            throw new RuntimeException("JSON 데이터를 읽는 중 오류 발생", e);
        }
    }

    // json-db간 매핑
    public List<MovieReview> convertDtoToEntityForMovie(List<MovieReviewDTO> dtoList) {
        return dtoList.stream().map(dto -> {
            MovieReview movieReview = new MovieReview();
            movieReview.setReviewTitle(dto.getTitle());
            movieReview.setRating(dto.getRating());
            movieReview.setNickname(dto.getAuthor());
            movieReview.setReviewDate(dto.getDate());
            movieReview.setReview(dto.getBody());
            movieReview.setUpvotes(dto.getHelpfulYes());
            movieReview.setDownvotes(dto.getHelpfulNo());
            movieReview.setTmdbId(dto.getTmdbId());
            return movieReview;
        }).collect(Collectors.toList());       
    }

    public List<TVReview> convertDtoToEntityForTV(List<TVReviewDTO> dtoList) {
        return dtoList.stream().map(dto -> {
            TVReview tvReview = new TVReview();
            tvReview.setReviewTitle(dto.getTitle());
            tvReview.setRating(dto.getRating());
            tvReview.setNickname(dto.getAuthor());
            tvReview.setReviewDate(dto.getDate());
            tvReview.setReview(dto.getBody());
            tvReview.setUpvotes(dto.getHelpfulYes());
            tvReview.setDownvotes(dto.getHelpfulNo());
            tvReview.setTmdbId(dto.getTmdbId());
            return tvReview;
        }).collect(Collectors.toList());       
    }
}
