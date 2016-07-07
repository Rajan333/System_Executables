#!/bin/bash
 
convert_vid()
{
    if [[ $1 ]]
    then
        
        filename=$(basename "$1")
        filename=${filename%.*}
       
        #making new directory with same filename
        mkdir $filename
        directory=$filename
     
        duration=$(ffmpeg -i "$1" 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)
        echo $duration > "$directory/$filename.log"

        minutes=${duration%:*}
        hours=${minutes%:*}
        minutes=${minutes##*:}
        seconds=${duration##*:}
        seconds=${seconds%.*}
     
        hours=$((10#$hours*3600))
        minutes=$((10#$minutes*60))

        total=$(expr $hours + $minutes + $seconds)
        number=$RANDOM
        let "number %= $total"
     
        echo "Generating thumbnail"
        ffmpeg -i "$1" -deinterlace -an -ss $number -t 00:00:01 -r 1 -y -vcodec mjpeg -f mjpeg "$directory/$filename.jpg" 2>&1
     
     
        echo "Converting $filename to h264"
        ffmpeg -i "$1"  -codec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 23 -b:v 800k -threads 6 -codec:a aac -strict experimental -b:a 128k -video_size 1280x720  "$directory/$filename.mp4" 2>&1 &
        echo "Finished h264"
        
        # waiting till all three formats are converted
        wait

        echo "Writing HTML..."
        
        echo "<pre>
        <video width'320' height='240' controls='controls' poster='$filename.jpg' preload=''><source src='$filename.mp4' type='video/mp4' />" > "$directory/$filename.html"
         
         echo " " >> "$directory/$filename.html"
         echo " Sorry, your browser does not support HTML5 video" >> "$directory/$filename.html"
         echo "</video>
        </pre>" >> "$directory/$filename.html"
         
        echo "All Done!"
    else
        echo "Usage: [filename]"
    fi    
}

# iterating over all files in directory
for file in *
 do
      # do something on $file
       if [ -f "$file" ]
       then
           convert_vid $file
       fi  
 done


