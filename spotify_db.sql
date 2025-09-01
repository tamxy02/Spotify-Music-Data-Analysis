-- SQL Project Spotify --
SELECT * FROM spotify; 

SELECT COUNT(*) FROM spotify;

-- Select only artist column
SELECT COUNT (DISTINCT artist) FROM spotify; 

-- Select only album_type column
SELECT DISTINCT album_type FROM spotify; 

-- Select the maximum of song duration
SELECT MAX(duration_min) FROM spotify;

-- Select the minimum of song duration
SELECT MIN (duration_min) FROM spotify; 

-- Select the song duration that has 0 minute
SELECT * FROM spotify
WHERE duration_min=0; 

-- Delete the song that has 0 minute duration
DELETE FROM spotify
WHERE duration_min=0; 
SELECT * FROM spotify
WHERE duration_min=0; 

-- Select channel column
SELECT DISTINCT channel FROM spotify; 

-- Select most_played_on column 
SELECT DISTINCT most_played_on FROM spotify; 

------------------------------------------------------------
-- Data Analysis --
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
-- 2. List all albums along with their respective artists.
-- 3. Get the total number of comments for tracks where licensed = TRUE.
-- 4. Find all tracks that belong to the album type single.
-- 5. Count the total number of tracks by each artist.

-- Question 1 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT DISTINCT stream, track FROM spotify
WHERE stream > 1000000000; 

-- Question 2 List all albums along with their respective artists.
SELECT 
	DISTINCT artist, album 
FROM spotify
ORDER BY 1

-- Question 3 Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM (comments) as total_comments
FROM spotif
WHERE licensed = 'TRUE'; 

-- Question 4 Find all tracks that belong to the album type single.
SELECT * FROM spotify

SELECT *
FROM spotify
WHERE album_type = 'single';

-- Question 5 Count the total number of tracks by each artist.

SELECT artist, COUNT(track) as total_songs
FROM spotify
GROUP BY artist
ORDER BY total_songs DESC; 

------------------------------------------------------------
-- Data Analysis --
-- 1. Calculate the average danceability of tracks in each album.
-- 2. Find the top 5 tracks with the highest energy values.
-- 3. List all tracks along with their views and likes where official_video = TRUE.
-- 4. For each album, calculate the total views of all associated tracks.
-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * 
FROM spotify; 

-- Question 1 Calculate the average danceability of tracks in each album.

SELECT album, AVG(danceability) as avg_danceability
FROM spotify
GROUP BY album;

-- Question 2 Find the top 5 tracks with the highest energy values.
SELECT DISTINCT (energy), track
FROM spotify
ORDER BY energy DESC
LIMIT 5; 

-- Question 3 List all tracks along with their views and likes where official_video = TRUE.
SELECT track, likes, views
FROM spotify
WHERE official_video ='TRUE';

-- Question 4 For each album, calculate the total views of all associated tracks.
SELECT album, track, SUM(views) as total_views
FROM spotify
GROUP BY album, track; 

--Question 5 Retrieve the track names that have been streamed on Spotify more than YouTube.



SELECT * FROM
(SELECT 
	track,  
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as stream_on_youtube, 
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as stream_on_spotify
FROM spotify
GROUP BY track
) as t1
WHERE 
	stream_on_spotify > stream_on_youtube
	AND 
	stream_on_youtube <> 0

------------------------------------------------------------
-- Data Analysis -- 
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
-- 2. Write a query to find tracks where the liveness score is above the average.
-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
-- 4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
-- 5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT * FROM spotify

--Question 1 Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist 
AS
(SELECT 
	artist, 
	track, 
	SUM(views) as total_view, 
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views)DESC) as rank
FROM spotify
GROUP BY artist, track
ORDER BY artist, total_view DESC
)
SELECT * FROM ranking_artist
WHERE rank <=3

-- Question 2 Write a query to find tracks where the liveness score is above the average.
-- average of liveness

SELECT 
	track, 
	liveness
FROM spotify
WHERE liveness > (SELECT AVG (liveness) FROM spotify)

-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
	album, 
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
FROM spotify
GROUP BY album
)
SELECT 
	album, 
	highest_energy - lowest_energy as energy_diff
FROM cte

SELECT 
  album, 
  MAX(energy) - MIN(energy) as energy_diff
FROM spotify
GROUP BY album