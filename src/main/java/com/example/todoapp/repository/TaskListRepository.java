package com.example.todoapp.repository;

import com.example.todoapp.entity.TaskList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import java.util.List;


public interface TaskListRepository extends JpaRepository<TaskList, Integer> {
    List<TaskList> findByListName(@Param("listName") String listName);
}

