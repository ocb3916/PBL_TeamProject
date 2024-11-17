package com.example.demo.service;

import com.example.demo.entity.StreamingSite;
import com.example.demo.entity.StreamingSiteList;
import com.example.demo.entity.Movie;
import com.example.demo.repository.StreamingSiteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StreamingSiteService {

    @Autowired
    private StreamingSiteRepository streamingSiteRepository;

    // 모든 스트리밍 사이트 정보 조회
    public List<StreamingSite> getAllStreamingSites() {
        return streamingSiteRepository.findAll();
    }

    // 스트리밍 사이트 정보 ID로 조회
    public StreamingSite getStreamingSiteById(Integer id) {
        return streamingSiteRepository.findById(id).orElse(null);
    }

    // 스트리밍 사이트 정보 저장 또는 업데이트
    public StreamingSite saveStreamingSite(StreamingSite streamingSite) {
        return streamingSiteRepository.save(streamingSite);
    }

    // 스트리밍 사이트 정보 삭제
    public void deleteStreamingSite(Integer id) {
        streamingSiteRepository.deleteById(id);
    }

    // 특정 스트리밍 사이트에서 제공하는 모든 영화 조회
    public List<StreamingSite> getStreamingSitesBySite(StreamingSiteList streamingSiteList) {
        return streamingSiteRepository.findByStreamingSiteList(streamingSiteList);
    }

    // 특정 영화가 제공되는 모든 스트리밍 사이트 조회
    public List<StreamingSite> getStreamingSitesByMovie(Movie movie) {
        return streamingSiteRepository.findByMovie(movie);
    }

    // 특정 스트리밍 사이트에서 특정 영화가 제공되는지 조회
    public List<StreamingSite> getStreamingSitesBySiteAndMovie(StreamingSiteList streamingSiteList, Movie movie) {
        return streamingSiteRepository.findByStreamingSiteListAndMovie(streamingSiteList, movie);
    }
}

