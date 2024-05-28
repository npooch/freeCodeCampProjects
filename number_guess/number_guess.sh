#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
echo -e "\nEnter your username:"
read USERNAME

# check if the user has played before 
USER_INFO=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")
if [[ -z $USER_INFO ]]
then
  # greet the new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # insert the new user's info into the database
  INSERT_USERNAME=$($PSQL "INSERT INTO users(username, best_game) VALUES('$USERNAME', 1000)")
else
  echo $USER_INFO | while read USER_ID BAR USERNAME BAR GAMES_PLAYED BAR BEST_GAME
  do
    # greet returning user with their stats from the database
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# initialize random number and number of guesses for the game
SECRET_NUMBER=$(echo $((1 + $RANDOM % 1000)))
NUM_GUESSES=0

GAME_LOOP() {
  # check for message to determine stage of the game
  if [[ $1 ]]
  then
    echo "$1"
  else
    echo "Guess the secret number between 1 and 1000:"
  fi
  # get user input
  read USER_GUESS
  NUM_GUESSES=$((NUM_GUESSES + 1))
  # validate whether the user entered an integer
  if [[ $USER_GUESS =~ ^[0-9]+$ ]]
  then
     if [[ $USER_GUESS -lt $SECRET_NUMBER ]]
     then
      GAME_LOOP "It's higher than that, guess again:"
     elif [[ $USER_GUESS -gt $SECRET_NUMBER ]]
     then
      GAME_LOOP "It's lower than that, guess again:"
     else
      echo "You guessed it in $NUM_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      # update the database with the players new stats
      GAMES_PLAYED_UPDATE=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
      BEST_GAME_UPDATE=$($PSQL "UPDATE users SET best_game = $NUM_GUESSES WHERE username='$USERNAME' AND best_game > $NUM_GUESSES")
     fi
  else 
    GAME_LOOP "That is not an integer, guess again:"
  fi
}
# inital call of game loop function to begin the guessing game
GAME_LOOP
