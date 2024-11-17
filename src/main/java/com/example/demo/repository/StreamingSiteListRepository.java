package com.example.demo.repository;

import com.example.demo.entity.StreamingSiteList;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StreamingSiteListRepository extends JpaRepository<StreamingSiteList, Integer> {

    // 스트리밍 사이트 이름으로 조회
    List<StreamingSiteList> findByStreamingSite(String streamingSite);

    // 스트리밍 사이트 이름에 특정 문자열이 포함된 항목 조회
    List<StreamingSiteList> findByStreamingSiteContaining(String keyword);
}
