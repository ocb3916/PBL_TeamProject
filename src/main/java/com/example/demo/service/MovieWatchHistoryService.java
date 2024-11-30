package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.MovieWatchHistoryDto;
import com.example.demo.entity.MovieWatchHistory;
import com.example.demo.entity.User;
import com.example.demo.repository.MovieWatchHistoryRepository;
import com.example.demo.repository.UserRepository;


@Service
public class MovieWatchHistoryService {

    @Autowired
    private UserRepository UserRepository;
    
    @Autowired
    private MovieWatchHistoryRepository MovieWatchHistoryRepository;

    // 모든 관심 목록 조회
    public List<MovieWatchHistory> getAllMovieWatchHistorys() {
        return MovieWatchHistoryRepository.findAll();
    }

    // 특정 사용자가 등록한 모든 관심 목록 조회
    public List<MovieWatchHistory> getMovieWatchHistorysByUser(User user) {
        return MovieWatchHistoryRepository.findByUser(user);
    }

    // TMDB ID로 관심 목록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    public MovieWatchHistory getMovieWatchHistoryByTmdbId(Long tmdbId) {
        return MovieWatchHistoryRepository.findByTmdbId(tmdbId);
    }

    // 관심 목록 저장 또는 업데이트
    public MovieWatchHistory saveMovieWatchHistory(MovieWatchHistoryDto dto) {
         // userId를 통해 User 객체 조회
        User user = UserRepository.findById(dto.getUserId())
            .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + dto.getUserId()));

        // MovieWatchHistory 객체 생성 후 저장
        MovieWatchHistory newEntry = new MovieWatchHistory(user, dto.getTmdbId());
        return MovieWatchHistoryRepository.save(newEntry);
    }

    // 관심 목록 삭제
    public void deleteMovieWatchHistory(Integer id) {
        MovieWatchHistoryRepository.deleteById(id);
    }
}

