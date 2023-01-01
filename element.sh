#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_SELECTION=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT_SELECTION=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol LIKE '$1' OR name LIKE '$1'")
fi
if [[ (-z $ELEMENT_SELECTION) && (-n $1) ]]
then
  echo "I could not find that element in the database."
elif [[ -n $1 ]]
then
  echo $ELEMENT_SELECTION | while ISF=" " read AN BAR NA BAR SY BAR TY BAR AM BAR MP BAR BP
  do
  echo "The element with atomic number $AN is $NA ($SY). It's a $TY, with a mass of $AM amu. $NA has a melting point of $MP celsius and a boiling point of $BP celsius."
  done
fi
