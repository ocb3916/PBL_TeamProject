package com.example.demo.controller;

import com.example.demo.entity.Cast;
import com.example.demo.entity.Movie;
import com.example.demo.entity.Actor;
import com.example.demo.service.CastService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/casts")
public class CastController {

    @Autowired
    private CastService castService;

    // 모든 캐스트 조회
    @GetMapping
    public List<Cast> getAllCasts() {
        return castService.getAllCasts();
    }

    // 캐스트 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<Cast> getCastById(@PathVariable Integer id) {
        Cast cast = castService.getCastById(id);
        if (cast != null) {
            return ResponseEntity.ok(cast);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 캐스트 생성 또는 업데이트
    @PostMapping
    public Cast createOrUpdateCast(@RequestBody Cast cast) {
        return castService.saveCast(cast);
    }

    // 캐스트 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCast(@PathVariable Integer id) {
        castService.deleteCast(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 영화에 속한 모든 캐스트 조회
    @GetMapping("/movie/{movieId}")
    public List<Cast> getCastsByMovie(@PathVariable Long movieId) {
        Movie movie = new Movie();
        movie.setId(movieId);
        return castService.getCastsByMovie(movie);
    }

    // 특정 배우가 출연한 모든 캐스트 조회
    @GetMapping("/actor/{actorId}")
    public List<Cast> getCastsByActor(@PathVariable Integer actorId) {
        Actor actor = new Actor();
        actor.setId(actorId);
        return castService.getCastsByActor(actor);
    }

    // 특정 영화와 배우에 해당하는 캐스트 조회
    @GetMapping("/movie/{movieId}/actor/{actorId}")
    public List<Cast> getCastsByMovieAndActor(@PathVariable Long movieId, @PathVariable Integer actorId) {
        Movie movie = new Movie();
        movie.setId(movieId);
        Actor actor = new Actor();
        actor.setId(actorId);
        return castService.getCastsByMovieAndActor(movie, actor);
    }

    // 특정 배역명을 가진 캐스트 조회
    @GetMapping("/role/{role}")
    public List<Cast> getCastsByRole(@PathVariable String role) {
        return castService.getCastsByRole(role);
    }

}

