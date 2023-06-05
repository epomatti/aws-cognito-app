package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import lombok.Data;

@Configuration
@Scope(value = "singleton")
@Data
public class Config {

  @Value("${aws.cognito.googleClientId}")
  private String googleClientId;

}
