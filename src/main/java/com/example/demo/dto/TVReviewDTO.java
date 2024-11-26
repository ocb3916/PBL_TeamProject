package com.example.demo.dto;

import java.sql.Date;

import com.example.demo.RatingDeserializer;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

public class TVReviewDTO {
    
    private String title;
    @JsonDeserialize(using = RatingDeserializer.class)
    private Integer rating;
    private String author;
    private Date date;
    private String body;
    @JsonProperty("helpful_yes")
    private Integer helpfulYes;
    @JsonProperty("helpful_no")
    private Integer helpfulNo;
    @JsonProperty("tmdb-id")
    private Long tmdbId;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }
    
    public Integer getHelpfulYes() {
        return helpfulYes;
    }

    public void setHelpfulYes(Integer helpfulYes) {
        this.helpfulYes = helpfulYes;
    }

    public Integer getHelpfulNo() {
        return helpfulNo;
    }

    public void setHelpfulNo(Integer helpfulNo) {
        this.helpfulNo = helpfulNo;
    }

    public Long getTmdbId() {
        return tmdbId;
    }

    public void setTmdbId(Long tmdbId) {
        this.tmdbId = tmdbId;
    }
}
