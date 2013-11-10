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
program cv_LoadImage2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  highgui_c,
  core_c,
  Core.types_c,
  imgproc_c;

const
  filename = 'Resource\opencv_logo_with_text.png';

var
  image: pIplImage = nil;
  src: pIplImage = nil;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    if Assigned(image) then
    begin
      // ��������� ��������
      src := cvCloneImage(image);
      if Assigned(src) then
      begin
        // ���� ��� ����������� ��������
        cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
        // ���������� ��������
        cvShowImage('original', image);
        // ������� � ���c��� ���������� � ��������
        WriteLn('src');
        with src^ do
        begin
          WriteLn(Format('[i] channels: %d', [nChannels]));
          WriteLn(Format('[i] pixel depth: %d bits', [depth]));
          WriteLn(Format('[i] width: %d pixels', [width]));
          WriteLn(Format('[i] height: %d pixels', [height]));
          WriteLn(Format('[i] image size: %d bytes', [imageSize]));
          WriteLn(Format('[i] width step: %d bytes', [widthStep]));
        end;
        WriteLn;
        WriteLn('original');
        with src^ do
        begin
          WriteLn(Format('[i] channels: %d', [nChannels]));
          WriteLn(Format('[i] pixel depth: %d bits', [depth]));
          WriteLn(Format('[i] width: %d pixels', [width]));
          WriteLn(Format('[i] height: %d pixels', [height]));
          WriteLn(Format('[i] image size: %d bytes', [imageSize]));
          WriteLn(Format('[i] width step: %d bytes', [widthStep]));
        end;
        // ��� ������� �������
        cvWaitKey(0);
        // �c��������� ��c��c�
        cvReleaseImage(image);
        cvReleaseImage(src);
        // ������� ����
        cvDestroyWindow('original');
      end;
    end;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
