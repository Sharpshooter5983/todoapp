package com.example.todoapp.repository;

import com.example.todoapp.entity.Priority;
import com.example.todoapp.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Integer> {

    @Query("SELECT t FROM Task t WHERE t.completed = true")
    List<Task> findCompletedTasks();

    @Query("SELECT t FROM Task t WHERE t.dueDay BETWEEN :start AND :end")
    List<Task> findTasksByDueDayBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    List<Task> findByPriority(Priority priority);
}
