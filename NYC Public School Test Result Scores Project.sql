--1. Inspecting the data
SELECT TOP 10 *
FROM schools;

--2. Finding schools with missing test values
SELECT
	(COUNT(school_name) - COUNT(percent_tested)) AS num_tested_missing,
	COUNT(school_name) AS num_schools
FROM schools;

--3. Number of schools by building code
SELECT COUNT(DISTINCT building_code) AS unique_num_school_buildings
FROM schools;

--4. Average math and reading scores for all schools
SELECT
	AVG(average_math) AS avg_all_math,
	AVG(average_reading) AS avg_all_reading,
	AVG(average_writing) AS avg_all_writing
FROM schools;

--5. Best schools for math (average math scores of 80% and higher, out of 800)
SELECT
	school_name,
	average_math
FROM schools
WHERE average_math >= 640
ORDER BY average_math DESC;

--6. Lowest reading score
SELECT MIN(average_reading) AS lowest_reading
FROM schools;

--7. Best writing school
SELECT TOP 1
	school_name,
	MAX(average_writing) AS max_writing
FROM schools
GROUP BY school_name
ORDER BY max_writing DESC;

--8. Top 10 schools
SELECT TOP 10
	school_name,
	(average_math + average_reading + average_writing) AS average_sat
FROM schools
ORDER BY average_sat DESC;

--9. Ranking boroughs
SELECT
	RANK() OVER(ORDER BY SUM(average_math + average_reading + average_writing)/COUNT(*) DESC) AS average_borough_sat_rank,
	borough,
	COUNT(school_name) AS num_schools,
	SUM(average_math + average_reading + average_writing)/COUNT(*) AS average_borough_sat
FROM schools
GROUP BY borough
ORDER BY average_borough_sat DESC;

--10. Top 5 math schools in Brooklyn
SELECT TOP 5
	school_name,
	average_math
FROM schools
WHERE borough = 'Brooklyn'
ORDER BY average_math DESC;

--11. Math, reading, and writing score ratios (which subject do schools have a perform preference towards? 1 : 1 : 1 Being perfectly balanced)
SELECT
	school_name,
	average_math,
	average_reading,
	average_writing,
	average_math + average_reading + average_writing AS avg_sat,
	CAST((CAST(average_math AS NUMERIC(5,2))/((average_math+average_reading+average_writing)/3))AS NUMERIC(5,2)) AS Math_Ratio,
	CAST((CAST(average_reading AS NUMERIC(5,2))/((average_math+average_reading+average_writing)/3))AS NUMERIC(5,2)) AS Reading_Ratio,
	CAST((CAST(average_writing AS NUMERIC(5,2))/((average_math+average_reading+average_writing)/3))AS NUMERIC(5,2)) AS Writing_Ratio
FROM schools
ORDER BY avg_sat DESC;