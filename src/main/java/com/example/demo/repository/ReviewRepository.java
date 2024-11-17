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

    // 리뷰 제목으로 리뷰 조회
    List<Review> findByReviewTitle(String reviewTitle);

    // 닉네임으로 리뷰 조회
    List<Review> findByNickname(String nickname);
 
    // 추천수가 특정 값 이상인 리뷰 조회
    List<Review> findByUpvotesGreaterThanEqual(Integer upvotes);
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    List<Review> findAllByOrderByUpvotesDesc();
}

