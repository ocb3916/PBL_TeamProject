package com.example.demo.repository;

import com.example.demo.entity.Review;
import com.example.demo.entity.User;
import com.example.demo.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.math.BigDecimal;

public interface ReviewRepository extends JpaRepository<Review, Integer> {

    // 특정 사용자가 작성한 모든 리뷰 조회
    List<Review> findByUser(User user);

    // 특정 영화에 대한 모든 리뷰 조회
    List<Review> findByMovie(Movie movie);

    // 특정 사용자가 특정 영화에 대해 작성한 리뷰 조회
    List<Review> findByUserAndMovie(User user, Movie movie);

    // 특정 등급 이상의 리뷰 조회
    List<Review> findByRatingGreaterThanEqual(BigDecimal rating);
}

