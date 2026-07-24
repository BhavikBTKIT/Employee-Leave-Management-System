USE employee_leave_management;

INSERT INTO departments (department_name, location) VALUES
('Engineering', 'Bengaluru'), ('Human Resources', 'Mumbai'),
('Finance', 'Delhi'), ('Sales', 'Pune');

INSERT INTO leave_types (leave_name, annual_limit) VALUES
('Casual Leave', 12), ('Sick Leave', 10), ('Earned Leave', 18);

INSERT INTO employees (employee_code, full_name, email, department_id, hire_date) VALUES
('EMP001', 'Aarav Sharma', 'aarav@example.com', 1, '2022-04-11'),
('EMP002', 'Diya Patel', 'diya@example.com', 1, '2023-01-15'),
('EMP003', 'Kabir Singh', 'kabir@example.com', 2, '2021-08-03'),
('EMP004', 'Meera Iyer', 'meera@example.com', 3, '2020-06-22'),
('EMP005', 'Vihaan Gupta', 'vihaan@example.com', 4, '2024-02-01');

UPDATE employees SET manager_id = 1 WHERE employee_id IN (2, 3);
UPDATE employees SET manager_id = 4 WHERE employee_id = 5;

INSERT INTO attendance (employee_id, attendance_date, attendance_status, check_in, check_out) VALUES
(1, '2026-07-20', 'PRESENT', '09:05:00', '18:10:00'),
(2, '2026-07-20', 'WFH', '09:20:00', '18:00:00'),
(3, '2026-07-20', 'PRESENT', '09:10:00', '17:50:00'),
(4, '2026-07-20', 'ABSENT', NULL, NULL),
(5, '2026-07-20', 'PRESENT', '09:00:00', '18:20:00');

INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, total_days, reason, request_status, approved_by, approved_at) VALUES
(2, 1, '2026-07-27', '2026-07-28', 2, 'Family function', 'APPROVED', 1, NOW()),
(3, 2, '2026-07-22', '2026-07-22', 1, 'Medical appointment', 'PENDING', NULL, NULL),
(5, 3, '2026-08-03', '2026-08-05', 3, 'Vacation', 'REJECTED', 4, NOW());
