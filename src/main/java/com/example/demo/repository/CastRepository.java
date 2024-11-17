package com.example.demo.repository;

import com.example.demo.entity.Cast;
import com.example.demo.entity.Movie;
import com.example.demo.entity.Actor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CastRepository extends JpaRepository<Cast, Integer> {

    // 특정 영화에 속한 모든 캐스트를 조회
    List<Cast> findByMovie(Movie movie);

    // 특정 배우가 출연한 모든 캐스트를 조회
    List<Cast> findByActor(Actor actor);

    // 특정 영화와 특정 배우에 해당하는 캐스트 조회
    List<Cast> findByMovieAndActor(Movie movie, Actor actor);

    // 특정 배역명을 가진 캐스트 조회
    List<Cast> findByRole(String role);
}

