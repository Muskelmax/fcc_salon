#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~ MY SALON ~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
HAS_PASSED=false


MAIN_MENU() {
  while [ $HAS_PASSED == false ]
  do
    HAS_PASSED=true
    #Display services
    SERVICES=$($PSQL "SELECT * FROM services")
    # echo $SERVICES
    echo "$SERVICES" | while read SERVICE_ID BAR NAME 
    do
      if [[ $NAME != 'name' && ! -z $NAME ]]
      then
        echo "$SERVICE_ID) $NAME"
      fi
    done
    read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      echo "that shit ain't no number. Here try agian:"
      HAS_PASSED=false
    fi
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") == "" ]]
    then
      echo "that shit ain't no Service. Here try agian:"
      HAS_PASSED=false
    fi
  done
  echo -e "\nYoooo That is sick and all. Drop yo phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'") 
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "AYooo! You new where? WHats you name":
    read CUSTOMER_NAME
    ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo -e "\nNICE COCK $CUSTOMER_NAME! When would you like to come around?"
  read SERVICE_TIME
  echo $CUSTOMER_NAME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo $CUSTOMER_ID
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
