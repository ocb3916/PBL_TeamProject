package com.example.demo.service;

import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // 모든 사용자 조회
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 사용자 ID로 사용자 조회
    public User getUserById(String id) {
        return userRepository.findById(id).orElse(null);
    }

    // 사용자 저장 또는 업데이트
    public User saveUser(User user) {
        return userRepository.save(user);
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
}

