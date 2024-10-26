package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "genre")
public class Genre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer genreId;

    @ManyToOne
    @JoinColumn(name = "movie_id", referencedColumnName = "id", nullable = false)
    private Movie movie;

    @ManyToOne
    @JoinColumn(name = "genre_list_id", referencedColumnName = "id", nullable = false)
    private GenreList genreList;

    @Column(nullable = false, length = 45)
    private String genre;

    // 기본 생성자
    public Genre() {}

    // 필드를 사용하는 생성자
    public Genre(Movie movie, GenreList genreList, String genre) {
        this.movie = movie;
        this.genreList = genreList;
        this.genre = genre;
    }

    // Getter 및 Setter
    public Integer getGenreId() {
        return genreId;
    }

    public void setGenreId(Integer genreId) {
        this.genreId = genreId;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public GenreList getGenreList() {
        return genreList;
    }

    public void setGenreList(GenreList genreList) {
        this.genreList = genreList;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }
}

