---------------------------------------------------------------
-- Exercice III                               
---------------------------------------------------------------

-- Question n°1 ) Combien de colonnes dans import ? (1 valeur)
SELECT COUNT(*) FROM information_schema.columns
WHERE table_name = 'import';

-- Question n°2 ) Combien de lignes dans import ? (1 valeur)
SELECT COUNT(*) FROM import;

-- Question n°3 ) Combien de codes NOC dans noc ? (1 valeur)
SELECT COUNT(DISTINCT nnococ) FROM import;

-- Question n°4 ) Combien d’athletes différents sont référencés dans ce fichier (1 valeur)
SELECT COUNT(DISTINCT id) FROM import;

-- Question n°5 ) Combien y-a t-il de médailles d’or dans ce fichier ?(1 valeur)
SELECT COUNT(*) FROM import where medal = 'Gold';

-- Question n°6 ) Retrouvez Carl Lewis; Combien de lignes se réfèrent à Carl Lewis ? (1 valeur)
SELECT COUNT(*) FROM Import where name = 'Carl Lewis %';


---------------------------------------------------------------
-- Exercice V                             
---------------------------------------------------------------

-- Question n°1) Liste des pays classés par participation aux épreuves (2 cols)
SELECT noc, count(*)
FROM jeux AS j, participe AS p
WHERE j.noj = p.noj
GROUP BY noc
ORDER BY count(*) desc;

-- Question n°2) Liste des pays classés par nombre de médailles d’or (2 cols)
SELECT noc, count(medal)
FROM jeux AS j, participe AS p
WHERE j.noj = p.noj
AND medal = 'Gold'
GROUP BY noc
ORDER BY count(medal) desc;

-- Similaire à la question N°1 mais on rajoute une condition

-- Question n°3) Liste des pays classés par nombre médailles totales (2 cols)
SELECT noc, count(medal)
FROM jeux AS j, participe AS p
WHERE j.noj = p.noj
AND medal IS NOT NULL
GROUP BY noc
ORDER BY count(medal) desc;

-- Similaire à la question N°2

-- Question n°4) Liste des sportifs ayant le plus de médailles d’or, avec le nombre (3 cols)
SELECT a.noa,name,count(medal)
FROM athlete AS a,participe AS p
WHERE a.noa = p.noa
AND medal = 'Gold'
GROUP BY a.noa
ORDER BY count(medal) DESC;

-- Ne pas oublier le ORDER BY qui range du plus petit au plus grand.


-- Question n°5) Nombre de médailles cumulées par pays pour les Jeux d’Albertville, par ordre décroissant (2 cols)
SELECT noc,COUNT(medal)
FROM jeux AS j,participe AS p
WHERE j.noj=p.noj
AND medal IS NOT NULL
AND j.city='Albertville'
GROUP BY noc
ORDER BY COUNT(medal) DESC;

-- Question n°6) Combien de sportifs ont fait les jeux olympiques sous 2 drapeaux différents, le dernier étant la France ? (1 valeur) Selon vous quel est le plus connu/célèbre/titré/... ?
SELECT COUNT(DISTINCT a.name)
FROM athlete AS a, participe AS p1, participe AS p2, jeux AS j1, jeux AS j2 
WHERE a.noa = p1.noa
AND j1.noj = p1.noj
AND j2.noj = p2.noj
AND p1.noa = p2.noa
AND j1.year < j2.year
AND j2.noc='FRA'
AND j1.noc <> 'FRA';

-- On peut aussi trouver l'athlète le plus célèbre avec cette requête:
SELECT a.name,COUNT(p2.medal)
FROM athlete AS a, participe AS p1, participe AS p2, jeux AS j1, jeux AS j2 
WHERE a.noa = p1.noa
AND j1.noj = p1.noj
AND j2.noj = p2.noj
AND p1.noa = p2.noa
AND j1.year < j2.year
AND j2.noc='FRA'
AND j1.noc <> 'FRA'
GROUP BY a.name
ORDER BY COUNT(p2.medal) DESC;
-- Cela nous donne l'athlète avec le plus de médailles en étant dans l'équipe de France (soit Angelo Parisi)

