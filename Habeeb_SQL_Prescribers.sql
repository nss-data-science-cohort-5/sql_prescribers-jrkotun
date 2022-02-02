-- Habeeb Kotun Jr.
-- Nashville Software School, DS5
-- February 1, 2022
-- SQL Prescribers

-- Question 1a
SELECT p1.npi, p2.total_claim_count
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
ORDER BY p2.total_claim_count DESC
LIMIT 1;
-- Answer: Prescriber with NPI 1912011792 had the highest amount of claims at 4538 claims.

-- Question 1b
SELECT p1.nppes_provider_first_name AS first_name, 
	   p1.nppes_provider_last_org_name AS last_name,
	   p1.specialty_description,
	   p2.total_claim_count
FROM prescriber AS p1
INNER JOIN prescription AS p2
ON p1.npi = p2.npi
ORDER BY p2.total_claim_count DESC
LIMIT 1;
-- Answer: David Coffey had the highest amount of claims. His specialty description in the database is listed as Family Practice.

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

-- Question 3a
SELECT d.generic_name,
	   p.total_drug_cost
FROM prescription AS p
INNER JOIN drug AS d
ON p.drug_name = d.drug_name
ORDER BY p.total_drug_cost DESC;
-- Answer: Pirfenidone is the drug with the highest total drug cost.

-- Question 3b

-- Answer: