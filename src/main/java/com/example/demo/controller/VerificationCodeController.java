package com.example.demo.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.entity.User;
import com.example.demo.service.EmailService;
import com.example.demo.service.UserService;
import com.example.demo.service.VerificationCodeService;

@RestController
@RequestMapping("/verification")
public class VerificationCodeController {

    private final VerificationCodeService verificationCodeService;
    private EmailService emailService;
    private UserService userService;

    public VerificationCodeController(VerificationCodeService verificationCodeService) {
        this.verificationCodeService = verificationCodeService;
    }

    @PostMapping("/generate")
    public ResponseEntity<String> generateCode(@RequestParam String userId) {
        User user = userService.getUserById(userId);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User not found.");
        }
        String code = verificationCodeService.generateCode(userId);
        emailService.sendVerificationEmail(user.getEmail(), code);
        return ResponseEntity.ok("Verification email sent to " + user.getEmail());
    }

    @PostMapping("/verify")
    public ResponseEntity<String> verifyCode(@RequestParam String userId, @RequestParam String code) {
        boolean isValid = verificationCodeService.verifyCode(userId, code);
        if (isValid) {
            return ResponseEntity.ok("Code verified successfully!");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid or expired code.");
        }
    }
}

