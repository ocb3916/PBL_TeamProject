package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.entity.TVFavoriteList;
import com.example.demo.entity.User;
import com.example.demo.repository.TVFavoriteListRepository;


@Service
public class TVFavoriteListService {
    
    @Autowired
    private TVFavoriteListRepository TVFavoriteListRepository;

    // 모든 관심 목록 조회
    public List<TVFavoriteList> getAllTVFavoriteLists() {
        return TVFavoriteListRepository.findAll();
    }

    // 특정 사용자가 등록한 모든 관심 목록 조회
    public List<TVFavoriteList> getTVFavoriteListsByUser(User user) {
        return TVFavoriteListRepository.findByUser(user);
    }

    // TMDB ID로 관심 목록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    public TVFavoriteList getTVFavoriteListByTmdbId(Long tmdbId) {
        return TVFavoriteListRepository.findByTmdbId(tmdbId);
    }

    // 관심 목록 저장 또는 업데이트
    public TVFavoriteList saveTVFavoriteList(TVFavoriteList TVFavoriteList) {
        return TVFavoriteListRepository.save(TVFavoriteList);
    }

    // 관심 목록 삭제
    public void deleteTVFavoriteList(Integer id) {
        TVFavoriteListRepository.deleteById(id);
    }
}