unit OpenCV.Lib;

interface

const

  CV_VERSION_EPOCH    = '2';
  CV_VERSION_MAJOR    = '4';
  CV_VERSION_MINOR    = '9';
  CV_VERSION_REVISION = '0';

  CV_VERSION = CV_VERSION_EPOCH + '.' + CV_VERSION_MAJOR + '.' + CV_VERSION_MINOR + '.' + CV_VERSION_REVISION;

  // * old  style version constants*/
  CV_MAJOR_VERSION    = CV_VERSION_EPOCH;
  CV_MINOR_VERSION    = CV_VERSION_MAJOR;
  CV_SUBMINOR_VERSION = CV_VERSION_MINOR;

  CV_VERSION_DLL = CV_VERSION_EPOCH + CV_VERSION_MAJOR + CV_VERSION_MINOR;

{$IFDEF DEBUG}
  Core_Dll           = 'opencv_core' + CV_VERSION_DLL + 'd.dll';
  highgui_Dll        = 'opencv_highgui' + CV_VERSION_DLL + 'd.dll';
  imgproc_Dll        = 'opencv_imgproc' + CV_VERSION_DLL + 'd.dll';
  objdetect_dll      = 'opencv_objdetect' + CV_VERSION_DLL + 'd.dll';
  legacy_dll         = 'opencv_legacy' + CV_VERSION_DLL + 'd.dll';
  calib3d_dll        = 'opencv_calib3d' + CV_VERSION_DLL + 'd.dll';
  tracking_DLL       = 'opencv_video' + CV_VERSION_DLL + 'd.dll';
  Nonfree_DLL        = 'opencv_nonfree' + CV_VERSION_DLL + 'd.dll';
  OpenCV_Classes_DLL = 'OpenCV_Classes.dll';
{$ELSE}
  Core_Dll           = 'opencv_core' + CV_VERSION_DLL + '.dll';
  highgui_Dll        = 'opencv_highgui' + CV_VERSION_DLL + '.dll';
  imgproc_Dll        = 'opencv_imgproc' + CV_VERSION_DLL + '.dll';
  objdetect_dll      = 'opencv_objdetect' + CV_VERSION_DLL + '.dll';
  legacy_dll         = 'opencv_legacy' + CV_VERSION_DLL + '.dll';
  calib3d_dll        = 'opencv_calib3d' + CV_VERSION_DLL + '.dll';
  tracking_DLL       = 'opencv_video' + CV_VERSION_DLL + '.dll';
  Nonfree_DLL        = 'opencv_nonfree' + CV_VERSION_DLL + '.dll';
  OpenCV_Classes_DLL = 'OpenCV_Classes.dll';
{$ENDIF}

implementation

end.
