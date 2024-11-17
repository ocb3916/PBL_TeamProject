package com.example.demo.repository;

import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserRepository extends JpaRepository<User, String> {

    // 이메일로 사용자 조회
    User findByEmail(String email);

    // 이름으로 사용자 조회
    List<User> findByName(String name);

    // 닉네임으로 사용자 조회
    List<User> findByNickName(String nickName);

    // 전화번호로 사용자 조회
    User findByPhoneNumber(String phoneNumber);
}

