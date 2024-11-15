#!/bin/bash
# Created by Jenna Mosey <Jmosey91>
groups=('Sales'
'HumanResources'
'TechnicalOperations'
'HelpDesk'
'Research')

#echo "0=$0"
#echo "1=$1"

BASE=$1

if [ -z "$BASE" ]; then # how to check if a value is null or empty?
echo
echo "Creates a department shared folder structure at the specified destination"
echo
echo " Usage: $0 <root folder>"
echo

exit 1
fi

USER=`whoami`
if [ "$USER" != "root" ]; then # check if user is not the root user
echo "Root permission required"
exit 1
fi

for group in ${groups[@]}; do
echo $group
if [ $(getent group $group) ]; then # group does not exist, create it
echo "Creating group $group..."
groupadd $group
fi

folder="$BASE/$group"
if [ ! -d "$folder" ]; then
echo "Creating shared folder at $folder..."
mkdir -p "$folder"
fi
 
echo " - Applying $USER:$group ownership on $folder..."
chown "$USER:$group" "$folder"

echo " - Applying permissions on $folder... $USER=rwx,$group=rwx,0="
chmod u+rwx,g+rwx,o-rwx "$folder"

echo " - Granting permissions (rx) to Helpdesk on $folder..."
setfacl -- modify=g:Helpdesk:rx "$folder"

done
