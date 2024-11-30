package com.example.demo.dto;

public class SearchHistoryDto {
    private String userId;
    private String searchHistory;

    // 기본 생성자
    public SearchHistoryDto() {}

    // Getter 및 Setter
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSearchHistory() {
        return searchHistory;
    }

    public void setSearchHistory(String searchHistory) {
        this.searchHistory = searchHistory;
    }
}
