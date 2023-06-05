package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

// @ComponentScan({ "io.pomatti.bookstore.store" })
@SpringBootApplication
public class DemoApplication {

	// @Autowired
	// OrderSender sender;

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
