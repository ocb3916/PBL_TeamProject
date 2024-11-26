package com.example.demo.service;

import com.example.demo.entity.SearchHistory;
import com.example.demo.entity.User;
import com.example.demo.repository.SearchHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SearchHistoryService {

    @Autowired
    private SearchHistoryRepository searchHistoryRepository;

    // 모든 검색 기록 조회
    public List<SearchHistory> getAllSearchHistories() {
        return searchHistoryRepository.findAll();
    }

    // 검색 기록 ID로 검색 기록 조회
    public SearchHistory getSearchHistoryById(Integer id) {
        return searchHistoryRepository.findById(id).orElse(null);
    }

    // 검색 기록 저장 또는 업데이트
    public SearchHistory saveSearchHistory(SearchHistory searchHistory) {
        return searchHistoryRepository.save(searchHistory);
    }

    // 검색 기록 삭제
    public void deleteSearchHistory(Integer id) {
        searchHistoryRepository.deleteById(id);
    }

    // 특정 사용자가 수행한 모든 검색 기록 조회
    public List<SearchHistory> getSearchHistoriesByUser(User user) {
        return searchHistoryRepository.findByUser(user);
    }

    // 검색 기록에 특정 문자열이 포함된 모든 항목 조회
    public List<SearchHistory> getSearchHistoriesByKeyword(String keyword) {
        return searchHistoryRepository.findBySearchHistoryContaining(keyword);
    }
}

