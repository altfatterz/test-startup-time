package com.example.teststartuptime;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class TestStartupTimeApplication {

    public static void main(String[] args) {
        SpringApplication.run(TestStartupTimeApplication.class, args);
    }

    @GetMapping("/")
    public String greet() {
        return "Hello";
    }
}
