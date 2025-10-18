-- 05

WITH yearly_average_prices AS (
    -- 1. CTE: Spočítá průměrnou cenu všech potravin
    SELECT 
        payroll_year, 
        AVG(value) AS average_price
    FROM t_jakub_merta_project_sql_primary_final 
    WHERE category_code IS NOT NULL
    GROUP BY payroll_year
),
yearly_average_payrolls AS (
    -- 2. CTE: Spočítá průměrnou mzdu
    SELECT
        payroll_year,
        AVG(value_payroll) AS average_payroll
    FROM t_jakub_merta_project_sql_primary_final
    GROUP BY payroll_year
),
yearly_growth AS (
    -- 3. CTE: Spočítá meziroční růsty a spojí předchozí tabulky
    SELECT 
        yap.payroll_year AS year, 
        -- Sloupce pro ceny potravin
        ROUND(yap.average_price::NUMERIC, 2) AS average_price_all_categories,
        ROUND(
            (
                (yap.average_price - LAG(yap.average_price, 1) OVER (ORDER BY yap.payroll_year)) 
                / LAG(yap.average_price, 1) OVER (ORDER BY yap.payroll_year) * 100
            )::NUMERIC, 
            2
        ) AS yearly_price_growth_percent,
        -- Sloupce pro mzdy
        ROUND(yapp.average_payroll::NUMERIC, 2) AS average_payroll,
        ROUND(
            (
                (yapp.average_payroll - LAG(yapp.average_payroll, 1) OVER (ORDER BY yapp.payroll_year)) 
                / LAG(yapp.average_payroll, 1) OVER (ORDER BY yapp.payroll_year) * 100
            )::NUMERIC, 
            2
        ) AS yearly_payroll_growth_percent
    FROM yearly_average_prices AS yap
    LEFT JOIN yearly_average_payrolls AS yapp
        ON yap.payroll_year = yapp.payroll_year
)
-- 4. Finální SELECT: Zobrazí všechny sloupce a připojí HDP
SELECT
    yg.year,
    yg.average_price_all_categories,
    yg.yearly_price_growth_percent,
    yg.average_payroll,
    yg.yearly_payroll_growth_percent,
    (yg.yearly_price_growth_percent - yg.yearly_payroll_growth_percent) AS growth_difference_percentage,
    sec.GDP,
    ROUND(
        (
            (sec.GDP - LAG(sec.GDP, 1) OVER (ORDER BY yg.year)) 
            / LAG(sec.GDP, 1) OVER (ORDER BY yg.year) * 100
        )::NUMERIC, 
        2
    ) AS yearly_gdp_growth_percent
FROM yearly_growth AS yg
LEFT JOIN t_jakub_merta_project_sql_secondary_final AS sec
    ON yg.year = sec.year
WHERE yg.year BETWEEN 2006 AND 2018
ORDER BY yg.year;