package com.example.demo.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public boolean sendVerificationEmail(String to, String verificationCode) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject("Your Verification Code");
            message.setText("Your verification code is: " + verificationCode);
    
            // 메일 발송
            mailSender.send(message);
    
            // 성공적으로 발송되었으면 true 반환
            return true;
        } catch (Exception e) {
            // 메일 발송 중 에러가 발생하면 false 반환
            System.err.println("Failed to send verification email: " + e.getMessage());
            return false;
        }
    }
}

