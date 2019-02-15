% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1001.281092564833000 ; 1000.912149457235700 ];

%-- Principal point:
cc = [ 396.479259774417070 ; 290.307670124063240 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.090516856752780 ; 0.284507826875694 ; 0.000741228944649 ; 0.000033190953232 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 3.230065887219769 ; 2.844700969241886 ];

%-- Principal point uncertainty:
cc_error = [ 1.017419790358922 ; 2.517132170759868 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.005120365754802 ; 0.058776500695587 ; 0.000284196206636 ; 0.000335540569495 ; 0.000000000000000 ];

%-- Image size:
nx = 782;
ny = 582;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 21;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -1.999014e+00 ; -2.095964e+00 ; -5.369292e-01 ];
Tc_1  = [ -1.174800e+01 ; -2.270376e+01 ; 2.719629e+02 ];
omc_error_1 = [ 7.253438e-04 ; 1.291291e-03 ; 2.036354e-03 ];
Tc_error_1  = [ 2.762847e-01 ; 6.938539e-01 ; 8.737769e-01 ];

%-- Image #2:
omc_2 = [ NaN ; NaN ; NaN ];
Tc_2  = [ NaN ; NaN ; NaN ];
omc_error_2 = [ NaN ; NaN ; NaN ];
Tc_error_2  = [ NaN ; NaN ; NaN ];

%-- Image #3:
omc_3 = [ -1.919860e+00 ; -1.778347e+00 ; -1.307914e-01 ];
Tc_3  = [ -5.405291e+01 ; -2.741190e+01 ; 2.799769e+02 ];
omc_error_3 = [ 1.666218e-03 ; 1.120695e-03 ; 1.502654e-03 ];
Tc_error_3  = [ 2.866078e-01 ; 7.142663e-01 ; 8.381479e-01 ];

%-- Image #4:
omc_4 = [ NaN ; NaN ; NaN ];
Tc_4  = [ NaN ; NaN ; NaN ];
omc_error_4 = [ NaN ; NaN ; NaN ];
Tc_error_4  = [ NaN ; NaN ; NaN ];

%-- Image #5:
omc_5 = [ -2.196876e+00 ; -2.036362e+00 ; -6.949555e-01 ];
Tc_5  = [ -2.083097e+01 ; -1.769533e+01 ; 2.540938e+02 ];
omc_error_5 = [ 6.486644e-04 ; 1.510720e-03 ; 2.488755e-03 ];
Tc_error_5  = [ 2.588089e-01 ; 6.440169e-01 ; 7.893959e-01 ];

%-- Image #6:
omc_6 = [ NaN ; NaN ; NaN ];
Tc_6  = [ NaN ; NaN ; NaN ];
omc_error_6 = [ NaN ; NaN ; NaN ];
Tc_error_6  = [ NaN ; NaN ; NaN ];

%-- Image #7:
omc_7 = [ -1.917024e+00 ; -2.034238e+00 ; -4.417018e-01 ];
Tc_7  = [ -2.814145e+01 ; -2.381231e+01 ; 2.464148e+02 ];
omc_error_7 = [ 9.774718e-04 ; 1.256974e-03 ; 1.772827e-03 ];
Tc_error_7  = [ 2.505695e-01 ; 6.308710e-01 ; 7.943275e-01 ];

%-- Image #8:
omc_8 = [ NaN ; NaN ; NaN ];
Tc_8  = [ NaN ; NaN ; NaN ];
omc_error_8 = [ NaN ; NaN ; NaN ];
Tc_error_8  = [ NaN ; NaN ; NaN ];

%-- Image #9:
omc_9 = [ -1.984458e+00 ; -1.998101e+00 ; -4.081832e-01 ];
Tc_9  = [ -3.099162e+01 ; -2.683917e+00 ; 2.731853e+02 ];
omc_error_9 = [ 9.624130e-04 ; 1.227055e-03 ; 1.766905e-03 ];
Tc_error_9  = [ 2.771430e-01 ; 6.883376e-01 ; 8.814079e-01 ];

