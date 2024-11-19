package com.example.demo.controller;

import com.example.demo.entity.SearchHistory;
import com.example.demo.entity.User;
import com.example.demo.service.SearchHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/search-histories")
public class SearchHistoryController {

    @Autowired
    private SearchHistoryService searchHistoryService;

    // 모든 검색 기록 조회
    @GetMapping
    public List<SearchHistory> getAllSearchHistories() {
        return searchHistoryService.getAllSearchHistories();
    }

    // 검색 기록 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<SearchHistory> getSearchHistoryById(@PathVariable Integer id) {
        SearchHistory searchHistory = searchHistoryService.getSearchHistoryById(id);
        if (searchHistory != null) {
            return ResponseEntity.ok(searchHistory);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 검색 기록 생성 또는 업데이트
    @PostMapping
    public SearchHistory createOrUpdateSearchHistory(@RequestBody SearchHistory searchHistory) {
        return searchHistoryService.saveSearchHistory(searchHistory);
    }

    // 검색 기록 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSearchHistory(@PathVariable Integer id) {
        searchHistoryService.deleteSearchHistory(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 사용자가 수행한 모든 검색 기록 조회
    @GetMapping("/user/{userId}")
    public List<SearchHistory> getSearchHistoriesByUser(@PathVariable String userId) {
        User user = new User();
        user.setId(userId);
        return searchHistoryService.getSearchHistoriesByUser(user);
    }

    // 검색 기록에 특정 문자열이 포함된 모든 항목 조회
    @GetMapping("/search/{keyword}")
    public List<SearchHistory> getSearchHistoriesByKeyword(@PathVariable String keyword) {
        return searchHistoryService.getSearchHistoriesByKeyword(keyword);
    }
}

