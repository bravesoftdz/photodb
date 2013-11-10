(* /*****************************************************************
  //                       Delphi-OpenCV Demo
  //               Copyright (C) 2013 Project Delphi-OpenCV
  // ****************************************************************
  // Contributor:
  // laentir Valetov
  // email:laex@bk.ru
  // ****************************************************************
  // You may retrieve the latest version of this file at the GitHub,
  // located at git://github.com/Laex/Delphi-OpenCV.git
  // ****************************************************************
  // The contents of this file are used with permission, subject to
  // the Mozilla Public License Version 1.1 (the "License"); you may
  // not use this file except in compliance with the License. You may
  // obtain a copy of the License at
  // http://www.mozilla.org/MPL/MPL-1_1Final.html
  //
  // Software distributed under the License is distributed on an
  // "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  // implied. See the License for the specific language governing
  // rights and limitations under the License.
  ******************************************************************* *)
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_MorphologyEx;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  highgui_c,
  core_c,
  Core.types_c,
  imgproc_c,
  imgproc.types_c;

const
  // ��� ��������
  filename = 'Resource\opencv_logo_with_text.png';

var
  image: PIplImage = nil;
  open: PIplImage = nil;
  close: PIplImage = nil;
  gradient: PIplImage = nil;
  tophat: PIplImage = nil;
  blackhat: PIplImage = nil;

  radius: Integer = 1;
  radius_max: Integer = 10;
  iterations: Integer = 1;
  iterations_max: Integer = 10;

  Kern: PIplConvKernel;
  Temp: PIplImage;
  c: Integer;

  //
  // �������-���������� �������� -
  // �����c ����
procedure myTrackbarRadius(pos: Integer); cdecl;
begin
  radius := pos;
end;

//
// �������-���������� �������� -
// ��c�� ��������
procedure myTrackbarIterations(pos: Integer); cdecl;
begin
  iterations := pos;
end;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ��������� ��������
    open := cvCloneImage(image);
    close := cvCloneImage(image);
    gradient := cvCloneImage(image);
    tophat := cvCloneImage(image);
    blackhat := cvCloneImage(image);

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('CV_MOP_OPEN', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('CV_MOP_CLOSE', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('CV_MOP_GRADIENT', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('CV_MOP_TOPHAT', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('CV_MOP_BLACKHAT', CV_WINDOW_AUTOSIZE);

    cvCreateTrackbar('radius', 'original', @radius, radius_max, myTrackbarRadius);
    cvCreateTrackbar('iterations', 'original', @iterations, iterations_max, myTrackbarIterations);

    while True do
    begin
      // ���������� ��������
      cvShowImage('original', image);
      // c����� ����
      Kern := cvCreateStructuringElementEx(radius * 2 + 1, radius * 2 + 1, radius, radius, CV_SHAPE_ELLIPSE);

      // �������� ��� �������������� �������� ����������� cvCreateImage
      Temp := cvCreateImage(cvSize(image^.width, image^.height), IPL_DEPTH_8U, 1);
      // �������� ��������������
      cvMorphologyEx(image, open, Temp, Kern, CV_MOP_OPEN, iterations);
      cvMorphologyEx(image, close, Temp, Kern, CV_MOP_CLOSE, iterations);
      cvMorphologyEx(image, gradient, Temp, Kern, CV_MOP_GRADIENT, iterations);
      cvMorphologyEx(image, tophat, Temp, Kern, CV_MOP_TOPHAT, iterations);
      cvMorphologyEx(image, blackhat, Temp, Kern, CV_MOP_BLACKHAT, iterations);

      // ���������� ���������
      cvShowImage('CV_MOP_OPEN', open);
      cvShowImage('CV_MOP_CLOSE', close);
      cvShowImage('CV_MOP_GRADIENT', gradient);
      cvShowImage('CV_MOP_TOPHAT', tophat);
      cvShowImage('CV_MOP_BLACKHAT', blackhat);

      cvReleaseStructuringElement(Kern);
      cvReleaseImage(Temp);

      c := cvWaitKey(33);
      if (c = 27) then
        Break;
    end;

    // �c��������� ��c��c�
    cvReleaseImage(&image);
    cvReleaseImage(&open);
    cvReleaseImage(&close);
    cvReleaseImage(&gradient);
    cvReleaseImage(&tophat);
    cvReleaseImage(&blackhat);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
