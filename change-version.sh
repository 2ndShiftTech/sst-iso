#!/bin/bash
# Create the new version
year=$(date +%y)   # last two digits of the year
month=$(date +%m)  # month number
day=$(date +%d)    # day of the month

# Auto-detect current extra from dev-rel and bump it
current_version=$(grep -oP 'v\d{2}\.\d{2}\.\d{2}\.\d{2}' archiso/airootfs/etc/dev-rel | head -1)
current_date="v${year}.${month}.${day}"

if [[ "$current_version" == ${current_date}.* ]]; then
    # Same day — bump the extra
    current_extra=$(echo "$current_version" | grep -oP '\d{2}$')
    extra=$(printf "%02d" $(( 10#$current_extra + 1 )))
else
    # New day — reset extra to 01
    extra="01"
fi

newversion="v${year}.${month}.${day}.${extra}"
echo "New Version: $newversion"

# Detect old versions in each file separately
old_devrel=$(grep -oP 'v\d{2}\.\d{2}\.\d{2}\.\d{2}' archiso/airootfs/etc/dev-rel | head -1)
old_buildiso=$(grep -oP "sstVersion='v\d{2}\.\d{2}\.\d{2}\.\d{2}'" build-scripts/build-the-iso.sh | grep -oP 'v\d{2}\.\d{2}\.\d{2}\.\d{2}' | head -1)
old_profiledef=$(grep -oP 'sst-v\d{2}\.\d{2}\.\d{2}\.\d{2}' archiso/profiledef.sh | grep -oP 'v\d{2}\.\d{2}\.\d{2}\.\d{2}' | head -1)
old_isoversion=$(grep -oP 'iso_version="v\d{2}\.\d{2}\.\d{2}\.\d{2}"' archiso/profiledef.sh | grep -oP 'v\d{2}\.\d{2}\.\d{2}\.\d{2}' | head -1)

# Debug output
echo "Old version in dev-rel     : $old_devrel"
echo "Old version in profiledef  : $old_profiledef"

# Replace entire ISO_RELEASE=... line
sed -i "s|^ISO_RELEASE=.*|ISO_RELEASE=$newversion|" archiso/airootfs/etc/dev-rel

# Replace entire sstVersion='...' line
sed -i "s|\(.*sstVersion='\)[^']*\('.*\)|\1$newversion\2|" build-scripts/build-the-iso.sh

# Replace entire iso_label="sst-..." line
sed -i "s|^iso_label=\"sst-.*\"|iso_label=\"sst-$newversion\"|" archiso/profiledef.sh

# Replace entire iso_version="..." line
sed -i "s|^iso_version=\"v.*\"|iso_version=\"$newversion\"|" archiso/profiledef.sh

# Final message
echo "#############################################################################################"
echo "################  $(basename "$(pwd)") version updated to $newversion"
echo "#############################################################################################"