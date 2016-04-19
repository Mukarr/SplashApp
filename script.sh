#!/bin/bash

#text formatting
bold=$(tput bold; tput smul)		
normal=$(tput sgr0)
width=$(tput cols)

# Greeting message
printf "%*s" "$width" |tr " " "-"
echo -e "Desktop Wallpaper Setup kit for Ubuntu-based distros.\nPlease specify answers for some of the pre-requisites, ${bold}with a number${normal}."
printf "%*s" "$width" |tr " " "-"

# Prompts the user for the directory path to store wallpapers to 
echo -e "Where do you want to store your wallpapers?\n ${bold}1. Default: /home/user/Pictures/Wallpapers${normal}\n 2. Custom | " 
read locNumber

if (($locNumber==1)); then
	user=$(whoami)
	location="/home/$user/Pictures/Wallpapers"
else
	echo -e "Specify the path of the directory |"
	read location
fi

printf "%*s" "$width" |tr " " "-"

# Prompts the user for the resolution of the screen
echo -e "Choose the resolution of your desktop screen?\n ${bold}1. 1360 x 768 ${normal}? \n ${bold}2. 1024 x  768${normal}? \n ${bold}3. 800 x 600${normal}? \n ${bold}4. None of the above${normal}?| " 
read resoNumber

if  (($resoNumber==1 )); then
	resolution="1360x768"
elif (($resoNumber==2)) ; then
	resolution="1024x768"
elif (($resoNumber==3)); then
	resolution="800x600"
else
	echo -e "Enter the resolution of your desktop screen?\n| " 
	read resolution
fi

printf "%*s" "$width" |tr " " "-"

# Prompts the user for the theme of wallpapers
echo -e "Choose the theme for your wallpapers:\n ${bold}1. food ${normal} \n ${bold}2. nature${normal} \n ${bold}3. people${normal} \n ${bold}4. technology${normal} \n ${bold}5. buildings${normal}\n ${bold}6. Random${normal}?| " 
read themeNumber

if (($themeNumber==1)); then
	theme="category/food"
elif (($themeNumber==2)); then
	theme="category/nature"
elif (($themeNumber==3)); then
	theme="category/people"
elif (($themeNumber==4)); then
	theme="category/technology"
elif (($themeNumber==5)); then
	theme="category/buildings"	
else
	theme="random"
fi

# Prompts the user for the interval between wallpapers change
echo -e "Choose the frequency of updating wallpapers:\n ${bold}1. every 10 min ${normal} \n ${bold}2. every hour${normal} \n ${bold}3. every 6 hours${normal} \n ${bold}4. every day${normal} \n ${bold}5. every fortnight${normal}\n ${bold}6. every month${normal}?| " 
read intervalOption

if (($intervalOption==1)); then
	croninterval="*/10 * * * *"
elif (($intervalOption==2)); then
	croninterval="25 * * * *"
elif (($intervalOption==3)); then
	croninterval="0 */6 * * *"
elif (($intervalOption==4)); then
	croninterval="0 9 * * *"
elif (($intervalOption==5)); then
	croninterval="0 9 1,16 * *"	
elif (($intervalOption==6)); then
	croninterval="0 9 1 * *"
fi

#If connected to internet, update the wallpaper
wget -q --tries=10 --timeout=20 --spider http://google.com		#check if PC is connected to internet
if [[ $? -eq 0 ]]; then
        echo "Oh! You are Online, Your new wallpaper will be updated soon. :)"
        name=$(date +%Y%m%d%H%M%S)
        wget -q https://source.unsplash.com/$theme/$resolution -O $location/$name.jpg	# download the image to a particular directory
        gsettings set org.gnome.desktop.background picture-uri "file://$location/$name.jpg"
else
        echo "Your PC seems to be Offline, your first new wallpaper will be set as soon as you are connected."
fi

# storing the preferences to a bash script for future usage
mkdir -p $location/splash_script	# create a new directory

echo -e "#!/bin/bash

PID="\$"(pgrep -u "\$"USER gnome-session)
export DBUS_SESSION_BUS_ADDRESS="\$"(grep -z DBUS_SESSION_BUS_ADDRESS /proc/"\$"PID/environ|cut -d= -f2-)

wget -q --tries=10 --timeout=20 --spider http://google.com		#check if PC is connected to internet

if [ "\$"? -eq 0 ]; then
        name="\$"(date +%Y%m%d%H%M%S)
        wget -q https://source.unsplash.com/$theme/$resolution -O $location/"\$"name.jpg	# download the image to a particular directory
        gsettings set org.gnome.desktop.background picture-uri "\""file://$location/"\$"name.jpg"\""
else
        name="\$"(find $location -type f | shuf -n 1)       					# randomly choosing a pic output: dirname/file.jpg
       # readlink mark-twain-quotes/Quotefancy-4026-1600x900.jpg			# getting its absolute path output: /home/   /file.jpg
        gsettings set org.gnome.desktop.background picture-uri "\$"name		# setting the wallpaper

fi
" > $location/splash_script/cronjob.sh

# creating a cronjob for auto-updation in future
crontab -l > mycron								#write out current crontab to a temp file
echo -n "$croninterval" >>mycron
echo "  sh $location/splash_script/cronjob.sh" >> mycron		#echo new cron into temp file
crontab mycron									#install new cron file
rm mycron										# remove the temp file


## Final message ##
echo "${bold}Completed${normal} ✔"

exit 0