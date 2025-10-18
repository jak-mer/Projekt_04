-- 01
	
-- Výpočet průměrné mzdy po odvětvích a letech:
WITH RocniPrumernaMzda AS (
    SELECT
        industry_branch_code,
        branch_name,
        payroll_year,
        AVG(value_payroll) AS avg_value_payroll
    FROM
        t_jakub_merta_project_sql_primary_final
    GROUP BY
        industry_branch_code,
        branch_name,
        payroll_year
),
-- Výpočet jednotlivých meziročních rozdílů:
MezirocniRozdily AS (
    SELECT
        industry_branch_code,
        branch_name,
        LEAD(avg_value_payroll, 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) - avg_value_payroll AS payroll_difference
    FROM
        RocniPrumernaMzda
)
-- Finální tabulka:
SELECT
    industry_branch_code,
    branch_name,
    ROUND(SUM(payroll_difference), 0) AS total_payroll_difference
FROM
    MezirocniRozdily
GROUP BY
    industry_branch_code,
    branch_name
ORDER BY
    total_payroll_difference DESC;