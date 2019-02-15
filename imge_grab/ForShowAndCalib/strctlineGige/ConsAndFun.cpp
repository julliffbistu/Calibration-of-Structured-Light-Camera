#include "ConsAndFun.h"
extern const string MainWin;
int64_t newWidth = 1626;
int64_t newHeight = 196;
int64_t exposuretime = 1000;
int64_t exposuretime2 = 1000;
int maxcols = newHeight - 20;
int th = 200;

double epsilon = 2.5;
double epsilon2 =1.5;
int64 t0;
int framecount = 0;
double fps_tracker = 0;
int roi_x = 10, roi_y = 10;

///////////////////////Replace 1//////////////////////////////////
double fu = 1372.173685;
double fv = 1375.475318;
double u0 = 803.5369344;
double v0 = 644.3114906;
double k1 = -0.2130440921;
double k2 = 0.1951889319;
double k3 = 0;
double p1 = -0.00281317717;
double p2 = -7.482228702e-05;
double a1 = 133.4625046;
double a2 = -0.04490296512;
double a3 = 0.9885814037;

///////////////////////Replace 1//////////////////////////////////
int SaveCalib(Mat frame,int fk)
{
	int SpacePress = 1;
	char filename[200];

	if (frame.empty())
	{
		fprintf(stderr, "Can not load the image file.\n");
		return false;
	}
	char key = (char)waitKey(1); //delay N millis, usually long enough to display and capture input

	switch (key) {
	case 'q':
	case 'Q':
	case 27: //escape key
		return false;
	case ' ': //Save an image
		sprintf_s(filename, "exp%d_num_%d.bmp", fk,framecount);
		imwrite(filename, frame);		 
			SpacePress = 2;
		 
		cout << "Saved " << filename << endl;
		break;
	default:
		 
		break;
	}
	framecount++;
	if (framecount % 10 == 0)
	{
		double t1 = cv::getTickCount();
		fps_tracker = 10.0 / (double(t1 - t0) / cv::getTickFrequency());
		t0 = t1;
	}
	char fpsC[255];
	sprintf_s(fpsC, "%d", (int)fps_tracker);
	std::string fpsSt("FPS:");
	fpsSt += fpsC;
	 
	cv::putText(frame, fpsSt, cv::Point(10, 20), CV_FONT_HERSHEY_SIMPLEX, 0.5, CV_RGB(255, 0, 0));
	Mat Small;
	resize(frame, Small, Size(813, 600));
	imshow(MainWin, Small);
	
	return SpacePress;
}