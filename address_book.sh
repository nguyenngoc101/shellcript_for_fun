#!/bin/bash

. utils.sh
DB="address_db.txt"
DELIMITER=";"

# Use delimiliter`;` to separate fields
# Ex: Name;Phone;Email
# Jonh Smith;12345;joe_smith@yahoo.com

save(){
    echo $@ >> $DB
    cat $DB
}

add(){
    echo "Add a new user."
    echo -e "[Name]: \c"
    read name
    echo -e "[Phone]: \c"
    read phone
    echo -e "[Email]: \c"
    read email
    join $DELIMITER $name $phone $email >> $DB
    echo "A new user created sucessfully!"
    echo -e "[Name]: $name"
    echo -e "[Phone]: $phone"
    echo -e "[Email]: $email"
}

print_usr(){
    user=$@
    IFS="$DELIMITER" read -r -a fields <<< $@
    printf "|%s10\t|%s10\t|%s10\t|\n" ${fields[0]} ${fields[1]} ${fields[2]}
}

show(){
    echo "Total users: $(wc -l < $DB)"
    printf "|Name\t|Phone\t|Email|\n"
    while read user
    do
        print_usr $user
    done < $DB
}

search(){
    local keyword=$1
    local hits=`grep -rni $DB -e "$keyword"`
    echo "${hits}"
}




remove(){
    return 1
}

print_hits(){
    local hits=$@
    local index=0
    echo "Total hits: `wc -l <<< "$hits"`"
    for hit in $hits
    do
        index=$(expr $index + 1)
        echo "---------$index-----------"
        print_usr $(echo $hit | cut -c3-)
    done
}



main(){
    while :
    do
        echo "------------------------------"
        echo "     Address Book System  "
        echo "------------------------------"
        echo "Press "0" to list all users."
        echo "Press "1" to add a new user."
        echo "Press "2" to edit a user."
        echo "Press "3" to search."
        echo "Press "4" to remove a user."
        echo "Press "5" to exit the program"
        read INPUT_STRING
        case $INPUT_STRING in
            0)
                show
                ;;
            1)
                add
                ;;
            2)
                echo "edit"
                ;;
            3)
                echo "remove"
                ;;
            4)
                echo "search"
                ;;
            5)
                echo "exit"
                exit 0
                ;;
            *)
                echo "Sorry, I don't understand"
                ;;
        esac
    done
}

main $@


