package com.example.demo.controller;

import com.example.demo.entity.StreamingSiteList;
import com.example.demo.service.StreamingSiteListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/streaming-site-lists")
public class StreamingSiteListController {

    @Autowired
    private StreamingSiteListService streamingSiteListService;

    // 모든 스트리밍 사이트 목록 조회
    @GetMapping
    public List<StreamingSiteList> getAllStreamingSiteLists() {
        return streamingSiteListService.getAllStreamingSiteLists();
    }

    // 스트리밍 사이트 목록 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<StreamingSiteList> getStreamingSiteListById(@PathVariable Integer id) {
        StreamingSiteList streamingSiteList = streamingSiteListService.getStreamingSiteListById(id);
        if (streamingSiteList != null) {
            return ResponseEntity.ok(streamingSiteList);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 스트리밍 사이트 목록 생성 또는 업데이트
    @PostMapping
    public StreamingSiteList createOrUpdateStreamingSiteList(@RequestBody StreamingSiteList streamingSiteList) {
        return streamingSiteListService.saveStreamingSiteList(streamingSiteList);
    }

    // 스트리밍 사이트 목록 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStreamingSiteList(@PathVariable Integer id) {
        streamingSiteListService.deleteStreamingSiteList(id);
        return ResponseEntity.noContent().build();
    }

    // 스트리밍 사이트 이름으로 조회
    @GetMapping("/name/{streamingSite}")
    public List<StreamingSiteList> getStreamingSiteListsByName(@PathVariable String streamingSite) {
        return streamingSiteListService.getStreamingSiteListsByName(streamingSite);
    }

    // 스트리밍 사이트 이름에 특정 문자열이 포함된 항목 조회
    @GetMapping("/search/{keyword}")
    public List<StreamingSiteList> getStreamingSiteListsByNameContaining(@PathVariable String keyword) {
        return streamingSiteListService.getStreamingSiteListsByNameContaining(keyword);
    }
}

