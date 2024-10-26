package com.example.demo.service;

import com.example.demo.entity.Genre;
import com.example.demo.entity.Movie;
import com.example.demo.entity.GenreList;
import com.example.demo.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GenreService {

    @Autowired
    private GenreRepository genreRepository;

    // 모든 장르 조회
    public List<Genre> getAllGenres() {
        return genreRepository.findAll();
    }

    // 장르 ID로 장르 조회
    public Genre getGenreById(Integer id) {
        return genreRepository.findById(id).orElse(null);
    }

    // 장르 저장 또는 업데이트
    public Genre saveGenre(Genre genre) {
        return genreRepository.save(genre);
    }

    // 장르 삭제
    public void deleteGenre(Integer id) {
        genreRepository.deleteById(id);
    }

    // 특정 영화에 속한 모든 장르 조회
    public List<Genre> getGenresByMovie(Movie movie) {
        return genreRepository.findByMovie(movie);
    }

    // 특정 장르 목록에 속한 모든 영화 조회
    public List<Genre> getGenresByGenreList(GenreList genreList) {
        return genreRepository.findByGenreList(genreList);
    }

    // 특정 영화와 특정 장르 목록에 해당하는 장르 조회
    public List<Genre> getGenresByMovieAndGenreList(Movie movie, GenreList genreList) {
        return genreRepository.findByMovieAndGenreList(movie, genreList);
    }
}

