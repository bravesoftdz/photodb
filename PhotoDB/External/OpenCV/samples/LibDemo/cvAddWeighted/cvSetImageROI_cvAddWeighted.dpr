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
program cvSetImageROI_cvAddWeighted;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  highgui_c,
  core_c,
  Core.types_c,
  imgproc_c;

Const
  filename_src1 = 'Resource\cat2-mirror.jpg';
  filename_src2 = 'Resource\cat2.jpg';

Var
  image: pIplImage = nil;
  templ: pIplImage = nil;
  dst: pIplImage = nil;
  x, y, width, height: Integer;
  alpha, beta: Double;

begin
try
  image := cvLoadImage(filename_src1);
  WriteLn(Format('[i] image_src1: %s', [filename_src1]));
  templ := cvLoadImage(filename_src2);
  WriteLn(Format('[i] image_src2: %s', [filename_src2]));

  cvNamedWindow('origianl', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('template', CV_WINDOW_AUTOSIZE);
  cvNamedWindow('res', CV_WINDOW_AUTOSIZE);
  dst := cvCloneImage(templ);
  // ������ �������
  width := templ^.width;
  height := templ^.height;

  // �������� � ������
  cvShowImage('origianl', image);
  cvShowImage('template', templ);

  x := 0;
  y := 0;
  // ����� ��c���� ������������
  alpha := 0.5;
  beta := 0.5;
  // �c����������� ���cc�� ������c�
  cvSetImageROI(image, cvRect(x, y, width, height));
  // ���������� c����
  cvAddWeighted(image, alpha, templ, beta, 0.0, dst);
  // �c��������� ���cc�� ������c�
  cvResetImageROI(image);
  // ���������� ���������
  cvShowImage('res', dst);

  // ��� ������� �������
  cvWaitKey(0);

  // �c��������� ��c��c�
  cvReleaseImage(image);
  cvReleaseImage(templ);
  cvReleaseImage(dst);
  cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
