-- 02
	
SELECT 
	category_name, 
	payroll_year AS year, 
	ROUND(AVG(value)::NUMERIC, 2) AS average_price,
	ROUND(AVG(value_payroll)::NUMERIC, 2) AS average_payroll,
	ROUND((AVG(value_payroll) / AVG(value))::NUMERIC, 2) AS vysledek_deleni
FROM t_jakub_merta_project_sql_primary_final 
WHERE LOWER(category_name) LIKE '%mléko%' OR LOWER(category_name) LIKE '%chléb%'
GROUP BY payroll_year, category_name 		