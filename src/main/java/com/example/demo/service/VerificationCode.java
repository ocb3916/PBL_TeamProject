package com.example.demo.service;

import java.time.LocalDateTime;

public class VerificationCode {

    private final String code;
    private final LocalDateTime expirationTime;

    public VerificationCode(String code, LocalDateTime expirationTime) {
        this.code = code;
        this.expirationTime = expirationTime;
    }

    public String getCode() {
        return code;
    }

    public boolean isExpired() {
        // 현재 시간이 만료 시간 이후인지 확인
        return LocalDateTime.now().isAfter(expirationTime);
    }
}

