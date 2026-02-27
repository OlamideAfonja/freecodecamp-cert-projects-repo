#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determine search type
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="atomic_number = $1"
elif [[ ${#1} -le 2 ]]
then
  QUERY="symbol = '$1'"
else
  QUERY="name = '$1'"
fi

RESULT=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, t.type,
p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $QUERY
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELT BOIL
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi