package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "genre_list") // 데이터베이스 테이블 이름을 명시적으로 지정
public class GenreList {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // 기본 키 자동 증가 설정
    private Integer id;

    @Column(nullable = false, length = 45) // NOT NULL 및 최대 길이 설정
    private String genre;

    // 기본 생성자
    public GenreList() {}

    // 필드를 사용하는 생성자
    public GenreList(String genre) {
        this.genre = genre;
    }

    // Getter 및 Setter
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }
}

