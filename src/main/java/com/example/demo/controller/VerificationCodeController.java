package com.example.demo.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.entity.User;
import com.example.demo.service.EmailService;
import com.example.demo.service.UserService;
import com.example.demo.service.VerificationCodeService;

import jakarta.servlet.http.HttpSession;

import java.util.Map;

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
    public ResponseEntity<String> generateCode(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        User user = userService.getUserById(userId);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User not found.");
        }
        String code = verificationCodeService.generateCode(userId);
        emailService.sendVerificationEmail(user.getEmail(), code);
        return ResponseEntity.ok("Verification email sent to " + user.getEmail());
    }

    @PostMapping("/verify")
    public ResponseEntity<String> verifyCode(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        String code = request.get("code");
        boolean isValid = verificationCodeService.verifyCode(userId, code);
        if (isValid) {
            return ResponseEntity.ok("Code verified successfully!");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid or expired code.");
        }
    }
}
