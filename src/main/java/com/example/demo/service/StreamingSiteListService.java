package com.example.demo.service;

import com.example.demo.entity.StreamingSiteList;
import com.example.demo.repository.StreamingSiteListRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StreamingSiteListService {

    @Autowired
    private StreamingSiteListRepository streamingSiteListRepository;

    // 모든 스트리밍 사이트 목록 조회
    public List<StreamingSiteList> getAllStreamingSiteLists() {
        return streamingSiteListRepository.findAll();
    }

    // 스트리밍 사이트 목록 ID로 조회
    public StreamingSiteList getStreamingSiteListById(Integer id) {
        return streamingSiteListRepository.findById(id).orElse(null);
    }

    // 스트리밍 사이트 목록 저장 또는 업데이트
    public StreamingSiteList saveStreamingSiteList(StreamingSiteList streamingSiteList) {
        return streamingSiteListRepository.save(streamingSiteList);
    }

    // 스트리밍 사이트 목록 삭제
    public void deleteStreamingSiteList(Integer id) {
        streamingSiteListRepository.deleteById(id);
    }

    // 스트리밍 사이트 이름으로 조회
    public List<StreamingSiteList> getStreamingSiteListsByName(String streamingSite) {
        return streamingSiteListRepository.findByStreamingSite(streamingSite);
    }

    // 스트리밍 사이트 이름에 특정 문자열이 포함된 항목 조회
    public List<StreamingSiteList> getStreamingSiteListsByNameContaining(String keyword) {
        return streamingSiteListRepository.findByStreamingSiteContaining(keyword);
    }
}
