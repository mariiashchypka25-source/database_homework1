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