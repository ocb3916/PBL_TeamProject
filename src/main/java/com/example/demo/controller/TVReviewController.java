package com.example.demo.controller;

import com.example.demo.entity.TVReview;
import com.example.demo.entity.User;
import com.example.demo.service.TVReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tv-reviews")
public class TVReviewController {

    @Autowired
    private TVReviewService TVReviewService;

    // 모든 리뷰 조회
    @GetMapping
    public List<TVReview> getAllTVReviews() {
        return TVReviewService.getAllTVReviews();
    }

    // 리뷰 제목으로 조회
    @GetMapping("/title/{title}")
    public List<TVReview> getTVReviewsByTitle(@PathVariable String title) {
        return TVReviewService.getTVReviewsByTitle(title);
    }

    // 닉네임으로 조회
    @GetMapping("/nickname/{nickname}")
    public List<TVReview> getTVReviewsByNickname(@PathVariable String nickname) {
        return TVReviewService.getTVReviewsByNickname(nickname);
    }

    // 추천수가 특정 값 이상인 리뷰 조회
    @GetMapping("/upvotes/{upvotes}")
    public List<TVReview> getTVReviewsByUpvotes(@PathVariable Integer upvotes) {
        return TVReviewService.getTVReviewsByUpvotes(upvotes);
    }

    // 리뷰 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<TVReview> getTVReviewById(@PathVariable Integer id) {
        TVReview review = TVReviewService.getTVReviewById(id);
        if (review != null) {
            return ResponseEntity.ok(review);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 리뷰 생성 또는 업데이트
    @PostMapping
    public TVReview createOrUpdateTVReview(@RequestBody TVReview TVReview) {
        return TVReviewService.saveTVReview(TVReview);
    }

    // 리뷰 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTVReview(@PathVariable Integer id) {
        TVReviewService.deleteTVReview(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 사용자가 작성한 모든 리뷰 조회
    @GetMapping("/user/{userId}")
    public List<TVReview> getTVReviewsByUser(@PathVariable String userId) {
        User user = new User();
        user.setId(userId);
        return TVReviewService.getTVReviewsByUser(user);
    }


    // 특정 등급 이상의 리뷰 조회
    @GetMapping("/rating/{rating}")
    public List<TVReview> getTVReviewsByRatingGreaterThanEqual(@PathVariable Integer rating) {
        return TVReviewService.getTVReviewsByRatingGreaterThanEqual(rating);
    }
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    @GetMapping("/sorted/upvotes")
    public List<TVReview> getTVReviewsSortedByUpvotes() {
        return TVReviewService.getTVReviewsSortedByUpvotes();
    }

    //TMDB_ID로 리뷰 조회
    @GetMapping("/{TMDB_ID}")
    public List<TVReview> getTVReviewsByTmdbId(@PathVariable Long tmdbId) {
        return TVReviewService.getTVReviewsByTmdbId(tmdbId);
    }
}
