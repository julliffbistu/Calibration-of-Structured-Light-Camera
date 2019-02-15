
#include "ConsAndFun2.h"
#include "ConsAndFun.h"

//////////////通过修改这部分来改变延时//开始和停止抓取会影响帧率
static const uint32_t c_countOfImagesToGrab = 10000000;
uint32_t c_count = c_countOfImagesToGrab;
/////////////////
////////////////重要参数设置

int CalibOrProcess = 0;
 
int64_t  Yoffset = 450;
double yoffset = 450.0000001;
double kstep=1;
///////////////
#include <pylon/PylonIncludes.h>

// Namespace for using pylon objects.
using namespace Pylon;

#if defined( USE_1394 )
// Setting for using  Basler IEEE 1394 cameras.
#include <pylon/1394/Basler1394InstantCamera.h>
typedef Pylon::CBasler1394InstantCamera Camera_t;
using namespace Basler_IIDC1394CameraParams;
#elif defined ( USE_GIGE )
// Setting for using Basler GigE cameras.
#include <pylon/gige/BaslerGigEInstantCamera.h>
typedef Pylon::CBaslerGigEInstantCamera Camera_t;
using namespace Basler_GigECameraParams;
#elif defined ( USE_CAMERALINK )
// Setting for using Basler Camera Link cameras.
#include <pylon/cameralink/BaslerCameraLinkInstantCamera.h>
typedef Pylon::CBaslerCameraLinkInstantCamera Camera_t;
using namespace Basler_CLCameraParams;
#elif defined ( USE_USB )
// Setting for using Basler USB cameras.
#include <pylon/usb/BaslerUsbInstantCamera.h>
typedef Pylon::CBaslerUsbInstantCamera Camera_t;
using namespace Basler_UsbCameraParams;
#else
#error Camera type is not specified. For example, define USE_GIGE for using GigE cameras.
#endif
//////////////
 

int64_t Adjust(int64_t val, int64_t minimum, int64_t maximum, int64_t inc)
{
	// Check the input parameters.
	if (inc <= 0)
	{
		// Negative increments are invalid.
		throw LOGICAL_ERROR_EXCEPTION("Unexpected increment %d", inc);
	}
	if (minimum > maximum)
	{
		// Minimum must not be bigger than or equal to the maximum.
		throw LOGICAL_ERROR_EXCEPTION("minimum bigger than maximum.");
	}

	// Check the lower bound.
	if (val < minimum)
	{
		return minimum;
	}

	// Check the upper bound.
	if (val > maximum)
	{
		return maximum;
	}

	// Check the increment.
	if (inc == 1)
	{
		// Special case: all values are valid.
		return val;
	}
	else
	{
		// The value must be min + (n * inc).
		// Due to the integer division, the value will be rounded down.
		return minimum + (((val - minimum) / inc) * inc);
	}
}

///////////////

