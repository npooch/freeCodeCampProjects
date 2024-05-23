#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ My Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "Welcome to my salon, how may I help you?"
  echo -e "\n1) cut\n2) color\n3) trim"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT 'cut' ;;
    2) MAKE_APPOINTMENT 'color' ;;
    3) MAKE_APPOINTMENT 'trim' ;;
    *) MAIN_MENU "I could not find that service. What would you like today?"
  esac
}

MAKE_APPOINTMENT() {
  SERVICE_NAME=$1
  SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE name = '$SERVICE_NAME'")
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get customer's name
    echo -e "\nI don't have a record for that phone number, What's your name?"
    read CUSTOMER_NAME
    # insert name into customer table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # get appointment time
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  # insert customer's appoinment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # confirm the appointment details
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 
}

MAIN_MENU
