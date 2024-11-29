package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.MovieFavoriteListDto;
import com.example.demo.entity.MovieFavoriteList;
import com.example.demo.entity.User;
import com.example.demo.repository.MovieFavoriteListRepository;
import com.example.demo.repository.UserRepository;


@Service
public class MovieFavoriteListService {

    @Autowired
    private UserRepository UserRepository;
    
    @Autowired
    private MovieFavoriteListRepository MovieFavoriteListRepository;

    // 모든 관심 목록 조회
    public List<MovieFavoriteList> getAllMovieFavoriteLists() {
        return MovieFavoriteListRepository.findAll();
    }

    // 특정 사용자가 등록한 모든 관심 목록 조회
    public List<MovieFavoriteList> getMovieFavoriteListsByUser(User user) {
        return MovieFavoriteListRepository.findByUser(user);
    }

    // TMDB ID로 관심 목록 조회(나중에 TMDB아이디로 영화이름 알아내서 영화이름으로 검색가능하게)
    public MovieFavoriteList getMovieFavoriteListByTmdbId(Long tmdbId) {
        return MovieFavoriteListRepository.findByTmdbId(tmdbId);
    }

    // 관심 목록 저장 또는 업데이트
    public MovieFavoriteList saveMovieFavoriteList(MovieFavoriteListDto dto) {
         // userId를 통해 User 객체 조회
        User user = UserRepository.findById(dto.getUserId())
            .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + dto.getUserId()));

        // MovieFavoriteList 객체 생성 후 저장
        MovieFavoriteList newEntry = new MovieFavoriteList(user, dto.getTmdbId());
        return MovieFavoriteListRepository.save(newEntry);
    }

    // 관심 목록 삭제
    public void deleteMovieFavoriteList(Integer id) {
        MovieFavoriteListRepository.deleteById(id);
    }
}
