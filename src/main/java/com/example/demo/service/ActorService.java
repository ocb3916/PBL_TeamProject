package com.example.demo.service;

import com.example.demo.entity.Actor;
import com.example.demo.repository.ActorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActorService {

    @Autowired
    private ActorRepository actorRepository;

    // 모든 배우 조회
    public List<Actor> getAllActors() {
        return actorRepository.findAll();
    }

    // 배우 ID로 배우 조회
    public Actor getActorById(Integer id) {
        return actorRepository.findById(id).orElse(null);
    }

    // 배우 저장 또는 업데이트
    public Actor saveActor(Actor actor) {
        return actorRepository.save(actor);
    }

    // 배우 삭제
    public void deleteActor(Integer id) {
        actorRepository.deleteById(id);
    }

    // 배우 이름으로 배우 조회
    public List<Actor> getActorsByName(String actorName) {
        return actorRepository.findByActorName(actorName);
    }

    // 이름에 특정 문자열이 포함된 배우 조회
    public List<Actor> getActorsByNameContaining(String keyword) {
        return actorRepository.findByActorNameContaining(keyword);
    }
}

