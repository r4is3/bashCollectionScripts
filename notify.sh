#!/bin/bash
# -*- coding:UTF8 -*-



## Be carefull of event to monitor : some file are copied or instead of CLOSE_WRITE
## Monitor event on the specified file and rsync it on the backup server
## usefull for automated backup of file as /etc/passwd, conf file...
if [[ $# -ne 2  ]]  
then
        echo -e "Usage : notify EVENT FILE\nWhere EVENT is :\n\tCLOSE_WRITE; DELETE_SELF or MOVED_SELF\n\t(see man inotifywait for details)\nFILE is the file you want to monitor\nBe carefull of the nice priority"
        exit 1
else
        while  [ 1 ] 
        do
                inotifywait -t 1 -e $1  -q --format '%w%f' $2 | 
                while read nom_du_fichier
                do
                        echo $nom_du_fichier
			## Here you ca perform everything you want on file
                        rsync -avvoghzp --chmod=u+rw,g-rwx,o-rwx -e 'ssh -p22' $nom_du_fichier wherever@youwant:/path/
                done
        done
fi

    
