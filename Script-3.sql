
--task1
-- Перший таск це просто створення 5-ти таблиць
create table users( --таблиця узерів
	user_id int primary key,
	user_name varchar,
	role varchar
);

create table divses ( -- таблиця дивайсів тобто пристроїв
	divase_id int primary key,
	divase_name varchar,
	ip_adress varchar
);

create table security_events( -- таблиця подій 
	event_id int primary key,
	event_type varchar,
	severity_level int
);

create table logs( -- таблиця логів
log_id int primary key,
user_id INT references users(user_id),
device_id INT references divses(divase_id),
event_id INT references security_events(event_id),
log_date TIMESTAMP

);

create table audit_results( -- таблиця результатів
audit_id int primary key,
log_id INT references logs(log_id),
risk_score INT,
recommendation TEXT
);

--task2
-- Другий блок заключається в наповненні цих таблиць

insert into users(user_id,user_name,role) values 
(1,'Anna','Manager'),
(2,'Olha','Developer'),
(3,'Ivan','Security spesialist'),
(4,'Maria','Developer'),
(5,'Oleh','Admin_hol');

insert into divses (divase_id, divase_name, ip_adress) values 
(101,'laptop1','192.167.1.10'),
(102,'laptap2','192.677.1.55'),
(103,'laptop3','11.0.1.1'),
(104,'laptop4','11.0.1.3'),
(105,'laptop5','11.0.1.2');

insert into security_events(event_id, event_type, severity_level) values 
(1,'Successful Login',1),
(2,'Failed Login Attempt',5),
(3,'Port Scanning Detected',9),
(4, 'Failed Login Attempt',5),
(5,'Successful Login',1);

insert into logs(log_id, user_id, device_id, event_id, log_date) values 
(1001, 1, 101, 1, '2026-06-17 09:00:00'),
(1002, 3, 102, 2, '2026-06-17 09:15:00'),
(1003, 2, 102, 2, '2026-06-17 09:16:00'),
(1004, NULL, 103, 3, '2026-06-17 11:30:00');

insert into audit_results (audit_id, log_id, risk_score, recommendation) values 
(2001, 1001, 1, 'No action required'),
(2002, 1002, 4, 'Monitor user activity'),
(2003, 1003, 6, 'Trigger password reset'),
(2004, 1004, 10, 'BLOCK IP IMMEDIATELY AND ISOLATE ROUTER');

--task3
-- головний код де  ми будемо писати  SELECT
-- Об'єднуємо 5 таблиць, щоб знайти інциденти з середнім та високим ризиком
select 
	u.user_name,
	d.divase_name,
	se.event_type,
	ar.risk_score
from logs l
left join users u on l.user_id = u.user_id
join divses d on l.device_id = d.divase_id
JOIN security_events se ON l.event_id = se.event_id
JOIN audit_results ar ON l.log_id = ar.log_id
WHERE ar.risk_score >= 4
ORDER BY ar.risk_score desc;


--task4
--додаткові бали, використання CTE
with high_risk as(
select 
	log_id,
	risk_score,
	recommendation
from audit_results
where risk_score > 5

)
select 
	l.log_date,
	d.ip_adress,
	hr.recommendation
from logs l
JOIN high_risk hr ON l.log_id = hr.log_id
JOIN divses d ON l.device_id = d.divase_id
limit 5;


