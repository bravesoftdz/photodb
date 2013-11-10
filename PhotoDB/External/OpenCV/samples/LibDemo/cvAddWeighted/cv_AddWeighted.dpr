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
program cv_AddWeighted;

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
  alpha: Double = 0.5;
  beta, input: Double;
  src1, src2, dst: pIplImage;

begin
  try
    src1 := cvLoadImage(filename_src1);
    src2 := cvLoadImage(filename_src2);
    cvNamedWindow('Linear Blend', CV_WINDOW_AUTOSIZE);
    beta := (1.0 - alpha);
    dst := cvCloneImage(src1);
    cvAddWeighted(src1, alpha, src2, beta, 0, dst);
    cvShowImage('Linear Blend', dst);
    cvwaitKey(0);
    cvReleaseImage(src1);
    cvReleaseImage(src2);
    cvReleaseImage(dst);
    cvDestroyAllWindows;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
