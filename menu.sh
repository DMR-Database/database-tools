#!/bin/bash
#
#
#Convert MD380/390 user.bin to HD1,MD2017 & Anytone format by PD2EMC
#
#
#This script uses the database from https://github.com/PD1LOI/MD380tools
#Either convert files from user.bin or download converted files
#
#
#This script uses https://github.com/sergev/dmrconfig for flashing HTs
#Please install this tool if you want flashing from the menu
#
#

#dmr config tools are needed for flashing
#included in github
#download and compile from https://github.com/sergev/dmrconfig
#
#

#Number off ids to delete in user.bin for database conversion
#
#
number="235"
#End

#Welcomescreen
#
#
dialog --stdout --backtitle "Brandmeister User Database Tool" \
  --title "User Database Tool made by PD2EMC" \
  --yesno "The Software is provided -as is- without warranty of any kind, either express or implied, including, but not limited to, the implied warranties of fitness for a purpose, or the warranty of non-infringement. Without limiting the foregoing, we make no warranty that: the software will meet your requirements, the software will be uninterrupted, timely, secure or error-free, the results that may be obtained from the use of the software will be effective, accurate or reliable, the quality of the software will meet your expectations any errors in the software will be corrected." 18 50
    # If cancelled, drop the dialog
    if [ $? -ne 0 ]; then
    clear;
    echo "Better luck next time :) 73 from the Database Team PD1WP - PD2EMC - PD1LOI";
    exit;
	fi;
#End

#Start Functions
#
#

#Download Databases
#
#
function wgetDatabase {
        clear
        echo "Download Database wget"
        echo "Remove all .csv files..."
        rm user*.csv >> /dev/null 2>&1

        sleep 1
        echo "Remove user.bin..."
        rm user*.bin  >> /dev/null 2>&1

        sleep 1
        echo "Get new user.bin from github..."
        wget https://raw.githubusercontent.com/PD1LOI/MD380tools/master/user.bin  >> /dev/null 2>&1
        echo "Ready:database downloaded."
        sleep 3
        clear
    }
