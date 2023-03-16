#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#SQL_TEXT="SELECT properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number FULL JOIN types ON properties.type_id = types.type_id"

OUTPUT() {
  if [[ $RESULT ]]
  then
    echo "$RESULT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done  
  fi
}

ELEMENT_NOT_FOUND() {
  echo "I could not find that element in the database."
}

if [[ $1 ]]
then
  # if arg1 is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  
    RESULT=$($PSQL "SELECT properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE elements.symbol='$1'")
      
    if [[ -z $RESULT ]]
    then
      RESULT=$($PSQL "SELECT properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE elements.name='$1'")
      if [[ -z $RESULT ]]
      then
        ELEMENT_NOT_FOUND
      else
        OUTPUT
      fi

    else
      OUTPUT
    fi
  
  else
    RESULT=$($PSQL "SELECT properties.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements ON properties.atomic_number = elements.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number=$1")
    if [[ -z $RESULT ]]
    then
      ELEMENT_NOT_FOUND
    else
      OUTPUT
    fi
  
  fi

else
  echo -e "Please provide an element as an argument."
fi

