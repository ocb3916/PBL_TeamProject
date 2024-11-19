package com.example.demo.controller;

import com.example.demo.entity.Genre;
import com.example.demo.entity.Movie;
import com.example.demo.entity.GenreList;
import com.example.demo.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/genres")
public class GenreController {

    @Autowired
    private GenreService genreService;

    // 모든 장르 조회
    @GetMapping
    public List<Genre> getAllGenres() {
        return genreService.getAllGenres();
    }

    // 장르 ID로 조회
    @GetMapping("/{id}")
    public ResponseEntity<Genre> getGenreById(@PathVariable Integer id) {
        Genre genre = genreService.getGenreById(id);
        if (genre != null) {
            return ResponseEntity.ok(genre);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // 장르 생성 또는 업데이트
    @PostMapping
    public Genre createOrUpdateGenre(@RequestBody Genre genre) {
        return genreService.saveGenre(genre);
    }

    // 장르 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGenre(@PathVariable Integer id) {
        genreService.deleteGenre(id);
        return ResponseEntity.noContent().build();
    }

    // 특정 영화에 속한 모든 장르 조회
    @GetMapping("/movie/{movieId}")
    public List<Genre> getGenresByMovie(@PathVariable Long movieId) {
        Movie movie = new Movie();
        movie.setId(movieId);
        return genreService.getGenresByMovie(movie);
    }

    // 특정 장르 목록에 속한 모든 장르 조회
    @GetMapping("/genreList/{genreListId}")
    public List<Genre> getGenresByGenreList(@PathVariable Integer genreListId) {
        GenreList genreList = new GenreList();
        genreList.setId(genreListId);
        return genreService.getGenresByGenreList(genreList);
    }

    // 특정 영화와 특정 장르 목록에 해당하는 장르 조회
    @GetMapping("/movie/{movieId}/genreList/{genreListId}")
    public List<Genre> getGenresByMovieAndGenreList(@PathVariable Long movieId, @PathVariable Integer genreListId) {
        Movie movie = new Movie();
        movie.setId(movieId);
        GenreList genreList = new GenreList();
        genreList.setId(genreListId);
        return genreService.getGenresByMovieAndGenreList(movie, genreList);
    }
}

