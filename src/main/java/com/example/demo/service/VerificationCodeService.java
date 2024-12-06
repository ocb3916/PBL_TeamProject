package com.example.demo.service;

import java.time.LocalDateTime;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

@Service
public class VerificationCodeService {

    private static final int CODE_LENGTH = 6;
    private static final int EXPIRATION_MINUTES = 5; // 유효기간 5분으로 설정

    private final ConcurrentHashMap<String, VerificationCode> codeStorage = new ConcurrentHashMap<>();

    public String generateCode(String userId) {
        String code = createRandomCode(CODE_LENGTH);
        LocalDateTime expirationTime = LocalDateTime.now().plusMinutes(EXPIRATION_MINUTES);

        VerificationCode verificationCode = new VerificationCode(code, expirationTime);
        codeStorage.put(userId, verificationCode);

        return code;
    }

    public boolean verifyCode(String userId, String code) {
        VerificationCode storedCode = codeStorage.get(userId);

        if (storedCode == null || storedCode.isExpired()) {
            return false; // 인증번호가 없거나 만료됨
        }

        return storedCode.getCode().equals(code);
    }

    private String createRandomCode(int length) {
        Random random = new Random();
        StringBuilder code = new StringBuilder();

        for (int i = 0; i < length; i++) {
            code.append(random.nextInt(10));
        }

        return code.toString();
    }

    public void removeCode(String Email) {
        codeStorage.remove(Email); // identifier는 이메일 또는 전화번호
    }
}
