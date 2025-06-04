-- Active: 1747498451290@@127.0.0.1@5432@postgres_assignment@public
-- Table Insertions
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    species_id INTEGER REFERENCES species (species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);

-- Data Insertions
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- Problem: 1
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains');



-- Problem: 2
SELECT count(DISTINCT(species_id)) as unique_species_count from sightings;



-- Problem: 3
SELECT * from sightings where location LIKE '%Pass';



-- Problem: 4
SELECT rangers.name, count(sighting_id) as total_sightings 
from rangers 
JOIN sightings 
    on rangers.ranger_id = sightings.ranger_id 
GROUP BY(rangers.name, rangers.ranger_id) 
ORDER BY(rangers.ranger_id, 'ASC')



-- Problem: 5
SELECT common_name 
from (select species.common_name, sightings.sighting_id 
    from species
    LEFT JOIN sightings
        on species.species_id = sightings.species_id
    ) 
where sighting_id IS NULL;



-- Problem: 6
SELECT common_name, sighting_time, name 
from sightings 
INNER JOIN rangers 
    on sightings.ranger_id = rangers.ranger_id 
INNER JOIN species 
    on sightings.species_id = species.species_id 
ORDER BY sighting_id DESC 
LIMIT 2;



-- Problem: 7
Update species 
set conservation_status = 'Historic' 
where (extract(year from discovery_date) < 1800)



-- Problem: 8
SELECT sighting_id, 
    CASE  
        WHEN extract(hour from sighting_time) < 12 THEN 'Morning'
        WHEN extract(hour from sighting_time) BETWEEN 12 and 17 THEN 'Afternoon'
        WHEN extract(hour from sighting_time) > 17 THEN 'Evening'
    END AS time_of_day
from sightings;



-- Problem: 9
DELETE from rangers where ranger_id NOT IN (SELECT ranger_id from sightings)