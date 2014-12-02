#!/bin/bash
# -*- coding:UTF8 -*-

## list all accounts except useless ones
for user in $(zmaccts -h | grep active | awk '{print $1}' | grep -v 'rfp\|ham.d_zezbe93\|spam.cfuo3nstyy\|virus-quarantine\|domain')
do      
        expireDate=$(zmprov ga $user | grep zimbraPasswordModifiedTime | cut -d' ' -f2 | cut -c-8)
        #toDate=$(date -d ${expireDate} +"%Y%m%d")
        thisDay=$(date +%Y%m%d)

        ## If remains less than 7 days to expiration send mail to user
        let T=($(date +%s -d $expireDate)-$(date +%s -d $thisDay))/86400
        count=$(echo $T | tr -d -)

        if [ $count -ge 358 ]
        then
                echo -e "$user expire dans : $count"
                (echo "Subject: Expiration de votre mot de passe";echo -e "Votre mot de passe va expirer dans moins de $count jours\nPas d'inquietude, le serveur vous proposera de le renouveler à la bonne date, vous n'avez rien à faire") | /opt/zimbra/postfix/sbin/sendmail $user
        fi
done

