package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.util.Date;

@Entity
@Table(name = "user")
public class User {

    @Id
    @Column(length = 15, nullable = false, unique = true)
    private String id; // 사용자 ID

    @Column(length = 255, nullable = false)
    private String pw; // 비밀번호

    @Column(nullable = false)
    private Date birthDate; // 생년월일

    @Column(length = 50, nullable = false)
    private String name; // 이름

    @Column(length = 255, nullable = false)
    private String nickName; // 닉네임

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Gender gender; // 성별

    @Column(length = 320, nullable = false)
    private String email; // 이메일

    @Column(length = 15, nullable = false)
    private String phoneNumber; // 전화번호

    // Gender enum 정의
    public enum Gender {
        MALE, FEMALE
    }

    // 기본 생성자
    public User() {}

    // 필드를 사용하는 생성자
    public User(String id, String pw, Date birthDate, String name, String nickName, Gender gender, String email, String phoneNumber) {
        this.id = id;
        this.pw = pw;
        this.birthDate = birthDate;
        this.name = name;
        this.nickName = nickName;
        this.gender = gender;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    // Getter 및 Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}


