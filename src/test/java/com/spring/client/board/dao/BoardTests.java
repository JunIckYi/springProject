package com.spring.client.board.dao;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.spring.client.board.vo.BoardVO;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@SpringBootTest
@Slf4j
public class BoardTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardDAO boardDAO;
	
	@Test
	public void testBoardList() {
		List<BoardVO> list = boardDAO.boardList();
		log.info("boardList() 메서드 호출");
		for(BoardVO vo : list) {
			log.info(vo.toString());
			
		}
	}
	
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setB_name("김청수");
		board.setB_title("용기가 필요할 때");
		board.setB_content("도중에 포기하지 말라");
		board.setB_pwd("1234");
		
		int count = boardDAO.boardInsert(board);
		log.info("입력된 행의 수:"+ count);
		
	}
	

}