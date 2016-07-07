#!/bin/bash

case "$1" in
       -I) INPUT_LOCATION=$2
           echo $INPUT_LOCATION ;;

       -O) OUTPUT_LOCATION=$2
           echo $OUTPUT_LOCATION ;;
        
       -lock) LOCK=$2
           echo $LOCK;;

        *) echo "Error: Unknown option " >&2
            exit 1;;
esac

case "$3" in
        -I) INPUT_LOCATION=$4
            echo $INPUT_LOCATION ;;

        -O) OUTPUT_LOCATION=$4
            echo $OUTPUT_LOCATION;;
        
        -lock) LOCK=$4
            echo $LOCK;;

        *) echo "Error: Unknown option" >&2
             exit 1;;
 esac

 if [[ $5 ]] 
 then
case "$5" in
    -I) INPUT_LOCATION=$6
        echo $INPUT_LOCATION ;;

    -O) OUTPUT_LOCATION=$6
        echo $OUTPUT_LOCATION ;;

    -lock) LOCK=$6
        echo $LOCK ;;
    
    *) echo "Error: Unknown option" >&2
        exit 1;;
esac
else
    LOCK="LOCK"
fi

convert_vid()
{
    
    if [[ $INPUT_FILE ]]
    then
      
    filename=$(basename "$INPUT_FILE")
    filename=${filename%.*}
    echo $filename
    
        
    #MEDIA_INFO=`mediainfo "$INPUT_FILE" | awk '/Height/ {print $3}'`      
    $MEDIA_INFO=`ffprobe -i "$INPUT_FILE" 2>&1 | awk '/Stream/ {print $1}' | sed 2d | sed 's/x/\ /' | awk '{print $2}'`
        
        echo $MEDIA_INFO
       
        if [ $MEDIA_INFO -ge 700 ];
        then
            
            touch "$OUTPUT_LOCATION/$LOCK.lock"
            ###### CREATING THUMBNAIL #######
#            ffmpeg -i "$INPUT_FILE" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"
            
            ##### CONVERTING TO H.264 ####### 
            ffmpeg -i "$INPUT_FILE" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 28 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4" 2>&1 
            rm "$OUTPUT_LOCATION/$LOCK.lock"

        elif [ $MEDIA_INFO -lt 700 -a $MEDIA_INFO -ge 450 ];
        then
            
            touch "$OUTPUT_LOCATION/$LOCK.lock"
            #####  CREATING THUMBNAIL #####
 #           ffmpeg -i "$INPUT_FILE" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"

            ##### CONVERTING TO H.264 #####
            ffmpeg -i "$INPUT_FILE" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 26 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4" 2>&1
            rm "$OUTPUT_LOCATION/$LOCK.lock"

        else
            touch "$OUTPUT_LOCATION/$LOCK.lock"
            #####  CREATING THUMBNAIL ######
  #          ffmpeg -i "$INPUT_FILE" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"
            
            #####  CONVERTING TO H.264 #####
            ffmpeg -i "$INPUT_FILE" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 25 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4"
            rm "$OUTPUT_LOCATION/$LOCK.lock"
        fi

        #echo "Generating thumbnail..." >> "$OUTPUT_LOCATION/$filename.log"
        #ffmpeg -i "$INPUT_FILE" -deinterlace -an -ss 00:00:01 -r 1 -y -vcodec mpeg -f mpeg "$OUTPUT_LOCATION/$filename.png" 2>&1
       # echo "Thumbnail created." >> "$OUTPUT_LOCATION/$filename.log"
        
        #echo "Converting $filename to h264..." >> "$OUTPUT_LOCATION/$filename.log"
        #ffmpeg -i "$INPUT_FILE" -codec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 23 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4" 2>&1 
        #echo "Finished h264" >> "$OUTPUT_LOCATION/$filename.log"

        
    fi

        
}

convert_vid1()
{

        filename=$(basename "$INPUT_LOCATION")
        filename=${filename%.*}
        echo $filename
        

        #MEDIA_INFO=`mediainfo "$INPUT_FILE" | awk '/Height/ {print {}'`
        $MEDIA_INFO=`ffprobe -i "$INPUT_LOCATION" 2>&1 | awk '/Stream/ {print $1}' | sed 2d | sed 's/x/\ /' | awk '{print $2}'`
        echo $MEDIA_INFO
                                        
        if [ $MEDIA_INFO -ge 700 ];
        then
            
            touch "$OUTPUT_LOCATION/$LOCK.lock"
            #####  CREATING THUMBNAIL ######
   #         ffmpeg -i "$INPUT_LOCATION" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"
            
            #####  CONVERTING TO H.264 #####
            ffmpeg -i "$INPUT_LOCATION" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 28 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4" 2>&1
            rm "$OUTPUT_LOCATION/$LOCK.lock"
            
         elif [ $MEDIA_INFO -lt 700 -a $MEDIA_INFO -ge 450 ];
         then
             touch "$OUTPUT_LOCATION/$LOCK.lock"

             #####  CREATING THUMBNAIL  #####
    #        ffmpeg -i "$INPUT_LOCATION" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"
             
             #####  CONVERTING TO H.264  #####
             ffmpeg -i "$INPUT_LOCATION" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 26 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4" 2>&1
             rm "$OUTPUT_LOCATION/$LOCK.lock"
                                                                                                                                                       
          else
             
             touch "$OUTPUT_LOCATION/$LOCK.lock"
            #####  CRETAING THUMBNAIL  #####
     #       ffmpeg -i "$INPUT_LOCATION" -ss 00:01:00 -vframes 1 "$OUTPUT_LOCATION/$filename.png"
            #####  CONVERTING TO H.264 #####
             ffmpeg -i "$INPUT_LOCATION" -vcodec:v libx264 -profile:v baseline -level 3.0 -movflags +faststart -crf 25 -b:v 800k -codec:a aac -strict experimental -b:a 128k -video_size 1280x720 "$OUTPUT_LOCATION/$filename.mp4"
             rm "$OUTPUT_LOCATION/$LOCK.lock"
         fi
     } 

echo "CONVERTING....."

if [ -f "$INPUT_LOCATION"  ]
 then
     convert_vid1
     echo "CONVERTED..."

 elif [ -d "$INPUT_LOCATION" ]
 then
    FILES=$INPUT_LOCATION"/*"
    #echo "FILES :" $FILES

    for file in $FILES
    do
        if [ -f "$file" ]
        then
          # echo "file : " $file
            INPUT_FILE=$INPUT_LOCATION/${file##*/}
    
            convert_vid $INPUT_FILE 
            echo "Converted..."
    
        fi
    done
fi


