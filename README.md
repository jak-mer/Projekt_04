# **Projekt 04\_Analýza mezd a cen potravin**





1. ## **Identifikační údaje**



Datum: 16. října 2025

Zpracoval: Jakub Merta

Verze: 1.0

Název databáze se zdrojovými daty: data\_academy\_content

Typ databáze: Postgres





## **2. Úvod a cíl projektu**

Cílem tohoto projektu je odpovědět na klíčové otázky týkající se dostupnosti základních potravin pro širokou veřejnost. Primárním úkolem je vytvořit robustní datovou analýzu, která porovná ceny potravin s průměrnými příjmy za sledované období. Jako doplňkový materiál bude připravena srovnávací tabulka s údaji o HDP, GINI koeficientu a populaci pro další evropské státy, aby bylo možné zasadit výsledky pro ČR do mezinárodního kontextu. Veškeré výstupy budou připraveny jako podklad pro tiskové oddělení..





## **3. Zdrojová data**

Ze zdrojových dat byly vytvořeny dvě tabulky, kde jsou data vhodně strukturována tak, aby se daly co nejlépe využít pro výzkumné otázky.

Tabulka **t\_jakub\_merta\_project\_SQL\_primary\_final.sql,**

&nbsp;kde jsou všechna data o mzdách a cenách potravin sjednocená podle let.


Tabulka **t\_jakub\_merta\_project\_SQL\_secondary\_final.sql,**

&nbsp;kde jsou spojená data o státech a ekonomických ukazatelích po jednotlivých letech pro Českou Republiku, které se celá analýza týká.






*UPOZORNĚNÍ: Jednotky hodnot v tabulce czechia\_price jsou prohozeny. Kód typu 316, který vyjadřuje průměrný počet zaměstnaných osob z tabulky czechia\_payroll\_value\_type je spárován s kódem jednotky 80 403 který vyjadřuje měnu v Kč tabulky czechia\_payroll\_unit.*

## 

## **3. Otázky a odpovědi**



### 01

#### -- VÝZKUMNÁ OTÁZKA:

Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

#### -- STRUČNÁ ODPOVĚĎ:

Ve všech odvětvích mzdy průměrně rostou.

Růst není konstatní a jsou roky kdy mzdy klesají, ale data prokazují průměrný růst.

#### -- SQL DOTAZ A VYSVĚTLENÍ:

Vytvořil jsem součty rozdílů průměrných mezd pro každé odvětví, od roku 2006 do roku 2018 pro které mám dostupná data.

Tedy během 13 let. Součty jsou kladné, tedy ve všech odvětvích mzdy průměrně stoupají.

Nejvíce rostou mzdy v odvětví "Informační a komunikační činnosti"

Nejméně v odvětví "Administrativní a podpůrné činnosti"

V klauzuli WITH si spočítám průměrnou roční mzdu pro každé odvětví a vypočítám meziroční rozdíly těchto mezd pro každé odvětví.

V hlavní klauzuli SELECT sečtu všechny meziroční rozdíly a to mi dá celkový nárůst mzdy za celé období.

Pro vytvoření rozdílu dvou hodnot v jednom sloupci je použita funkce LEAD.



### 02

#### -- VÝZKUMNÁ OTÁZKA:

Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

#### -- ODPOVĚĎ:

Za jeden měsíční plat v roce 2006 si je možné koupit 1287 kg chleba a 1437 l mléka.

Za jeden měsíční plat v roce 2018 si je možné koupit koupit 1342 kg chleba a 1641 l mléka.

#### -- SQL DOTAZ A VYSVĚTLENÍ:

Jako srovnatelné období jsme zvolil měsíc v prvním a posledním roce měření.

V tabulce jsem profiltroval pouze hledané mléko a chléb a seřadil vzestupně podle let.

Průměrnou mzdu v daném roce jsem vydělil průměrnou měsíční mzdou dané potraviny v tom stejném roce.



### 03

#### -- VÝZKUMNÁ OTÁZKA:

Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

#### -- ODPOVĚĎ:

Cukr krystal zdražuje nejpomaleji, respektive v průměru za sledované období zlevnil.

#### -- SQL DOTAZ A VYSVĚTLENÍ:

Nejprve jsem si v pomocné tabulce spočítal průměrnou cenu každé potraviny pro každý jednotlivý rok.

Následně jsem pomocí funkce LAG porovnal cenu daného roku s cenou roku předchozího a vypočítal tak meziroční procentuální růst pro každé období.

Nakonec jsem všechny tyto jednotlivé meziroční růsty pro každou kategorii zprůměroval, čímž jsem získal průměrné roční tempo růstu.

Výsledky jsem pak seřadil od potravin s nejpomalejším růstem cen.



### 04

#### -- VÝZKUMNÁ OTÁZKA:

Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

#### -- ODPOVĚĎ:

Ne, v žádném roce není nárust cen potravin větší než nárůst mezd více než 10%.

#### -- SQL DOTAZ A VYSVĚTLENÍ:

V tomto dotazu jsem nejprve ve dvou oddělených krocích spočítal průměrnou cenu všech potravin a průměrnou mzdu pro každý jednotlivý rok.

Tyto dvě sady dat jsem následně spojil a pomocí funkce LAG vypočítal meziroční procentuální růst cen i mezd.

Nakonec jsem od procentuálního růstu cen odečetl procentuální růst mezd, abych zjistil, o kolik rychleji rostly ceny potravin v porovnání s příjmy.



### 05

#### -- OTÁZKA:

Má výška HDP vliv na změny ve mzdách a cenách potravin?

Neboli, pokud HDP vzroste výrazněji v jednom roce,

projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

#### -- ODPOVĚĎ:

Pokud budeme považovat výraznější růst HDP hodnoty nad 5%, Dělo se tak pouze v letech 2007, 2015, 2017.

Z dat vyplývá, že růst HDP minimálně koreluje s růstem mezd i růstem cen potravin v letech 2007 a 2017, kde je růst obého nad 5%.

Rok 2015 z toho vyčnívá. V něm i v roce následujím ceny potravin klesají, mzdy sice rostou ale ne tak výrázně jako v letech 2007 a 2017.

Růst HDP tedy vliv na ceny potravin a výši mezd má, ale není to pravidlem.

#### -- SQL DOTAZ A VYSVĚTLENÍ:

V tomto dotazu jsem nejprve ve dvou samostatných krocích spočítal průměrnou roční cenu potravin a průměrnou roční mzdu.

Tato data jsem následně spojil a pomocí funkce LAG jsem

pro každý rok vypočítal meziroční procentuální růst obou těchto hodnot.

K výsledné tabulce jsem pak připojil data o HDP z druhé tabulky a stejným způsobem jsem dopočítal i jeho meziroční růst.

Nakonec jsem od růstu cen odečetl růst mezd, abych zjistil, jak se vyvíjela dostupnost potravin v čase.

