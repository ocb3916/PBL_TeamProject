package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.EmailService;
import com.example.demo.service.VerificationCodeService;

import java.util.Map;

@RestController
@CrossOrigin(origins="*")
@RequestMapping("/email")
public class EmailController {

    private final VerificationCodeService verificationCodeService;
    private final EmailService emailService;

    public EmailController(VerificationCodeService verificationCodeService, EmailService emailService) {
        this.verificationCodeService = verificationCodeService;
        this.emailService = emailService;
    }

    @PostMapping("/send")
    public ResponseEntity<String> sendEmail(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String code = verificationCodeService.generateCode(email);
        emailService.sendVerificationEmail(email, code);
        return ResponseEntity.ok("Verification email sent!");
    }
}
