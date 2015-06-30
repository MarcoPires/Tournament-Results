-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Table for player (id, name)
CREATE TABLE Players(
	playerID serial primary key,
	name varchar(200)
);

-- Table for matches between players (id, winner, losser, date)
-- Date is not needed, but is a good way to keep track 
-- of the rounds, or when the matche was recorded.
CREATE TABLE Matches(
	matchID serial primary key,
	winnerID serial references Players (playerID),
	loserID serial references Players (playerID),
	date timestamp default current_timestamp
);

-- View to simplify access to results (id, name, wins, matches)
CREATE VIEW PlayersStatistics AS
	SELECT
		Players.playerID AS id,
		Players.name AS name,
		Wins.wonGames AS wins,
		SUM( Wins.wonGames + Defeats.lostGames ) AS matches
	FROM
		Players,
		(
			SELECT 
				Players.playerID,
				COALESCE(COUNT(Matches.loserID), 0) AS lostGames
			FROM 
				Players
				LEFT OUTER JOIN Matches ON Matches.loserID = Players.playerID 
			GROUP BY 
				Players.playerID
		) AS Defeats,
		(
			SELECT 
				Players.playerID,
				COALESCE(COUNT(Matches.winnerID), 0) AS wonGames
			FROM 
				Players
				LEFT OUTER JOIN Matches ON Matches.winnerID = Players.playerID 
			GROUP BY 
				Players.playerID
		) AS Wins
	WHERE 
		Wins.playerID = Players.playerID 
		AND
		Defeats.playerID = Players.playerID
	GROUP BY 
		Players.playerID,
		Players.name,
		Wins.wonGames,
		Defeats.lostGames
	ORDER BY
		Wins.wonGames DESC
	;

-- Add some data for testing
INSERT INTO Players (name) VALUES ('Markov Chaney'), ('Joe Malik'), ('Mao Tsu-hsi'), ('Atlanta Hope');
INSERT INTO Matches (winnerID, loserID) VALUES (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4);

-- Some output for visual validation
SELECT * FROM Players;
SELECT * FROM Matches;
SELECT * FROM PlayersStatistics;