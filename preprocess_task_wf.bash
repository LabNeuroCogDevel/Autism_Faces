 #!/bin/bash
rootdir='/Volumes/TX/Autism_Faces/subject_data/'
REMOVEALL="YES" 
set -e
set -x


        cd ${rootdir}/

	echo "---------------------------"${subjID}"----------------------"
	#Make sure each subject has a directory
	if [ -d ${rootdir}/${subjID} ]; then
		
		#If Mprage has been preprocessed then delete the files and navigate to the anatomical directory to re-preprocess
		#if [ -f ${rootdir}/${subjID}/anatomical/mprage.nii.gz ]; then
			
			cd ${rootdir}/${subjID}/anatomical
                         
                        touch 'willberemovedinasec'
			
                        [ "$REMOVEALL"  == "YES" ] && find . -maxdepth 1 -not -iname \*dcm | grep -v '\.$' | xargs rm 

			#rm dimon.files*
			#rm GERT_Reco_dicom*
			#rm *.nii.gz
			#rm *.mat
			#rm *.log
                        # keep only DCM

			#removed -o mprage so the output is listed as mprage_nonlinear_2mm.nii.gz and mprage.nii.gz is the zipped dicom files
			preprocessMprage \
			-d n \
			-p '*.dcm' \

			
			cd ${rootdir}
		#fi
	fi
	
       #Perform preprocessingFunctional on each experiment (condition)
       for experi in 'experiment1' 'experiment2'; do
       
               for task in 'faces_usa' 'faces_aus' 'cars'; do
               
               
                  if [ -d ${rootdir}/${subjID}/${experi}/${task}/ ]; then
                          
                        cd ${rootdir}/${subjID}/${experi}/${task}/

                        [ "$REMOVEALL"  == "YES" ] && find . -maxdepth 1 -not -iname \*dcm | grep -v '\.$' | xargs rm 
                        #rm ${rootdir}/${subjID}/${experi}/${task}/*.nii.gz
                        #rm ${rootdir}/${subjID}/${experi}/${task}/*.mat
                        #rm ${rootdir}/${subjID}/${experi}/${task}/*.par
                        #rm ${rootdir}/${subjID}/${experi}/${task}/*.png
                                
                        preprocessFunctional \
                          -startover \
                          -dicom "*.dcm" \
                          -delete_dicom no \
                          -mprage_bet ../../anatomical/mprage_bet.nii*    \
                          -warpcoef ../../anatomical/mprage_warpcoef.nii* \
                          -rescaling_method 100_voxelmean	
                        cd ${rootdir}
                  fi

               done
       done
       
#zip rest files
   if [ -d ${rootdir}/${subjID}/rest/ ]; then
           
       cd ${rootdir}/${subjID}/rest/
         
       #convert dicom to nifti using Dimon
       Dimon \
           -infile_pattern "*dcm" \
           -GERT_Reco \
           -quit \
           -dicom_org \
           -sort_by_acq_time \
           -gert_write_as_nifti \
           -gert_create_dataset \
           -gert_to3d_prefix rest

       rm -f dimon.files*
       rm -f GERT_Reco_dicom*

       #if afnirc has compressor on, then above will already generate nii.gz
       if [ -f rest.nii ]; then
           gzip -f rest.nii #use -f to force overwrite in case where mprage.nii.gz exists, but we want to replace it.
       fi
    
       #default to LPI
       #hopefully the 3dresample bug is fixed:
       #http://afni.nimh.nih.gov/afni/community/board/read.php?f=1&i=39923&t=39923
       3dresample -overwrite -orient LPI -prefix "rest.nii.gz" -inset "rest.nii.gz"
       else continue;
   fi
