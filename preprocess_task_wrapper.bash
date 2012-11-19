#!/bin/bash
rootdir='/Volumes/TX/Autism_Faces/subject_data/'
REMOVEALL="YES" 
MAXJOBS=5
set -x

script=$(cd $(dirname $0);pwd)/preprocess_task_wf.bash
logDir=$(cd $(dirname $0);pwd)/logs/
[ -d $logDir ] || mkdir -p $logDir

cd ${rootdir}/

for subjID in $(ls -d 1* 2*); do

   # if we've put more than $MAXJOBS in the background
   # sleep for a little bit
   while [ $(jobs |wc -l) -ge $MAXJOBS ]; do
    sleep 100
   done

   #for subjID in 1* 2*; do
   export subjID=$subjID  

   # () &    means execute all that within and fork to background
   ( ($script || echo "$subjID failed" |  mail -s "error $(date +%F)" aclynn11@gmail.com) 2>&1 | tee $logDir/$subjID.$(date +%F).log    ) &
done

echo "finished!" |  mail -s "done $(date +%F)" aclynn11@gmail.com    