int main(int argc, char* argv[])
{
	
	cv::CommandLineParser parser(argc, argv,
		"{h||}"
		"{w||}"
		"{t||}"
		"{t2||}"
		"{o||}"
		"{c||}"
		"{k||}"
		);
	if (parser.has("h"))
	{
		newHeight=parser.get<double>("h");
	}
	if (parser.has("w"))
	{
		newWidth = parser.get<double>("w");
	}
	if (parser.has("t"))
	{
		exposuretime = parser.get<double>("t");
	}
	if (parser.has("t2"))
	{
		exposuretime2 = parser.get<double>("t2");
	}
	if (parser.has("o"))
	{
		Yoffset = parser.get<double>("o");
		yoffset = parser.get<double>("o");
	}
	if (parser.has("c"))
	{
		CalibOrProcess = 1;
	}
	if (parser.has("k"))
	{
		kstep  = parser.get<double>("k");  
	}
	double kstep2 = 0;
	
	// The exit code of the sample application.
	int exitCode = 0;

	// Before using any pylon methods, the pylon runtime must be initialized. 
	PylonInitialize();
	try
	{
		// Create an instant camera object with the camera device found first.
		//	CInstantCamera camera(CTlFactory::GetInstance().CreateFirstDevice());


		///////////
		CDeviceInfo info;
		info.SetDeviceClass(Camera_t::DeviceClass());

		// Create an instant camera object with the first found camera device matching the specified device class.
		Camera_t camera(CTlFactory::GetInstance().CreateFirstDevice(info));

		// Print the model name of the camera.
		cout << "Using device " << camera.GetDeviceInfo().GetModelName() << endl;

		// Open the camera.
		camera.Open();
		///////////

		// Print the model name of the camera.
		cout << "Using device " << camera.GetDeviceInfo().GetModelName() << endl;
		/////////////////////
		camera.PixelFormat.SetValue(PixelFormat_Mono8);
		////////////////////

		// Some properties have restrictions. Use GetInc/GetMin/GetMax to make sure you set a valid value.
		
		//newWidth = Adjust(newWidth, camera.Width.GetMin(), camera.Width.GetMax(), camera.Width.GetInc());		
		//newHeight = Adjust(newHeight, camera.Height.GetMin(), camera.Height.GetMax(), camera.Height.GetInc());
		////if (CalibOrProcess == 0)
		//{
		//	camera.Width.SetValue(newWidth);
		//	camera.Height.SetValue(newHeight);
		//	if (IsWritable(camera.OffsetX))
		//	{
		//		camera.OffsetX.SetValue(camera.OffsetX.GetMin());
		//	}
		//	if (IsWritable(camera.OffsetY))
		//	{
		//		camera.OffsetY.SetValue(Yoffset);
		//	}
		//	cout << "OffsetX          : " << camera.OffsetX.GetValue() << endl;
		//	cout << "OffsetY          : " << camera.OffsetY.GetValue() << endl;
		//	cout << "Width            : " << camera.Width.GetValue() << endl;
		//	cout << "Height           : " << camera.Height.GetValue() << endl;
		//}
		/*else
		{
			camera.Width.SetValue(1626);
			camera.Height.SetValue(1236);
			

		}*/
		
		////////////////////
		//Disable acquisition start trigger if available
		{
			GenApi::IEnumEntry* acquisitionStart = camera.TriggerSelector.GetEntry(TriggerSelector_AcquisitionStart);
			if (acquisitionStart && GenApi::IsAvailable(acquisitionStart))
			{
				camera.TriggerSelector.SetValue(TriggerSelector_AcquisitionStart);
				camera.TriggerMode.SetValue(TriggerMode_Off);
			}
		}
		//Disable frame start trigger if available
		{
			GenApi::IEnumEntry* frameStart = camera.TriggerSelector.GetEntry(TriggerSelector_FrameStart);
			if (frameStart && GenApi::IsAvailable(frameStart))
			{  
				camera.TriggerSelector.SetValue(TriggerSelector_FrameStart);
				camera.TriggerMode.SetValue(TriggerMode_Off);
			}
		}
	//	camera.AcquisitionMode.SetValue(AcquisitionMode_SingleFrame);
		/////////////////////////////
		// The parameter MaxNumBuffer can be used to control the count of buffers
		// allocated for grabbing. The default value of this parameter is 10.
		camera.MaxNumBuffer = 5;

		// Start the grabbing of c_countOfImagesToGrab images.
		// The camera device is parameterized with a default configuration which
		// sets up free-running continuous acquisition.
		camera.StartGrabbing(c_countOfImagesToGrab);

		// This smart pointer will receive the grab result data.
		CGrabResultPtr ptrGrabResult;
		CImageFormatConverter formatConverter;
		formatConverter.OutputPixelFormat = PixelType_BGR8packed;
		Mat openCvImage;
		CPylonImage pylonImage;
		/////////////////  设置曝光时间部分
		camera.GainAuto.SetValue(GainAuto_Off);
		camera.GainRaw.SetValue(camera.GainRaw.GetMin());
		camera.ExposureAuto.SetValue(ExposureAuto_Off);
		camera.ExposureTimeRaw.SetValue(exposuretime);
		////////////////


		// Camera.StopGrabbing() is called automatically by the RetrieveResult() method
		// when c_countOfImagesToGrab images have been retrieved.
		while (camera.IsGrabbing())
		{
			c_count--;
			// Wait for an image and then retrieve it. A timeout of 5000 ms is used.
			camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);

			// Image grabbed successfully?
			if (ptrGrabResult->GrabSucceeded())
			{
				// Access the image data.
				//cout << "SizeX: " << ptrGrabResult->GetWidth() << endl;
				//cout << "SizeY: " << ptrGrabResult->GetHeight() << endl;
				const uint8_t *pImageBuffer = (uint8_t *)ptrGrabResult->GetBuffer();
				//cout << "Gray value of first pixel: " << (uint32_t)pImageBuffer[0] << endl << endl;
				formatConverter.Convert(pylonImage, ptrGrabResult);
				// Create an OpenCV image out of pylon image
				openCvImage = cv::Mat(ptrGrabResult->GetHeight(), ptrGrabResult->GetWidth(), CV_8UC3, (uint8_t *)pylonImage.GetBuffer());			
				int ProcessResult;	
                if( CalibOrProcess)
					ProcessResult = SaveCalib(openCvImage, kstep2);
                else
				ProcessResult=  imageProcessmain(openCvImage);
 
				
				if (ProcessResult)
				{
					
					 
					if ((ProcessResult==2) && CalibOrProcess)  //如果按下空格
					{
						if (kstep2 > kstep)
							kstep2 = 0;
						int exptime = exposuretime + (exposuretime2 - exposuretime) / kstep*kstep2;
						camera.ExposureTimeRaw.SetValue(exptime);
						
						cout << "exposuretime   " << exptime <<   endl;
						kstep2=kstep2+1;
						  
						
					}
					
					if (c_count == 0)
					{ 
					   c_count = c_countOfImagesToGrab;
					   camera.StartGrabbing(c_countOfImagesToGrab);
					}
					
				}
				 
				else
				{
					camera.StopGrabbing();
				}

#ifdef PYLON_WIN_BUILD
				// Display the grabbed image.
				//Pylon::DisplayImage(1, ptrGrabResult);
#endif
			}
			else
			{
				cout << "Error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
			}
		}
	}
	catch (const GenericException &e)
	{
		// Error handling.
		cerr << "An exception occurred." << endl
			<< e.GetDescription() << endl;
		exitCode = 1;
	}

	// Comment the following two lines to disable waiting on exit.
	//cerr << endl << "Press Enter to exit." << endl;
	//while (cin.get() != '\n');

	// Releases all pylon resources. 
	PylonTerminate();

	return exitCode;
}
