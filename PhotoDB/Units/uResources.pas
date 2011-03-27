unit uResources;

interface

uses Windows, SysUtils, Classes, JPEG, pngImage, uMemory;

function GetFolderPicture : TPNGImage;
function GetLogoPicture : TPNGImage;
function GetSlideShowLoadPicture : TPNGImage;
function GetExplorerBackground : TPNGImage;
function GetSearchBackground : TPNGImage;
function GetDateRangeImage : TPNGImage;
function GetImagePanelImage : TPNGImage;
function GetLoadingImage : TPNGImage;
function GetActivationImage : TPNGImage;
function GetPrinterPatternImage : TJpegImage;

{$R PhotoDB.res}

{$R Logo.res}
{$R Slideshow_Load.res}
{$R Directory_Large.res}
{$R ExplorerBackground.res}
{$R SearchBackground.res}   
{$R DateRange.res}
{$R Manifest.res}
{$R ImagePanelBackground.res}
{$R Loading.res}
{$R Activation.res}
{$R PrinterPattern.res}

//Icons
{$R icons.res}
{$R db_icons.res}
{$R ZoomRc.res}
{$R editor.res}
{$R explorer.res}
{$R search.res}
{$R panel.res}
{$R cmd_icons.res}
{$R updater.res}

implementation

function GetRCDATAResourceStream(ResName : string) : TMemoryStream;
var
  MyRes  : Integer;
  MyResP : Pointer;
  MyResS : Integer;
begin
  Result := nil;
  MyRes := FindResource(HInstance, PWideChar(ResName), RT_RCDATA);
  if MyRes <> 0 then begin
    MyResS := SizeOfResource(HInstance,MyRes);
    MyRes := LoadResource(HInstance,MyRes);
    if MyRes <> 0 then begin
      MyResP := LockResource(MyRes);
      if MyResP <> nil then begin
        Result := TMemoryStream.Create;
        with Result do begin
          Write(MyResP^, MyResS);
          Seek(0, soFromBeginning);
        end;
        UnLockResource(MyRes);
      end;
      FreeResource(MyRes);
    end
  end;
end;

function LoadPNGFromRES(ResName : string) : TPNGImage;
var
  RCDataStream : TMemoryStream;
begin
  Result := nil;
  RCDataStream := GetRCDATAResourceStream(ResName);
  if RCDataStream <> nil then
  begin
    Result := TPNGImage.Create;
    Result.LoadFromStream(RCDataStream);
    F(RCDataStream);
  end;
end;

function LoadJPEGFromRES(ResName : string) : TJPEGImage;
var
  RCDataStream : TMemoryStream;
begin
  Result := nil;
  RCDataStream := GetRCDATAResourceStream(ResName);
  if RCDataStream <> nil then
  begin
    Result := TJPEGImage.Create;
    Result.LoadFromStream(RCDataStream);
    F(RCDataStream);
  end;
end;

function GetFolderPicture : TPNGImage;
begin
  Result := LoadPNGFromRES('DIRECTORY_LARGE');
end;

function GetSlideShowLoadPicture : TPNGImage;
begin
  Result := LoadPNGFromRES('SLIDESHOW_LOAD');
end;

function GetExplorerBackground : TPNGImage;
begin
  Result := LoadPNGFromRES('EXPLORERBACKGROUND');
end;

function GetSearchBackground : TPNGImage;
begin
  Result := LoadPNGFromRES('SEARCHBACKGROUND');
end;

function GetDateRangeImage : TPNGImage;
begin
  Result := LoadPNGFromRES('DATERANGE');
end;

function GetImagePanelImage : TPNGImage;
begin
  Result := LoadPNGFromRES('IMAGEPANELBACKGROUND');
end;

function GetLoadingImage : TPNGImage;
begin
  Result := LoadPNGFromRES('LOADING');
end;

function GetLogoPicture : TPNGImage;
begin
  Result := LoadPNGFromRES('LOGO');
end;

function GetActivationImage : TPNGImage;
begin
  Result := LoadPNGFromRES('ACTIVATION');
end;

function GetPrinterPatternImage : TJpegImage;
begin
  Result := LoadJPEGFromRES('PRINTERPATTERN');
end;

end.
