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
program cv_Resize;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  highgui_c,
  core_c,
  Core.types_c,
  imgproc_c;

const
  // ��� ��������
  filename = 'Resource\cat2.jpg';

var
  // �c������
  image: PIplImage = nil;
  dst: array [0 .. 3] of PIplImage;
  i: Integer;

begin
  try
    image := cvLoadImage(filename, 1);
    i := 0;
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;

    // c������� ����������� �������� (������ ��� ������������)
    for i := 0 to 3 do
    begin
      dst[i] := cvCreateImage(cvSize(image^.width div 3, image^.height div 3), image^.depth, image^.nChannels);
      cvResize(image, dst[i], i);
    end;

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvShowImage('original', image);

    // ���������� ���������
    for i := 0 to 3 do
    begin
      cvNamedWindow(PCVChar(IntToStr(i)), CV_WINDOW_AUTOSIZE);
      cvShowImage(PCVChar(IntToStr(i)), dst[i]);
    end;

    // ��� ������� �������
    cvWaitKey(0);
    // �c��������� ��c��c�
    cvReleaseImage(image);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
