#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Empty tables
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# add winning teams to the teams table
if [[ $WINNER != 'winner' ]]
  then
# get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
if [[ -z $TEAM_ID ]]
  then
# if not found
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
    then 
      echo "Inserted into teams, $WINNER"
  fi
# get new team_id
 TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
 fi
fi

# add oppossing teams to the teams table
if [[ $OPPONENT != 'opponent' ]]
then
  # get team_id
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  if [[ -z $TEAM_ID ]]
    then
    # if not found
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
    then 
      echo "Inserted into teams, $OPPONENT"
  fi
# get new team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi
fi

# add info to games table
if [[ $YEAR != 'year' ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # insert game info
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then
        echo "Inserted new game"
    fi 
fi

done
