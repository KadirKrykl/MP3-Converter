#!/bin/bash
FORM=${FORM=dialog}
DIRECTORY=`$FORM --backtitle "MP3 Converter" --stdout --title "Where are your music?" --dselect $HOME/ 14 48`

case $? in
	0)
		rm -f dr.txt
		find $DIRECTORY -name "*.ogg"  >> dr.txt
		find $DIRECTORY -name "*.flac" >> dr.txt
		sed -i -e 's/ //g' dr.txt
		dirList=""
		n=1
		for pkg in $(cat dr.txt)
		do
			dirList="$dirList $(basename $pkg) $n off"
			n=$[n+1]
		done
		echo $dirList
		choices=`$FORM --backtitle "MP3 Converter" --stdout --checklist "Choose item:" 80 40 20 $dirList`
		if [ $? -eq 0 ]
		then
			for s in $choices
			do
				case ${s: (-3) } in
				ogg)
					a=$(find $DIRECTORY -name "$s")
  					ffmpeg -i "$a" -acodec libmp3lame -map_metadata 0:s:0 "${a[@]/%ogg/mp3}";;
				lac)
					a=$(find $DIRECTORY -name "$s")
  					ffmpeg -i $a -acodec libmp3lame "${a[@]/%flac/mp3}";;
				esac
			done
		else
			echo "Cancel Selected"
		fi;;
	1)
		echo "Cancel pressed.";;
	255)
		echo "Box closed.";;
esac