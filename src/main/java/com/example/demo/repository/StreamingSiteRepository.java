package com.example.demo.repository;

import com.example.demo.entity.StreamingSite;
import com.example.demo.entity.StreamingSiteList;
import com.example.demo.entity.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StreamingSiteRepository extends JpaRepository<StreamingSite, Integer> {

    // 특정 스트리밍 사이트에서 제공하는 모든 영화 조회
    List<StreamingSite> findByStreamingSiteList(StreamingSiteList streamingSiteList);

    // 특정 영화가 제공되는 모든 스트리밍 사이트 조회
    List<StreamingSite> findByMovie(Movie movie);

    // 특정 스트리밍 사이트에서 특정 영화가 제공되는지 조회
    List<StreamingSite> findByStreamingSiteListAndMovie(StreamingSiteList streamingSiteList, Movie movie);
}
