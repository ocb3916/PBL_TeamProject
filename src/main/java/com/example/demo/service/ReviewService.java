package com.example.demo.service;

import com.example.demo.entity.Review;
import com.example.demo.entity.User;
import com.example.demo.entity.Movie;
import com.example.demo.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    // 모든 리뷰 조회
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    // 리뷰 ID로 리뷰 조회
    public Review getReviewById(Integer id) {
        return reviewRepository.findById(id).orElse(null);
    }

    // 리뷰 저장 또는 업데이트
    public Review saveReview(Review review) {
        return reviewRepository.save(review);
    }

    // 리뷰 삭제
    public void deleteReview(Integer id) {
        reviewRepository.deleteById(id);
    }

    // 특정 사용자가 작성한 모든 리뷰 조회
    public List<Review> getReviewsByUser(User user) {
        return reviewRepository.findByUser(user);
    }

    // 특정 영화에 대한 모든 리뷰 조회
    public List<Review> getReviewsByMovie(Movie movie) {
        return reviewRepository.findByMovie(movie);
    }

    // 특정 사용자가 특정 영화에 대해 작성한 리뷰 조회
    public List<Review> getReviewsByUserAndMovie(User user, Movie movie) {
        return reviewRepository.findByUserAndMovie(user, movie);
    }

    // 특정 등급 이상의 리뷰 조회
    public List<Review> getReviewsByRatingGreaterThanEqual(BigDecimal rating) {
        return reviewRepository.findByRatingGreaterThanEqual(rating);
    }
}
