#!/bin/bash



# function one
systemHelth() {
	echo "system helth check"
  {
        echo "------------ Disk Usage ------------"
        df -h
        echo ""
        echo "------------ CPU Info -------------"
        lscpu
        echo ""
        echo "------------ Memory Usage ---------"
        free -h
    } > system_report.txt
    
    # Show first 10 lines
    echo "First 10 lines of report:"
    head -n 10 system_report.txt
}
# function 2

activeProcesses(){
	echo "active processes are the following:"
	top
	read -p "Enter a keyword to search processes: " keyword
	count=$(top | grep "$keyword" | grep -v grep | wc -l)

    echo -e "Processes matching '$keyword': $count"
    ps aux | grep "$keyword" | grep -v grep

}
# function three 
	
user_group_management() {
    echo "User & Group Management..."

    # Ask for username
    read -p "Enter a new username: " username

    # Check if user exists
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists!"
        return
    fi

    # Ask for group name
    read -p "Enter a new group name: " groupname

    # Create group and user (needs sudo)
    sudo groupadd "$groupname"
    sudo useradd -m -G "$groupname" "$username"

    # Set default password
    sudo passwd "$username"

    # Change ownership of a test file
    read -p "Enter a test file path to change ownership: " testfile
    if [ -f "$testfile" ]; then
        sudo chown "$username":"$groupname" "$testfile"
        echo "Ownership changed for $testfile"
    else
        echo "File does not exist!"
    fi
}



#function four
file_organixer(){
	read -p "Enter the directory path to organize: " dir
	if [ ! -d "$dir" ]; then 
		echo "direcotory doesnot exits "
		return
	fi 

	mkdir -p "$dir/images" "$dir/docs" "$dir/scripts"
	mv "$dir"/*.jpg "$dir/images/" 2>/dev/null
    	mv "$dir"/*.png "$dir/images/" 2>/dev/null
    	mv "$dir"/*.txt "$dir/docs/" 2>/dev/null
    	mv "$dir"/*.md "$dir/docs/" 2>/dev/null
    	mv "$dir"/*.sh "$dir/scripts/" 2>/dev/null	
tree "$dir"

}
#function five 

Network-diagonastics(){
read -p "Enter the website you want to ping: " website

{
    echo "Ping $website "
    ping -c 4 "$website"
    echo ""

    echo "DNS Lookup for $website "
    dig "$website"
    echo ""

    echo "curl $website "
    curl -I "$website"
    echo ""
} > networkReport.txt

echo "Report saved to networkReport.txt"
}
#  function 6

shedule-task(){
	echo "set a sheduled tasks: "
	read -p "Enter full path of the script to schedule: " scriptpath
	if [ ! -f "$scriptpath"]
	then 
		echo "script doesnot exists "
	fi
	read -p "Enter minute (0-59): " minute
   	read -p "Enter hour (0-23): " hour

	echo "$minute $hour * * * $scriptpath" | crontab -

    	echo "Cron job added successfully!"
}

#function 7 


ssh-key() {
    echo "SSH Key Setup..."

    
    ssh-keygen -t rsa 

    echo "Your public key is: "
    cat ~/.ssh/id_rsa.pub

   
}

while true; do
    echo "==== System Health & Admin Menu ===="
    echo "1) System Health Check"
    echo "2) Active Processes"
    echo "3) User & Group Management"
    echo "4) File Organizer"
    echo "5) Network Diagnostics"
    echo "6) Scheduled Task Setup"
    echo "7) SSH Key Setup"
    echo "8) Exit"
    
    read -p "Enter your choice [1-8]: " choice
    
    case $choice in
        1) systemHelth ;;
        2) activeProcesses ;;
        3) user_group_management ;;
        4) file_organixer ;;
        5) Network-diagonastics ;;
        6) shedule-task ;;
        7) ssh-key ;;
        8) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option! Please enter 1-8." ;;
    esac
done

























