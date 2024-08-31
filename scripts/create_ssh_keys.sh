#!/bin/sh

#get the current directory of the script
script_dir=$(dirname $0)

#set path to inventory.ini file in the directory above this script
inventory_file_path="$script_dir/../inventory.ini"
echo "Inventory file path: $inventory_file_path"

# parse the inventory.ini file to get the list of hosts on each line below the [myhosts] section but not before the next section [.*]
hosts=$(awk '/\[myhosts\]/{flag=1; next} /^\[/{flag=0} flag' $inventory_file_path)

#if ~/.ssh/id_rsa doesnt exist, create ssh keys
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Creating ssh keys"
    ssh-keygen -t rsa -b 4096 -C "ansible" -f ~/.ssh/id_rsa -N ""
fi

# create ssh keys for each host in the inventory.ini file for user admin
for host in $hosts
do
    #strip whitespace and newlines from the host
    host=$(echo $host | tr -d '[:space:]')
    ssh-copy-id -i ~/.ssh/id_rsa.pub admin@$host
    sleep 5
done

# setup ssh config file
echo "Setting up ssh config file"
echo "Host *" > ~/.ssh/config
echo "    StrictHostKeyChecking no" >> ~/.ssh/config
echo "    UserKnownHostsFile=/dev/null" >> ~/.ssh/config
echo "    LogLevel ERROR" >> ~/.ssh/config
chmod 600 ~/.ssh/config


