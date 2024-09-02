package com.example.todoapp;

import com.example.todoapp.entity.Priority;
import com.example.todoapp.entity.Task;
import com.example.todoapp.repository.TaskRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.LocalDateTime;

@SpringBootApplication
public class TodoappApplication {

	public static void main(String[] args) {
		SpringApplication.run(TodoappApplication.class, args);
	}

	@Bean
	public CommandLineRunner demo(TaskRepository repository) {
		return (args) -> {
			// save a few customers
//			 repository.save(new Task().setCompleted(false).setTitle("Homework").
//					setNote("Midterm").setDueDay(LocalDateTime.now()).setPriority(Priority.HIGH));
//			 repository.save(new Task().setCompleted(false).setTitle("testme").
//					setNote("check...").setDueDay(LocalDateTime.now()).setPriority(Priority.LOW));
//			 repository.save(new Task().setCompleted(false).setTitle("testme2").
//			 		setNote("check...").setDueDay(LocalDateTime.now()).setPriority(Priority.LOW));
		};
	}
}


