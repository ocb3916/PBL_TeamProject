package com.example.demo.controller;

import com.example.demo.entity.MovieReview;
import com.example.demo.entity.User;
import com.example.demo.service.MovieReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/movie-reviews")
public class MovieReviewController {

    @Autowired
    private MovieReviewService movieReviewService;

    // 모든 리뷰 조회
    @GetMapping
    public List<MovieReview> getAllMovieReviews() {
        return movieReviewService.getAllMovieReviews();
    }

    // 리뷰 제목으로 조회
    @GetMapping("/title/{title}")
    public List<MovieReview> getMovieReviewsByTitle(@PathVariable String title) {
        return movieReviewService.getMovieReviewsByTitle(title);
    }

    // 닉네임으로 조회
    @GetMapping("/nickname/{nickname}")
    public List<MovieReview> getMovieReviewsByNickname(@PathVariable String nickname) {
        return movieReviewService.getMovieReviewsByNickname(nickname);
    }

    // 추천수가 특정 값 이상인 리뷰 조회
    @GetMapping("/upvotes/{upvotes}")
    public List<MovieReview> getMovieReviewsByUpvotes(@PathVariable Integer upvotes) {
        return movieReviewService.getMovieReviewsByUpvotes(upvotes);
    }

    // 리뷰 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<MovieReview> getMovieReviewById(@PathVariable Integer id) {
        MovieReview review = movieReviewService.getMovieReviewById(id);
        if (review != null) {
            return ResponseEntity.ok(review);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 리뷰 생성 또는 업데이트
    @PostMapping
    public MovieReview createOrUpdateMovieReview(@RequestBody MovieReview movieReview) {
        return movieReviewService.saveMovieReview(movieReview);
    }

    // 리뷰 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMovieReview(@PathVariable Integer id) {
        movieReviewService.deleteMovieReview(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 사용자가 작성한 모든 리뷰 조회
    @GetMapping("/user/{userId}")
    public List<MovieReview> getMovieReviewsByUser(@PathVariable String userId) {
        User user = new User();
        user.setId(userId);
        return movieReviewService.getMovieReviewsByUser(user);
    }


    // 특정 등급 이상의 리뷰 조회
    @GetMapping("/rating/{rating}")
    public List<MovieReview> getMovieReviewsByRatingGreaterThanEqual(@PathVariable Integer rating) {
        return movieReviewService.getMovieReviewsByRatingGreaterThanEqual(rating);
    }
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    @GetMapping("/sorted/upvotes")
    public List<MovieReview> getMovieReviewsSortedByUpvotes() {
        return movieReviewService.getMovieReviewsSortedByUpvotes();
    }

    //TMDB_ID로 리뷰 조회
    @GetMapping("/{TMDB_ID}")
    public List<MovieReview> getMovieReviewsByTmdbId(@PathVariable Long tmdbId) {
        return movieReviewService.getMovieReviewsByTmdbId(tmdbId);
    }
}
