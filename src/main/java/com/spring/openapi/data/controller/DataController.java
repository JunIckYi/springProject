package com.spring.openapi.data.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.openapi.data.service.DataService;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(value="/data/*")
@Slf4j
public class DataController {

	@Setter(onMethod_ = @Autowired)
	private DataService dataService;
	
	@GetMapping(value = "/chungnamView")
	public String chungnamView() {
		log.info("충남 관광명소 리스트 화면");
		
		return "data/chungnamView";
	}
	

	

	
	
}
