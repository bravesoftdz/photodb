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
program cv_SetMouseCallback;

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
  c: Integer;

  // ��c��� �������������
procedure drawTarget(img: PIplImage; x, y, radius: Integer); cdecl;
begin
  cvCircle(img, cvPoint(x, y), radius, CV_RGB(250, 0, 0), 1, 8);
  cvLine(img, cvPoint(x - radius div 2, y - radius div 2), cvPoint(x + radius div 2, y + radius div 2),
    CV_RGB(250, 0, 0), 1, 8);
  cvLine(img, cvPoint(x - radius div 2, y + radius div 2), cvPoint(x + radius div 2, y - radius div 2),
    CV_RGB(250, 0, 0), 1, 8);
end;

// ���������� c������ �� �����
procedure myMouseCallback(event: Integer; x: Integer; y: Integer; flags: Integer; param: Pointer); cdecl;
Var
  img: PIplImage;
begin
  img := PIplImage(param);
  if event = CV_EVENT_LBUTTONDOWN then
  begin
    Writeln(Format('%d x %d', [x, y]));
    drawTarget(img, x, y, 10);
  end;
end;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    // ������ ���������� �����
    cvSetMouseCallback('original', myMouseCallback, image);

    while True do
    begin
      // ���������� ��������
      cvShowImage('original', image);
      c := cvWaitKey(33);
      if (c = 27) then
        break;
    end;

    // �c��������� ��c��c�
    cvReleaseImage(image);
    // ������� ����
    cvDestroyWindow('original');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
