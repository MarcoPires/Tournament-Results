# Tournament Results

Tournament results is an PostgreSQL database that storage players matches using swiss pairings system.
This project allows us to quickly know the pairs list for the next round.

### Version
1.0.0 - 30/06/2015

### Tech

Tournament results uses:

* PostgreSQL
* Python 2.7

### Requirements

Tournament results needs:

* PostgreSQL
* Python 2.7
* psycopg2


### Installation

```
# Go to the projecto folder
$ cd /vagrant/tournament
# Open psql prompt
$ psql
# Create the database
$ CREATE DATABASE tournament
# Use the database tournament
$ \c tournament
# Import schema
$ \i tournament.sql
```

### Sample Usage

```
# import module
from tournament import *

# Remove all the match records from the database.
deleteMatches()

# Remove all the player records from the database.
deletePlayers()

# Returns the number of players currently registered.
countPlayers()

# Adds a player to the tournament database.
registerPlayer("Fair Play")

# Records the outcome of a single match between two players.
# Args:
#   winner:  the id number of the player who won
#   loser:  the id number of the player who lost
reportMatch(idPlayer1, idPlayer2)

# Returns a list of the players and their win records, sorted by wins.
playerStandings()

# Returns a list of pairs of players for the next round of a match.
swissPairings()
```
### General use and License
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.


### Contacts
For more information feel free to contact me:
e-mail : mpires@leya.com

