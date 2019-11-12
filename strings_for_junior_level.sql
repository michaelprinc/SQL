---------------------------------------------  1

SELECT 
       CASE
           WHEN CHARINDEX('/', street_nbr) = 0
           THEN NULL
           ELSE SUBSTRING(street_nbr, 1, CHARINDEX('/', street_nbr) - 1)
       END popisne,

	   CASE
           WHEN CHARINDEX('/', street_nbr) = 0
           THEN NULL
           ELSE SUBSTRING(street_nbr, CHARINDEX('/', street_nbr) + 1, LEN(street_nbr))
       END orientacni
FROM string.urady
;

---------------------------------------------  2

SELECT name, ent_id, ICO, city_txt, zip_txt,
       CASE
           WHEN street_txt = street_nbr 
           THEN city_txt + ' ' + street_nbr
           ELSE street_txt
       END street_txt

FROM string.urady
;

---------------------------------------------  3

SELECT Name, 
       Pocet_pismen
FROM
(
    SELECT Ent_Id, 
           DATALENGTH(Name) / 2 - DATALENGTH(replace(Name, 'c', '')) / 2 Pocet_pismen
    FROM String.Urady
) A
JOIN String.Urady B ON A.Ent_Id = B.Ent_Id
ORDER BY Pocet_pismen DESC;

---------------------------------------------  4

SELECT CASE
           WHEN replace(zip_txt, ' ', '') like '[0-9][0-9][0-9][0-9][0-9]'
           THEN cast(replace(zip_txt, ' ', '') as int)
           ELSE NULL
       END zip_txt
FROM string.urady;

---------------------------------------------  5

SELECT CASE
           WHEN RIGHT(name, 3) = 'ice' THEN name + ' - krásná ves'
		   ELSE name
	   END name,
	   ent_id, ICO, name, city_txt, zip_txt, street_txt, street_nbr
FROM string.urady;
