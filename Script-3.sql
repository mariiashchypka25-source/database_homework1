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


