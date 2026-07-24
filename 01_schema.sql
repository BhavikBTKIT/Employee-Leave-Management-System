-- Employee Leave Management System - MySQL 8.0+
DROP DATABASE IF EXISTS employee_leave_management;
CREATE DATABASE employee_leave_management;
USE employee_leave_management;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT NULL,
    status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_employee_department FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id)
        REFERENCES employees(employee_id)
);

CREATE TABLE leave_types (
    leave_type_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_name VARCHAR(50) NOT NULL UNIQUE,
    annual_limit DECIMAL(5,1) NOT NULL,
    CONSTRAINT chk_annual_limit CHECK (annual_limit >= 0)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    attendance_status ENUM('PRESENT', 'ABSENT', 'WFH', 'ON_LEAVE') NOT NULL DEFAULT 'PRESENT',
    check_in TIME NULL,
    check_out TIME NULL,
    UNIQUE KEY uq_employee_attendance (employee_id, attendance_date),
    CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id),
    CONSTRAINT chk_check_times CHECK (check_out IS NULL OR check_in IS NULL OR check_out > check_in)
);

CREATE TABLE leave_requests (
    leave_request_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days DECIMAL(5,1) NOT NULL,
    reason VARCHAR(500) NOT NULL,
    request_status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    approved_by INT NULL,
    approved_at TIMESTAMP NULL,
    CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_leave_type FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id),
    CONSTRAINT fk_leave_approver FOREIGN KEY (approved_by) REFERENCES employees(employee_id),
    CONSTRAINT chk_leave_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_leave_total_days CHECK (total_days > 0)
);

-- Indexes for common report and lookup queries.
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_attendance_date_status ON attendance(attendance_date, attendance_status);
CREATE INDEX idx_leave_employee_status ON leave_requests(employee_id, request_status);
CREATE INDEX idx_leave_dates ON leave_requests(start_date, end_date);
