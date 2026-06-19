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