function gitDatabase {
        clear
        echo "Download Database git pull"
        echo "Remove all .csv files..."
        rm user*.csv >> /dev/null 2>&1
        sleep 1

        echo "Check github for new file..."
        git pull
        echo "Ready:database downloaded."
        sleep 3
        clear
}
function dlmd380Database {
        clear
	echo "Download latest database"
        echo "Remove user.bin file..."
        rm user*.bin >> /dev/null 2>&1

        sleep 1
        echo "Get new user.bin from github..."
        wget https://raw.githubusercontent.com/PD1LOI/MD380tools/master/user.bin  >> /dev/null 2>&1
        echo "Ready:database downloaded."
        sleep 1
}
function dlmd2017Database {
	clear
	echo "Download latest database"
        echo "Remove usermd2017.csv file..."
        rm usermd2017.csv >> /dev/null 2>&1

        sleep 1
        echo "Get new usermd2017.csv from github..."
        wget https://raw.githubusercontent.com/PD1LOI/MD380tools/master/usermd2017.csv  >> /dev/null 2>&1
        echo "Ready:database downloaded."
        sleep 1
}
function dlanytoneDatabase {
        clear
	echo "Download latest database"
        echo "Remove userat.csv file..."
        rm userat.csv >> /dev/null 2>&1

        sleep 1
        echo "Get new userat.csv from github..."
        wget https://raw.githubusercontent.com/PD1LOI/MD380tools/master/userat.csv  >> /dev/null 2>&1
        echo "Ready:database downloaded."
        sleep 1
}
#Convert Databases
#
#
function convhd1Database {
        clear
        echo "Convert database to HD1 format"
        echo "Make HD1 Database..."
        awk -F, '{print "Private Call",$2"  "$1,$3,$4"-"$5,$7,$1}' OFS=, "user.bin" > userhd1.csv
        tail -n+$number userhd1.csv > userhd2.csv
        sleep 1

        echo "Cut at 100000 users..."
        sed -n '1,100000p' userhd2.csv > userhd3.csv
        sleep 1

        echo "Format csv with CR LF..."
        awk 'sub("$","\r")' userhd3.csv > userhd.csv
        sleep 1

        echo "Remove temp files..."
        rm userhd1.csv
        rm userhd2.csv
	rm userhd3.csv

        sleep 1
        echo "Ready: userhd.csv for HD1 created."
        sleep 3
}
function convmd2017Database {
        clear
        echo "Convert database to MD2017 format"
        echo "Make MD2017 Database..."
        #grep '^2' user.bin > usereu.bin
        #grep '^3' user.bin >> usereu.bin
        sleep 1

        echo "Rearange collumns to MD2017..."
        #awk -F, '{print $1,$2,$3,$4,$5,$7}' OFS=, "usereu.bin" > usermd1.csv
        awk -F, '{print $1,$2,$3,$4,$5,$7}' OFS=, "user.bin" > usermd1.csv
        sleep 1

        echo "Remove unused Callerids..."
        tail -n+$number usermd1.csv > usermd2.csv
        sleep 1

        echo "Format csv with CR LF....."
        awk 'sub("$","\r")' usermd2.csv > usermd2017.csv
        sleep 1

        echo "Remove temp files..."
        rm usermd1.csv
        rm usermd2.csv
        #rm usermdeu.csv
        sleep 1

        echo "Ready: usermd2017.csv for MD2017 created."
        sleep 3
}
function convanytoneDatabase {
	clear
	echo "Convert database to Anytone format"
	echo "Make Anytone Database..."
	sleep 1
	
	echo "Remove Talkgroups from top..."
	tail -n+$number user.bin > userat.bin
	sleep 1
	
	echo "Replacing Country names..."
	sed -i 's/,,AD/,,Andorra/g' userat.bin
	sed -i 's/,,AR/,,Argentina/g' userat.bin
	sed -i 's/,,AT/,,Austria/g' userat.bin
	sed -i 's/,,AU/,,Australia/g' userat.bin
	sed -i 's/,,BA/,,Bosnia and Herzegovina/g' userat.bin
	sed -i 's/,,BB/,,Barbados/g' userat.bin
	sed -i 's/,,BE/,,Belgium/g' userat.bin
	sed -i 's/,,BG/,,Bulgaria/g' userat.bin
	sed -i 's/,,BR/,,Brazil/g' userat.bin
	sed -i 's/,,BZ/,,Belize/g' userat.bin
	sed -i 's/,,CA/,,Canada/g' userat.bin
	sed -i 's/,,CH/,,Switzerland/g' userat.bin
	sed -i 's/,,CL/,,Chile/g' userat.bin
	sed -i 's/,,CN/,,China/g' userat.bin
	sed -i 's/,,CO/,,Columbia/g' userat.bin
	sed -i 's/,,CR/,,Costa Rica/g' userat.bin
	sed -i 's/,,CY/,,Cyprus/g' userat.bin
	sed -i 's/,,CZ/,,Czech Republic/g' userat.bin
	sed -i 's/,,DE/,,Germany/g' userat.bin
	sed -i 's/,,DK/,,Denmark/g' userat.bin
	sed -i 's/,,DM/,,Dominica/g' userat.bin
	sed -i 's/,,DO/,,Dominican Republic/g' userat.bin
	sed -i 's/,,EC/,,Ecuador/g' userat.bin
	sed -i 's/,,EE/,,Estonia/g' userat.bin
	sed -i 's/,,ES/,,Spain/g' userat.bin
	sed -i 's/,,FI/,,Finland/g' userat.bin
	sed -i 's/,,FR/,,France/g' userat.bin
	sed -i 's/,,GR/,,Greece/g' userat.bin
	sed -i 's/,,GT/,,Guatemala/g' userat.bin
	sed -i 's/,,HK/,,Hong Kong/g' userat.bin
	sed -i 's/,,HR/,,Croatia/g' userat.bin
	sed -i 's/,,HT/,,Haiti/g' userat.bin
	sed -i 's/,,HU/,,Hungary/g' userat.bin
	sed -i 's/,,ID/,,Indonesia/g' userat.bin
	sed -i 's/,,IE/,,Ireland/g' userat.bin
	sed -i 's/,,IL/,,Israel/g' userat.bin
	sed -i 's/,,IN/,,India/g' userat.bin
	sed -i 's/,,IT/,,Italy/g' userat.bin
	sed -i 's/,,JP/,,Japan/g' userat.bin
	sed -i 's/,,KR/,,Korea/g' userat.bin
	sed -i 's/,,KW/,,Kuwait/g' userat.bin
	sed -i 's/,,LI/,,Liechtenstein/g' userat.bin
	sed -i 's/,,LU/,,Luxemburg/g' userat.bin
	sed -i 's/,,LV/,,Latvia/g' userat.bin
	sed -i 's/,,ME/,,Montenegro/g' userat.bin
	sed -i 's/,,MK/,,Macedonia/g' userat.bin
	sed -i 's/,,MT/,,Malta/g' userat.bin
	sed -i 's/,,MX/,,Mexico/g' userat.bin
	sed -i 's/,,MY/,,Malaysia/g' userat.bin
	sed -i 's/,,NL/,,Netherlands/g' userat.bin
	sed -i 's/,,NO/,,Norway/g' userat.bin
	sed -i 's/,,NZ/,,New Zealand/g' userat.bin
	sed -i 's/,,PA/,,Pananma/g' userat.bin
	sed -i 's/,,PH/,,Philippines/g' userat.bin
	sed -i 's/,,PL/,,Poland/g' userat.bin
	sed -i 's/,,PT/,,Portugal/g' userat.bin
	sed -i 's/,,QA/,,Qatar/g' userat.bin
	sed -i 's/,,RE/,,Reunion/g' userat.bin
	sed -i 's/,,RO/,,Romainia/g' userat.bin
	sed -i 's/,,RS/,,Serbia/g' userat.bin
	sed -i 's/,,RU/,,Russia/g' userat.bin
	sed -i 's/,,SE/,,Sweden/g' userat.bin
	sed -i 's/,,SG/,,Singapore/g' userat.bin
	sed -i 's/,,SI/,,Slovenia/g' userat.bin
	sed -i 's/,,SK/,,Slovakia/g' userat.bin
	sed -i 's/,,TH/,,Thailand/g' userat.bin
	sed -i 's/,,TR/,,Turkey/g' userat.bin
	sed -i 's/,,TT/,,Trinidad and Tobago/g' userat.bin
	sed -i 's/,,TW/,,Taiwan/g' userat.bin
	sed -i 's/,,UA/,,Ukraine/g' userat.bin
	sed -i 's/,,UK/,,England/g' userat.bin
	sed -i 's/,,US/,,USA/g' userat.bin
	sed -i 's/,,UY/,,Uruguay/g' userat.bin
	sed -i 's/,,VE/,,Venezuela/g' userat.bin
	sed -i 's/,,ZA/,,South Africa/g' userat.bin
	sleep 1
	
	echo "Replacing Region Names..."
	sed -i 's/,AB,/,Alberta,/g' userat.bin
	sed -i 's/,ABR,/,Abruzzo,/g' userat.bin
	sed -i 's/,ACT,/,Austrailian Capital T,/g' userat.bin
	sed -i 's/,AK,/,Alaska,/g' userat.bin
	sed -i 's/,AL,/,Alabama,/g' userat.bin
	sed -i 's/,ANT,/,Antwerpen,/g' userat.bin
	sed -i 's/,AR,/,Arkansas,/g' userat.bin
	sed -i 's/,AZ,/,Arizona,/g' userat.bin
	sed -i 's/,BAS,/,Basilicata,/g' userat.bin
	sed -i 's/,BB,/,Brandenburg,/g' userat.bin
	sed -i 's/,BC,/,British Columbia,/g' userat.bin
	sed -i 's/,BE,/,Berlin,/g' userat.bin
	sed -i 's/,BW,/,Baden-Wurttemberg,/g' userat.bin
	sed -i 's/,BRU,/,Brussels,/g' userat.bin
	sed -i 's/,BY,/,Bavaria,/g' userat.bin
	sed -i 's/,CA,/,California,/g' userat.bin
	sed -i 's/,CAL,/,Calabria,/g' userat.bin
	sed -i 's/,CAM,/,Campania,/g' userat.bin
	sed -i 's/,CO,/,Colorada,/g' userat.bin
	sed -i 's/,CT,/,Connecticut,/g' userat.bin
	sed -i 's/,DC,/,District of Columbia,/g' userat.bin
	sed -i 's/,DE,/,Delaware,/g' userat.bin
	sed -i 's/,DR,/,Drenthe,/g' userat.bin
	sed -i 's/,EMI,/,Emila-Romagna,/g' userat.bin
	sed -i 's/,FLD,/,Flevoland,/g' userat.bin
	sed -i 's/,FL,/,Florida,/g' userat.bin
	sed -i 's/,FRL,/,Friesland,/g' userat.bin
	sed -i 's/,FRI,/,Friuli-Venezia Giulia,/g' userat.bin
	sed -i 's/,GA,/,Georgia,/g' userat.bin
	sed -i 's/,GLD,/,Gelderland,/g' userat.bin
	sed -i 's/,GR,/,Groningen,/g' userat.bin
	sed -i 's/,HB,/,Bremen,/g' userat.bin
	sed -i 's/,HE,/,Hessen,/g' userat.bin
	sed -i 's/,HH,/,Hamburg,/g' userat.bin
	sed -i 's/,HI,/,Hawaii,/g' userat.bin
	sed -i 's/,IA,/,Iowa,/g' userat.bin
	sed -i 's/,ID,/,Idaho,/g' userat.bin
	sed -i 's/,IF,/,Ile-de-France,/g' userat.bin
	sed -i 's/,IL,/,Illinois,/g' userat.bin
	sed -i 's/,IN,/,Indiana,/g' userat.bin
	sed -i 's/,KS,/,Kansas,/g' userat.bin
	sed -i 's/,KY,/,Kentucky,/g' userat.bin
	sed -i 's/,LA,/,Louisiana,/g' userat.bin
	sed -i 's/,LAZ,/,Lazio,/g' userat.bin
	sed -i 's/,LB,/,Limburg,/g' userat.bin
	sed -i 's/,LIG,/,Liguria,/g' userat.bin
	sed -i 's/,LIE,/,Liege,/g' userat.bin
	sed -i 's/,LIM,/,Limburg,/g' userat.bin
	sed -i 's/,LOM,/,Lombardia,/g' userat.bin
	sed -i 's/,MA,/,Massachusetts,/g' userat.bin
	sed -i 's/,MAR,/,Marche,/g' userat.bin
	sed -i 's/,MB,/,Manitoba,/g' userat.bin
	sed -i 's/,MD,/,Maryland,/g' userat.bin
	sed -i 's/,ME,/,Maine,/g' userat.bin
	sed -i 's/,MI,/,Michigan,/g' userat.bin
	sed -i 's/,MN,/,Minnesota,/g' userat.bin
	sed -i 's/,MO,/,Missouri,/g' userat.bin
	sed -i 's/,MOL,/,Molise,/g' userat.bin
	sed -i 's/,MS,/,Mississippi,/g' userat.bin
	sed -i 's/,MT,/,Montana,/g' userat.bin
	sed -i 's/,MV,/,Mecklenburg-Vorpommern,/g' userat.bin
	sed -i 's/,N-BR,/,N. Brabant,/g' userat.bin
	sed -i 's/,N-H,/,N. Holland,/g' userat.bin
	sed -i 's/,NB,/,New Brunswick,/g' userat.bin
	sed -i 's/,NC,/,N. Carolina,/g' userat.bin
	sed -i 's/,ND,/,N. Dakota,/g' userat.bin
	sed -i 's/,NE,/,Nebraska,/g' userat.bin
	sed -i 's/,NH,/,New Hampshire,/g' userat.bin
	sed -i 's/,NI,/,Lower Saxony,/g' userat.bin
	sed -i 's/,NJ,/,New Jersey,/g' userat.bin
	sed -i 's/,NL,/,Newfoundland,/g' userat.bin
	sed -i 's/,NM,/,New Mexico,/g' userat.bin
	sed -i 's/,NS,/,Nova Scotia,/g' userat.bin
	sed -i 's/,NSW,/,New S. Wales,/g' userat.bin
	sed -i 's/,NT,/,N. Territory,/g' userat.bin
	sed -i 's/,NV,/,Nevada,/g' userat.bin
	sed -i 's/,NW,/,N.Rhine-Westphalia,/g' userat.bin
	sed -i 's/,NY,/,New York,/g' userat.bin
	sed -i 's/,OVL,/,Oost-Vlaanderen,/g' userat.bin
	sed -i 's/,OA,/,OA,/g' userat.bin
	sed -i 's/,OH,/,Ohio,/g' userat.bin
	sed -i 's/,OK,/,Oklahoma,/g' userat.bin
	sed -i 's/,ON,/,Ontario,/g' userat.bin
	sed -i 's/,OR,/,Oregon,/g' userat.bin
	sed -i 's/,OV,/,Overijssel,/g' userat.bin
	sed -i 's/,PA,/,Pennsylvania,/g' userat.bin
	sed -i 's/,PE,/,Prince Edward Isle,/g' userat.bin
	sed -i 's/,PIE,/,Piemonte,/g' userat.bin
	sed -i 's/,PLDS,/,Lower Silesia,/g' userat.bin
	sed -i 's/,PLKP,/,Kuyavia-Pomerania,/g' userat.bin
	sed -i 's/,PLLB,/,Lubusz,/g' userat.bin
	sed -i 's/,PLLD,/,Lodz,/g' userat.bin
	sed -i 's/,PLLU,/,Lublin,/g' userat.bin
	sed -i 's/,PLMA,/,Lesser Poland,/g' userat.bin
	sed -i 's/,PLMZ,/,Mazovia,/g' userat.bin
	sed -i 's/,PLOP,/,Opole,/g' userat.bin
	sed -i 's/,PLPD,/,Podlaskie,/g' userat.bin
	sed -i 's/,PLPK,/,Subcarpathia,/g' userat.bin
	sed -i 's/,PLPM,/,Pomerania,/g' userat.bin
	sed -i 's/,PLSK,/,Holy Cross,/g' userat.bin
	sed -i 's/,PLSL,/,Silesia,/g' userat.bin
	sed -i 's/,PLWN,/,Greater Poland,/g' userat.bin
	sed -i 's/,PLZP,/,W.Pomerania,/g' userat.bin
	sed -i 's/,PR,/,Puerto Rico,/g' userat.bin
	sed -i 's/,PUG,/,Puglia,/g' userat.bin
	sed -i 's/,QC,/,Quebec,/g' userat.bin
	sed -i 's/,QLD,/,Queensland,/g' userat.bin
	sed -i 's/,RI,/,Rhode Island,/g' userat.bin
	sed -i 's/,RP,/,Rhineland-Palatinate,/g' userat.bin
	sed -i 's/,SA,/,S. Australia,/g' userat.bin
	sed -i 's/,SAR,/,Sardegna,/g' userat.bin
	sed -i 's/,SC,/,S. Carolina,/g' userat.bin
	sed -i 's/,SD,/,S. Dakota,/g' userat.bin
	sed -i 's/,SH,/,Schleswig-Holstein,/g' userat.bin
	sed -i 's/,SIC,/,Sicilia,/g' userat.bin
	sed -i 's/,SK,/,Saskatchewan,/g' userat.bin
	sed -i 's/,SL,/,Saarland,/g' userat.bin
	sed -i 's/,SN,/,Saxony,/g' userat.bin
	sed -i 's/,ST,/,Saxony-Anhalt,/g' userat.bin
	sed -i 's/,SV,/,Savona,/g' userat.bin
	sed -i 's/,TAS,/,Tasmania,/g' userat.bin
	sed -i 's/,TH,/,Thuringia,/g' userat.bin
	sed -i 's/,TN,/,Tennessee,/g' userat.bin
	sed -i 's/,TOS,/,Toscana,/g' userat.bin
	sed -i 's/,TRE,/,Trentino-Alto Adige,/g' userat.bin
	sed -i 's/,TX,/,Texas,/g' userat.bin
	sed -i 's/,UMB,/,Umbria,/g' userat.bin
	sed -i 's/,UT,/,Utah,/g' userat.bin
	sed -i 's/,UTR,/,Utrecht,/g' userat.bin
	sed -i 's/,VA,/,Virginia,/g' userat.bin
	sed -i 's/,VAL,/,Valle d-Aosta,/g' userat.bin
	sed -i 's/,VAN,/,Antwerp,/g' userat.bin
	sed -i 's/,VB,/,Vlaams-Brabant,/g' userat.bin
	sed -i 's/,VBR,/,Flemish Brabant,/g' userat.bin
	sed -i 's/,VEN,/,Veneto,/g' userat.bin
	sed -i 's/,VIC,/,Victoria,/g' userat.bin
	sed -i 's/,VLI,/,Limburg,/g' userat.bin
	sed -i 's/,VOV,/,E. Flanders,/g' userat.bin
	sed -i 's/,VT,/,Vermont,/g' userat.bin
	sed -i 's/,WVL,/,W. Flanders,/g' userat.bin
	sed -i 's/,WA,/,Washington,/g' userat.bin
	sed -i 's/,WAU,/,W. Australia,/g' userat.bin
	sed -i 's/,WBR,/,Walloon Brabant,/g' userat.bin
	sed -i 's/,WHT,/,Hainaut,/g' userat.bin
	sed -i 's/,WI,/,Wisconsin,/g' userat.bin
	sed -i 's/,WLG,/,Leige,/g' userat.bin
	sed -i 's/,WLX,/,Luxembourg,/g' userat.bin
	sed -i 's/,WNA,/,Namur,/g' userat.bin
	sed -i 's/,WV,/,W. Virginia,/g' userat.bin
	sed -i 's/,WY,/,Wyoming,/g' userat.bin
	sed -i 's/,YT,/,Yukon,/g' userat.bin
	sed -i 's/,ZE,/,Zeeland,/g' userat.bin
	sed -i 's/,ZH,/,S. Holland,/g' userat.bin
	sleep 1
	
	echo "Rearange collumns to Anytone format....."
	awk -F, '{print NR,$1,$2,$3,$4,$5,$7,"","Private Call","None"}' OFS=, "userat.bin" > userat1.csv
	sleep 1
	
	echo "Adding new header..."
	sed -e '1i\No.,Radio ID,Callsign,Name,City,State,Country,Remarks,Call Type,Call Alert\' userat1.csv > userat2.csv
	sleep 1
	
	echo "Format csv with CR LF....."
	awk 'sub("$","\r")' userat2.csv > userat.csv
	sleep 1
	
	echo "Remove temp files..."
	rm userat.bin
	rm userat1.csv
	rm userat2.csv
	sleep 1
	
	echo "Ready: userat.csv for Anytone created."
	sleep 3
}
#Flash to Radios
#
#
function flashmd380Database {
        clear
        echo "Flash database to MD380/390"
        read -n 1 -s -r -p "Connect your HT and press any key to continue"
        echo ""
        ./md380-tool spiflashwrite user.bin 0x100000
        sleep 3
	}
