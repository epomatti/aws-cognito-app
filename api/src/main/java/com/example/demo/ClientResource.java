package com.example.demo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/client")
public class ClientResource {

  private static List<Client> customers = new ArrayList<>() {
    {
      add(new Client("John Doe", 50000));
      add(new Client("Jane Doe", 100_000));
      add(new Client("Anne Doe", 2_000_000));
    }
  };

  @GetMapping("/all")
  public ResponseEntity<List<Client>> get() {
    return ResponseEntity.ok(customers);
  }
}
