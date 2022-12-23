#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


PRINT_ELEMENT_INFO() {
  # get element info in different variables
  ATOMIC_NUMBER=$SEARCH_RESULT
  SYMBOL=$($PSQL"SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  NAME=$($PSQL"SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL"SELECT type FROM types LEFT JOIN properties ON types.type_id = properties.type_id WHERE atomic_number = $ATOMIC_NUMBER")
  MASS=$($PSQL"SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELT_POINT=$($PSQL"SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOIL_POINT=$($PSQL"SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

  # print the desired message
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
}

if [[ -z $1 ]]; then
  echo Please provide an element as an argument.
else
  # if there's an input, look for an element with that atomic number
  SEARCH_RESULT=$($PSQL"SELECT atomic_number FROM elements WHERE atomic_number = $1")
  # if not found, look for the symbol
  if [[ -z $SEARCH_RESULT ]]; then
    SEARCH_RESULT=$($PSQL"SELECT atomic_number FROM elements WHERE symbol = '$1'")
    # if not found, try the element name
    if [[ -z $SEARCH_RESULT ]]; then
      SEARCH_RESULT=$($PSQL"SELECT atomic_number FROM elements WHERE name = '$1'")
      # if none of the above succeded, inform the user and exit
      if [[ -z $SEARCH_RESULT ]]; then
        echo I could not find that element in the database.
      else
        PRINT_ELEMENT_INFO
      fi
    else
      PRINT_ELEMENT_INFO
    fi
  else
    PRINT_ELEMENT_INFO
  fi

fi