function flashmd2017Database {
        clear
        echo "Flash database to MD2017"
        read -n 1 -s -r -p "Connect your HT and press any key to continue"
        echo ""
        ./dmrconfig -u usermd2017.csv
        sleep 3
        }
function flashanytoneDatabase {
        clear
        echo "Flash database to Anytone"
        read -n 1 -s -r -p "Connect your HT and press any key to continue"
        echo ""
        ./dmrconfig -u userat.csv
        sleep 3
	}
#Remove Databases
#
#
function removegitDatabase {
        clear
        echo "Remove all github databases..."
        read -n 1 -s -r -p "Press any key to continue"
        echo ""
        git rm --cached userhd.csv
        git rm --cached userat.csv
        git rm --cached usermd2017.csv
        git rm --cached user.bin
        git commit -m "<remove databases>"
        git push
        sleep 3
}
function removelocalDatabase {
	clear
        echo "Remove all local databases..."
        read -n 1 -s -r -p "Press any key to continue"
        echo ""
        rm user*.bin
        rm user*.csv
        sleep 3
}
#Database upload
#
#
function uploadconvDatabase {
	clear
	echo "Upload converted databases to github"
	echo "Adding userhd.csv to git"
	git add userhd.csv
	echo "commit new filecomment ..."
	git commit -m "<new HD1 database *autogenerated* by pd2emc>"
	echo "git push files ..........."
	git push
	sleep 3

	clear
	echo "Adding usermd2017.csv to git"
	git add usermd2017.csv
	echo "commit new filecomment ..."
	git commit -m "<new MD2017 database *autogenerated* by pd2emc>"
	echo "git push files ..........."
	git push
	sleep 3

	clear
	echo "Adding userat.csv to git"
	git add userat.csv
	echo "commit new filecomment ..."
	git commit -m "<new Anytone database *autogenerated* by pd2emc>"
	echo "git push files ..........."
	git push
	sleep 3
}
function uploaduserDatabase {
	clear
	echo "Upload user.bin to github"
	echo "Adding user.bin to git"
	git add user.bin
	echo "commit new filecomment ..."
	git commit -m "<new user.bin database by pd1wp>"
	echo "git push files ..........."
	git push
	sleep 3
}
function newmenuDatabase {
	clear
	echo "Make new bmmenu.bin"
	shc -f menu.sh
	mv menu.sh.x bmmenu.bin 
        echo "Upload new bmmenu.bin to github"
        echo "Adding user.bin to git"
	git add bmmenu.bin 
        echo "commit new filecomment ..."
        git commit -m "<new bmmenu.bin by pd2emc>"
        echo "git push files ..........."
        git push
        sleep 5
}
#
#
#End Functions

