package com.example.demo.controller;

import com.example.demo.entity.GenreList;
import com.example.demo.service.GenreListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/genre-lists")
public class GenreListController {

    @Autowired
    private GenreListService genreListService;

    // 모든 장르 목록 조회
    @GetMapping
    public List<GenreList> getAllGenreLists() {
        return genreListService.getAllGenreLists();
    }

    // 장르 목록 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<GenreList> getGenreListById(@PathVariable Integer id) {
        GenreList genreList = genreListService.getGenreListById(id);
        if (genreList != null) {
            return ResponseEntity.ok(genreList);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 장르 목록 생성 또는 업데이트
    @PostMapping
    public GenreList createOrUpdateGenreList(@RequestBody GenreList genreList) {
        return genreListService.saveGenreList(genreList);
    }

    // 장르 목록 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGenreList(@PathVariable Integer id) {
        genreListService.deleteGenreList(id);
        return ResponseEntity.noContent().build();
    }

    // 장르 이름으로 장르 목록 조회
    @GetMapping("/name/{genre}")
    public List<GenreList> getGenreListsByName(@PathVariable String genre) {
        return genreListService.getGenreListsByGenre(genre);
    }

    // 장르 이름에 특정 문자열이 포함된 장르 목록 조회
    @GetMapping("/search/{keyword}")
    public List<GenreList> getGenreListsByNameContaining(@PathVariable String keyword) {
        return genreListService.getGenreListsByGenreContaining(keyword);
    }
}

