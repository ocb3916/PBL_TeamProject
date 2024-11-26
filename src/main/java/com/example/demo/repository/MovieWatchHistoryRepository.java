package com.example.demo.repository;

import com.example.demo.entity.MovieWatchHistory;
import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MovieWatchHistoryRepository extends JpaRepository<MovieWatchHistory, Integer> {

    // 특정 사용자가 작성한 모든 관심 목록 조회
    List<MovieWatchHistory> findByUser(User user);

    // TMDB ID로 관심 목록 조회
    MovieWatchHistory findByTmdbId(Long tmdbId);
}
