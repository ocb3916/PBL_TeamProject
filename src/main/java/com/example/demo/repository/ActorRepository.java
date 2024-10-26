package com.example.demo.repository;

import com.example.demo.entity.Actor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ActorRepository extends JpaRepository<Actor, Integer> {

    // 이름으로 배우 조회
    List<Actor> findByActorName(String actorName);

    // 이름에 특정 문자열이 포함된 배우 조회
    List<Actor> findByActorNameContaining(String keyword);
}


