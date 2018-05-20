#!/bin/bash

#Funtion for decoration of output
delimeter () {
  echo -e "\033[0;34m----------------------------------------------------------------\033[0m\033[0m "
}

#Function for retrieving some string 
show_passwd_strings () {
	sed -n "$s"p /etc/passwd
}

case "$1" in
  #-i) 
  #If argument equal "-s" it means show info about users 
  -s) REPLY=y
  ;;
esac

#Find minimal user id
min_uid=$(cat /etc/login.defs | grep -w 'UID_MIN' | tr -d "\t" | cut -d " " -f 2)

#Find count of string in passwd file
numstr=$(cat /etc/passwd | wc -l)

#Retrieving string and taking ID, if ID is valid counter increasing and string adding to array
for (( s=1; s<=$numstr; s++)) do
  if [[ strvl=$( awk -F: '{print $3}' /etc/passwd | sed -n "$s"p) -ge $min_uid && $strvl -lt "20000" ]]; then
    ((u++))
	IFS=$'\n' user_and_id+=$(show_passwd_strings)
  fi;
done

echo -e "Registered users \033[2m(without super users)\033[0m: \033[1;31m$u\033[0m"

#If it no arguments it will enable interactive mode
if [[ $1 = "-i" ]]; then
  echo -en "Do you want see more info about users? \033[2my/n (more options m)\033[0m : "
  read -n 1
  echo
fi;

#If pressed "yes" or argument of cm was "-s" it will show info about users
if [[ $REPLY = "y" || $REPLY = "Y" ]]; then
  delimeter
  echo -e "$user_and_id"
fi

delimeter
exit 0