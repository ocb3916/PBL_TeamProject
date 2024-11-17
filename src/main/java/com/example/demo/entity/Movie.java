package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.math.BigDecimal;

@Entity
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // 자동 증가 설정
    private Integer id;

    @Column(nullable = false, length = 45) // NOT NULL 및 최대 길이 설정
    private String name;

    @Column(length = 512) // URL을 저장할 충분한 길이로 설정
    private String poster; // 포스터 URL

    @Column(nullable = false, length = 45)
    private String director;

    @Column(precision = 2, scale = 1)
    private BigDecimal movieRating; // DECIMAL(2,1) 타입

    @Column
    private Integer runningTime; // 러닝타임

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AgeRating ageRating; // ENUM 타입

    @Column(precision = 7, scale = 3)
    private BigDecimal score; // 스코어

    @Column(columnDefinition = "TEXT")
    private String synopsis; // TEXT 타입

    // AgeRating enum 정의
    public enum AgeRating {
        ALL, TWELVE, FIFTEEN, NINETEEN
    }

    // 기본 생성자
    public Movie() {}

    public Movie(String name, String poster, String director, BigDecimal movieRating,
                 Integer runningTime, AgeRating ageRating, BigDecimal score, String synopsis) {
        this.name = name;
        this.poster = poster;
        this.director = director;
        this.movieRating = movieRating;
        this.runningTime = runningTime;
        this.ageRating = ageRating;
        this.score = score;
        this.synopsis = synopsis;
    }

    // Getter 및 Setter
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public BigDecimal getMovieRating() {
        return movieRating;
    }

    public void setMovieRating(BigDecimal movieRating) {
        this.movieRating = movieRating;
    }

    public Integer getRunningTime() {
        return runningTime;
    }

    public void setRunningTime(Integer runningTime) {
        this.runningTime = runningTime;
    }

    public AgeRating getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(AgeRating ageRating) {
        this.ageRating = ageRating;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }
}
