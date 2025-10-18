-- 03

WITH yearly_growth_data AS (
    WITH yearly_prices AS (
        SELECT 
            category_name, 
            payroll_year, 
            AVG(value) AS average_price
        FROM t_jakub_merta_project_sql_primary_final 
        GROUP BY category_name, payroll_year
    )
    SELECT 
        category_name,
        (
            (average_price - LAG(average_price, 1) OVER (PARTITION BY category_name ORDER BY payroll_year))
            / LAG(average_price, 1) OVER (PARTITION BY category_name ORDER BY payroll_year)
            * 100
        ) AS yearly_growth_percentage
    FROM yearly_prices
)
-- Finální agregace:
SELECT 
    category_name,
    ROUND(AVG(yearly_growth_percentage)::NUMERIC, 2) AS average_yearly_growth
FROM yearly_growth_data
GROUP BY category_name
ORDER BY average_yearly_growth ASC;