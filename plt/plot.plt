set terminal pngcairo enhanced size 1200,900 font ",15"

set output "extensive.png"

set xrange [400:2500]
set xlabel "Wavelength, nm"
set xtics 200

set grid
set ylabel "Reflectance"


set output "intensive-extensive_grasslands.png"
set multiplot layout 2,1 

set label "Extensive use" at 450,0.55
plot	"../extensive_spring.out" u 1:2 t "Spring" w l lc rgb "green" lw 2 ,\
			"../extensive_summer.out" u 1:2 t "Summer" w l lc rgb "orange" lw 2 ,\
			"../extensive_autumn.out" u 1:2 t "Autumn" w l lc rgb "brown" lw 2 

unset label

set label "Intensive use" at 450,0.55
plot	"../intensive_spring.out" u 1:2 t "Spring" w l lc rgb "green" lw 2 ,\
			"../intensive_summer.out" u 1:2 t "Summer" w l lc rgb "orange" lw 2 ,\
			"../intensive_autumn.out" u 1:2 t "Autumn" w l lc rgb "brown" lw 2 
unset label
unset multiplot



set terminal pngcairo enhanced size 2400,1800 font ",16"
set output "sensitivity_tests.png"
set multiplot layout 3,3 title "Sensitivity tests" font ",18"

plot	"../sens_test_LAI_2_Cab_30.out" u 1:2 t "LAI 2.0" w l lw 2 ,\
			"../sens_test_LAI_3_Cab_30.out" u 1:2 t "LAI 3.0" w l lw 2 ,\
			"../sens_test_LAI_4_Cab_30.out" u 1:2 t "LAI 4.0" w l lw 2 ,\
			"../sens_test_LAI_5_Cab_30.out" u 1:2 t "LAI 5.0" w l lw 2 ,\
			"../sens_test_LAI_6_Cab_30.out" u 1:2 t "LAI 6.0" w l lw 2 ,\
			"../sens_test_LAI_7_Cab_30.out" u 1:2 t "LAI 7.0" w l lw 2

plot	"../sens_test_LAI_3_Cab_20.out" u 1:2 t "Cab 20" w l lw 2 ,\
			"../sens_test_LAI_3_Cab_25.out" u 1:2 t "Cab 25" w l lw 2 ,\
			"../sens_test_LAI_3_Cab_30.out" u 1:2 t "Cab 30" w l lw 2 ,\
			"../sens_test_LAI_3_Cab_35.out" u 1:2 t "Cab 35" w l lw 2 ,\
			"../sens_test_LAI_3_Cab_40.out" u 1:2 t "Cab 40" w l lw 2 

plot	"../sens_test_LAI_3_Car_5.out" u 1:2 t "Car 5" w l lw 2 ,\
			"../sens_test_LAI_3_Car_6.out" u 1:2 t "Car 6" w l lw 2 ,\
			"../sens_test_LAI_3_Car_7.out" u 1:2 t "Car 7" w l lw 2 ,\
			"../sens_test_LAI_3_Car_8.out" u 1:2 t "Car 8" w l lw 2

plot	"../sens_test_LAI_3_Cbrown_000.out" u 1:2 t "Cbrown 0.00" w l lw 2 ,\
			"../sens_test_LAI_3_Cbrown_005.out" u 1:2 t "Cbrown 0.05" w l lw 2 ,\
			"../sens_test_LAI_3_Cbrown_010.out" u 1:2 t "Cbrown 0.10" w l lw 2 ,\
			"../sens_test_LAI_3_Cbrown_020.out" u 1:2 t "Cbrown 0.20" w l lw 2

plot	"../sens_test_LAI_3_Cm_0003.out" u 1:2 t "Cm 0.003" w l lw 2 ,\
			"../sens_test_LAI_3_Cm_0005.out" u 1:2 t "Cm 0.005" w l lw 2 ,\
			"../sens_test_LAI_3_Cm_0007.out" u 1:2 t "Cm 0.007" w l lw 2 ,\
			"../sens_test_LAI_3_Cm_0010.out" u 1:2 t "Cm 0.010" w l lw 2 

plot	"../sens_test_LAI_3_Cw_001.out" u 1:2 t "Cw 0.01" w l lw 2 ,\
			"../sens_test_LAI_3_Cw_002.out" u 1:2 t "Cw 0.02" w l lw 2 ,\
			"../sens_test_LAI_3_Cw_003.out" u 1:2 t "Cw 0.03" w l lw 2

plot	"../sens_test_LAI_3_psoil_01.out" u 1:2 t "Psoil 0.1" w l lw 2 ,\
			"../sens_test_LAI_3_psoil_03.out" u 1:2 t "Psoil 0.3" w l lw 2 ,\
			"../sens_test_LAI_3_psoil_06.out" u 1:2 t "Psoil 0.6" w l lw 2 ,\
			"../sens_test_LAI_3_psoil_09.out" u 1:2 t "Psoil 0.9" w l lw 2

plot	"../sens_test_LAI_hspot_0005.out" u 1:2 t "hspot 0.005" w l lw 2 ,\
			"../sens_test_LAI_hspot_0010.out" u 1:2 t "hspot 0.010" w l lw 2 ,\
			"../sens_test_LAI_hspot_0015.out" u 1:2 t "hspot 0.015" w l lw 2

plot	"../sens_test_LAI_N_05.out" u 1:2 t "N 0.5" w l lw 2 ,\
			"../sens_test_LAI_N_10.out" u 1:2 t "N 1.0" w l lw 2 ,\
			"../sens_test_LAI_N_15.out" u 1:2 t "N 1.5" w l lw 2



unset multiplot
