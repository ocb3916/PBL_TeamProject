package com.example.demo.repository;

import com.example.demo.entity.MovieFavoriteList;
import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MovieFavoriteListRepository extends JpaRepository<MovieFavoriteList, Integer> {

    // 특정 사용자가 등록한 모든 관심 목록 조회
    List<MovieFavoriteList> findByUser(User user);

    // TMDB ID로 관심 목록 조회
    MovieFavoriteList findByTmdbId(Long tmdbId);
}