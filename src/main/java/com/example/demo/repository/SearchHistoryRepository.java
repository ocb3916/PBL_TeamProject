package com.example.demo.repository;

import com.example.demo.entity.SearchHistory;
import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface SearchHistoryRepository extends JpaRepository<SearchHistory, Integer> {

    // 특정 사용자가 수행한 모든 검색 기록 조회
    List<SearchHistory> findByUser(User user);

    // 검색 기록에 특정 문자열이 포함된 모든 항목 조회
    List<SearchHistory> findBySearchHistoryContaining(String keyword);
}

