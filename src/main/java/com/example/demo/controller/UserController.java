package com.example.demo.controller;

import com.example.demo.dto.UserDto;
import com.example.demo.entity.User;
import com.example.demo.service.EmailService;
import com.example.demo.service.UserService;
import com.example.demo.service.VerificationCodeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins="*")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private VerificationCodeService verificationCodeService;

    @Autowired
    private EmailService emailService;
    // 모든 사용자 조회
    
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    // 사용자 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable String id) {
        User user = userService.getUserById(id);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 사용자 생성 또는 업데이트
    @PostMapping
    public User createOrUpdateUser(@RequestBody UserDto userDto) {
        return userService.saveUser(userDto);
    }

    // 사용자 삭제
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    // 이메일로 사용자 조회
    @GetMapping("/email/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        User user = userService.getUserByEmail(email);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 이름으로 사용자 조회
    @GetMapping("/name/{name}")
    public List<User> getUsersByName(@PathVariable String name) {
        return userService.getUsersByName(name);
    }

    // 닉네임으로 사용자 조회
    @GetMapping("/nickname/{nickName}")
    public List<User> getUsersByNickName(@PathVariable String nickName) {
        return userService.getUsersByNickName(nickName);
    }

    // 전화번호로 사용자 조회
    @GetMapping("/phone/{phoneNumber}")
    public ResponseEntity<User> getUserByPhoneNumber(@PathVariable String phoneNumber) {
        User user = userService.getUserByPhoneNumber(phoneNumber);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<User> login(@RequestBody Map<String, String> request) {
        String id = request.get("id");
        String pw = request.get("pw");
        User user = userService.authenticate(id, pw);
        if (user != null) {
            return ResponseEntity.ok(user); // 로그인 성공 시 사용자 정보 반환
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build(); // 인증 실패 시 401 반환
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // 현재 세션이 있으면 반환
        if (session != null) {
            session.invalidate(); // 세션 무효화
        }
        // 로그아웃 성공 처리
        return ResponseEntity.ok().build(); // 성공 응답
    }

    @PostMapping("/user-authentication")
    public ResponseEntity<String> userAuthentication(@RequestBody Map<String, String> request) {
        // 얘네 역할은 유저의 ID와 이름으로 인증받아서 이메일 보내는 것까지
        String id = request.get("id");
        String name = request.get("name");
        User user = userService.getUserById(id);
        if (user != null && user.getName().equals(name)) {
            String email = user.getEmail();
            String verificationCode = verificationCodeService.generateCode(id); // 인증번호 생성
            boolean isSent = emailService.sendVerificationEmail(email, verificationCode); // 이메일 전송
            if (isSent) {
                return ResponseEntity.ok("Verification code has been sent to your email.");
            } else {
                return ResponseEntity.status(500).body("Failed to send verification code.");
            }
        } else {
            return ResponseEntity.status(400).body("User not found or name does not match.");
        }
    }
    
    // 비밀번호 재설정 엔드포인트 (인증번호 검증은 인증번호컨트롤러에서 처리)
    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword(@RequestBody Map<String, String> request) {
        // 얘 역할은 그냥 비밀번호 초기화 역할만
        String id = request.get("id");
        String newPassword = request.get("newPassword");
        User user = userService.getUserById(id);
        // 비밀번호 재설정
        boolean isReset = userService.resetPassword(user.getEmail(), newPassword);
    
        if (isReset) {
            return ResponseEntity.ok("Password has been reset successfully.");
        } else {
            return ResponseEntity.status(400).body("User not found.");
        }
    }

    // 아이디 중복 체크
    @PostMapping("/check-id")
    public ResponseEntity<Map<String, Boolean>> checkIdDuplicate(@RequestBody Map<String, String> request) {
	String id = request.get("id");
        boolean isAvailable = userService.isIdAvailable(id);
        Map<String, Boolean> response = new HashMap<>();
        response.put("available", isAvailable);
        return ResponseEntity.ok(response);
    }
    
    // 이메일 업데이트
    @PutMapping("/email")
    public ResponseEntity<?> updateEmail(@RequestBody Map<String, String> request) {
        try {
            String userId = request.get("userId");
            String newEmail = request.get("value");

            userService.updateEmail(userId, newEmail);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Email updated successfully."
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    // 전화번호 업데이트
    @PutMapping("/phone")
    public ResponseEntity<?> updatePhone(@RequestBody Map<String, String> request) {
        try {
            String userId = request.get("userId");
            String newPhone = request.get("value");

            userService.updatePhone(userId, newPhone);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Phone number updated successfully."
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }

    // 닉네임 업데이트
    @PutMapping("/nickname")
    public ResponseEntity<?> updateNickname(@RequestBody Map<String, String> request) {
        try {
            String userId = request.get("userId");
            String newNickname = request.get("value");

            userService.updateNickname(userId, newNickname);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Nickname updated successfully."
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }
}
