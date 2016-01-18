#!/bin/bash

#System Dependencies: jq pip pycrypto zip

args=("$@")
# get number of elements
ELEMENTS=${#args[@]}


#Mount the cards
for (( i=0;i<$ELEMENTS;i++));
do
    
    mount /dev/sd"${args[${i}]}"2 /mnt/root$(($i+1))
    mount /dev/sd"${args[${i}]}"3 /mnt/content$(($i+1)) 

    #Setting paths of all directories
    ROOT_PATH="/mnt/root$(($i+1))"
    CONTENT_PATH="/mnt/content$(($i+1))"
    cat $ROOT_PATH/home/pi/resources/box.json | sed -e "s@/home@$ROOT_PATH/home@g" | sed -e "s@/tmp@$ROOT_PATH/tmp@g" | sed -e "s@/mnt/box_content@$CONTENT_PATH@g" > $ROOT_PATH/home/tmp_box.json
	
    export BOX_JSON="$ROOT_PATH/home/tmp_box.json"
	
    ENCRYPTED_LOGS=$(jq -r '.LOCATIONS.ENCRYPTED_LOGS' $BOX_JSON)
    UTILITIES=$(jq -r '.UTILS_DIR' $BOX_JSON)
    SCRIPTS=$(jq -r '.SCRIPTS_DIR' $BOX_JSON)
    RESOURCES=$(jq -r '.RESOURCES_DIR' $BOX_JSON)
    TARGET_DIR=$(jq -r '.LOGS.EXPORTED' $BOX_JSON)
    CONFIGURABLES=$(jq -r '.RESOURCES_DIR' $BOX_JSON)$(jq -r '.RESOURCES.CONFIGURABLES' $BOX_JSON)
    BOX_IDENTITY=$(jq -r '.RESOURCES_DIR' $BOX_JSON)$(jq -r '.RESOURCES.BOX_IDENTITY' $BOX_JSON)
    USER_LOGS=$(jq -r '.LOGS.USER_DIR' $BOX_JSON)
    SERVER_LOGS=$(jq -r '.LOGS.SERVER_DIR' $BOX_JSON)
    ZIP_NAME=${TARGET_DIR}"box_logs.zip"
    ARCHIVE_LOGS=$(jq -r '.LOGS.SERVER_ARCHIVE' $BOX_JSON)

    echo $BOX_JSON 
    echo $ENCRYPTED_LOGS 
    echo $UTILITIES 
    echo $SCRIPTS 
    echo $RESOURCES 
    echo $TARGET_DIR 
    echo $CONFIGURABLES 
    echo $BOX_IDENTITY 
    echo $USER_LOGS 
    echo $SERVER_LOGS
    echo $ZIP_NAME
    echo $ARCHIVE_LOGS


    #Creating directory if not present 
    mkdir -p $ENCRYPTED_LOGS
    rm -rf $ENCRYPTED_LOGS* 

    echo "[INFO] Packaging logs to encrypt..."
    #EXPORTED_FILE=`bash ${SCRIPTS}shell/export_logs`
    mkdir -p $TARGET_DIR
    rm -rf $TARGET_DIR/*
    cp -p $USER_LOGS* $TARGET_DIR >/dev/null 2>&1 || :
    cp -p $SERVER_LOGS* $TARGET_DIR >/dev/null 2>&1 || :
    cp -p $SERVER_ARCHIVE* $TARGET_DIR >/dev/null 2>&1 || :
    cp -p $CONFIGURABLES $TARGET_DIR >/dev/null 2>&1 || :
    cp -p $BOX_IDENTITY $TARGET_DIR >/dev/null 2>&1 || :
    zip $ZIP_NAME $TARGET_DIR* >/dev/null 2>&1 || 
    find $TARGET_DIR -type f ! -name "*.zip" -exec rm -rf {} \;

    EXPORTED_FILE=`echo $ZIP_NAME`

    if [ ! -e "$EXPORTED_FILE" ]; then
        echo "[ERROR] No exported file found at ${EXPORTED_FILE}. Exiting..."
        exit 2;
    fi

    echo "[INFO] Encrypting logs..." 
    python ${UTILITIES}veil/pi-veiler.py $EXPORTED_FILE $ENCRYPTED_LOGS
    FILE=`ls $ENCRYPTED_LOGS`

    
    if [ $? == "0" ]; then
        echo '[SUCCESS] Encrypted logs ready'
    else
        echo "[ERROR] Unable to encrypt logs"
    fi;

   #SEND POST REQUEST TO A URL 
   echo $EXPORTED_FILE
   curl -i -F "file=@$ENCRYPTED_LOGS$FILE" -F "email=dubeymaharaj@gmail.com" -F "mac_addr=hh:hh:hh:hh:hh:hh" http://lumber.pressplaytv.in/veil/


   umount /mnt/root$(($i+1)) 
   umount /mnt/content$(($i+1))
done
