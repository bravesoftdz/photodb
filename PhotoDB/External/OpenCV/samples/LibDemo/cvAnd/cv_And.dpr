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
program cv_And;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  highgui_c,
  core_c,
  Core.types_c,
  imgproc_c;

const
  filename = 'Resource\roulette-wheel2-small.jpg';

Var
  Rmin: Integer = 0;
  Rmax: Integer = 256;

  Gmin: Integer = 0;
  Gmax: Integer = 256;

  Bmin: Integer = 0;
  Bmax: Integer = 256;

  RGBmax: Integer = 256;

  image: pIplImage = nil;
  dst: pIplImage = nil;

  // ��� �������� ������� RGB
  rgb: pIplImage = nil;
  r_plane: pIplImage = nil;
  g_plane: pIplImage = nil;
  b_plane: pIplImage = nil;
  // ��� �������� ������� RGB ��c�� ��������������
  r_range: pIplImage = nil;
  g_range: pIplImage = nil;
  b_range: pIplImage = nil;
  // ��� �������� c�������� ��������
  rgb_and: pIplImage = nil;

  //
  // �������-����������� ��������
  //
procedure myTrackbarRmin(pos: Integer); cdecl;
begin
  Rmin := pos;
  cvInRangeS(r_plane, cvScalar(Rmin), cvScalar(Rmax), r_range);
end;

procedure myTrackbarRmax(pos: Integer); cdecl;
begin
  Rmax := pos;
  cvInRangeS(r_plane, cvScalar(Rmin), cvScalar(Rmax), r_range);
end;

procedure myTrackbarGmin(pos: Integer); cdecl;
begin
  Gmin := pos;
  cvInRangeS(g_plane, cvScalar(Gmin), cvScalar(Gmax), g_range);
end;

procedure myTrackbarGmax(pos: Integer); cdecl;
begin
  Gmax := pos;
  cvInRangeS(g_plane, cvScalar(Gmin), cvScalar(Gmax), g_range);
end;

procedure myTrackbarBmin(pos: Integer); cdecl;
begin
  Bmin := pos;
  cvInRangeS(b_plane, cvScalar(Bmin), cvScalar(Bmax), b_range);
end;

procedure myTrackbarBmax(pos: Integer); cdecl;
begin
  Bmax := pos;
  cvInRangeS(b_plane, cvScalar(Bmin), cvScalar(Bmax), b_range);
end;

Var
  framemin, framemax: Double;
  c: Integer;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename);
    WriteLn(Format('[i] image: %s', [filename]));

    // c����� ��������
    rgb := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 3);
    r_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    g_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    b_plane := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    r_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    g_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    b_range := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    rgb_and := cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);
    // ��������
    cvCopyImage(image, rgb);
    // ��������� �� �������� ������
    cvSplit(rgb, b_plane, g_plane, r_plane, 0);

    //
    // ���������� ����������� � ���c�������� ��������
    // � ������� HSV
    framemin := 0;
    framemax := 0;

    cvMinMaxLoc(r_plane, @framemin, @framemax);
    WriteLn(Format('[R] %f x %f', [framemin, framemax]));
    Rmin := Trunc(framemin);
    Rmax := Trunc(framemax);
    cvMinMaxLoc(g_plane, @framemin, @framemax);
    WriteLn(Format('[G] %f x %f', [framemin, framemax]));
    Gmin := Trunc(framemin);
    Gmax := Trunc(framemax);
    cvMinMaxLoc(b_plane, @framemin, @framemax);
    WriteLn(Format('[B] %f x %f', [framemin, framemax]));
    Bmin := Trunc(framemin);
    Bmax := Trunc(framemax);

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('R', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('G', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('B', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('R range', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('G range', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('B range', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('rgb and', CV_WINDOW_AUTOSIZE);

    cvCreateTrackbar('Rmin', 'R range', @Rmin, RGBmax, myTrackbarRmin);
    cvCreateTrackbar('Rmax', 'R range', @Rmax, RGBmax, myTrackbarRmax);
    cvCreateTrackbar('Gmin', 'G range', @Gmin, RGBmax, myTrackbarGmin);
    cvCreateTrackbar('Gmax', 'G range', @Gmax, RGBmax, myTrackbarGmax);
    cvCreateTrackbar('Bmin', 'B range', @Gmin, RGBmax, myTrackbarBmin);
    cvCreateTrackbar('Bmax', 'B range', @Gmax, RGBmax, myTrackbarBmax);

    //
    // �����c��� ���� �� �������� c����
    //
    if (image^.width < 1920 / 4) and (image^.height < 1080 / 2) then
    begin
      cvMoveWindow('original', 0, 0);
      cvMoveWindow('R', image^.width + 10, 0);
      cvMoveWindow('G', (image^.width + 10) * 2, 0);
      cvMoveWindow('B', (image^.width + 10) * 3, 0);
      cvMoveWindow('rgb and', 0, image^.height + 30);
      cvMoveWindow('R range', image^.width + 10, image^.height + 30);
      cvMoveWindow('G range', (image^.width + 10) * 2, image^.height + 30);
      cvMoveWindow('B range', (image^.width + 10) * 3, image^.height + 30);
    end;

    while (true) do
    begin

      // ���������� ��������
      cvShowImage('original', image);

      // ���������� c���
      cvShowImage('R', r_plane);
      cvShowImage('G', g_plane);
      cvShowImage('B', b_plane);

      // ���������� ��������� ���������� ��������������
      cvShowImage('R range', r_range);
      cvShowImage('G range', g_range);
      cvShowImage('B range', b_range);

      // c���������
      cvAnd(r_range, g_range, rgb_and);
      cvAnd(rgb_and, b_range, rgb_and);

      // ���������� ���������
      cvShowImage('rgb and', rgb_and);

      c := cvWaitKey(33);
      if (c = 27) then
        // �c�� ������ ESC - �������
        break;

    end;
    WriteLn('[i] Results:');
    WriteLn(Format('[i][R] %d : %d', [Rmin, Rmax]));
    WriteLn(Format('[i][G] %d : %d', [Gmin, Gmax]));
    WriteLn(Format('[i][B] %d : %d', [Bmin, Bmax]));

    // �c��������� ��c��c�
    cvReleaseImage(image);
    cvReleaseImage(rgb);
    cvReleaseImage(r_plane);
    cvReleaseImage(g_plane);
    cvReleaseImage(b_plane);
    cvReleaseImage(r_range);
    cvReleaseImage(g_range);
    cvReleaseImage(b_range);
    cvReleaseImage(rgb_and);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
