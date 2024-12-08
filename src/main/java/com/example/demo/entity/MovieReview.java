package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.util.Date;

@Entity
@Table(name = "movie_review")
public class MovieReview {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = true)
    private User user;

    @Column(name = "user_id", insertable = false, updatable = false)
    private String userId;

    @Column
    private Integer rating;

    @Column(columnDefinition = "TEXT")
    private String review;

    @Column(length = 255)
    private String reviewTitle;

    @Temporal(TemporalType.TIMESTAMP)
    private Date reviewDate;

    @Column(length = 100)
    private String nickname;

    @Column(name = "tmdb_id")
    private Long tmdbId;

    @Column(nullable = false)
    private Integer upvotes = 0;

    @Column(nullable = false)
    private Integer downvotes = 0;

    // 기본 생성자
    public MovieReview() {}

    // 필드를 사용하는 생성자
    public MovieReview(User user, Integer rating, String review, String reviewTitle, Date reviewDate, String nickname) {
        this.user = user;
        this.rating = rating;
        this.review = review;
        this.reviewTitle = reviewTitle;
        this.reviewDate = reviewDate;
        this.nickname = nickname;
    }

    // TMDB에서 가져온 리뷰 받는 생성자
    public MovieReview(String reviewTitle, Integer rating, String nickname, Date reviewDate, String review, Integer upvotes, Integer downvotes, Long tmdbId) {
        this.reviewTitle = reviewTitle;
        this.rating = rating;
        this.nickname = nickname;
        this.reviewDate = reviewDate;
        this.review = review;
        this.upvotes = upvotes;
        this.downvotes = downvotes;
        this.tmdbId = tmdbId;
    }

    // Getter 및 Setter
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public String getReviewTitle() {
        return reviewTitle;
    }

    public void setReviewTitle(String reviewTitle) {
        this.reviewTitle = reviewTitle;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public Long getTmdbId() {
        return tmdbId;
    }

    public void setTmdbId(Long tmdbId) {
        this.tmdbId = tmdbId;
    }

    public Integer getUpvotes() {
        return upvotes;
    }

    public void setUpvotes(Integer upvotes) {
        this.upvotes = upvotes;
    }

    public Integer getDownvotes() {
        return downvotes;
    }

    public void setDownvotes(Integer downvotes) {
        this.downvotes = downvotes;
    }
}
