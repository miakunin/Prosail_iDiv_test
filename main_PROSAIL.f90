!*************************************************************************
!*                                                                       *
	PROGRAM main_PROSAIL

	! 26 06 2022
	! M. Iakunin (m.yakunin89@gmail.com)
	! added an option to read main parametres from the namelist file

	! 09 22 2011
	! This program allows modeling reflectance data from canopy
	! - modeling leaf optical properties with PROSPECT-5 (feret et al. 2008)
	! - modeling leaf inclination distribution function with the subroutine campbell
	! (Ellipsoidal distribution function caracterised by the average leaf 
	! inclination angle in degree), or dladgen (2 parameters LIDF)
	! - modeling canopy reflectance with 4SAIL (Verhoef et al., 2007)
	
	! This version has been implemented by Jean-Baptiste Feret
	! Jean-Baptiste Feret takes the entire responsibility for this version 
	! All comments, changes or questions should be sent to:
	! jbferet@stanford.edu

	! References:
	! 	Verhoef et al. (2007) Unified Optical-Thermal Four-Stream Radiative
	! 	Transfer Theory for Homogeneous Vegetation Canopies, IEEE TRANSACTIONS 
	! 	ON GEOSCIENCE AND REMOTE SENSING, VOL. 45, NO. 6, JUNE 2007
	! 	Féret et al. (2008), PROSPECT-4 and 5: Advances in the Leaf Optical
	! 	Properties Model Separating Photosynthetic Pigments, REMOTE SENSING OF 
	! 	ENVIRONMENT
	! The specific absorption coefficient corresponding to brown pigment is
	! provided by Frederic Baret (EMMAH, INRA Avignon, baret@avignon.inra.fr)
	! and used with his autorization.
	! the model PRO4SAIL is based on a version provided by
	!	Wout Verhoef
	!	NLR	
	!	April/May 2003

	! The original 2-parameter LIDF model is developed by and described in:
	! 	W. Verhoef, 1998, "Theory of radiative transfer models applied in 
	!	optical remote sensing of vegetation canopies", Wageningen Agricultural
	!	University,	The Netherlands, 310 pp. (Ph. D. thesis)
	! the Ellipsoidal LIDF is taken from:
	!   Campbell (1990), Derivtion of an angle density function for canopies 
	!   with ellipsoidal leaf angle distribution, Agricultural and Forest 
	!   Meteorology, 49 173-176
!*                                                                       *
!*************************************************************************

	USE MOD_ANGLE				! defines pi & rad conversion
	USE MOD_staticvar			! static variables kept in memory for optimization
	USE MOD_flag_util			! flags for optimization
	USE MOD_output_PROSPECT		! output variables of PROSPECT
	USE MOD_SAIL				! variables of SAIL
	USE MOD_dataSpec_P5B		
	IMPLICIT NONE

! LEAF BIOCHEMISTRY
REAL*8 :: N,Cab,Car,Cbrown,Cw,Cm
! CANOPY
REAL*8 :: LAI,LIDFa,LIDFb,psoil
REAL*8 :: skyl,hspot,ihot
REAL*8 :: tts,tto,psi
REAL*8,ALLOCATABLE,SAVE :: resh(:),resv(:)
REAL*8,ALLOCATABLE,SAVE :: rsoil0(:),PARdiro(:),PARdifo(:)
INTEGER :: TypeLidf,ii
integer :: arg_num, funit, rc
character(len=256) :: case_name, input_name, output_name
logical OK

namelist /SAIL4/ LAI, hspot, tts, tto, psi, psoil
namelist /LEAF_CHEM/ Cab, Car, Cbrown, Cw, Cm, N

! ANGLE CONVERSION
pi=ATAN(1.)*4.
rd=pi/180.

