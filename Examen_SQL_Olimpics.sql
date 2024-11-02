#2.1. Muestra la cantidad de eventos que tiene cada deporte (0,5p).
SELECT s.sport_name AS 'Sport', COUNT(e.id) AS 'Qty_Events'
FROM event e
JOIN sport s
ON e.sport_id = s.id
GROUP BY Sport;

#2.2. Muestra el nombre de la ciudad y la cantidad de Juegos Olímpicos que han organizado, las ciudades que hayan organizado más de un Juegos Olímpicos (1p).
SELECT c.city_name AS 'City', COUNT(g.id) AS 'Qty_games'
FROM games g
JOIN games_city gc
ON g.id = gc.games_id
JOIN city c
ON gc.city_id = c.id
GROUP BY City
HAVING Qty_games > 1;

#2.3. Muestra el nombre de todas las deportistas (género femenino) españolas que participaron en los Juegos de Barcelona 92 y que se llaman Cristina (puedes hacer la consulta teniendo en cuenta que el id de los Juegos de Barcelona 92 es 1) (1p).

####ID JJOO Barcelona 92 = "1"####
SELECT g.id AS 'id_JJOO_Barcelona_92'
FROM games g
JOIN games_city gc
ON g.id = gc.games_id
JOIN city c
ON gc.city_id = c.id
WHERE c.city_name LIKE 'Barcelona';
################################

SELECT p.full_name AS 'Name'
FROM games_competitor gc
JOIN games g
ON gc.games_id = g.id
JOIN person p
ON gc.person_id = p.id
JOIN person_region pr
ON p.id = pr.person_id
JOIN noc_region nr
ON pr.region_id = nr.id
WHERE p.full_name LIKE '%Cristina%' AND nr.region_name LIKE 'Spain' AND p.gender LIKE 'F' AND g.id = (
																										SELECT g.id AS 'id_JJOO_Barcelona_92'
																										FROM games g
																										JOIN games_city gc
																										ON g.id = gc.games_id
																										JOIN city c
																										ON gc.city_id = c.id
																										WHERE c.city_name LIKE 'Barcelona'
                                                                                                        );

#2.4. Muestra el nombre de la persona deportista que ganó más medallas en Río de Janeiro (es preferible que no, pero puedes utilizar el hecho de que los Juegos de Río tienen el id 21) (1,5p).
#####ID JJOO Rio de Janeiro = "21"#####
SELECT g.id AS 'id_JJOO_Rio_De_Janeiro'
FROM games g
JOIN games_city gc
ON g.id = gc.games_id
JOIN city c
ON gc.city_id = c.id
WHERE c.city_name LIKE 'Rio de Janeiro';
########################################

SELECT p.full_name AS 'Athlete', COUNT(ce.medal_id) AS 'Qty_medals'
FROM games_competitor gc
JOIN games g
ON gc.games_id = g.id
JOIN person p
ON gc.person_id = p.id
JOIN competitor_event ce
ON gc.id = ce.competitor_id
JOIN medal m
ON ce.medal_id = m.id
WHERE m.id != 4 AND g.id = (
							SELECT g.id AS 'id_JJOO_Rio_De_Janeiro'
							FROM games g
							JOIN games_city gc
							ON g.id = gc.games_id
							JOIN city c
							ON gc.city_id = c.id
							WHERE c.city_name LIKE 'Rio de Janeiro'
                            )
GROUP BY Athlete
ORDER BY Qty_medals DESC
LIMIT 1;

#2.5. ¿Quién ganó más medallas de oro en atletismo masculino en los Juegos de Barcelona 92: ¿España o USA? (Es preferible que no, pero puedes utilizar el hecho de que los Juegos de Barcelona tienen el id 1 y el atletismo como deporte tiene el id 6) (1,5p).
#####ID JJOO Barcelona 92 = "1"#####
SELECT g.id AS 'id_JJOO_Barcelona_92'
FROM games g
JOIN games_city gc
ON g.id = gc.games_id
JOIN city c
ON gc.city_id = c.id
WHERE c.city_name LIKE 'Barcelona';
###################################

#########ID Athletics = "6"########
SELECT id AS 'id_Athletics'
FROM sport
WHERE sport_name LIKE 'Athletics%';
###################################

#########ID's Athletics Men's#########
SELECT id AS 'id_Athletics_Men'
FROM event
WHERE event_name LIKE 'Athletics Men%';
#######################################

SELECT nr.region_name AS 'Country', COUNT(m.id) AS 'Qty_Gold_Medals'
FROM games_competitor gc
JOIN person p
ON gc.person_id = p.id
JOIN competitor_event ce
ON gc.id = ce.competitor_id
JOIN medal m
ON ce.medal_id = m.id
JOIN games g
ON gc.games_id = g.id
JOIN event e
ON ce.event_id = e.id
JOIN sport s
ON e.sport_id = s.id
JOIN person_region pr
ON p.id = pr.person_id
JOIN noc_region nr
ON pr.region_id = nr.id
JOIN games_city gci
ON g.id = gci.games_id
JOIN city c
ON gci.city_id = c.id
WHERE m.id = 1 AND g.id = (
							SELECT g.id AS 'id_JJOO_Barcelona_92'
							FROM games g
							JOIN games_city gc
							ON g.id = gc.games_id
							JOIN city c
							ON gc.city_id = c.id
							WHERE c.city_name LIKE 'Barcelona'
                            ) 
                            AND e.id IN (
										SELECT id AS 'id_Athletics_Men'
										FROM event
										WHERE event_name LIKE 'Athletics Men%'
                                        )
										AND nr.region_name IN ('Spain','USA')
GROUP BY Country;

#2.6. Muestra el nombre de la persona deportista que tiene el mayor peso de entre todos y todas. No puedes utilizar ni ORDER BY ni LIMIT, es decir, la consulta debe ser dinámica, y si hubiera dos o más personas con el peso máximo, deberías mostrarlas todas (1p).
#RTA: Yago Ming

SELECT full_name AS 'Athlete'
FROM person
WHERE height = (
				SELECT MAX(height)
                FROM person
                );

#2.7. Muestra los nombres de los países que cumplan la siguiente condición: la altura mínima de cualquiera de sus deportistas masculinos es mayor a la altura media de todos los deportistas masculinos. No debes incluir en estos cálculos a todos aquellos deportistas de los que no tenemos su altura (2p).
###Male average height = 179.49###
SELECT AVG(height)
FROM person
WHERE gender = 'M' AND height != 0;
###################################

SELECT nr.region_name AS 'Country', MIN(p.height) AS 'Minimum_height'
FROM noc_region nr
JOIN person_region pr
ON nr.id = pr.region_id
JOIN person p
ON p.id = pr.person_id
WHERE p.gender = 'M' AND p.height != 0 AND p.height IS NOT NULL
GROUP BY Country
HAVING Minimum_height > (
						SELECT AVG(height)
						FROM person
						WHERE gender = 'M' AND height != 0 AND height IS NOT NULL
						);m