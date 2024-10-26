package com.example.demo.service;

import com.example.demo.entity.GenreList;
import com.example.demo.repository.GenreListRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GenreListService {

    @Autowired
    private GenreListRepository genreListRepository;

    // 모든 장르 목록 조회
    public List<GenreList> getAllGenreLists() {
        return genreListRepository.findAll();
    }

    // 장르 목록 ID로 조회
    public GenreList getGenreListById(Integer id) {
        return genreListRepository.findById(id).orElse(null);
    }

    // 장르 목록 저장 또는 업데이트
    public GenreList saveGenreList(GenreList genreList) {
        return genreListRepository.save(genreList);
    }

    // 장르 목록 삭제
    public void deleteGenreList(Integer id) {
        genreListRepository.deleteById(id);
    }

    // 장르 이름으로 장르 목록 조회
    public List<GenreList> getGenreListsByGenre(String genre) {
        return genreListRepository.findByGenre(genre);
    }

    // 장르 이름에 특정 문자열이 포함된 장르 목록 조회
    public List<GenreList> getGenreListsByGenreContaining(String keyword) {
        return genreListRepository.findByGenreContaining(keyword);
    }
}

