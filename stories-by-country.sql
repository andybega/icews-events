DESCRIBE events;
DESCRIBE stories;

# Select by country, only domestic actors (source and target country the same)
SELECT s.storyid, e.event_date, 
	   s.rawtext, l.province
FROM   simple_events e
JOIN   stories s ON s.StoryID=e.story_id
JOIN   eventtypes t USING(eventtype_id)
JOIN   locations l USING(location_id)
JOIN   countries c ON c.id = l.country_id
WHERE  e.event_date >= '2000-00-01' 
  AND  Substring(t.code, 1, 2) IN ('14')
  AND  c.countryname="CHINA"
  AND  e.source_country_id = e.target_country_id
LIMIT 2;

# Select instead by province, you can also specify multiple provinces
# This may not work well if provinces are blank
SELECT s.storyid, e.event_date, 
	   s.rawtext, l.province
FROM   simple_events e
JOIN   stories s ON s.StoryID=e.story_id
JOIN   eventtypes t USING(eventtype_id)
JOIN   locations l USING(location_id)
JOIN   countries c ON c.id = l.country_id
WHERE  e.event_date >= '2000-00-01' 
  AND  Substring(t.code, 1, 2) IN ('14')
  AND  c.countryname="CHINA"
  AND  l.province IN ('Anhui Sheng', 'Hunan Sheng')
  AND  e.source_country_id = e.target_country_id
LIMIT 2;

# Spelling is probably off, here's a list of provinces for China:
SELECT Distinct(l.province)
FROM   locations l
JOIN   countries c ON c.id = l.country_id
WHERE  c.countryname='China';

# Here we check how many events matching our filters occur in each province
# This will take a bit longer to run as it has to go through all stories.
# The trick is to group results at the bottom line.
SELECT l.province, count(*) AS count
FROM   simple_events e
JOIN   stories s ON s.StoryID=e.story_id
JOIN   eventtypes t USING(eventtype_id)
JOIN   locations l USING(location_id)
JOIN   countries c ON c.id = l.country_id
WHERE  e.event_date >= '2000-00-01' 
  AND  Substring(t.code, 1, 2) IN ('14')
  AND  c.countryname="CHINA"
  AND  e.source_country_id = e.target_country_id
GROUP BY l.province;

# You can also select by lat/long coordinates. Combine that with a country
# and we can only get events in western China, e.g.
SELECT s.storyid, e.event_date, 
	   s.rawtext, l.province
FROM   simple_events e
JOIN   stories s ON s.StoryID=e.story_id
JOIN   eventtypes t USING(eventtype_id)
JOIN   locations l USING(location_id)
JOIN   countries c ON c.id = l.country_id
WHERE  e.event_date >= '2000-00-01' 
  AND  Substring(t.code, 1, 2) IN ('14')
  AND  c.countryname="CHINA"
  AND  e.source_country_id = e.target_country_id
  AND  l.longitude <= 100
LIMIT 2;

