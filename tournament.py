#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect(databaseName="tournament"):
    """Connect to the PostgreSQL database.  Returns a database connection and cursor."""
    try:
    	conn = psycopg2.connect("dbname={}".format(databaseName))
    	cur = conn.cursor()

    	return conn, cur
    except:
    	print("Error: Connection failed")


def closeConnection(conn, cur):
    """Close connection with the database"""
    
    cur.close()
    conn.close()


def deleteMatches():
    """Remove all the match records from the database."""
    
    conn, cur = connect()
    cur.execute("DELETE FROM matches;")
    conn.commit()
    closeConnection(conn, cur)


def deletePlayers():
    """Remove all the player records from the database."""

    conn, cur = connect()
    cur.execute("DELETE FROM players;")
    conn.commit()
    closeConnection(conn, cur)


def countPlayers():
    """Returns the number of players currently registered."""

    conn, cur = connect()
    cur.execute("SELECT COUNT(playerID) FROM players;")
    numberPlayers = cur.fetchone()[0]
    closeConnection(conn, cur)

    return numberPlayers


def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """

    conn, cur = connect()
    cur.execute("INSERT INTO players (name) VALUES (%s)", (name,))
    conn.commit()
    closeConnection(conn, cur)


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """

    conn, cur = connect()
    cur.execute("SELECT * FROM players_statistics;")
    playerStats = cur.fetchall()
    closeConnection(conn, cur)

    return playerStats


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """

    conn, cur = connect()
    cur.execute("INSERT INTO matches (winnerID, loserID) VALUES (%s,%s)", (winner, loser,))
    conn.commit()
    closeConnection(conn, cur)

 
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    # Get a list of player sorted by wins
    standings = playerStandings()
    # Get the list size
    length = len(standings)
    # Keeps the current player id
    player = 0
    # Keeps the current pair id 
    pair = 0
    # Index for the player id in the standings tuple 
    getId = 0
    # Index for the player name in the standings tuple
    getName = 1
    # Keep a list of pairs
    pairings = []

    # Run the standings list by twos (matching pairs)
    if length % 2 == 0 and length > 2:
        for i in xrange(0, length, 2):
            # Get current player
            player = i
            # Get current player pair
            pair = i+1
            # Save the pairs, with id and name (pair1Id, pair1Name, pair2Id, pair2Name)
            pairings.append( 
                    [ 
                        standings[player][getId], standings[player][getName], 
                        standings[pair][getId], standings[pair][getName] 
                    ] 
                )

    return pairings