! PROSPECT output
ALLOCATE (LRT(nw,2),rho(nw),tau(nw))
! SAIL
ALLOCATE (sb(nw),sf(nw),vb(nw),vf(nw),w(nw))
ALLOCATE (m(nw),m2(nw),att(nw),sigb(nw),rinf(nw))
ALLOCATE (PARdiro(nw),PARdifo(nw))
ALLOCATE(tsd(nw),tdd(nw),tdo(nw),rsd(nw),rdd(nw),rso(nw),rdo(nw))
ALLOCATE(rddt(nw),rsdt(nw),rdot(nw),rsodt(nw),rsost(nw),rsot(nw),rsos(nw),rsod(nw))
ALLOCATE(lidf(13))
! resh : hemispherical reflectance
! resv : directional reflectance
ALLOCATE (resh(nw),resv(nw))
ALLOCATE (rsoil_old(nw))

	TypeLidf=1
	! if 2-parameters LIDF: TypeLidf=1
	IF (TypeLidf.EQ.1) THEN
		! LIDFa LIDF parameter a, which controls the average leaf slope
		! LIDFb LIDF parameter b, which controls the distribution's bimodality
		!	LIDF type 		a 		 b
		!	Planophile 		1		 0
		!	Erectophile    -1	 	 0
		!	Plagiophile 	0		-1
		!	Extremophile 	0		 1
		!	Spherical 	   -0.35 	-0.15
		!	Uniform 0 0
		! 	requirement: |LIDFa| + |LIDFb| < 1	
		LIDFa	=	-0.35
		LIDFb	=	-0.15
	! if ellipsoidal distribution: TypeLidf=2
	ELSEIF (TypeLidf.EQ.2) THEN
		! 	LIDFa	= average leaf angle (degrees) 0 = planophile	/	90 = erectophile
		! 	LIDFb = 0
		LIDFa	=	30
		LIDFb	=	0
	ENDIF

!First, make sure the right number of inputs have been provided
if(COMMAND_ARGUMENT_COUNT().lt.1) then
  print*, "WARNING! No input filename was provided. Default parametres are used"

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !!  4SAIL canopy structure parm !!
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  LAI   = 3.    ! leaf area index (m^2/m^2)
  hspot = 0.01  ! hot spot
  tts   = 30.   ! solar zenith angle (°)
  tto   = 10.   ! observer zenith angle (°)
  psi   = 0.    ! azimuth (°)

  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  !!LEAF CHEM & STR PROPERTIES!!
  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ! INITIAL PARAMETERS
  Cab   = 40.   ! chlorophyll content (µg.cm-2) 
  Car   = 8.    ! carotenoid content (µg.cm-2)
  Cbrown  = 0.0   ! brown pigment content (arbitrary units)
  Cw    = 0.01  ! EWT (cm)
  Cm    = 0.009 ! LMA (g.cm-2)
  N   = 1.5   ! structure coefficient
  psoil = 1 

	output_name = "Refl_CAN_P5B.txt"
endif

if(COMMAND_ARGUMENT_COUNT().ge.1) then
  call GET_COMMAND_ARGUMENT(1,case_name)
  input_name = trim(case_name) // ".nml"
  output_name = trim(case_name) // ".out" 

  inquire (file=input_name, EXIST=OK)

  if ( .not. OK ) then
    print*, "Error: input file ", trim(input_name), " does not exist. Program terminated"
    stop
  endif

  print*, "Reading parametres from file ", input_name

  ! Open and read Namelist file.
  open (file=input_name, action="READ", status="OLD", newunit=funit)

  read (nml=SAIL4, iostat=rc, unit=funit)
  if (rc /= 0) then 
		print*, "Error: invalid Namelist format! Program terminated"
		stop
	endif

  read (nml=LEAF_CHEM, iostat=rc, unit=funit)
  if (rc /= 0) then 
		print*, "Error: invalid Namelist format! Program terminated"
		stop
	endif

	close(funit)
endif

	ALLOCATE (rsoil0(nw))
!	psoil	=	1.		! soil factor (psoil=0: wet soil / psoil=1: dry soil)
	rsoil0=psoil*Rsoil1+(1-psoil)*Rsoil2

	init_completed=.false.	! only at first call of PRO4SAIL

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!        CALL PRO4SAIL         !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	CALL PRO4SAIL(N,Cab,Car,Cbrown,Cw,Cm,LIDFa,LIDFb,TypeLIDF,LAI,hspot,tts,tto,psi,rsoil0)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!	direct / diffuse light	!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	! the direct and diffuse light are taken into account as proposed by:
	! Francois et al. (2002) Conversion of 400–1100 nm vegetation albedo 
	! measurements into total shortwave broadband albedo using a canopy 
	! radiative transfer model, Agronomie
	skyl	=	0.847- 1.61*sin((90-tts)*rd)+ 1.04*sin((90-tts)*rd)*sin((90-tts)*rd) ! % diffuse radiation
	! Es = direct
	! Ed = diffuse
	! PAR direct
	PARdiro	=	(1-skyl)*Es
	! PAR diffus
	PARdifo	=	(skyl)*Ed
	! resv : directional reflectance
	resv	= (rdot*PARdifo+rsot*PARdiro)/(PARdiro+PARdifo)
	OPEN (unit=11,file=output_name)
		WRITE(11,'(i4,f10.6)') (lambda(ii),resv(ii), ii=1,nw)
	CLOSE(11)

	print*, "Model OK"
	print*, "Output is written to ", trim(output_name)

STOP
END
