# Prosail_iDiv_test

This small tweak for the PROSAIL RT model adds a simple I/O interface to the main program. It allows to make changes in the input parametres without recompiling the model.

Usage of the model is the following:

./PROSAIL_EXEC_w_interface $casename 

The $casename says to the model that it should use $casename.nml input file with input parametres and write the model ouput to the $casename.out.

If the $casename is not provided, a "default" values for the model parametres would be used (see in the code).

 
