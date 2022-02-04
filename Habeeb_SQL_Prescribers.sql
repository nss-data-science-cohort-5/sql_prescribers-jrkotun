-- Habeeb Kotun Jr.
-- Nashville Software School, DS5
-- February 1, 2022
-- SQL Prescribers

-- Question 1a
SELECT npi, SUM(total_claim_count)
FROM prescription
GROUP BY npi
ORDER BY SUM(total_claim_count) DESC
LIMIT 1;
-- Answer: Prescriber with NPI 1881634483 had the highest amount of claims at 99707 claims.

-- Question 1b
SELECT p1.nppes_provider_first_name AS first_name, 
	   p1.nppes_provider_last_org_name AS last_name,
	   p1.specialty_description,
	   SUM(p2.total_claim_count)
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
GROUP BY 1, 2, 3
ORDER BY SUM(p2.total_claim_count) DESC
LIMIT 1;
-- Answer: Bruce Pendley had the highest amount of claims. His specialty description in the database is listed as Family Practice.

-- Question 2a
SELECT p1.specialty_description, 
	   SUM(p2.total_claim_count) AS total_specialty_claims
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
GROUP BY p1.specialty_description
ORDER BY total_specialty_claims DESC
LIMIT 1;
-- Answer: Family Practice is the specialty with the most total number of claims.

-- Question 2b
SELECT p1.specialty_description, 
	   SUM(p2.total_claim_count) AS total_specialty_claims
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
INNER JOIN drug AS d
ON p2.drug_name = d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY p1.specialty_description
ORDER BY total_specialty_claims DESC
LIMIT 1;
-- Answer: Nurse Practitioner is the specialty with the most total number of claims for opioids.

-- Question 2c
SELECT p1.specialty_description, 
	   COUNT(p2.total_claim_count) AS number_prescriptions
FROM prescriber AS p1
FULL JOIN prescription AS p2
ON p1.npi = p2.npi
GROUP BY p1.specialty_description
HAVING COUNT(p2.total_claim_count) = 0
-- Answer: There are 15 specialties that appear in the prescriber table that have no associated prescriptions in the prescription table.

-- Question 3a
SELECT d.generic_name,
	   SUM(p.total_drug_cost)::MONEY AS total_drug_cost
FROM prescription AS p
INNER JOIN drug AS d
ON p.drug_name = d.drug_name
GROUP BY d.generic_name
ORDER BY SUM(p.total_drug_cost) DESC
LIMIT 1;
-- Answer: Insulin is the drug with the highest total drug cost.

-- Question 3b
SELECT d.generic_name,
	   SUM(p.total_drug_cost)::MONEY AS total_drug_cost,
	   ROUND(SUM(total_drug_cost) / SUM(total_day_supply), 2) AS cost_per_day
FROM prescription AS p
INNER JOIN drug AS d
ON p.drug_name = d.drug_name
GROUP BY d.generic_name
ORDER BY 3 DESC;
-- Answer: C1 Esterase is the drug with the hightest total cost per day.

-- Question 4a
SELECT drug_name,
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
END AS drug_type
FROM drug

-- Question 4b
SELECT drug_type, SUM(total_drug_cost)::MONEY
FROM(SELECT drug_name, total_drug_cost,
	CASE 
		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		ELSE 'neither'
	END AS drug_type
	FROM drug
	FULL JOIN prescription
	USING (drug_name)) AS drug_bill
WHERE drug_type != 'neither'
GROUP BY drug_type
ORDER BY SUM(total_drug_cost) DESC;
-- Answer: More money was spent on opioids.

-- Question 5a
SELECT COUNT(DISTINCT cbsa)
FROM cbsa
WHERE cbsaname LIKE '%, TN%';
-- Answer: There are 10 distinct CBSAs in Tennessee.

-- Question 5b
SELECT cbsa, cbsaname, SUM(population) AS total_population
FROM cbsa
INNER JOIN population
USING (fipscounty)
GROUP BY cbsa, cbsaname
ORDER BY total_population DESC; 
/* 
Answer: Nashville-Davidson-Murfreesboro-Franklin, TN (CBSA 34980) has the largest combined population.
Morristown, TN (CBSA 34100) has the smallest combined population.
*/

-- Question 5c
SELECT county, state, population
FROM population
LEFT JOIN cbsa
USING (fipscounty)
LEFT JOIN fips_county
USING (fipscounty)
WHERE cbsa IS NULL
ORDER BY population DESC;
-- Answer: Sevier county in Tennessee has the largest population that is not included in a CBSA.

-- Question 6a
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;

-- Question 6b
SELECT drug_name, total_claim_count, opioid_drug_flag
FROM prescription
LEFT JOIN drug
USING (drug_name)
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;

-- Question 6c
SELECT drug_name, 
	   total_claim_count, 
	   opioid_drug_flag,
	   nppes_provider_first_name AS prescriber_first_name, 
	   nppes_provider_last_org_name AS prescriber_last_name
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING(npi)
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;

-- Question 7a
SELECT npi, 
	   drug_name
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Pain Management'
AND nppes_provider_city = 'NASHVILLE'
AND opioid_drug_flag = 'Y';

-- Question 7b
SELECT npi, drug_name, COALESCE(total_claim_count, 0) AS total_claim_count
FROM(
	SELECT npi, 
	   	   drug_name
	FROM prescriber
	CROSS JOIN drug
	WHERE specialty_description = 'Pain Management'
	AND nppes_provider_city = 'NASHVILLE'
	AND opioid_drug_flag = 'Y') AS subquery
LEFT JOIN prescription
USING (npi, drug_name)
ORDER BY npi, drug_name, total_claim_count DESC;