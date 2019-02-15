#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv.hpp>
#include <opencv2/highgui/highgui.hpp>  
#include "opencv2/objdetect/objdetect.hpp"
#include <opencv2/imgproc/imgproc.hpp>   
#include <highgui.h>

 
using namespace cv;
extern bool imageProcessmain(Mat frame);
///////////////
int main(int argc, char* argv[])
{
	Mat frame = imread("filename2615.bmp");
	double duration_ms ,start;
	//transpose(frame, frame);

    start = double(getTickCount());	
	imageProcessmain(frame);
     duration_ms = (double(getTickCount()) - start) * 1000 / getTickFrequency();
	std::cout << "It took " << duration_ms << " ms." << std::endl;
	
	waitKey();
}