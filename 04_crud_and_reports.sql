USE employee_leave_management;

-- CREATE: add an employee.
INSERT INTO employees (employee_code, full_name, email, department_id, hire_date)
VALUES ('EMP006', 'Ananya Rao', 'ananya@example.com', 1, '2026-07-24');

-- READ: list active employees and their department/manager (JOIN report).
SELECT e.employee_code, e.full_name, d.department_name, m.full_name AS manager_name
FROM employees e
JOIN departments d ON d.department_id = e.department_id
LEFT JOIN employees m ON m.employee_id = e.manager_id
WHERE e.status = 'ACTIVE';

-- UPDATE: change an employee's department.
UPDATE employees SET department_id = 4 WHERE employee_code = 'EMP006';

-- DELETE: use only for test data.
DELETE FROM employees WHERE employee_code = 'EMP006';

-- Pending leave requests with employee and leave-type details.
SELECT lr.leave_request_id, e.full_name, d.department_name, lt.leave_name,
       lr.start_date, lr.end_date, lr.total_days, lr.reason
FROM leave_requests lr
JOIN employees e ON e.employee_id = lr.employee_id
JOIN departments d ON d.department_id = e.department_id
JOIN leave_types lt ON lt.leave_type_id = lr.leave_type_id
WHERE lr.request_status = 'PENDING';

-- Department attendance summary using GROUP BY and aggregate functions.
SELECT d.department_name, a.attendance_date,
       SUM(a.attendance_status = 'PRESENT') AS present_count,
       SUM(a.attendance_status = 'WFH') AS wfh_count,
       SUM(a.attendance_status = 'ABSENT') AS absent_count
FROM attendance a
JOIN employees e ON e.employee_id = a.employee_id
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name, a.attendance_date;

-- Employees whose approved leave exceeds the average approved leave usage (subquery).
SELECT e.full_name, SUM(lr.total_days) AS approved_leave_days
FROM employees e
JOIN leave_requests lr ON lr.employee_id = e.employee_id
WHERE lr.request_status = 'APPROVED'
GROUP BY e.employee_id, e.full_name
HAVING SUM(lr.total_days) > (
    SELECT AVG(employee_days)
    FROM (
        SELECT SUM(total_days) AS employee_days
        FROM leave_requests
        WHERE request_status = 'APPROVED'
        GROUP BY employee_id
    ) AS leave_totals
);

-- View report.
SELECT * FROM vw_employee_leave_summary ORDER BY full_name, leave_name;

-- Stored-procedure examples.
-- CALL sp_submit_leave(3, 1, '2026-08-10', '2026-08-11', 'Personal work');
-- CALL sp_approve_leave(2, 1);
