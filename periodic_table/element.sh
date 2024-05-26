#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
# check for argument
if [[ $1 ]]
then
# get element info, if it exists
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) RIGHT JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT_INFO=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) RIGHT JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
fi
# check if argument is a valid element
  if [[ -z $ELEMENT_INFO ]]
  then
    #if not found
    echo "I could not find that element in the database."
  else
    # read data into variables
    echo $ELEMENT_INFO | while read TYPE_ID BAR ATOM_NUM BAR ELEMENT_SYMBOL BAR ELEMENT_NAME BAR ATOM_MASS BAR MELT_POINT BAR BOIL_POINT BAR ELEMENT_TYPE
    do
      # output data with the following sentence structure 
      echo "The element with atomic number $ATOM_NUM is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOM_MASS amu. $ELEMENT_NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  fi
else
  # if no argument
  echo "Please provide an element as an argument."
fi
