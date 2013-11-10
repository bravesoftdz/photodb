// --------------------------------- OpenCV license.txt ---------------------------
(* //    IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
  //
  //    By downloading, copying, installing or using the software you agree to this license.
  //    If you do not agree to this license, do not download, install,
  //    copy or use the software.
  //
  //
  //                             License Agreement
  //                  For Open Source Computer Vision Library
  //
  //   Copyright (C) 2000-2008, Intel Corporation, all rights reserved.
  //   Copyright (C) 2009, Willow Garage Inc., all rights reserved.
  //   Third party copyrights are property of their respective owners.
  //
  //   Redistribution and use in source and binary forms, with or without modification,
  //   are permitted provided that the following conditions are met:
  //
  //     * Redistribution's of source code must retain the above copyright notice,
  //       this list of conditions and the following disclaimer.
  //
  //     * Redistribution's in binary form must reproduce the above copyright notice,
  //       this list of conditions and the following disclaimer in the documentation
  //       and/or other materials provided with the distribution.
  //
  //     * The name of the copyright holders may not be used to endorse or promote products
  //       derived from this software without specific prior written permission.
  //
  //   This software is provided by the copyright holders and contributors "as is" and
  //   any express or implied warranties, including, but not limited to, the implied
  //   warranties of merchantability and fitness for a particular purpose are disclaimed.
  //   In no event shall the Intel Corporation or contributors be liable for any direct,
  //   indirect, incidental, special, exemplary, or consequential damages
  //   (including, but not limited to, procurement of substitute goods or services;
  //   loss of use, data, or profits; or business interruption) however caused
  //   and on any theory of liability, whether in contract, strict liability,
  //   or tort (including negligence or otherwise) arising in any way out of
  //   the use of this software, even if advised of the possibility of such damage. *)

(* /  **************************************************************************************************
  //                                 Project Delphi-OpenCV
  //  **************************************************************************************************
  //  Contributor:
  //  laentir Valetov
  //  email:laex@bk.ru
  //  **************************************************************************************************
  //  You may retrieve the latest version of this file at the GitHub,
  //  located at git://github.com/Laex/Delphi-OpenCV.git
  //  **************************************************************************************************
  //  License:
  //  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
  //  you may not use this file except in compliance with the License. You may obtain a copy of the
  //  License at http://www.mozilla.org/MPL/
  //
  //  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  //  ANY KIND, either express or implied. See the License for the specific language governing rights
  //  and limitations under the License.
  //
  //  Alternatively, the contents of this file may be used under the terms of the
  //  GNU Lesser General Public License (the  "LGPL License"), in which case the
  //  provisions of the LGPL License are applicable instead of those above.
  //  If you wish to allow use of your version of this file only under the terms
  //  of the LGPL License and not to allow others to use your version of this file
  //  under the MPL, indicate your decision by deleting  the provisions above and
  //  replace  them with the notice and other provisions required by the LGPL
  //  License.  If you do not delete the provisions above, a recipient may use
  //  your version of this file under either the MPL or the LGPL License.
  //
  //  For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html
  //  **************************************************************************************************
  //  Warning: Using Delphi XE3 syntax!
  //  **************************************************************************************************
  //  The Initial Developer of the Original Code:
  //  OpenCV: open source computer vision library
  //  Homepage:    http://opencv.org
  //  Online docs: http://docs.opencv.org
  //  Q&A forum:   http://answers.opencv.org
  //  Dev zone:    http://code.opencv.org
  //  **************************************************************************************************
  //  Original file:
  //  opencv\modules\highgui\include\opencv2\highgui.hpp
  //  ************************************************************************************************* *)

unit highgui;

interface

Uses
  WinApi.Windows,
  Mat,
  Core.types_c,
  Core.types,
  highgui_c;

Type

  // Attention!
  // The sequence of function declarations interface must match the
  // sequence of function declarations in the project "opencv_classes" (C++)

  IVideoCapture = interface
    ['{3F605CF0-ECAC-4230-B30B-AF9BFD516C4F}']
    function open(device: Integer): bool; overload; stdcall;
    function openfilename(filename: pAnsiChar): bool; overload; stdcall;
    function isOpened(): bool; stdcall;
    procedure release(); stdcall;

    function grab(): bool; stdcall;
    function retrieve(Var image: IMat; flag: Integer): bool; stdcall;
    function read(Var image: IMat): bool; stdcall;

    function setValue(propId: Integer; value: double): bool; stdcall;
    function getValue(propId: Integer): double; stdcall;
  end;

function CreateVideoCapture: IVideoCapture; overload; safecall;
function CreateVideoCapture(device: Integer): IVideoCapture; overload; safecall;
function CreateVideoCapture(filename: pAnsiChar): IVideoCapture; overload; safecall;

// Flags for namedWindow
Const
  WINDOW_NORMAL = $00000000;
  // the user can resize the window (no constraint) / also use to switch a fullscreen window to a normal size
  WINDOW_AUTOSIZE = $00000001; // the user cannot resize the window, the size is constrainted by the image displayed
  WINDOW_OPENGL   = $00001000; // window with opengl support

  WINDOW_FULLSCREEN = 1;         // change the window to fullscreen
  WINDOW_FREERATIO  = $00000100; // the image expends as much as it can (no ratio constraint)
  WINDOW_KEEPRATIO  = $00000000; // the ratio of the image is respected

  // CV_EXPORTS_W void namedWindow(const String& winname, int flags = WINDOW_AUTOSIZE);
procedure namedWindow(const winname: String; const flags: Integer = WINDOW_AUTOSIZE);
// CV_EXPORTS_W void destroyWindow(const String& winname);
procedure destroyWindow(const winname: String);
// CV_EXPORTS_W void destroyAllWindows();
procedure destroyAllWindows();
// CV_EXPORTS_W int startWindowThread();
function startWindowThread(): Integer;
// CV_EXPORTS_W int waitKey(int delay = 0);
function waitKey(const delay: Integer = 0): Integer;
// CV_EXPORTS_W void imshow(const String& winname, InputArray mat);
procedure imshow(const winname: String; const Mat: IMat);
// CV_EXPORTS_W void resizeWindow(const String& winname, int width, int height);
procedure resizeWindow(const winname: String; const width, height: Integer);
// CV_EXPORTS_W void moveWindow(const String& winname, int x, int y);
procedure moveWindow(const winname: String; const x, y: Integer);
// CV_EXPORTS_W void setWindowProperty(const String& winname, int prop_id, double prop_value);
procedure setWindowProperty(const winname: String; const prop_id: Integer; const prop_value: double);
// CV_EXPORTS_W double getWindowProperty(const String& winname, int prop_id);
function getWindowProperty(const winname: String; const prop_id: Integer): double;
// CV_EXPORTS int createTrackbar(const String& trackbarname, const String& winname,
// int* value, int count,
// TrackbarCallback onChange = 0,
// void* userdata = 0);
function createTrackbar(const trackbarname: String; const winname: String; value: PInteger; count: Integer;
  onChange: CvTrackbarCallback2 = nil; userdata: Pointer = nil): Integer;

// CV_EXPORTS_W Mat imread( const string& filename, int flags=1 );
function imread(const filename: string; flag: Integer = 1): IMat;
// CV_EXPORTS_W bool imwrite( const string& filename, InputArray img, const vector<int>& params=vector<int>());
function imwrite(const filename: String; const img: IMat): bool;

implementation

Uses
  uLibName,
  cvUtils,
  core_c;

function CreateVideoCapture: IVideoCapture; external OpenCV_Classes_DLL name 'CreateVideoCapture';
function CreateVideoCapture(device: Integer): IVideoCapture; external OpenCV_Classes_DLL name 'CreateVideoCapture_dvc';
function CreateVideoCapture(filename: pAnsiChar): IVideoCapture;
  external OpenCV_Classes_DLL name 'CreateVideoCapture_fln';
function _imread(const filename: pCvChar; flag: Integer): IMat; external OpenCV_Classes_DLL name '_imread';
function _imwrite(const filename: pCvChar; const img: IMat): bool; external OpenCV_Classes_DLL name '_imwrite';

function imread(const filename: string; flag: Integer): IMat;
begin
  Result := _imread(
    c_str(filename),
    flag);
end;

function imwrite(const filename: String; const img: IMat): bool;
begin
  Result := _imwrite(
    c_str(filename),
    img);
end;

procedure namedWindow(const winname: String; const flags: Integer = WINDOW_AUTOSIZE);
begin
  cvNamedWindow(
    c_str(winname),
    flags);
end;

procedure destroyWindow(const winname: String);
begin
  cvDestroyWindow(c_str(winname));
end;

procedure destroyAllWindows();
begin
  cvDestroyAllWindows();
end;

function startWindowThread(): Integer;
begin
  Result := cvStartWindowThread();
end;

function waitKey(const delay: Integer = 0): Integer;
begin
  Result := cvWaitKey(delay);
end;

procedure imshow(const winname: String; const Mat: IMat);
Var
  IplImage: TIplImage;
begin
  IplImage.InitFromMat(Mat);
  cvShowImage(
    c_str(winname),
    @IplImage);
end;

procedure resizeWindow(const winname: String; const width, height: Integer);
begin
  cvResizeWindow(
    c_str(winname),
    width,
    height);
end;

procedure moveWindow(const winname: String; const x, y: Integer);
begin
  cvMoveWindow(
    c_str(winname),
    x,
    y);
end;

procedure setWindowProperty(const winname: String; const prop_id: Integer; const prop_value: double);
begin
  cvSetWindowProperty(
    c_str(winname),
    prop_id,
    prop_value);
end;

function getWindowProperty(const winname: String; const prop_id: Integer): double;
begin
  Result := cvGetWindowProperty(
    c_str(winname),
    prop_id);
end;

function createTrackbar(const trackbarname: String; const winname: String; value: PInteger; count: Integer;
  onChange: CvTrackbarCallback2 = nil; userdata: Pointer = nil): Integer;
begin
  Result := cvCreateTrackbar2(
    c_str(trackbarname),
    c_str(winname),
    value,
    count,
    onChange,
    userdata);
end;

end.
