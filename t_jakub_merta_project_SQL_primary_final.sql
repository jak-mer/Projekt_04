-- Vytvoř tabulku s názvem: t_{jmeno}_{prijmeni}_project_SQL_primary_final

CREATE TABLE IF NOT EXISTS t_jakub_merta_project_SQL_primary_final AS	
	SELECT 
		cp.id,
		cp.value,
		cp.category_code,
		cp.region_code,
		cpc.name AS category_name,
		cpc.price_value,
		cpc.price_unit,
		cpay.id AS id_payroll,
		cpay.value AS value_payroll,
		cpay.value_type_code,
		cpay.unit_code,
		cpay.calculation_code,
		cpay.industry_branch_code,
		cpay.payroll_year,
		cpayc.name AS calculation_name,
		cpayib.name AS branch_name,
		cpayu.name AS payroll_unit,
		cpayvt.name AS type_name
	FROM czechia_price AS cp
		JOIN czechia_payroll AS cpay -- Spojení tabulek "czechia payroll" a "czechia_price"
			ON date_part('year', cp.date_from) = cpay.payroll_year
			AND cpay.value_type_code = 5958
			AND cp.region_code IS NULL
		JOIN czechia_payroll_calculation AS cpayc -- Připojení tabulky "czechia payroll calculation"
			ON cpay.calculation_code = cpayc.code 
		JOIN czechia_payroll_industry_branch AS cpayib -- Připojení tabulky "czechia_payroll_industry_branch"
			ON cpay.industry_branch_code = cpayib.code
		JOIN czechia_payroll_unit AS cpayu -- Připojení tabulky "czechia_payroll_unit"
			ON cpay.unit_code = cpayu.code
		JOIN czechia_payroll_value_type AS cpayvt -- Připojení tabulky "czechia_payroll_value_type"
			ON cpay.value_type_code = cpayvt.code
		JOIN czechia_price_category AS cpc -- Připojení tabulky "czechia_price_category"
			ON cp.category_code = cpc.code;