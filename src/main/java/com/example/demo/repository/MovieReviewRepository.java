package com.example.demo.repository;

import com.example.demo.entity.MovieReview;
import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MovieReviewRepository extends JpaRepository<MovieReview, Integer> {

    // 특정 사용자가 작성한 모든 리뷰 조회
    List<MovieReview> findByUser(User user);

    // 특정 등급 이상의 리뷰 조회
    List<MovieReview> findByRatingGreaterThanEqual(Integer rating);

    // 리뷰 제목으로 리뷰 조회
    List<MovieReview> findByReviewTitle(String reviewTitle);

    // 닉네임으로 리뷰 조회
    List<MovieReview> findByNickname(String nickname);
 
    // 추천수가 특정 값 이상인 리뷰 조회
    List<MovieReview> findByUpvotesGreaterThanEqual(Integer upvotes);
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    List<MovieReview> findAllByOrderByUpvotesDesc();

    // TMDB아이디로 리뷰 조회
    List<MovieReview> findByTmdbId(Long tmdbId);
    
    @Modifying
    @Query("UPDATE MovieReview r SET r.nickname = :nickname WHERE r.user.id = :userId")
    void updateNicknameByUser(@Param("userId") String userId, @Param("nickname") String nickname);
}

