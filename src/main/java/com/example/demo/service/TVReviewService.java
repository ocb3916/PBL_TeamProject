package com.example.demo.service;

import com.example.demo.entity.TVReview;
import com.example.demo.entity.User;
import com.example.demo.repository.TVReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TVReviewService {

    @Autowired
    private TVReviewRepository TVReviewRepository;

    // 모든 리뷰 조회
    public List<TVReview> getAllTVReviews() {
        return TVReviewRepository.findAll();
    }

    // 리뷰 ID로 리뷰 조회
    public TVReview getTVReviewById(Integer id) {
        return TVReviewRepository.findById(id).orElse(null);
    }

    // 리뷰 저장 또는 업데이트
    public TVReview saveTVReview(TVReview review) {
        return TVReviewRepository.save(review);
    }

    // 리뷰 삭제
    public void deleteTVReview(Integer id) {
        TVReviewRepository.deleteById(id);
    }

    // 특정 사용자가 작성한 모든 리뷰 조회
    public List<TVReview> getTVReviewsByUser(User user) {
        return TVReviewRepository.findByUser(user);
    }

    // 특정 등급 이상의 리뷰 조회
    public List<TVReview> getTVReviewsByRatingGreaterThanEqual(Integer rating) {
        return TVReviewRepository.findByRatingGreaterThanEqual(rating);
    }

    // 리뷰 제목으로 리뷰 조회
    public List<TVReview> getTVReviewsByTitle(String title) {
        return TVReviewRepository.findByReviewTitle(title);
    }
    
    // 닉네임으로 리뷰 조회
    public List<TVReview> getTVReviewsByNickname(String nickname) {
        return TVReviewRepository.findByNickname(nickname);
    }
    
    // 추천수가 특정 값 이상인 리뷰 조회
    public List<TVReview> getTVReviewsByUpvotes(Integer upvotes) {
        return TVReviewRepository.findByUpvotesGreaterThanEqual(upvotes);
    }
    
    // 추천수에 따라 내림차순으로 정렬된 리뷰 조회
    public List<TVReview> getTVReviewsSortedByUpvotes() {
        return TVReviewRepository.findAllByOrderByUpvotesDesc();
    }

    //TMDB아이디로 리뷰 조회
    public List<TVReview> getTVReviewsByTmdbId(Long tmdbId) {
        return TVReviewRepository.findByTmdbId(tmdbId);
    }
}
