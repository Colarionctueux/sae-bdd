DROP TABLE IF EXISTS import;
DROP TABLE IF EXISTS noc_regions;

CREATE TABLE import (
    id INTEGER,
    name VARCHAR(108),
    sex CHAR(1) CHECK (sex IN ('M', 'F')),
    age INTEGER CHECK (age < 110),
    height INTEGER,
    weight DECIMAL,
    team VARCHAR(47),
    nnococ CHAR(3),
    games CHAR(11),
    year INTEGER CHECK (year < 2023),
    season CHAR(6) CHECK (season IN ('Winter', 'Summer')),
    city VARCHAR(22),
    sport VARCHAR(25),
    event VARCHAR(85),
    medal VARCHAR(6) CHECK (medal IS NULL OR medal IN ('Gold', 'Silver', 'Bronze'))
);


CREATE TABLE noc_regions (
    noc CHAR(3),
    name VARCHAR(108),
    notes varchar (27)
);

\copy import FROM 'athlete_events.csv' WITH (FORMAT CSV, HEADER true, NULL 'NA');
\copy noc_regions FROM 'vnoc_regions.csv' WITH (FORMAT CSV, HEADER true, NULL 'NA');

DELETE FROM import WHERE year < 1920;
DELETE FROM import WHERE sport = 'Art Competitions';
SELECT COUNT(*) FROM import;