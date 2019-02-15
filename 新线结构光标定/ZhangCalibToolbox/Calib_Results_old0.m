% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 991.661188936437950 ; 992.582412027753660 ];

%-- Principal point:
cc = [ 398.184560900510580 ; 280.912420849063610 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.077437371976447 ; 0.187434880796541 ; 0.001214952581970 ; -0.000041002438753 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 6.701787711285401 ; 5.556593837755655 ];

%-- Principal point uncertainty:
cc_error = [ 0.772796083217285 ; 6.033823586363201 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.002309965221586 ; 0.019914501081477 ; 0.000394180706033 ; 0.000245378076488 ; 0.000000000000000 ];

%-- Image size:
nx = 782;
ny = 582;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 15;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -1.954915e+00 ; -2.025166e+00 ; -4.235833e-01 ];
Tc_1  = [ -1.887023e+01 ; -2.912521e+01 ; 2.789531e+02 ];
omc_error_1 = [ 1.962653e-03 ; 2.099978e-03 ; 3.068862e-03 ];
Tc_error_1  = [ 2.177136e-01 ; 1.732404e+00 ; 1.879332e+00 ];

%-- Image #2:
omc_2 = [ NaN ; NaN ; NaN ];
Tc_2  = [ NaN ; NaN ; NaN ];
omc_error_2 = [ NaN ; NaN ; NaN ];
Tc_error_2  = [ NaN ; NaN ; NaN ];

%-- Image #3:
omc_3 = [ -2.065111e+00 ; -2.024897e+00 ; -3.156071e-01 ];
Tc_3  = [ -1.156889e+01 ; -1.893489e+01 ; 2.817675e+02 ];
omc_error_3 = [ 1.487174e-03 ; 1.536224e-03 ; 2.266366e-03 ];
Tc_error_3  = [ 2.194859e-01 ; 1.736816e+00 ; 1.905334e+00 ];

%-- Image #4:
omc_4 = [ NaN ; NaN ; NaN ];
Tc_4  = [ NaN ; NaN ; NaN ];
omc_error_4 = [ NaN ; NaN ; NaN ];
Tc_error_4  = [ NaN ; NaN ; NaN ];

%-- Image #5:
omc_5 = [ -2.057523e+00 ; -2.077491e+00 ; -2.763176e-01 ];
Tc_5  = [ -1.538511e+01 ; -2.329708e+01 ; 2.792018e+02 ];
omc_error_5 = [ 1.220960e-03 ; 1.269756e-03 ; 1.940137e-03 ];
Tc_error_5  = [ 2.176507e-01 ; 1.726210e+00 ; 1.891585e+00 ];

%-- Image #6:
omc_6 = [ NaN ; NaN ; NaN ];
Tc_6  = [ NaN ; NaN ; NaN ];
omc_error_6 = [ NaN ; NaN ; NaN ];
Tc_error_6  = [ NaN ; NaN ; NaN ];

%-- Image #7:
omc_7 = [ -2.092101e+00 ; -1.996197e+00 ; -3.006994e-01 ];
Tc_7  = [ -1.684361e+01 ; -3.453957e+01 ; 2.748135e+02 ];
omc_error_7 = [ 1.486683e-03 ; 1.439845e-03 ; 2.158863e-03 ];
Tc_error_7  = [ 2.149185e-01 ; 1.714196e+00 ; 1.858036e+00 ];

%-- Image #8:
omc_8 = [ NaN ; NaN ; NaN ];
Tc_8  = [ NaN ; NaN ; NaN ];
omc_error_8 = [ NaN ; NaN ; NaN ];
Tc_error_8  = [ NaN ; NaN ; NaN ];

%-- Image #9:
omc_9 = [ -2.058640e+00 ; -2.075059e+00 ; -2.871896e-01 ];
Tc_9  = [ -6.827136e+01 ; -1.538061e+01 ; 2.833200e+02 ];
omc_error_9 = [ 1.260654e-03 ; 1.300546e-03 ; 2.084334e-03 ];
Tc_error_9  = [ 2.205558e-01 ; 1.741407e+00 ; 1.921591e+00 ];

%-- Image #10:
omc_10 = [ NaN ; NaN ; NaN ];
Tc_10  = [ NaN ; NaN ; NaN ];
omc_error_10 = [ NaN ; NaN ; NaN ];
Tc_error_10  = [ NaN ; NaN ; NaN ];

%-- Image #11:
omc_11 = [ -1.924706e+00 ; -2.058824e+00 ; -4.284817e-01 ];
Tc_11  = [ -7.986991e+01 ; -4.591123e+01 ; 2.623239e+02 ];
omc_error_11 = [ 1.906171e-03 ; 2.010524e-03 ; 3.165043e-03 ];
Tc_error_11  = [ 2.055936e-01 ; 1.653862e+00 ; 1.774178e+00 ];

%-- Image #12:
omc_12 = [ NaN ; NaN ; NaN ];
Tc_12  = [ NaN ; NaN ; NaN ];
omc_error_12 = [ NaN ; NaN ; NaN ];
Tc_error_12  = [ NaN ; NaN ; NaN ];

%-- Image #13:
omc_13 = [ -1.891606e+00 ; -1.907689e+00 ; -5.314404e-01 ];
Tc_13  = [ -3.696657e+01 ; -4.560581e+01 ; 2.586108e+02 ];
omc_error_13 = [ 2.584076e-03 ; 2.574764e-03 ; 3.476015e-03 ];
Tc_error_13  = [ 2.036143e-01 ; 1.630058e+00 ; 1.747871e+00 ];

%-- Image #14:
omc_14 = [ NaN ; NaN ; NaN ];
Tc_14  = [ NaN ; NaN ; NaN ];
omc_error_14 = [ NaN ; NaN ; NaN ];
Tc_error_14  = [ NaN ; NaN ; NaN ];

%-- Image #15:
omc_15 = [ -1.875675e+00 ; -1.931935e+00 ; -5.390050e-01 ];
Tc_15  = [ -1.190377e+01 ; -4.575919e+01 ; 2.585077e+02 ];
omc_error_15 = [ 2.536843e-03 ; 2.599451e-03 ; 3.564454e-03 ];
Tc_error_15  = [ 2.031366e-01 ; 1.629088e+00 ; 1.743371e+00 ];

