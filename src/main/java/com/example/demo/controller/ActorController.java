package com.example.demo.controller;

import com.example.demo.entity.Actor;
import com.example.demo.service.ActorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/actors")
public class ActorController {

    @Autowired
    private ActorService actorService;

    // 모든 배우 조회
    @GetMapping
    public List<Actor> getAllActors() {
        return actorService.getAllActors();
    }

    // 배우 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<Actor> getActorById(@PathVariable Integer id) {
        Actor actor = actorService.getActorById(id);
        if (actor != null) {
            return ResponseEntity.ok(actor);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 배우 생성 또는 업데이트
    @PostMapping
    public Actor createOrUpdateActor(@RequestBody Actor actor) {
        return actorService.saveActor(actor);
    }

    // 배우 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteActor(@PathVariable Integer id) {
        actorService.deleteActor(id);
        return ResponseEntity.noContent().build();
    }

    // 배우 이름으로 조회
    @GetMapping("/name/{actorName}")
    public List<Actor> getActorsByName(@PathVariable String actorName) {
        return actorService.getActorsByName(actorName);
    }

    // 이름에 특정 문자열이 포함된 배우 조회
    @GetMapping("/search/{keyword}")
    public List<Actor> getActorsByNameContaining(@PathVariable String keyword) {
        return actorService.getActorsByNameContaining(keyword);
    }
}
