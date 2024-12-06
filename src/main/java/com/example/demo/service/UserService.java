package com.example.demo.service;

import com.example.demo.dto.UserDto;
import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordService passwordService;
    
    @Autowired
    private VerificationCodeService verificationCodeService;


    // 모든 사용자 조회
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 사용자 ID로 사용자 조회
    public User getUserById(String id) {
        return userRepository.findById(id).orElse(null);
    }

    // 사용자 저장 또는 업데이트
    public User saveUser(UserDto userDTO) {
        User user = new User();
        user.setId(userDTO.getId());
        user.setPw(passwordService.encodePassword(userDTO.getPw())); // 비밀번호 해시화
        user.setName(userDTO.getName());
        user.setBirthDate(userDTO.getBirthDate());
        user.setName(userDTO.getName());
        user.setNickName(userDTO.getNickName());
        user.setGender(userDTO.getGender());
        user.setEmail(userDTO.getEmail());
        user.setPhoneNumber(userDTO.getPhoneNumber());
        return userRepository.save(user); // DB에 저장
    }

    // 사용자 삭제
    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }

    // 이메일로 사용자 조회
    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // 이름으로 사용자 조회
    public List<User> getUsersByName(String name) {
        return userRepository.findByName(name);
    }

    // 닉네임으로 사용자 조회
    public List<User> getUsersByNickName(String nickName) {
        return userRepository.findByNickName(nickName);
    }

    // 전화번호로 사용자 조회
    public User getUserByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }

    // 사용자 인증 메서드 추가 (ID와 비밀번호로 인증)
    public User authenticate(String id, String pw) {
        User user = getUserById(id); // ID로 사용자 조회
        if (user != null && passwordService.matches(pw, user.getPw())) { // 비밀번호 비교
            return user; // 인증 성공
        } else {
            return null; // 인증 실패
        }
    }

    //비밀번호 해시화

    public void registerUser(String username, String rawPassword) {
        String encodedPassword = passwordService.encodePassword(rawPassword);
        User user = new User();
        user.setId(username);
        user.setPw(encodedPassword); // 해시화된 비밀번호 저장
        userRepository.save(user);
    }

    // 비밀번호 재설정 메서드
    public boolean resetPassword(String Email, String newPassword) {
        User User = userRepository.findByEmail(Email); // identifier는 이메일 또는 전화번호

        if (User == null) {
            return false; // 사용자를 찾을 수 없음
        }

        String hashedPassword = passwordService.encodePassword(newPassword);
        User.setPw(hashedPassword);
        userRepository.save(User);

        // 인증번호 사용 완료 후 삭제
        verificationCodeService.removeCode(Email);

        return true;
    }
}

