#include <stdio.h>
#include <iostream>
#include <stdio.h>
#include <opencv.hpp>
#include <opencv2/highgui/highgui.hpp>  
#include "opencv2/objdetect/objdetect.hpp"
#include <opencv2/imgproc/imgproc.hpp>  
#include <opencv2/core/core.hpp>  
#include <highgui.h> 
#include <pylon/PylonIncludes.h>
#ifdef PYLON_WIN_BUILD
#    include <pylon/PylonGUI.h>
#endif
 
using namespace Pylon;
using namespace GenApi;

using namespace std;
using namespace cv;
extern int64_t newWidth ;
extern int64_t newHeight  ;
extern int64_t exposuretime  ;
extern int64_t exposuretime2;
extern double  yoffset  ;
extern int th ;
extern int maxcols;
 
extern double epsilon ;
extern double epsilon2;
extern int64 t0;
extern int framecount  ;
extern double fps_tracker  ;
extern int roi_x , roi_y  ;

 
extern double fu ;
extern double fv ;
extern double u0 ;
extern double v0 ;
extern double k1 ;
extern double k2;
extern double p1 ;
extern double p2;
extern double k3 ;

extern double a1, a2, a3;

///////////////Па»ъ//////////
extern void undist(double x, double y, double result[2]);

extern void undistOffset(double x, double y, double result[2]);


extern const string MainWin ;
extern  int SaveCalib(Mat frame,int fk);
extern bool imageProcessmain(Mat frame);
 