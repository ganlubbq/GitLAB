Files:

Filename:  multi_sst_TF_main.m
	   The main implementation of the multivariate time-frequency representation based on the synchrosqueezing transform.
	   The complementary files used for this matlab file are: multi_bandwidth.m and multi_bandwidth_check.m 

Filename: sst_wavelet_linear.m
	  Linear implementation of the wavelet based synchrosqueezing transform.

Filename: cwavelet_transform.m 
          Continuous wavelet transform implementing both the morlet and bump wavelets. 

Filename: example_code.m 

	  This file provides 4 multivariate time-frequency representations, illustrating the performance of the algorithm. 
          -The first simulation consists of bivariate noisy sinusoidal oscillation with a small frequency deviation between 
	  each channel.	
	  - The second simulation consists of bivariate frequency modulated oscillation with a small frequency deviation between 
	  each channel.	
	  -The third simulation consists of float drift data.
	  -The fourth simulation consits of bivariate doppler radar data pertaining to the motion of a robotic device. 	 		