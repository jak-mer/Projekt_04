-- Vytvoř tabulku s názvem: t_{jmeno}_{prijmeni}_project_SQL_secondary_final

CREATE TABLE IF NOT EXISTS t_jakub_merta_project_SQL_secondary_final AS	
	SELECT
	    ec.country,
	    ec."year",
	    ec.gdp,
	    ec.population,
	    COUNT(*) AS pocet_duplikatu
	FROM  economies AS ec
	WHERE ec.country = 'Czech Republic' AND ec.gdp IS NOT NULL
	GROUP BY
	    ec.country,
	    ec."year",
	    ec.gdp,
	    ec.population;
