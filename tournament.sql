-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Table for player (id, name)
CREATE TABLE players(
	playerID serial primary key,
	name varchar(200)
);

-- Table for matches between players (id, winner, losser, date)
-- Date is not needed, but is a good way to keep track 
-- of the rounds, or when the matche was recorded.
CREATE TABLE matches(
	matchID serial primary key,
	winnerID serial references players (playerID),
	loserID serial references players (playerID),
	date timestamp default current_timestamp
);

-- View to simplify access to results (id, name, wins, matches)
CREATE VIEW players_statistics AS
	SELECT
		players.playerID AS id,
		players.name AS name,
		Wins.wonGames AS wins,
		SUM( Wins.wonGames + Defeats.lostGames ) AS matches
	FROM
		players,
		(
			SELECT 
				players.playerID,
				COALESCE(COUNT(matches.loserID), 0) AS lostGames
			FROM 
				players
				LEFT OUTER JOIN matches ON matches.loserID = players.playerID 
			GROUP BY 
				players.playerID
		) AS Defeats,
		(
			SELECT 
				players.playerID,
				COALESCE(COUNT(matches.winnerID), 0) AS wonGames
			FROM 
				players
				LEFT OUTER JOIN matches ON matches.winnerID = players.playerID 
			GROUP BY 
				players.playerID
		) AS Wins
	WHERE 
		Wins.playerID = players.playerID 
		AND
		Defeats.playerID = players.playerID
	GROUP BY 
		players.playerID,
		players.name,
		Wins.wonGames,
		Defeats.lostGames
	ORDER BY
		Wins.wonGames DESC
	;

-- Add some data for testing
INSERT INTO players (name) VALUES ('Markov Chaney'), ('Joe Malik'), ('Mao Tsu-hsi'), ('Atlanta Hope');
INSERT INTO matches (winnerID, loserID) VALUES (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4);

-- Some output for visual validation
SELECT * FROM players;
SELECT * FROM matches;
SELECT * FROM players_statistics;