%-- Image #10:
omc_10 = [ NaN ; NaN ; NaN ];
Tc_10  = [ NaN ; NaN ; NaN ];
omc_error_10 = [ NaN ; NaN ; NaN ];
Tc_error_10  = [ NaN ; NaN ; NaN ];

%-- Image #11:
omc_11 = [ -2.148148e+00 ; -1.827496e+00 ; -2.521829e-01 ];
Tc_11  = [ -3.163567e+01 ; -1.637653e+01 ; 2.869187e+02 ];
omc_error_11 = [ 1.119055e-03 ; 1.039005e-03 ; 1.543254e-03 ];
Tc_error_11  = [ 2.919021e-01 ; 7.288293e-01 ; 9.194724e-01 ];

%-- Image #12:
omc_12 = [ NaN ; NaN ; NaN ];
Tc_12  = [ NaN ; NaN ; NaN ];
omc_error_12 = [ NaN ; NaN ; NaN ];
Tc_error_12  = [ NaN ; NaN ; NaN ];

%-- Image #13:
omc_13 = [ -2.426452e+00 ; -1.733028e+00 ; -1.920744e-01 ];
Tc_13  = [ -3.418983e+01 ; -8.295036e+00 ; 2.780860e+02 ];
omc_error_13 = [ 8.349854e-04 ; 7.854676e-04 ; 1.630003e-03 ];
Tc_error_13  = [ 2.831778e-01 ; 7.032139e-01 ; 8.872479e-01 ];

%-- Image #14:
omc_14 = [ NaN ; NaN ; NaN ];
Tc_14  = [ NaN ; NaN ; NaN ];
omc_error_14 = [ NaN ; NaN ; NaN ];
Tc_error_14  = [ NaN ; NaN ; NaN ];

%-- Image #15:
omc_15 = [ -2.305195e+00 ; -1.748038e+00 ; -2.485370e-01 ];
Tc_15  = [ -3.508400e+01 ; -6.779574e+00 ; 2.866476e+02 ];
omc_error_15 = [ 9.487184e-04 ; 9.132732e-04 ; 1.603379e-03 ];
Tc_error_15  = [ 2.916500e-01 ; 7.238456e-01 ; 9.242713e-01 ];

%-- Image #16:
omc_16 = [ NaN ; NaN ; NaN ];
Tc_16  = [ NaN ; NaN ; NaN ];
omc_error_16 = [ NaN ; NaN ; NaN ];
Tc_error_16  = [ NaN ; NaN ; NaN ];

%-- Image #17:
omc_17 = [ NaN ; NaN ; NaN ];
Tc_17  = [ NaN ; NaN ; NaN ];
omc_error_17 = [ NaN ; NaN ; NaN ];
Tc_error_17  = [ NaN ; NaN ; NaN ];

%-- Image #18:
omc_18 = [ NaN ; NaN ; NaN ];
Tc_18  = [ NaN ; NaN ; NaN ];
omc_error_18 = [ NaN ; NaN ; NaN ];
Tc_error_18  = [ NaN ; NaN ; NaN ];

%-- Image #19:
omc_19 = [ NaN ; NaN ; NaN ];
Tc_19  = [ NaN ; NaN ; NaN ];
omc_error_19 = [ NaN ; NaN ; NaN ];
Tc_error_19  = [ NaN ; NaN ; NaN ];

%-- Image #20:
omc_20 = [ NaN ; NaN ; NaN ];
Tc_20  = [ NaN ; NaN ; NaN ];
omc_error_20 = [ NaN ; NaN ; NaN ];
Tc_error_20  = [ NaN ; NaN ; NaN ];

%-- Image #21:
omc_21 = [ -1.964128e+00 ; -2.007272e+00 ; -4.166957e-01 ];
Tc_21  = [ -3.087569e+01 ; -2.536726e+01 ; 2.847639e+02 ];
omc_error_21 = [ 9.820929e-04 ; 1.210712e-03 ; 1.754684e-03 ];
Tc_error_21  = [ 2.897346e-01 ; 7.280472e-01 ; 9.178365e-01 ];

