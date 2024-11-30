package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.TVWatchHistoryDto;
import com.example.demo.entity.TVWatchHistory;
import com.example.demo.entity.User;
import com.example.demo.service.TVWatchHistoryService;

@RestController
@RequestMapping("/api/TV-watch-histories")
public class TVWatchHistoryController {
    
    @Autowired
    private TVWatchHistoryService TVWatchHistoryService;

    // 모든 시청 기록 조회
    @GetMapping
    public List<TVWatchHistory> getAllTVWatchHistorys() {
        return TVWatchHistoryService.getAllTVWatchHistorys();
    }

    // 특정 사용자가 등록한 모든 시청 기록 조회
    @GetMapping("/user/{userId}")
    public List<TVWatchHistory> getTVWatchHistorysByUser(@PathVariable String userId) {
        User user = new User();
        user.setId(userId);
        return TVWatchHistoryService.getTVWatchHistorysByUser(user);
    }

    // TMDB ID로 시청 기록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    @GetMapping("/{TMDB_ID}")
    public TVWatchHistory getTVWatchHistorysByTmdbId(@PathVariable Long tmdbId) {
        return TVWatchHistoryService.getTVWatchHistoryByTmdbId(tmdbId);
    }

    // 시청 기록 생성 또는 업데이트
    @PostMapping
    public TVWatchHistory createOrUpdateTVWatchHistory(@RequestBody TVWatchHistoryDto dto) {
        return TVWatchHistoryService.saveTVWatchHistory(dto);
    }

    // 시청 기록 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTVWatchHistory(@PathVariable Integer id) {
        TVWatchHistoryService.deleteTVWatchHistory(id);
        return ResponseEntity.noContent().build();
    }
}

