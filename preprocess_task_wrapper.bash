#!/bin/bash
rootdir='/Volumes/TX/Autism_Faces/subject_data/'
REMOVEALL="YES" 
set -x

script=$(cd $(dirname $0);pwd)/preprocess_task_wf.bash

cd ${rootdir}/

for subjID in $(ls -d 1* 2*); do
   #for subjID in 1* 2*; do
   export subjID=$subjID  
   $script || echo "$subjID failed" |  mail -s "error $(date +%F)" aclynn11@gmail.com    
done

echo "finished!" |  mail -s "done $(date +%F)" aclynn11@gmail.com    

