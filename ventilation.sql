DROP TABLE IF EXISTS participe;
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS jeux;
DROP TABLE IF EXISTS pays;

CREATE TABLE pays (
    noc CHAR(3),
    region VARCHAR(32),
    notes VARCHAR(27),
    CONSTRAINT pk_pays PRIMARY KEY (noc)
);

CREATE TABLE jeux (
    noj SERIAL,
    season CHAR(6),
    year INTEGER,
    city VARCHAR(22),
    sport VARCHAR(25),
    event VARCHAR(85),
    noc CHAR(3),
    CONSTRAINT pk_jeux PRIMARY KEY (noj),
    CONSTRAINT fk_pays FOREIGN KEY (noc) REFERENCES pays(noc)
);

CREATE TABLE athlete (
    noa INTEGER,
    name VARCHAR(108),
    sex CHAR(1) CHECK (sex IN ('M', 'F')),
    height INTEGER,
    weight DECIMAL,
    CONSTRAINT pk_athlete PRIMARY KEY (noa)
);

CREATE TABLE participe (
    noa INTEGER,
    noj INTEGER,
    age INTEGER CHECK (age < 110),
    team VARCHAR(47),
    medal VARCHAR(6) CHECK (medal IS NULL OR medal IN ('Gold', 'Silver', 'Bronze')),
    CONSTRAINT pk_participe PRIMARY KEY (noa,noj),
    CONSTRAINT fk_athlete FOREIGN KEY (noa) REFERENCES athlete(noa),
    CONSTRAINT fk_jeux FOREIGN KEY (noj) REFERENCES jeux(noj)
);

INSERT INTO pays 
SELECT * 
FROM noc_regions;

INSERT INTO jeux(season,year,city,sport,event,noc)
SELECT DISTINCT season,year,city,sport,event,nnococ
FROM import;

INSERT INTO athlete(noa,name,sex,height,weight)
SELECT DISTINCT id,name,sex,height,weight
FROM import;

INSERT INTO participe
SELECT ae.ID, j.noj, ae.age, ae.team, ae.medal
FROM import AS ae, jeux AS j
WHERE ae.season = j.season
AND ae.year = j.year
AND ae.city = j.city
AND ae.sport = j.sport
AND ae.nnococ = j.noc
AND ae.event = j.event;