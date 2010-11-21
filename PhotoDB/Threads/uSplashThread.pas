unit uSplashThread;

interface

uses
   Classes, Windows, Messages, JPEG, Graphics, uTime,
   uConstants, uResources, UnitDBCommonGraphics, uMemory,
   uTranslate, ActiveX, uFileUtils, pngimage,
   uFormUtils;

type
  TSplashThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TLanguageThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  SplashThread : TThread = nil;

procedure SetSplashProgress(ProgressValue : Byte);

implementation

{ TSplashThread }

const
  SplWidth = 645;
  SplHeight = 450;

var
  SplashWindowClass : TWndClass;
  hSplashWnd : HWND;
  hSplashProgress : Byte = 0;
  IsFirstDraw : Boolean = True;
  MouseCaptured : Boolean = False;
  LoadingImage : TBitmap = nil;

procedure SetSplashProgress(ProgressValue : Byte);
begin
  hSplashProgress := ProgressValue;
  //PostMessage(hSplashWnd, WM_PAINT, 0, 0);
end;

procedure UpdateFormImage;
begin
  RenderForm(hSplashWnd, LoadingImage, 255);
end;

function SplashWindowProc(hWnd : HWND; uMsg : UINT; wParam : WPARAM;
                    lParam : LPARAM) : LRESULT; stdcall;
var
  PNGLogo : TPNGImage;
begin
  case uMsg of
    WM_DESTROY:
      begin
        F(LoadingImage);
        PostQuitMessage(0); // stop message loop
        Result := 0;
        Exit;
      end;
    WM_CREATE:
      begin
        PNGLogo := GetLoadingImage;
        try
          LoadingImage := TBitmap.Create;
          LoadingImage.PixelFormat := pf32bit;
          LoadingImage.Assign(PNGLogo);
        finally
          F(PNGLogo);
        end;
      end;
    WM_PAINT:
      begin
        //UpdateFormImage;
      end;
    WM_LBUTTONDOWN:
      begin
        MouseCaptured := True;
      end;
    WM_LBUTTONUP:
      begin
        MouseCaptured := False;
      end;
    WM_MOUSEMOVE  :
      begin
        if MouseCaptured then
          //
      end;
  end;
  Result := DefWindowProc(hWnd, uMsg, wParam, lParam);
end; // SplashWindowProc
               
procedure TSplashThread.Execute;
const
  ClassName = 'PhotoDB Splash';
var
  Instance : Thandle;
  Msg: TMsg; // declare this too, for later
begin
  try
    Instance := GetModuleHandle(nil);

    if Terminated then
      Exit;

    SplashWindowClass.style := CS_HREDRAW or CS_VREDRAW;
    SplashWindowClass.lpfnWndProc := @SplashWindowProc;
    SplashWindowClass.hInstance := Instance;
    SplashWindowClass.hIcon := LoadIcon(0, IDI_APPLICATION);
    SplashWindowClass.hCursor := LoadCursor(0, IDC_ARROW);
    SplashWindowClass.hbrBackground := COLOR_BTNFACE + 1;
    SplashWindowClass.lpszClassName := ClassName;

    if Terminated then
      Exit;

    RegisterClass(SplashWindowClass);
    try
      hSplashWnd := CreateWindowEx(WS_EX_TOOLWINDOW or WS_EX_TOPMOST, ClassName, 'SplashScreen',
                                   WS_POPUP,
                                   GetSystemMetrics(SM_CXSCREEN) div 2 - SplWidth div 2,
                                   GetSystemMetrics(SM_CYSCREEN) div 2 - SplHeight div 2,
                                   SplWidth, SplHeight, 0, 0, Instance, nil);
      try

        if Terminated then
          Exit;

        UpdateFormImage;
        if Terminated then
          Exit;

        ShowWindow(hSplashWnd, SW_SHOWNOACTIVATE);

        while True do
        begin
          if Terminated then
            Break;
          if PeekMessage(Msg, hSplashWnd, 0,0, PM_REMOVE) then
          begin
            if Msg.message = WM_QUIT then
              Break;
            TranslateMessage(Msg);
            DispatchMessage(Msg);
          end else
          begin
            // Do rendering here if a real-time app
          end;
          Sleep(1);
        end;
      finally
        DestroyWindow(hSplashWnd);
      end;
    finally
      UnregisterClass(ClassName, Instance);
    end;
    TW.I.Start('SPLASH THREAD END');

  finally
    SplashThread := nil;
    FreeOnTerminate := True;
  end;
end; // ShowSplashWindow

{ TLanguageThread }

procedure TLanguageThread.Execute;
begin
  FreeOnTerminate := True;
  CoInitialize(nil);
  try
    //call translate manager to load XML with language in separate thead
    TA('PhotoDB');
  finally
    CoUninitialize;
  end;
end;

initialization

  //if not GetParamStrDBBool('/NoLogo') then
  begin
    TW.I.Start('TSplashThread');
    SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
    SetThreadPriority(MainThreadID, THREAD_PRIORITY_TIME_CRITICAL);
    SplashThread := TSplashThread.Create(False);
    TLanguageThread.Create(False);
    TW.I.Start('TSplashThread - Created');
  end;

end.
