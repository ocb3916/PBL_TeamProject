package com.example.demo.service;

import com.example.demo.entity.Cast;
import com.example.demo.entity.Movie;
import com.example.demo.entity.Actor;
import com.example.demo.repository.CastRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CastService {

    @Autowired
    private CastRepository castRepository;

    // 모든 캐스트 조회
    public List<Cast> getAllCasts() {
        return castRepository.findAll();
    }

    // 캐스트 ID로 캐스트 조회
    public Cast getCastById(Integer id) {
        return castRepository.findById(id).orElse(null);
    }

    // 캐스트 저장 또는 업데이트
    public Cast saveCast(Cast cast) {
        return castRepository.save(cast);
    }

    // 캐스트 삭제
    public void deleteCast(Integer id) {
        castRepository.deleteById(id);
    }

    // 특정 영화에 속한 모든 캐스트 조회
    public List<Cast> getCastsByMovie(Movie movie) {
        return castRepository.findByMovie(movie);
    }

    // 특정 배우가 출연한 모든 캐스트 조회
    public List<Cast> getCastsByActor(Actor actor) {
        return castRepository.findByActor(actor);
    }

    // 특정 영화와 배우에 해당하는 캐스트 조회
    public List<Cast> getCastsByMovieAndActor(Movie movie, Actor actor) {
        return castRepository.findByMovieAndActor(movie, actor);
    }

    // 특정 배역명을 가진 캐스트 조회
    public List<Cast> getCastsByRole(String role) {
        return castRepository.findByRole(role);
    }
}
