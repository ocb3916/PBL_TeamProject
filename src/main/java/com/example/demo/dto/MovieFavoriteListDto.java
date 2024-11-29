package com.example.demo.dto;

public class MovieFavoriteListDto {
    private String userId;
    private Long tmdbId;

    // 기본 생성자
    public MovieFavoriteListDto() {}

    // Getter 및 Setter
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Long getTmdbId() {
        return tmdbId;
    }

    public void setTmdbId(Long tmdbId) {
        this.tmdbId = tmdbId;
    }
}

