package com.example.demo.controller;

import com.example.demo.entity.StreamingSite;
import com.example.demo.entity.StreamingSiteList;
import com.example.demo.entity.Movie;
import com.example.demo.service.StreamingSiteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/streaming-sites")
public class StreamingSiteController {

    @Autowired
    private StreamingSiteService streamingSiteService;

    // 모든 스트리밍 사이트 정보 조회
    @GetMapping
    public List<StreamingSite> getAllStreamingSites() {
        return streamingSiteService.getAllStreamingSites();
    }

    // 스트리밍 사이트 정보 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<StreamingSite> getStreamingSiteById(@PathVariable Integer id) {
        StreamingSite streamingSite = streamingSiteService.getStreamingSiteById(id);
        if (streamingSite != null) {
            return ResponseEntity.ok(streamingSite);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 스트리밍 사이트 정보 생성 또는 업데이트
    @PostMapping
    public StreamingSite createOrUpdateStreamingSite(@RequestBody StreamingSite streamingSite) {
        return streamingSiteService.saveStreamingSite(streamingSite);
    }

    // 스트리밍 사이트 정보 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStreamingSite(@PathVariable Integer id) {
        streamingSiteService.deleteStreamingSite(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 스트리밍 사이트에서 제공하는 모든 영화 조회
    @GetMapping("/site/{siteId}")
    public List<StreamingSite> getStreamingSitesBySite(@PathVariable Integer siteId) {
        StreamingSiteList streamingSiteList = new StreamingSiteList();
        streamingSiteList.setId(siteId);
        return streamingSiteService.getStreamingSitesBySite(streamingSiteList);
    }

    // 특정 영화가 제공되는 모든 스트리밍 사이트 조회
    @GetMapping("/movie/{movieId}")
    public List<StreamingSite> getStreamingSitesByMovie(@PathVariable Long movieId) {
        Movie movie = new Movie();
        movie.setId(movieId);
        return streamingSiteService.getStreamingSitesByMovie(movie);
    }

    // 특정 스트리밍 사이트에서 특정 영화가 제공되는지 조회
    @GetMapping("/site/{siteId}/movie/{movieId}")
    public List<StreamingSite> getStreamingSitesBySiteAndMovie(@PathVariable Integer siteId, @PathVariable Long movieId) {
        StreamingSiteList streamingSiteList = new StreamingSiteList();
        streamingSiteList.setId(siteId);
        Movie movie = new Movie();
        movie.setId(movieId);
        return streamingSiteService.getStreamingSitesBySiteAndMovie(streamingSiteList, movie);
    }
}