-- Question n°7) Combien de sportifs ont fait les jeux olympiques sous 2 drapeaux différents, le premier étant la France ? (1 valeur) Selon vous quel est le plus connu/célèbre/titré/... ?
SELECT COUNT(DISTINCT a.name)
FROM athlete AS a, participe AS p1, participe AS p2, jeux AS j1, jeux AS j2 
WHERE a.noa = p1.noa
AND j1.noj = p1.noj
AND j2.noj = p2.noj
AND p1.noa = p2.noa
AND j1.year < j2.year
AND j1.noc='FRA'
AND j2.noc <> 'FRA';

-- Pour connaître le plus connu sous l'équipe de France:
SELECT a.name,COUNT(p1.medal)
FROM athlete AS a, participe AS p1, participe AS p2, jeux AS j1, jeux AS j2 
WHERE a.noa = p1.noa
AND j1.noj = p1.noj
AND j2.noj = p2.noj
AND p1.noa = p2.noa
AND j1.year < j2.year
AND j1.noc='FRA'
AND j2.noc <> 'FRA'
GROUP BY a.name
ORDER BY COUNT(p1.medal) DESC;

-- Nous trouvons Philippe Boccora avec 2 médailles et Julien Bahain avec 1 seule, 
-- Le plus connu est bien evidemment Philippe Boccora car il a le meme prenom que le meilleur professeur de BDD au monde.
-- Bien que Julien Bahain ayant participé en dernier est malheureusement surement plus connu... 



-- Question n°8) Distribution des âges des médaillés d’or (2 cols)
SELECT age, count(*)
FROM participe AS p, jeux AS j
WHERE j.noj=p.noj
AND medal = 'Gold'
GROUP BY age;


-- Question n°9) Distribution des disciplines donnant des médailles aux plus de 50 ans par ordre décroissant (2 cols)
SELECT sport, COUNT(*)
FROM participe AS p,jeux AS j
WHERE j.noj = p.noj
AND p.age >= 50
AND medal IS NOT NULL
GROUP BY sport
ORDER BY COUNT(*) DESC;

-- Ne pas oublier le medal IS NOT NULL sinon le COUNT(*) aura une valeur trop elevée.

-- Question n°10) Nombre d’épreuves par type de jeux (hivers,été), par année croissante (3 cols)
SELECT COUNT(DISTINCT event),season,year
FROM jeux
GROUP BY season,year
ORDER BY year ASC;

-- Bien penser au DISTINCT dans le COUNT, sinon cela affichera le nombre de fois que 1 athlète a réalisé 1 epreuve.

-- Question n°11) Nombre de médailles féminines aux jeux d’été par année croissante (2 cols)
SELECT COUNT(medal), year
FROM athlete AS a, participe AS p, jeux AS j
WHERE a.noa=p.noa
AND p.noj=j.noj
AND sex='F'
AND season='Summer'
GROUP BY year
ORDER BY year ASC;

-- Ajouter la table participe pour pouvoir faire la liaison entre athlete et jeux.

---------------------------------------------------------------
-- Exercice VI                             
---------------------------------------------------------------

-- Nous avons choisis la Chine comme pays et le Tir à l'Arc comme sport.
-- 1) Nombre de médailles gagnées par année croissantes (2 colonnes):

SELECT COUNT(medal),year
FROM participe AS p, jeux AS j
WHERE p.noj = j.noj
AND sport = 'Archery'
AND noc = 'CHN'
GROUP BY year
ORDER BY year ASC;

-- 2) Les femmes ayant participée à ce sport ainsi que les médailles gagnées :

SELECT COUNT(medal),name
FROM participe AS p, jeux AS j, athlete AS a
WHERE p.noj = j.noj
AND a.noa = p.noa
AND sport = 'Archery'
AND sex='F'
AND noc = 'CHN'
GROUP BY name;

-- 3) Tou(te)s les participant(e)s chinoi(se)s aux différentes épreuves de tir à l'arc des JO 2008 ainsi que la médaille qu'ils ont reçus :

SELECT name,event,medal
FROM athlete AS a, jeux AS j, participe AS p
WHERE a.noa=p.noa
AND j.noj = p.noj
AND year = 2008
AND noc='CHN'
AND sport = 'Archery';

-- 4) Les attributs physiques moyen des hommes et des femmes dans ce sport ainsi que les medailles qu'ils ont gagné(e)s:

SELECT sex,AVG(height) AS "Average height",AVG(weight) AS "Average weight",COUNT(medal)
FROM athlete AS a, jeux AS j, participe AS p
WHERE a.noa=p.noa
AND j.noj = p.noj
AND noc='CHN'
AND sport = 'Archery'
GROUP BY sex;