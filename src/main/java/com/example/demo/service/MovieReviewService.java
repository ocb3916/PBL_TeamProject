package com.example.demo.service;

import com.example.demo.entity.MovieReview;
import com.example.demo.entity.User;
import com.example.demo.repository.MovieReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MovieReviewService {

    @Autowired
    private MovieReviewRepository MovieReviewRepository;

    // 모든 리뷰 조회
    public List<MovieReview> getAllMovieReviews() {
        return MovieReviewRepository.findAll();
    }

    // 리뷰 ID로 리뷰 조회
    public MovieReview getMovieReviewById(Integer id) {
        return MovieReviewRepository.findById(id).orElse(null);
    }

    // 리뷰 저장 또는 업데이트
    public MovieReview saveMovieReview(MovieReview MovieReview) {
        return MovieReviewRepository.save(MovieReview);
    }

    // 리뷰 삭제
    public void deleteMovieReview(Integer id) {
        MovieReviewRepository.deleteById(id);
    }

    // 특정 사용자가 작성한 모든 리뷰 조회
    public List<MovieReview> getMovieReviewsByUser(User user) {
        return MovieReviewRepository.findByUser(user);
    }

    // 특정 등급 이상의 리뷰 조회
    public List<MovieReview> getMovieReviewsByRatingGreaterThanEqual(Integer rating) {
        return MovieReviewRepository.findByRatingGreaterThanEqual(rating);
    }

    // 리뷰 제목으로 리뷰 조회
    public List<MovieReview> getMovieReviewsByTitle(String title) {
        return MovieReviewRepository.findByReviewTitle(title);
    }
    
    // 닉네임으로 리뷰 조회
    public List<MovieReview> getMovieReviewsByNickname(String nickname) {
        return MovieReviewRepository.findByNickname(nickname);
    }
    
    // 추천수가 특정 값 이상인 리뷰 조회
    public List<MovieReview> getMovieReviewsByUpvotes(Integer upvotes) {
        return MovieReviewRepository.findByUpvotesGreaterThanEqual(upvotes);
    }
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    public List<MovieReview> getMovieReviewsSortedByUpvotes() {
        return MovieReviewRepository.findAllByOrderByUpvotesDesc();
    }

    //TMDB아이디로 리뷰 조회
    public List<MovieReview> getMovieReviewsByTmdbId(Long tmdbId) {
        return MovieReviewRepository.findByTmdbId(tmdbId);
    }
}
