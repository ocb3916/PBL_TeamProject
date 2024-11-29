package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.entity.TVWatchHistory;
import com.example.demo.entity.User;
import com.example.demo.repository.TVWatchHistoryRepository;


@Service
public class TVWatchHistoryService {
    
    @Autowired
    private TVWatchHistoryRepository TVWatchHistoryRepository;

    // 모든 관심 목록 조회
    public List<TVWatchHistory> getAllTVWatchHistorys() {
        return TVWatchHistoryRepository.findAll();
    }

    // 특정 사용자가 등록한 모든 관심 목록 조회
    public List<TVWatchHistory> getTVWatchHistorysByUser(User user) {
        return TVWatchHistoryRepository.findByUser(user);
    }

    // TMDB ID로 관심 목록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    public TVWatchHistory getTVWatchHistoryByTmdbId(Long tmdbId) {
        return TVWatchHistoryRepository.findByTmdbId(tmdbId);
    }

    // 관심 목록 저장 또는 업데이트
    public TVWatchHistory saveTVWatchHistory(TVWatchHistoryDto dto) {
         // userId를 통해 User 객체 조회
        User user = UserRepository.findById(dto.getUserId())
            .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + dto.getUserId()));

        // TVWatchHistory 객체 생성 후 저장
        TVWatchHistory newEntry = new TVWatchHistory(user, dto.getTmdbId());
        return TVWatchHistoryRepository.save(newEntry);
    }

    // 관심 목록 삭제
    public void deleteTVWatchHistory(Integer id) {
        TVWatchHistoryRepository.deleteById(id);
    }
}