#Start Main Menu
#
#
cmd=(dialog  \
--separate-output \
--clear \
--ok-label "Run selected tasks" \
--cancel-label "Exit from Menu" \
--title "Brandmeister User Database Tool" \
--checklist "-------Please choose your options and select Run selected tasks-------" 22 76 16)

options=(
1 "Remove old and download new database" off
2 "Download new database with git pull" off
3 "Convert user.bin to Anytone 868/878 format" off
4 "Convert user.bin to TYT MD2017 format" off
5 "Convert user.bin to Ailunce HD1 format" off
6 "Upload converted database back to github" off
7 "Upload user.bin back to github *use with care*" off
8 "Flash local converted database to TYT MD380/390" off
9 "Flash local converted database to TYT MD2017" off
10 "Flash local converted database to Anytone 868/878" off
11 "Download and flash database to TYT MD380/390" off
12 "Download and flash database to TYT MD2017" off
13 "Download and flash database to Anytone 868/878" off
97 "Make new menu and upload to git" off
98 "Remove databases from github *use with care*" off
99 "Remove databases from local folder" off)

while true; do
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    # If cancelled, drop the dialog
    if [ $? -ne 0 ]; then
    clear;
    echo "73 from the Database Team PD1WP - PD2EMC - PD1LOI";
    exit;
fi;
#End

#Run functions Menu
#
#
for choice in $choices ; do
    case $choice in
    1)
	wgetDatabase
	;;
	2)
	gitDatabase
	;;
	3)
	convanytoneDatabase
	;;
        4)
	convmd2017Database
	;;
        5)
	convhd1Database
	;;
        6)
	uploadconvDatabase
	;;
        7)
	uploaduserDatabase
	;;
	8)
        flashmd380Database
	;;
	9)
        flashmd2017Database
	;;
	10)
	flashanytoneDatabase
	;;
	11)
        dlmd380Database
        flashmd380Database
	;;
	12)
        dlmd2017Database
        flashmd2017Database
	;;
	13)
        dlanytoneDatabase
        flashanytoneDatabase
	;;
        97)
        newmenuDatabase
        ;;
	98)
	removegitDatabase
	;;
	99)
        removelocalDatabase
        ;;
	*)
	exit
	;;
	esac
  done
done
#End
