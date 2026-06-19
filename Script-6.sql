--task2
-- Другий блок заключається в наповненні цих таблиць
-- Він тут видозмінений після того як було вказано що ми маємо мати багато даних
-- Генерація даних в таблиці задопомогою ренддом метод який надав ШІ який кинув викладач
truncate table audit_results, logs, security_events, divses, users RESTART IDENTITY CASCADE;

insert into users (user_id, user_name, role)
select
    g,
    'user_' || g,
    (ARRAY['Developer','Manager','Security specialist','Admin_hol'])[floor(random()*4)+1]
FROM generate_series(1, 500) AS g;

-- 2. DIVSES — 500 пристроїв з валідними IP
INSERT INTO divses (divase_id, divase_name, ip_adress)
SELECT
    g,
    'laptop_' || g,
    (floor(random()*223)+1)::text || '.' ||
     floor(random()*256)::text     || '.' ||
     floor(random()*256)::text     || '.' ||
    (floor(random()*254)+1)::text
FROM generate_series(1, 500) AS g;

-- 3. SECURITY_EVENTS — 5 базових типів подій(написано мною)
insert into security_events(event_id, event_type, severity_level) values 
(1,'Successful Login',1),
(2,'Failed Login Attempt',5),
(3,'Port Scanning Detected',9),
(4, 'Failed Login Attempt',5),
(5,'Successful Login',1),
(6, 'Brute Force Attack', 8),
(7, 'SQL Injection Attempt', 10);

-- 4. LOGS — 10 000 записів за 2026 рік, ~5% user_id = NULL
INSERT INTO logs (log_id, user_id, device_id, event_id, log_date)
SELECT
    g,
    CASE WHEN random() < 0.05 THEN NULL ELSE floor(random()*500)+1 END,
    floor(random()*500)+1,
    floor(random()*5)+1,
    timestamp '2026-01-01 00:00:00'
        + random() * (timestamp '2027-01-01' - timestamp '2026-01-01')
FROM generate_series(1, 10000) AS g;

-- 5. AUDIT_RESULTS — рівно по одному на кожен лог, risk_score 1..10
INSERT INTO audit_results (audit_id, log_id, risk_score, recommendation)
SELECT
    s.log_id,
    s.log_id,
    s.risk_score,
    CASE
        WHEN s.risk_score <= 3 THEN 'Low risk. Routine monitoring is sufficient, no immediate action required.'
        WHEN s.risk_score <= 6 THEN 'Medium risk. Review related logs and verify the user/device activity.'
        WHEN s.risk_score <= 8 THEN 'High risk. Investigate immediately, reset credentials and enable MFA.'
        ELSE 'Critical risk. Isolate the device, block access and escalate to the SOC team.'
    END
FROM (
    SELECT log_id, (floor(random()*10)+1)::int AS risk_score
    FROM logs
) AS s;
