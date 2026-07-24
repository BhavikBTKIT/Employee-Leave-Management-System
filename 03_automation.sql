USE employee_leave_management;

DELIMITER $$

CREATE TRIGGER trg_leave_before_insert
BEFORE INSERT ON leave_requests
FOR EACH ROW
BEGIN
    IF NEW.total_days <> DATEDIFF(NEW.end_date, NEW.start_date) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'total_days must match the inclusive leave date range';
    END IF;
END$$

CREATE TRIGGER trg_leave_after_approval
AFTER UPDATE ON leave_requests
FOR EACH ROW
BEGIN
    IF NEW.request_status = 'APPROVED' AND OLD.request_status <> 'APPROVED' THEN
        INSERT INTO attendance (employee_id, attendance_date, attendance_status)
        SELECT NEW.employee_id, DATE_ADD(NEW.start_date, INTERVAL seq.day_no DAY), 'ON_LEAVE'
        FROM (
            SELECT 0 AS day_no UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
            UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
            UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
            UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
            UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
            UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
            UNION ALL SELECT 30
        ) AS seq
        WHERE DATE_ADD(NEW.start_date, INTERVAL seq.day_no DAY) <= NEW.end_date
        ON DUPLICATE KEY UPDATE attendance_status = 'ON_LEAVE', check_in = NULL, check_out = NULL;
    END IF;
END$$

CREATE PROCEDURE sp_submit_leave(
    IN p_employee_id INT, IN p_leave_type_id INT, IN p_start_date DATE,
    IN p_end_date DATE, IN p_reason VARCHAR(500)
)
BEGIN
    INSERT INTO leave_requests (employee_id, leave_type_id, start_date, end_date, total_days, reason)
    VALUES (p_employee_id, p_leave_type_id, p_start_date, p_end_date,
            DATEDIFF(p_end_date, p_start_date) + 1, p_reason);
END$$

CREATE PROCEDURE sp_approve_leave(IN p_leave_request_id INT, IN p_approver_id INT)
BEGIN
    UPDATE leave_requests
    SET request_status = 'APPROVED', approved_by = p_approver_id, approved_at = NOW()
    WHERE leave_request_id = p_leave_request_id AND request_status = 'PENDING';
END$$

DELIMITER ;

CREATE OR REPLACE VIEW vw_employee_leave_summary AS
SELECT e.employee_id, e.employee_code, e.full_name, d.department_name,
       lt.leave_name, COALESCE(SUM(CASE WHEN lr.request_status = 'APPROVED' THEN lr.total_days ELSE 0 END), 0) AS approved_days,
       lt.annual_limit
FROM employees e
JOIN departments d ON d.department_id = e.department_id
CROSS JOIN leave_types lt
LEFT JOIN leave_requests lr ON lr.employee_id = e.employee_id AND lr.leave_type_id = lt.leave_type_id
GROUP BY e.employee_id, e.employee_code, e.full_name, d.department_name, lt.leave_name, lt.annual_limit;
