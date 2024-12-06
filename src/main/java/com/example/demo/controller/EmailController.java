package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.EmailService;
import com.example.demo.service.VerificationCodeService;

@RestController
@RequestMapping("/email")
public class EmailController {

    private final VerificationCodeService verificationCodeService;
    private final EmailService emailService;

    public EmailController(VerificationCodeService verificationCodeService, EmailService emailService) {
        this.verificationCodeService = verificationCodeService;
        this.emailService = emailService;
    }

    @PostMapping("/send")
    public ResponseEntity<String> sendEmail(@RequestParam String email) {
        String code = verificationCodeService.generateCode(email);
        emailService.sendVerificationEmail(email, code);
        return ResponseEntity.ok("Verification email sent!");
    }
}
