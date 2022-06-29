# source file
SRC=MODULE_PRO4SAIL.f90 dataSpec_P5B.f90 main_PROSAIL.f90 LIDF.f90 dladgen.f PRO4SAIL.f90 prospect_5B.f90 tav_abs.f90 volscatt.f90
OBJ=MODULE_PRO4SAIL.o dataSpec_P5B.o main_PROSAIL.o LIDF.o dladgen.o PRO4SAIL.o prospect_5B.o tav_abs.o volscatt.o

# compiler
FC = gfortran

# compile flags
FCFLAGS = -g -O3# -Wall

# link flags
FLFLAGS = -lnetcdff -lnetcdf

# include path
#INC =
 
PROGRAM = PROSAIL_EXEC_w_interface
default: $(PROGRAM)

$(PROGRAM): $(OBJ)
	$(FC) -I$(INC) $(FCFLAGS) -o $@ $(FLFLAGS) $^

#%.o: %.f90
$(OBJ): $(SRC)
	$(FC) -I$(INC) $(FCFLAGS) -c $(FLFLAGS) $^

.PHONY: clean
clean:
	rm *.o

