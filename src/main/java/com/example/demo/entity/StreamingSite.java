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
@Table(name = "streaming_site")
public class StreamingSite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "site_id", referencedColumnName = "id", nullable = false)
    private StreamingSiteList streamingSiteList;

    @ManyToOne
    @JoinColumn(name = "movie_id", referencedColumnName = "id", nullable = false)
    private Movie movie;

    // 기본 생성자
    public StreamingSite() {}

    // 필드를 사용하는 생성자
    public StreamingSite(StreamingSiteList streamingSiteList, Movie movie) {
        this.streamingSiteList = streamingSiteList;
        this.movie = movie;
    }

    // Getter 및 Setter
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public StreamingSiteList getStreamingSiteList() {
        return streamingSiteList;
    }

    public void setStreamingSiteList(StreamingSiteList streamingSiteList) {
        this.streamingSiteList = streamingSiteList;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }
}

