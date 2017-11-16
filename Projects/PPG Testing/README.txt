BENCHMARK data for RR estimation from the Photoplethysmogram used in 
W. Karlen, S. Raman, J. M. Ansermino, and G. A. Dumont, “Multiparameter respiratory rate estimation from the photoplethysmogram,” IEEE transactions on bio-medical engineering, vol. 60, no. 7, pp. 1946–53, 2013. DOI: 10.1109/TBME.2013.2246160 PMED: http://www.ncbi.nlm.nih.gov/pubmed/23399950

This data is free to use for research. Please cite above publication. 

Available on http://www.capnobase.org/index.php?id=857

****Revisions****

r3 11/02/2015 adds demographics information such as weight, age and ventilation mode to meta structure

r2 01/05/2013 fixes erronous reference.hr.pleth that were privously imported from signal that was not corrected for artifacts
              adds signal.ecg, labels.ecg, and reference.hr.ecg ; allows to compare hr against ECG 
  
r1 28/04/2013 initial public release




If you have questions about this data or other, contact: walter.karlen@ieee.org

Each mat file is one case of 8 minutes.
Structures names are:
% param: samplingrates and case name, ventilation mode
% meta:  meta information such as demographics
% signal: raw co2 and pleth signals
% labels: labels for beats, breaths and artifacts obtained from a human rater
% reference: trends derived from labels
% SFresults: RR obtained using Smart Fusion approach, and steps thereof


Credits for data collection go to 
Pediatric Anesthesia Research Team, Child and Family Research Institute, The University of British Columbia, Vancouver, Canada
http://part.cfri.ca