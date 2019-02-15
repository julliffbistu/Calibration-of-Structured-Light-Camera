#include "ConsAndFun.h"
#include "ConsAndFun2.h"

/////////////filesave
#include<iostream>
#include<fstream>
#include  <string >
#include<sstream>
using namespace std;
////////////filesave

const string MainWin = "The image";
double CenRefine[srccols] = { 0 };
int savecount = 1000;
char filename[200];
ofstream outfile;

int cut(int input, int low, int high)
{
	if (input < low)
		input = low;
	else if (input > high)
		input = high;
	return input;
}

void undist(double x, double y, double  result[])
{
	double x_d = (x - u0) / fu;
	double y_d = (y - v0) / fv;
	double r_2 = x_d*x_d + y_d*y_d;
	double  k_radial = 1 + k1 * r_2 + k2 * r_2*r_2 + k3 * r_2*r_2*r_2;
	double delta_x = 2 * p1 * (r_2 + 2 * x_d*y_d) + p2*(r_2 + x_d*x_d);
	double delta_y = p1 * (r_2 + 2 * y_d*y_d) + 2 * p2*x_d*y_d;
	result[0] = (x_d - delta_x) / k_radial*fu + u0;//x
	result[1] = (y_d - delta_y) / k_radial*fv + v0;//y

}
void undistOffset(double x, double y, double result[])  //畸变校正的次数还要再看看论文。
{
	double x_d = (x - u0) / fu;
	double y_d = (y - v0 + yoffset) / fv;
	double r_2 = x_d*x_d + y_d*y_d;
	double  k_radial = 1 + k1 * r_2 + k2 * r_2*r_2 + k3 * r_2*r_2*r_2;
	double delta_x = 2 * p1 * (r_2 + 2 * x_d*y_d) + p2*(r_2 + x_d*x_d);
	double delta_y = p1 * (r_2 + 2 * y_d*y_d) + 2 * p2*x_d*y_d;
	result[0] = (x_d - delta_x) / k_radial*fu + u0;//x
	result[1] = (y_d - delta_y) / k_radial*fv + v0;//y 	 
}
void threeD(double x, double y, double result[])
{
	double undistxy[2];
	undistOffset(x, y, undistxy);
	double Zc = a1 / (1.0f - a2*  (undistxy[0] - u0) / fu - a3*(undistxy[1] - v0) / fv);//Zc
	double Xc = Zc* ((undistxy[0] - u0)) / fu;//Xc
	double Yc = Zc * ((undistxy[1] - v0)) / fv;//Yc
	///////////////////////Replace 2 in StcuctlineProcess.cpp threeD//////////////////////////////////
	result[0] = 0.010748433028 *Xc + 0.714445324835*Yc + -0.699608711359*Zc + 120.703145227610;
	result[1] = 0.999512619870 *Xc + -0.028183231410*Yc + -0.013424909255*Zc + 37.707807237587;
	result[2] = -0.029308597862 *Xc + -0.699123439236*Yc + -0.714400043954*Zc + 98.406438411037;
	///////////////////////Replace 2 in StcuctlineProcess.cpp threeD//////////////////////////////////

}

double Pointdistance(double  x1, double y1, double x2, double y2)
{ //点点距离 

	return		   sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
}
double linelen(Vec4f line)
{ //线长
	double  x1 = line[0];
	double y1 = line[1];
	double x2 = line[2];
	double y2 = line[3];
	return		   sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
}
static double PointToSegDist(double x, double y, double x1, double y1, double x2, double y2)
{   //点线距离 其中x1y1,x2y2是线段
	double cross = (x2 - x1) * (x - x1) + (y2 - y1) * (y - y1);
	if (cross <= 0) return sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));

	double d2 = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
	if (cross >= d2) return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));

	double r = cross / d2;
	double px = x1 + (x2 - x1) * r;
	double py = y1 + (y2 - y1) * r;
	return sqrt((x - px) * (x - px) + (py - y1) * (py - y1));
}
static double PointToSegDist(double x, double y, Vec4f line)
{   //点线距离 其中x1y1,x2y2是线段
	double  x1 = line[0];
	double y1 = line[1];
	double x2 = line[2];
	double y2 = line[3];
	double cross = (x2 - x1) * (x - x1) + (y2 - y1) * (y - y1);
	if (cross <= 0) return sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1));

	double d2 = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
	if (cross >= d2) return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));

	double r = cross / d2;
	double px = x1 + (x2 - x1) * r;
	double py = y1 + (y2 - y1) * r;
	return sqrt((x - px) * (x - px) + (py - y1) * (py - y1));
}

