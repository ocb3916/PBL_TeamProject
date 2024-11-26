package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.entity.TVFavoriteList;
import com.example.demo.entity.User;
import com.example.demo.service.TVFavoriteListService;

@RestController
@RequestMapping("/api/TV-favorite-lists")
public class TVFavoriteListController {
    
    @Autowired
    private TVFavoriteListService TVFavoriteListService;

    // 모든 관심 목록 조회
    @GetMapping
    public List<TVFavoriteList> getAllTVFavoriteLists() {
        return TVFavoriteListService.getAllTVFavoriteLists();
    }

    // 특정 사용자가 등록한 모든 관심 목록 조회
    @GetMapping("/user/{userId}")
    public List<TVFavoriteList> getTVFavoriteListsByUser(@PathVariable String userId) {
        User user = new User();
        user.setId(userId);
        return TVFavoriteListService.getTVFavoriteListsByUser(user);
    }

    // TMDB ID로 관심 목록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    @GetMapping("/{TMDB_ID}")
    public TVFavoriteList getTVFavoriteListsByTmdbId(@PathVariable Long tmdbId) {
        return TVFavoriteListService.getTVFavoriteListByTmdbId(tmdbId);
    }

    // 관심 목록 생성 또는 업데이트
    @PostMapping
    public TVFavoriteList createOrUpdateTVFavoriteList(@RequestBody TVFavoriteList TVFavoriteList) {
        return TVFavoriteListService.saveTVFavoriteList(TVFavoriteList);
    }

    // 관심 목록 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTVFavoriteList(@PathVariable Integer id) {
        TVFavoriteListService.deleteTVFavoriteList(id);
        return ResponseEntity.noContent().build();
    }
}
