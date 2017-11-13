#!/bin/bash

. utils.sh
DB="address_db.txt"
DELIMITER=";"

# Use delimiliter`;` to separate fields
# Ex: Name;Phone;Email
# Jonh Smith;12345;joe_smith@yahoo.com

get_max_user_id(){
    echo $(wc -l < $DB)
}

add(){
    echo "Add a new user."
    echo -e "[Name]: \c"
    read name
    echo -e "[Phone]: \c"
    read phone
    echo -e "[Email]: \c"
    read email
    local user_id=$(expr `get_max_user_id` + 1)   
    join $DELIMITER $user_id $name $phone $email >> $DB
    echo "A new user created sucessfully!"
    echo -e "[Id]: $user_id"
    echo -e "[Name]: $name"
    echo -e "[Phone]: $phone"
    echo -e "[Email]: $email"
}

print_usr(){
    user=$@
    IFS="$DELIMITER" read -r -a fields <<< $@
    printf "|%-25s\t|%-25s\t|%-25s\t|%-25s\t\n" ${fields[0]} ${fields[1]} ${fields[2]} ${fields[3]}
}

show(){
    echo "Total users: $(wc -l < $DB)"
    for i in {1..100}; do [ $i -ne 100 ] && echo -e "-\c" || echo ""; done
    printf "|%-25s\t|%-25s\t|%-25s|%-25s\t\n" "Id" "Name" "Phone" "Email"
    for i in {1..100}; do [ $i -ne 100 ] && echo -e "-\c" || echo ""; done
    while read user
    do
        print_usr $user
    done < $DB
}

edit(){
    show
    echo "Please choose an Id to edit"
    echo "Press X to go back to Menu"
    while :
    do
        read user_id
        if [ $user_id == "X" ]; then break;
        elif [ "$user_id" -ge 1 -a "$user_id" -le $(wc -l < $DB) ]; then
            echo "editing user: $user_id"
            echo -e "[Name]: \c"
            read name
            echo -e "[Phone]: \c"
            read phone
            echo -e "[Email]: \c"
            read email
            local edited_user=$( join $DELIMITER $user_id $name $phone $email )
            echo "$edited_user"
            sed -i '1s/.*/replace' $DB
            echo "The user edited sucessfully!"
            echo -e "[Id]: $user_id"
            echo -e "[Name]: $name"
            echo -e "[Phone]: $phone"
            echo -e "[Email]: $email"
        else
            echo "The Id not exists in Database. Please choose other Ids"
        fi
    done
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


helps(){
    echo "------------------------------"
    echo "     Address Book System  "
    echo "------------------------------"
    echo "Press "0" to list all users."
    echo "Press "1" to add a new user."
    echo "Press "2" to edit a user."
    echo "Press "3" to search."
    echo "Press "4" to remove a user."
    echo "Press "5" for helps"
    echo "Press "6" to exit the program"
}

main(){
    while :
    do
        helps
        read INPUT_STRING
        case $INPUT_STRING in
            0)
                show
                ;;
            1)
                add
                ;;
            2)
                edit
                ;;
            3)
                echo "remove"
                ;;
            4)
                echo "search"
                ;;
            5)
                helps
                ;;
            6)
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


