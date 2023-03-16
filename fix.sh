#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# 1.You should rename the weight column to atomic_mass
TASK_1() {
  RESULT_1=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass")
  echo "Task_1 $RESULT_1"
}

# 2.You should rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
TASK_2() {
  RESULT_2a=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius")
  echo "Task_2a $RESULT_2a"

  RESULT_2b=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius")
  echo "Task_2b $RESULT_2b"
}

# 3.Your melting_point_celsius and boiling_point_celsius columns should not accept null values
TASK_3() {
  RESULT_3a=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL")
  echo "Task_3a $RESULT_3a"

  RESULT_3b=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL")
  echo "Task_3b $RESULT_3b"
}

# 4.You should add the UNIQUE constraint to the symbol and name columns from the elements table
TASK_4() {
  RESULT_4a=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol)")
  echo "Task_4a $RESULT_4a"

  RESULT_4b=$($PSQL "ALTER TABLE elements ADD UNIQUE(name)")
  echo "Task_4b $RESULT_4b"
}

# 5.Your symbol and name columns should have the NOT NULL constraint
TASK_5() {
  RESULT_5a=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL")
  echo "Task_5a $RESULT_5a"

  RESULT_5b=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL")
  echo "Task_5b $RESULT_5b"
}

# 6.You should set the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table
TASK_6() {
  RESULT_6=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)")
  echo "Task_6 $RESULT_6"
}

# 7.You should create a types table that will store the three types of elements
TASK_7() {
  RESULT_7=$($PSQL "CREATE TABLE types()")
  echo "Task_7 $RESULT_7"
}

# 8.Your types table should have a type_id column that is an integer and the primary key
TASK_8() {
  RESULT_8=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY")
  echo "Task_8 $RESULT_8"
}

# 9.Your types table should have a type column that's a VARCHAR and cannot be null. It will store the different types from the type column in the properties table
TASK_9() {
  RESULT_9=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(30) NOT NULL UNIQUE")
  echo "Task_9 $RESULT_9"
}

# 10.You should add three rows to your types table whose values are the three different types from the properties table
TASK_10() {
  # group properties types
  RESULT_10a=$($PSQL "SELECT type FROM properties GROUP BY type")
  echo "$RESULT_10a" | while read TYPE
  do
    # insert types in types table
    RESULT_10b=$($PSQL "INSERT INTO types(type) VALUES('$TYPE')")
    echo "Task_10b $RESULT_10b" 
  done
}

# 11.Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
TASK_11() {
  RESULT_11=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id)")
  echo "Task_11 $RESULT_11"
}

# 12.Each row in your properties table should have a type_id value that links to the correct type from the types table
TASK_12() {
  # get type_id and type from types table
  RESULT_12a=$($PSQL "SELECT type_id, type FROM types ORDER BY type_id")
  echo "$RESULT_12a" | while read TYPE_ID BAR TYPE
  do
    # fill type_id in properties table
    RESULT_12b=$($PSQL "UPDATE properties SET type_id = $TYPE_ID WHERE type = '$TYPE'")
    echo "Task_12b $RESULT_12b"
  done
  # set column type_id NOT NULL
  RESULT_11b=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL")
  echo "Task_11b $RESULT_11b"
}

# 13.You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
TASK_13() {
  RESULT_13a=$($PSQL "SELECT atomic_number, symbol FROM elements ORDER BY atomic_number")
  echo "$RESULT_13a" | while read ATOMIC_NUMBER BAR SYMBOL
  do 
    ADJUSTED_SYMBOL=${SYMBOL^}
    RESULT_13b=$($PSQL "UPDATE elements SET symbol = '$ADJUSTED_SYMBOL' WHERE atomic_number = $ATOMIC_NUMBER")
    echo "Task_13b $RESULT_13b"
  done
}

# 14.You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
TASK_14() {
  RESULT_14a=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL")
  echo "Task_14a $RESULT_14a"
  
  RESULT_14b=$($PSQL "SELECT atomic_number, atomic_mass FROM properties ORDER BY atomic_number")
  echo "$RESULT_14b" | while read ATOMIC_NUMBER BAR ATOMIC_MASS
  do 
    ADJUSTED_ATOMIC_MASS=$(echo $ATOMIC_MASS | sed -e 's/[0]*$//g')
    echo "$ATOMIC_NUMBER $ADJUSTED_ATOMIC_MASS"
    
    RESULT_14c=$($PSQL "UPDATE properties SET atomic_mass = $ADJUSTED_ATOMIC_MASS WHERE atomic_number = $ATOMIC_NUMBER")
    echo "Task_14c $RESULT_14c"
  done  
}

# 15.You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
TASK_15() {
  RESULT_15a=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine')")
  echo "Task_15a $RESULT_15a"

  RESULT_15b=$($PSQL "SELECT type_id FROM types WHERE type = 'nonmetal'")
  echo "Task_15b $RESULT_15b"

  RESULT_15c=$($PSQL "INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 'nonmetal', 18.998, -220, -188.1, $RESULT_15b)")
  echo "$Task_15c $RESULT_15c"
}

# 16.You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
TASK_16() {
  RESULT_16a=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon')")
  echo "Task_16a $RESULT_16a"

  RESULT_16b=$($PSQL "SELECT type_id FROM types WHERE type = 'nonmetal'")
  echo "Task_16b $RESULT_16b"

  RESULT_16c=$($PSQL "INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(10, 'nonmetal', 20.18, -248.6, -246.1, $RESULT_16b)")
  echo "$Task_16c $RESULT_16c"
}

# 17.You should delete the non existent element, whose atomic_number is 1000, from the two tables
TASK_17() {
  RESULT_17a=$($PSQL "DELETE FROM properties WHERE atomic_number = 1000")
  echo "Task_17a $RESULT_17a"

  RESULT_17b=$($PSQL "DELETE FROM elements WHERE atomic_number = 1000")
  echo "Task_17b $RESULT_17b"
}

# 18.Your properties table should not have a type column
TASK_18() {
  RESULT_18=$($PSQL "ALTER TABLE properties DROP COLUMN type")
  echo "Task_18 $RESULT_18"
}

# 0. ALL TASKS
TASK_0() {
  TASK_1
  TASK_2
  TASK_3
  TASK_4
  TASK_5
  TASK_6
  TASK_7
  TASK_8
  TASK_9
  TASK_10
  TASK_11
  TASK_12
  TASK_13
  TASK_14
  TASK_15
  TASK_16
  TASK_17
  TASK_18
}

case $1 in 
  0) TASK_0 ;;
  1) TASK_1 ;;
  2) TASK_2 ;;
  3) TASK_3 ;;
  4) TASK_4 ;;
  5) TASK_5 ;;
  6) TASK_6 ;;
  7) TASK_7 ;;
  8) TASK_8 ;;
  9) TASK_9 ;;
  10) TASK_10 ;;
  11) TASK_11 ;;
  12) TASK_12 ;;
  13) TASK_13 ;;
  14) TASK_14 ;;
  15) TASK_15 ;;
  16) TASK_16 ;;
  17) TASK_17 ;;
  18) TASK_18 ;;  
esac
