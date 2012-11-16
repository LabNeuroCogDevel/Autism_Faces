Autism_Faces
============

Processsing Autism fMRI data

* preprocess_task_wrapper.bash  
  * wraps around preprocess_task_wf.bash
  * sends email if error and when finished

* preprocess_task_wf.bash
  * expects subjID to be exported to the environment 
        export subjID=1101
        ./preprocess_task_wf.bash

TODO:
preprocess_task_wf.bash will fail if there are directories (needs rm -f)

