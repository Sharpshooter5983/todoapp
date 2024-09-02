package com.example.todoapp.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
public class Task implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer tId;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String note;

    private LocalDateTime dueDay;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Priority priority;

    @Column(nullable = false)
    private Boolean completed = false;

    @ManyToOne
    @JoinColumn(name = "list_id")
    @JsonBackReference

    private TaskList taskList;

    // Getters and Setters

    public Integer getTId() {
        return tId;
    }

    public Task setTId(Integer tId) {
        this.tId = tId;
        return this;
    }

    public String getTitle() {
        return title;
    }

    public Task setTitle(String title) {
        this.title = title;
        return this;
    }

    public String getNote() {
        return note;
    }

    public Task setNote(String note) {
        this.note = note;
        return this;
    }

    public LocalDateTime getDueDay() {
        return dueDay;
    }

    public Task setDueDay(LocalDateTime dueDay) {
        this.dueDay = dueDay;
        return this;
    }

    public Priority getPriority() {
        return priority;
    }

    public Task setPriority(Priority priority) {
        this.priority = priority;
        return this;
    }

    public Boolean getCompleted() {
        return completed;
    }

    public Task setCompleted(Boolean completed) {
        this.completed = completed;
        return this;
    }

    public TaskList getTaskList() {
        return taskList;
    }

    public Task setTaskList(TaskList taskList) {
        this.taskList = taskList;
        return this;
    }
}
