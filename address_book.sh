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
    join $DELIMITER "$user_id" "$name" "$phone" "$email" >> $DB
    echo "A new user created sucessfully!"
    echo -e "[Id]: $user_id"
    echo -e "[Name]: $name"
    echo -e "[Phone]: $phone"
    echo -e "[Email]: $email"
}

print_usr(){
    user=$@
    IFS="$DELIMITER" read -r -a fields <<< $@
    printf "|%-25s\t|%-25s\t|%-25s\t|%-25s\t\n" "${fields[0]}" "${fields[1]}" "${fields[2]}" "${fields[3]}"
}

print_header(){
    for i in {1..100}; do [ $i -ne 100 ] && echo -e "-\c" || echo ""; done
    printf "|%-25s\t|%-25s\t|%-25s\t|%-25s\t\n" "Id" "Name" "Phone" "Email"
    for i in {1..100}; do [ $i -ne 100 ] && echo -e "-\c" || echo ""; done
}

show(){
    echo "Total users: $(wc -l < $DB)"
    print_header
    while read user
    do
        print_usr $user
    done < $DB
}

edit(){
    show
    while :
    do
        echo "Please choose an Id to edit"
        echo "Press X to go back to Menu"
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
            local edited_user=$(join "$DELIMITER" "$user_id" "$name" "$phone" "$email")
            sed -i "s/^${user_id};.*/${edited_user}/" $DB
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
    echo -e "Please enter a keword: \c"
    read keyword
    local hits=`grep -ri $DB -e "$keyword"`
    print_header
    echo "$hits" | while read -r hit
    do
        print_usr $hit
    done
}




remove(){
    show
    echo "Please choose an Id user to delete"
    echo "Press X to go back to Menu"
    read user_id
    if [ $user_id == "X" ]; then break;
    elif [ "$user_id" -ge 1 -a "$user_id" -le $(wc -l < $DB) ]; then
        echo "Deleting user_id=${user_id}"
        read -p "Are you sure Y/N? " -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            sed -i "/^${user_id};/d" $DB
            echo "Delete user_id=${user_id} successfully!"
        fi
    else
        echo "The Id not exists in Database. Please choose other Ids"
    fi
}


helps(){
    echo "------------------------------"
    echo "     Address Book System  "
    echo "------------------------------"
    echo "Press "[0]" to show users."
    echo "Press "[1]" to add a new user."
    echo "Press "[2]" to edit a user."
    echo "Press "[3]" to search."
    echo "Press "[4]" to remove a user."
    echo "Press "[5]" for helps"
    echo "Press "[6]" to exit the program"
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
                search
                ;;
            4)
                remove
                ;;
            5)
                helps
                ;;
            6)
                echo "bye bye!"
                exit 0
                ;;
            *)
                echo "Sorry, I don't understand"
                ;;
        esac
    done
}

main $@


