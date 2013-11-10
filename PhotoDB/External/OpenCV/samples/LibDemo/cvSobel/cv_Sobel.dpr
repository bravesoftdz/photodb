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
program cv_Sobel;

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
  filename = 'Resource\cat2.jpg';

var
  xorder: Integer = 1;
  xorder_max: Integer = 2;

  yorder: Integer = 1;
  yorder_max: Integer = 2;

  // �������-���������� �������� -
  // ������� ����������� �� X
procedure myTrackbarXorder(pos: Integer); cdecl;
begin
  xorder := pos;
end;

//
// �������-���������� �������� -
// ������� ����������� �� Y
procedure myTrackbarYorder(pos: Integer); cdecl;
begin
  yorder := pos;
end;

Var
  image: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;
  aperture: Integer = 3;
  c: Integer;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename);
    WriteLn(Format('[i] image: %s', [filename]));
    // c����� ��������
    dst := cvCreateImage(cvSize(image^.width, image^.height), IPL_DEPTH_16S, image^.nChannels);
    dst2 := cvCreateImage(cvSize(image^.width, image^.height), image^.depth, image^.nChannels);

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('sobel', CV_WINDOW_AUTOSIZE);

    cvCreateTrackbar('xorder', 'original', @xorder, xorder_max, myTrackbarXorder);
    cvCreateTrackbar('yorder', 'original', @yorder, yorder_max, myTrackbarYorder);

    while True do
    begin

      // ���������, ����� ������� ����������� �� X � Y ��� ������� �� 0
      if (xorder = 0) and (yorder = 0) then
      begin
        WriteLn('[i] Error: bad params for cvSobel() !');
        cvZero(dst2);
      end
      else
      begin
        // ��������� �������� c�����
        cvSobel(image, dst, xorder, yorder, aperture);
        // ����������� ����������� � 8-�������
        cvConvertScale(dst, dst2);
      end;

      // ���������� ��������
      cvShowImage('original', image);
      cvShowImage('sobel', dst2);

      c := cvWaitKey(33);
      if (c = 27) then
        // �c�� ������ ESC - �������
        break;

    end;

    // �c��������� ��c��c�
    cvReleaseImage(image);
    cvReleaseImage(dst);
    cvReleaseImage(dst2);
    // ������� ����
    cvDestroyAllWindows;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
