package com.example.demo.entity;



import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "cast")
public class Cast {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "movie_id", referencedColumnName = "id", nullable = false)
    private Movie movie;

    @ManyToOne
    @JoinColumn(name = "actor_id", referencedColumnName = "id", nullable = false)
    private Actor actor;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MainSupporting mainSupporting;

    public enum MainSupporting {
        MAIN, SUPPORTING
    }

    // 기본 생성자
    public Cast() {}

    // 필드를 사용하는 생성자
    public Cast(Movie movie, Actor actor, MainSupporting mainSupporting) {
        this.movie = movie;
        this.actor = actor;
        this.mainSupporting = mainSupporting;
    }

    // Getter 및 Setter
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public Actor getActor() {
        return actor;
    }

    public void setActor(Actor actor) {
        this.actor = actor;
    }

    public MainSupporting getMainSupporting() {
        return mainSupporting;
    }

    public void setMainSupporting(MainSupporting mainSupporting) {
        this.mainSupporting = mainSupporting;
    }
}

