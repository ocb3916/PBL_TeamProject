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

    @Column
    private byte[] poster; // MEDIUMBLOB 타입

    @Column(nullable = false, length = 45)
    private String director;

    @Column(precision = 2, scale = 1)
    private BigDecimal movieRating; // DECIMAL(2,1) 타입

    private Integer averagePlayTime; // INT 타입

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AgeRating ageRating; // ENUM 타입

    private Integer ranking; // INT 타입

    @Column(columnDefinition = "TEXT")
    private String synopsis; // TEXT 타입

    // AgeRating enum 정의
    public enum AgeRating {
        ALL, TWELVE, FIFTEEN, NINETEEN
    }

    // 기본 생성자
    public Movie() {}

    // 필드를 사용하는 생성자 (필요한 경우 추가)
    public Movie(String name, byte[] poster, String director, BigDecimal movieRating,
                 Integer averagePlayTime, AgeRating ageRating, Integer ranking, String synopsis) {
        this.name = name;
        this.poster = poster;
        this.director = director;
        this.movieRating = movieRating;
        this.averagePlayTime = averagePlayTime;
        this.ageRating = ageRating;
        this.ranking = ranking;
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

    public byte[] getPoster() {
        return poster;
    }

    public void setPoster(byte[] poster) {
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

    public Integer getAveragePlayTime() {
        return averagePlayTime;
    }

    public void setAveragePlayTime(Integer averagePlayTime) {
        this.averagePlayTime = averagePlayTime;
    }

    public AgeRating getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(AgeRating ageRating) {
        this.ageRating = ageRating;
    }

    public Integer getRanking() {
        return ranking;
    }

    public void setRanking(Integer ranking) {
        this.ranking = ranking;
    }

    public String getSynopsis() {
        return synopsis;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }
}