void on_mouse(int event, int x, int y, int, void *)  //获取鼠标位置
{
	//if (event == EVENT_MOUSEMOVE) 
	{
		//Mat current_view;
		//image.copyTo(current_view);
		//rectangle(current_view, Point(x - winwidth, y - winheight), Point(x + winwidth, y + winheight), Scalar(0, 0, 255));
		//imshow(window_name, current_view);
		roi_x = x;
		roi_y = y;

	}
}
void showmouseRGB(Mat& src)  //获取鼠标位置
{
	Vec3b pixel;
	roi_y = cut(roi_y, 0, src.rows - 1);
	roi_x = cut(roi_x, 0, src.cols - 1);
	pixel = src.at<Vec3b>(roi_y, roi_x);
	char cC[255], cC1[255], cC2[255], cC3[255];
	sprintf_s(cC, "%d", (int)pixel[0]);
	sprintf_s(cC1, "%d", (int)pixel[1]);
	sprintf_s(cC2, "%d", (int)pixel[2]);
	sprintf_s(cC3, "%d", (int)(pixel[2] + pixel[1] + pixel[0]) / 3);
	std::string st("gray:");	st += cC3; st += " B:";
	st += cC;	st += " G:";	st += cC1;	st += " R:";	st += cC2;

	cv::putText(src, st, cv::Point(roi_x, roi_y), CV_FONT_HERSHEY_SIMPLEX, 0.5, CV_RGB(255, 0, 0));

}
void showmouse3D(Mat& src)  //获取鼠标位置
{
	roi_y = cut(roi_y, 0, src.rows - 1);
	roi_x = cut(roi_x, 0, src.cols - 1);
	double XYZ[3];
	threeD(roi_x, CenRefine[roi_x], XYZ);
	char cC[255], cC1[255], cC2[255], cC3[255];
	sprintf_s(cC, "%.4f", XYZ[0]);
	sprintf_s(cC1, "%.4f", XYZ[1]);
	sprintf_s(cC2, "%.4f", XYZ[2]);
	sprintf_s(cC3, "%.3f", CenRefine[roi_x]);

	std::string st(""); st += " Xw:";
	st += cC;	st += " Yw:";	st += cC1;	st += " Zw:";	st += cC2;
	st += " ycen:";	st += cC3;

	int roi_x1 = cut(roi_x, 0, src.cols - 500);
	cv::putText(src, st, cv::Point(roi_x1, roi_y), CV_FONT_HERSHEY_SIMPLEX, 0.5, CV_RGB(255, 10, 122));
	//cout << "y" << CenRefine[roi_x] << endl;
}
void lineExtract(Mat& src)
{	Mat  gray;	Mat bw;
	cvtColor(src, gray, CV_BGR2GRAY);
	bw = gray > th;
	int step0 = src.step[0];
	int step1 = src.step[1];
	int esize1 = src.elemSize1();
	uchar *psrc = src.data;
	//int step2 = bw.step[0];
	//int step3 = bw.step[1];
	//uchar *pbw = bw.data;
	int step4 = gray.step[0];
	int step5 = gray.step[1];
	uchar *pgray = gray.data;
	double CenCoase[srccols] = { 0 };
	double CenMax[srccols] = { 0 };
	int Seachstart[srccols] = { 0 };
	line(src, Point2f(0, maxcols), Point2f(srccols-1, maxcols), CV_RGB(255, 25, 255), 1);
	Mat Zimg(1000, srccols, CV_8UC3, Scalar(0, 0, 0));
	int Zstep0 = Zimg.step[0];
	int Zstep1 = Zimg.step[1];
	int Zesize1 = Zimg.elemSize1();
	uchar *pZimg = Zimg.data;
	
	for (int k = 0; k < srccols; k++)  //Coase
	{
		int count = 0;
		int start = 0;
		int len = 0;
		int maxj = 0;
		int max = 0;
		 
		for (int j = 0; j < srcrows; ++j)
		{
			if (pgray[j*step4 + k*step5] > max)
			{
				max = pgray[j*step4 + k*step5];
				maxj = j;
			}//寻找极大值
			if (pgray[j*step4 + k*step5] > th)
			{
				count += 1;
				if (count > 8)
					break;
				

				len = 1;
				start = j;
				for (; j<srcrows && pgray[j*step4 + k*step5]>th; ++j)
				{
					len += 1;
					if (pgray[j*step4 + k*step5] > max)
					{
						max = pgray[j*step4 + k*step5];
						maxj = j;
					}
				}//for寻找连通域的终点
				 
					int CoaseCur = start + len*0.5;
					if (CoaseCur < maxcols)
					{
						CenCoase[k] = CoaseCur;
					}
				 

			}//if 发现新的连通域
		}  //for 列循环
		if (count > 1)//如果多于一个连通域
		{
			//CenCoase[k] = start + 0.5*len;
			Seachstart[k] = start;
			//psrc[(int)start * step0 + k*step1] = 5;  //blue  
			//psrc[(int)start * step0 + k*step1 + esize1] = 5;//green  
			//psrc[(int)start * step0 + k*step1 + esize1 * 2] = 100;//red 
		}//if 如果多于一个连通域
		else 
			if (max > th)
		{
			CenCoase[k] = start + 0.5*len;//首先，如果有最大值
		}
		else
		{
			CenMax[k] = maxj;
			//psrc[(int)maxj * step0 + k*step1] = 5;  //blue  
			//psrc[(int)maxj * step0 + k*step1 + esize1] = 255;//green  
			//psrc[(int)maxj * step0 + k*step1 + esize1 * 2] = 100;//red 
		}
		//psrc[(int)CenCoase[k] * step0 + k*step1] = 5;  //blue  
		//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1] = 5;//green  
		//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1 * 2] = 100;//red 
	}//coase
	
	
	
	
	//找出可靠点和不可靠点///////////////////////////


	/*  for (int k = 0; k < srccols; k++)  //Coase
	{
		int count = 0;
		int start = 0;
		int len = 0;
		int maxj = 0;
		int max = 0;
		for (int j = 0; j < srcrows; ++j)
		{
			if (pgray[j*step4 + k*step5] > max)
			{
				max = pgray[j*step4 + k*step5];
				maxj = j;
			}//寻找极大值
			if (pgray[j*step4 + k*step5] > th)
			{
				count += 1;
				if (count > 1)
					break;

				len = 1;
				start = j;
				for (; j<srcrows && pgray[j*step4 + k*step5]>th; ++j)
				{
					len += 1;
					if (pgray[j*step4 + k*step5] > max)
					{
						max = pgray[j*step4 + k*step5];
						maxj = j;
					}
				}//for寻找连通域的终点

			}//if 发现新的连通域
		}  //for 列循环
		if (count > 1)//如果多于一个连通域
		{
			//CenCoase[k] = start + 0.5*len;
			Seachstart[k] = start;
			//psrc[(int)start * step0 + k*step1] = 5;  //blue  
			//psrc[(int)start * step0 + k*step1 + esize1] = 5;//green  
			//psrc[(int)start * step0 + k*step1 + esize1 * 2] = 100;//red 
		}//if 如果多于一个连通域
		else if (max > th)
		{
			CenCoase[k] = start + 0.5*len;//首先，如果有最大值
		}
		else
		{
			CenMax[k] = maxj;
			//psrc[(int)maxj * step0 + k*step1] = 5;  //blue  
			//psrc[(int)maxj * step0 + k*step1 + esize1] = 255;//green  
			//psrc[(int)maxj * step0 + k*step1 + esize1 * 2] = 100;//red 
		}
		//psrc[(int)CenCoase[k] * step0 + k*step1] = 5;  //blue  
		//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1] = 5;//green  
		//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1 * 2] = 100;//red 
	}//coase
	//找出可靠点和不可靠点///////////////////////////


	 //找直线的方法虽然不好，但是可以参考
	//找出所有直线/////////////////	
	double xs[srccols] = { 0 };
	double ys[srccols] = { 0 };
	int num = 0;
	for (int k = 0; k < srccols; k++)
	{
		if (Seachstart[k])
		{
			continue;
		}
		else if (CenCoase[k]>1)
		{
			xs[num] = k;
			ys[num] = CenCoase[k];
			num++;
			//psrc[(int)CenCoase[k] * step0 + k*step1] = 5;  //blue  
			//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1] = 255;//green  
			//psrc[(int)CenCoase[k] * step0 + k*step1 + esize1 * 2] = 100;//red 
		}
	}//第一步，所有可靠点存起来，方便操作
	
	vector<double> xcur, ycur;

	Vec4f linecur;
	vector<Vec4f>lineall;
	int flag;
	for (int k = 0; k < num; k++)
	{
		for (; k < num&&xcur.size() < 5; k++)
		{
			xcur.push_back(xs[k]);
			ycur.push_back(ys[k]);
		}
		linecur[0] = xcur.at(0);
		linecur[1] = ycur.at(0);
		linecur[2] = xcur.at(xcur.size() - 1);
		linecur[3] = ycur.at(xcur.size() - 1);
		if (xcur.size() > 2)
		{
			for (int L = 1; L < xcur.size() - 1; L++)
			{
				if (PointToSegDist(xcur.at(L), ycur.at(L), linecur) > epsilon)
				{
					xcur.erase(xcur.begin());
					ycur.erase(ycur.begin());
					linecur[0] = xcur.at(0);
					linecur[1] = ycur.at(0);
					L = 1;
				}
			}
			if (xcur.size() > 2)
			{
				// 确定有三点或者以上的点共线后//
				flag = 1;
				for (k = k + 1; k < num&&flag; k++)  //往后寻找新点
				{
					if (PointToSegDist(xs[k], ys[k], linecur) <= epsilon)
					{
						xcur.push_back(xs[k]);
						ycur.push_back(ys[k]);
					}
					else
					{
						linecur[2] = xs[k];
						linecur[3] = ys[k];

						for (int L = 1; L < xcur.size(); L++)
						{
							if (PointToSegDist(xcur.at(L), ycur.at(L), linecur) > epsilon)
							{
								flag = 0;  //找到终点，停止外层循环
								break;
							}
						}
					}

				}
				if (xcur.size() > 5)
				{
					linecur[2] = xs[k - 2];
					linecur[3] = ys[k - 2];
					lineall.push_back(linecur); //找到终点，保存直线
				}
				xcur.clear();
				ycur.clear();
				//确定有三点或者以上的点共线后//
			}
		}
	}//外循环，线段提取
	if (xcur.size() > 4)//最后n点
	{
		linecur[2] = xs[num - 2];
		linecur[3] = ys[num - 2];
		lineall.push_back(linecur);

	}
	//找出所有直线/////////////////	
	for (int L = 0; L < lineall.size(); L++)	{ line(src, Point2f(lineall.at(L)[0], lineall.at(L)[1]), Point2f(lineall.at(L)[2], lineall.at(L)[3]), CV_RGB(255, 2, 0), 2); }
	//cout << "linesize" <<lineall.size() << endl;
	*/
	//将部分不可靠点变为可靠点////////////////
	/*
	Vec4f line1, line2;
	int L = 1;
	int Cases = 1;
	if (lineall.size())   //在有直线的情形下
	{
	line2 = lineall.at(0);
	line1 = line2;
	for (int k = 0; k < srccols; k++)
	{
	if (k <= line1[2])
	{
	Cases = 1; //第一种可能，在直线1上
	}
	else if (k>line1[2] && k < line2[0])
	{
	Cases = 2;//第二种可能，在直线12之间
	}
	else if (k <= line2[2])
	{
	Cases = 3;
	}
	else if (L < lineall.size())
	{
	Cases = 1;
	line1 = line2;
	line2 = lineall.at(L);
	L++;
	}
	else
	{
	Cases = 3;
	}
	if (Seachstart[k])
	{
	int start[17] = { 0 };
	int len[17] = { 0 };
	int count = -1;
	start[0] = Seachstart[k];
	len[0] = 1;
	for (int j = Seachstart[k]; j < srcrows; ++j)
	{
	if (pgray[j*step4 + k*step5] > th)
	{
	count += 1;
	if (count >=17)
	{
	cout << "break" << endl;
	break;
	}

	start[count] = j;
	len[count] = 1;
	for (; j<srcrows && pgray[j*step4 + k*step5]>th; ++j)
	{
	len[count] += 1;

	}//for寻找连通域的终点
	}//if 发现新的连通域
	}//for  行循环
	double mindist = 100000;
	int minj = 0;
	switch (Cases)
	{
	case 1:
	for (int c = 0; c <=count; c++)
	{
	if (PointToSegDist(k, start[c] + len[c], line1) < mindist)
	{
	mindist = PointToSegDist(k, start[c] + len[c], line1);
	minj = c;
	}

	}
	break;
	case 2:
	for (int c = 0; c <= count; c++)
	{
	if (PointToSegDist(k, start[c] + len[c] / 2, line1) < mindist)
	{
	mindist = PointToSegDist(k, start[c] + len[c] / 2, line1);
	minj = c;
	}
	if (PointToSegDist(k, start[c] + len[c] / 2, line2) < mindist)
	{
	mindist = PointToSegDist(k, start[c] + len[c] / 2, line2);
	minj = c;
	}

	}
	break;
	case 3:
	for (int c = 0; c <= count; c++)
	{

	if (PointToSegDist(k, start[c] + len[c] / 2, line2) < mindist)
	{
	mindist = PointToSegDist(k, start[c] + len[c] / 2, line2);
	minj = c;
	}

	}
	break;
	}
	if (mindist < epsilon)
	{


	CenCoase[k] = start[minj] + len[minj] / 2;
	//cout << "CenCoase[k]" << CenCoase[k] << endl;
	}

	} //if 多于一个连通域
	else if (CenCoase[k] < 2)
	{
	switch (Cases)
	{
	case 1:

	if (PointToSegDist(k, CenMax[k], line1) < epsilon*1.5)
	{
	CenCoase[k] = CenMax[k];
	}

	break;
	case 2:

	if (PointToSegDist(k, CenMax[k], line1) < epsilon*1.5)
	{
	CenCoase[k] = CenMax[k];
	}
	if (PointToSegDist(k, CenMax[k], line2) < epsilon*1.5)
	{
	CenCoase[k] = CenMax[k];
	}

	break;
	case 3:

	if (PointToSegDist(k, CenMax[k], line2) < epsilon*1.5)
	{
	CenCoase[k] = CenMax[k];
	}

	break;
	}//switch
	circle(src, Point2f(k, CenCoase[k]), 4, CV_RGB(255, 1, 125));
	}//elseif
	}
	}

	//将部分不可靠点变为可靠点////////////////
	// */
//
/*
	Vec4f line1, line2;
	int L = 1;
	int Cases = 1;
	if (lineall.size())   //在有直线的情形下
	{
		line2 = lineall.at(0);
		line1 = line2;
		for (int k = 0; k < srccols; k++)
		{

			if (k <= line1[2])
			{
				Cases = 1; //第一种可能，在直线1上			




			}
			else if (k>line1[2] && k < line2[0])
			{
				Cases = 2;//第二种可能，在直线12之间
			}
			else if (k <= line2[2])
			{
				Cases = 3;
			}
			else if (L < lineall.size())
			{
				Cases = 1;
				line1 = line2;
				line2 = lineall.at(L);
				L++;
			}
			else
			{
				Cases = 3;
			}
			if (Seachstart[k])
			{
				double K, B;
				int y = 0;
				double K1, B1;
				int y1 = 0;
				switch (Cases)
				{
				case 1:
					K = (line1[3] - line1[1]) / (line1[2] - line1[0] + DBL_MIN);
					B = line1[1] - K*line1[0];
					y = cut(K*k + B, 0, srcrows - 1);
					if (pgray[y*step4 + k*step5] > th)
						CenCoase[k] = y;
					break;
				case 2:
					K = (line1[3] - line1[1]) / (line1[2] - line1[0] + DBL_MIN);
					B = line1[1] - K*line1[0];
					y = cut(K*k + B, 0, srcrows - 1);
					K1 = (line2[3] - line2[1]) / (line2[2] - line2[0] + DBL_MIN);
					B1 = line2[1] - K1*line2[0];
					y1 = cut(K1*k + B1, 0, srcrows - 1);
					if (pgray[y1*step4 + k*step5] > th&&pgray[y*step4 + k*step5] > th)
					{
						if (pgray[y1*step4 + k*step5] > pgray[y*step4 + k*step5] + 10)
							CenCoase[k] = y1;
						else if (pgray[y1*step4 + k*step5] < pgray[y*step4 + k*step5] - 10)
							CenCoase[k] = y;
						else
						{
							if (y > y1)
								CenCoase[k] = y;
							else
								CenCoase[k] = y1;
						}
					}
					else if (pgray[y*step4 + k*step5] > th)
					{
						CenCoase[k] = y;

					}
					else
					{
						CenCoase[k] = y;
					}
					break;
				case 3:
					K = (line2[3] - line2[1]) / (line2[2] - line2[0] + DBL_MIN);
					B = line2[1] - K*line2[0];
					y = cut(K*k + B, 0, srcrows - 1);
					if (pgray[y*step4 + k*step5] > th)
					{
						CenCoase[k] = y;

					}

					break;
				}
				circle(src, Point2f(k, CenCoase[k]), 4, CV_RGB(255, 1, 125));

			} //if 多于一个连通域

		}
	}
*/
	//将部分不可靠点变为可靠点////////////////
	double Yw[srccols] = { 0 };
	double Zw[srccols] = { 0 };
	double XYZ[3];

	for (int k = 1; k < srccols - 1; k++)  //refine
	{
		int max = 0;
		int maxj = 0;
		if (CenCoase[k])  //To refine
		{
			//double count = 0;
			double sum = 0;
			int start = cut(CenCoase[k] - maxline, 0, srcrows - 1);
			int end = cut(CenCoase[k] + maxline, 0, srcrows);
			for (int j = start; j < end; j++)
			{
				if (pgray[j*step4 + k*step5] > th*0.75)
				{
					sum += pgray[j*step4 + k*step5];
					CenRefine[k] += j*pgray[j*step4 + k*step5];
				}
			}
			if (sum)
				CenRefine[k] /= sum;
			else
				CenRefine[k] = CenCoase[k];
			maxj = cut(CenRefine[k], 0, srcrows - 1);

			psrc[maxj*step0 + k*step1] = 5;  //blue  
			psrc[maxj*step0 + k*step1 + esize1] = 5;//green  
			psrc[maxj*step0 + k*step1 + esize1 * 2] = 200;//red 

		}//refine1
		else
		{
			CenRefine[k] =0;
			
			/*
		
			maxj = CenMax[k];
			if (fabs(maxj - CenCoase[k - 1]) < epsilon2 || fabs(maxj - CenCoase[k + 1]) < epsilon2 || pgray[maxj*step4 + k*step5] > th*0.5)
			{
			double sum = 0;
			int start = cut(maxj - maxline, 0, srcrows - 1);
			int end = cut(maxj + maxline, 0, srcrows);
			for (int j = start; j < end; j++)
			{
			if (pgray[j*step4 + k*step5] > th*0.5)
			{
			sum += pgray[j*step4 + k*step5];
			CenRefine[k] += j*pgray[j*step4 + k*step5];
			}
			}
			if (sum)
			CenRefine[k] /= sum;
			else
			CenRefine[k] = maxj;

			//psrc[maxj*step0 + k*step1] = 0;  //blue
			//psrc[maxj*step0 + k*step1 + esize1] = 155;//green
			//psrc[maxj*step0 + k*step1 + esize1 * 2] = 155;//red
			circle(src, Point2f(k, CenRefine[k]), 4, CV_RGB(255, 255 , 125));

			}
			*/   //先不要这部分，可能是噪声的重要来源

		}//else

		if (CenRefine[k] > 2)
		{
			threeD(k, CenRefine[k], XYZ);
			Yw[k] = XYZ[1];
			Zw[k] = XYZ[2];
		}
		else
		{
			Yw[k] = 0;
			Zw[k] = 0;
		}
		int J = (Zimg.rows - Zw[k] * 70);
		J = cut(J, 0, Zimg.rows-1);
		for (int j = J; j < Zimg.rows;j++)
		pZimg[j*Zstep0 + k*Zstep1] = 255;  //blue  
		if (savecount < 1900)
		{
			outfile << Zw[k] << ",";
		}

	}//refine for
	//	imwrite("00.bmp", src);
	outfile << " \r\n";

	imshow("二值图", bw);
	//imshow("灰度图", gray);
	imshow("Zimg", Zimg);

}
bool imageProcessmain(Mat frame)
{
	if (frame.empty())
	{
		fprintf(stderr, "Can not load the image file.\n");
		return false;
	}
	char key = (char)waitKey(1);

	switch (key) {
	case 'q':
	case 'Q':
	case 27: //escape key
		return false;
	case ' ': //Save an image
		sprintf_s(filename, "filename%.7d.bmp", framecount);
		imwrite(filename, frame);
		cout << "Saved " << filename << endl;
		break;
	case 'S':
	case 's':
		savecount = 0;
		sprintf_s(filename, "XZ%.3d.csv", framecount);
		outfile.open(filename, 'w');
		break;

	default:
		break;
	}
	framecount++;
	savecount++;
	if (savecount > 1900)
	{
		savecount = 1900;
		if (outfile.is_open())
		{
			outfile.close();
			cout << "保存完毕" << endl;
		}
	}

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
	lineExtract(frame);
	setMouseCallback(MainWin, on_mouse);
	//showmouseRGB(frame); 
	showmouse3D(frame);
	cv::putText(frame, fpsSt, cv::Point(10, 20), CV_FONT_HERSHEY_SIMPLEX, 0.5, CV_RGB(255, 0, 0));
	resize(frame,frame,Size(800,600));
	imshow(MainWin, frame);
	return true;
}