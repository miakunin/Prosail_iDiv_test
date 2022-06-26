# source file
SRC=MODULE_PRO4SAIL.f90 dataSpec_P5B.f90 main_PROSAIL.f90 LIDF.f90 dladgen.f PRO4SAIL.f90 prospect_5B.f90 tav_abs.f90 volscatt.f90
OBJ=MODULE_PRO4SAIL.o dataSpec_P5B.o main_PROSAIL.o LIDF.o dladgen.o PRO4SAIL.o prospect_5B.o tav_abs.o volscatt.o
#SRC_PRECIP=main_cosmo_tot_precip_comparison.f90 coord_lookup_function_precip_no_weight.f90
#OBJ_PRECIP=main_cosmo_tot_precip_comparison.o coord_lookup_function_precip_no_weight.o

# compiler
FC = gfortran

# compile flags
FCFLAGS = -g -O3# -Wall

# link flags
FLFLAGS = -lnetcdff -lnetcdf

# include path
#INC = /p/software/jurecadc/stages/2020/software/netCDF-Fortran/4.5.3-GCCcore-9.3.0-serial/include/

PROGRAM = PROSAIL_EXEC_w_interface
default: $(PROGRAM)

$(PROGRAM): $(OBJ)
	$(FC) -I$(INC) $(FCFLAGS) -o $@ $(FLFLAGS) $^

#%.o: %.f90
$(OBJ): $(SRC)
	$(FC) -I$(INC) $(FCFLAGS) -c $(FLFLAGS) $^


#ALT_PROGRAM = precipitation_get_and_compare
#precip: $(ALT_PROGRAM)

#$(ALT_PROGRAM): $(OBJ_PRECIP)
#	$(FC) -I$(INC) $(FCFLAGS) -o $@ $(FLFLAGS) $^

#$(OBJ_PRECIP): $(SRC_PRECIP)
#	$(FC) -I$(INC) $(FCFLAGS) -c $(FLFLAGS) $^

.PHONY: clean
clean:
	rm *.o

