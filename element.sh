#!/bin/bash
#echo -e "\n~~~~~ Periodic Table ~~~~"

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SELECT_STRING="atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
JOIN_TABLES="elements JOIN properties USING (atomic_number) JOIN types USING (type_id)"

# if the argument is empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

# checking if the argument is the atomic number
elif [[ $1 =~ ^[0-9]+$ ]]
then
  # making the query by atomic number
  QUERY_RESULT=$($PSQL "SELECT $SELECT_STRING FROM $JOIN_TABLES WHERE atomic_number=$1")
else
  # checking if the argument is the symbol
  if [[ $1 =~ ^[A-Z]{1}[a-z]{0,1}$ ]]
  then
    # making the query by symbol
    QUERY_RESULT=$($PSQL "SELECT $SELECT_STRING FROM $JOIN_TABLES WHERE symbol='$1'")
  else
    # making the query by name
    QUERY_RESULT=$($PSQL "SELECT $SELECT_STRING FROM $JOIN_TABLES WHERE name='$1'")
  fi
fi

# the query must be processing only when and argument is given
if [[ -n $1 ]]
then
  # if the query is empty
  if [[ -z $QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else  
    # getting the info from the query result
    echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi