unit FileDrop;

interface

uses Windows, ActiveX, Classes, ShlObj,SysUtils, dialogs;
type
  { TDragDropInfo ������ ��������� �� 
  ��������� � FMDD2.PAS }
  TDragDropInfo = class (TObject)
  private
    FInClientArea : Boolean;
    FDropPoint : TPoint;
    FFileList : TStringList;
  public
    constructor Create (ADropPoint : TPoint; 
    AInClient : Boolean);
    destructor Destroy; override;
    procedure Add (const s : String);
    property InClientArea : Boolean read 
    FInClientArea;
    property DropPoint : TPoint read 
    FDropPoint;
    property Files : TStringList read 
    FFileList;
    function CreateHDrop : HGlobal;
  end;

  TFileDropEvent = procedure 
  (DDI : TDragDropInfo) 
  of object;

  { TFileDropTarget �����, ��� ��������� 
  ���������� ����� }
  TFileDropTarget = class (TInterfacedObject, 
  IDropTarget)
  private
    FHandle : HWND;
    FOnFilesDropped : TFileDropEvent;
    FOnDragEnter: TNotifyEvent;
    FOnDragLeave: TNotifyEvent;
    FCanMove: boolean;
    procedure SetOnDragEnter(const Value: TNotifyEvent);
    procedure SetOnDragLeave(const Value: TNotifyEvent);
    procedure SetCanMove(const Value: boolean);
  public
    constructor Create (Handle: HWND; 
    AOnDrop: TFileDropEvent);
    destructor Destroy; override;

    { �� IDropTarget }
function DragEnter(const dataObj: IDataObject; 
                       grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint)
      : HResult; stdcall;
    function DragOver(grfKeyState: Longint; 
    pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; 
                  grfKeyState: Longint; 
                  pt: TPoint;
      var dwEffect: Longint): HResult; 
      stdcall;

    property OnFilesDropped : TFileDropEvent
      read FOnFilesDropped write FOnFilesDropped;
       Procedure SetHandle(Handle : THandle);
    property OnDragEnter : TNotifyEvent read FOnDragEnter Write SetOnDragEnter;
    property OnDragLeave : TNotifyEvent read FOnDragLeave Write SetOnDragLeave;
    property CanMove : boolean Read FCanMove Write SetCanMove;
  end;

implementation

uses ShellAPI;

{ TDragDropInfo }

constructor TDragDropInfo.Create
    (
      ADropPoint : TPoint;
      AInClient : Boolean
    );
begin
  inherited Create;
  FFileList := TStringList.Create;
  FDropPoint := ADropPoint;
  FInClientArea := AInClient;
end;

destructor TDragDropInfo.Destroy;
begin
  FFileList.Free;
  inherited Destroy;
end;

procedure TDragDropInfo.Add
    (
      const s : String
    );
begin
  Files.Add (s+#0);
end;

function TDragDropInfo.CreateHDrop: HGlobal;
var
  RequiredSize : Integer;
  i : Integer;
  hGlobalDropInfo : HGlobal;
  DropFiles : PDropFiles;
  c : PChar;
begin
  {
    �������� ��������� TDropFiles � ������,
    ���������� �����
    GlobalAlloc. ������� ������ ������� ����������
    � ����������,
    ��������� ���, ��������, ����� ������������ 
    ������� ��������.
  }

  { ���������� ����������� ������ ��������� }
  RequiredSize := sizeof (TDropFiles);
  for i := 0 to Self.Files.Count-1 do
  begin
    { ����� ������ ������, ���� 1 ���� ��� 
    ����������� }
    RequiredSize := RequiredSize + 
    Length (Self.Files[i]) + 1;
  end;
  { 1 ���� ��� ������������ ����������� }
  inc (RequiredSize);

  hGlobalDropInfo := GlobalAlloc
((GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT), 
      RequiredSize);
  if (hGlobalDropInfo <> 0) then
  begin
    { ����������� ������� ������, ����� � ��� 
      ����� ���� ����������
    }
      DropFiles := GlobalLock (hGlobalDropInfo);

    { �������� ���� ��������� DropFiles }
    {
      pFiles -- �������� �� ������ 
      ��������� �� ������� ����� �������
      � ������� ������.
    }
    DropFiles.pFiles := sizeof (TDropFiles);
    DropFiles.pt := Self.FDropPoint;
    DropFiles.fNC := Self.InClientArea;
    DropFiles.fWide := False;

    {
      �������� ������ ��� ����� � �����.
      ����� ���������� �� �������� 
      DropFiles + DropFiles.pFiles,
      �� ���� ����� ���������� ���� ���������.
    }
    c := PChar (DropFiles);
    c := c + DropFiles.pFiles;
    for i := 0 to Self.Files.Count-1 do
    begin
      StrCopy(c, PChar (Self.Files[i]));
      c := c + Length (Self.Files[i]);
    end;

    { ������� ���������� }
    GlobalUnlock (hGlobalDropInfo);
  end;

  Result := hGlobalDropInfo;
end;


{ TFileDropTarget }

constructor TFileDropTarget.Create
    (
      Handle: HWND;
      AOnDrop: TFileDropEvent
    );
begin
  inherited Create;
  _AddRef;
  FHandle := Handle;
  FCanMove:=false;
  FOnFilesDropped := AOnDrop;
  ActiveX.CoLockObjectExternal(Self,
  true, false);
  ActiveX.RegisterDragDrop (FHandle, Self);
end;

{ Destroy ������� ���������� � ������� 
� ��������� ����� � ��� }
destructor TFileDropTarget.Destroy;
var
  WorkHandle: HWND;
begin
  {
    ���� �������� FHandle �� ����� 0, 
    ������, ����� � ����� ��� 
    ��� ����������. �������� �������� 
    �� ��, ��� FHandle ����������
    ������ ����� ��������� 0, ������ 
    ��� CoLockObjectExternal �
    RevokeDragDrop �������� Release, 
    ���, � ���� �������, �����
    �������� � ������ Free � ������������ 
    ���������.
    ����������, ��� ���� �������� �� 
    ������ �������. ���� ������ �����
    ���������� �� ����, ��� 
    ������� ������ ������ �� 0,
    ����� ���������� ����������.
  }
{  if (FHandle <> 0) then
  begin
    WorkHandle := FHandle;
    FHandle := 0;
    ActiveX.CoLockObjectExternal 
    (Self, false, true);
    ActiveX.RevokeDragDrop (WorkHandle);
  end;  }

  inherited Destroy;
end;

function TFileDropTarget.DragEnter
    (
      const dataObj: IDataObject;
      grfKeyState: Longint;
      pt: TPoint;
      var dwEffect: Longint
    ): HResult; stdcall;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
  if Assigned(FOnDragEnter) then
  FOnDragEnter(Self);  
end;

function TFileDropTarget.DragOver
    (
      grfKeyState: Longint;
      pt: TPoint;
      var dwEffect: Longint
    ): HResult; stdcall;
begin
{ if CanMove then
 begin
  if grfKeyState and 8<>0 then dwEffect := DROPEFFECT_MOVE else
  dwEffect := DROPEFFECT_COPY;
 end else        }
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TFileDropTarget.DragLeave: 
HResult; stdcall;
begin
  Result := S_OK;
  if Assigned(FOnDragLeave) then
  FOnDragLeave(Self);
end;

{
  ��������� ���������� ������.
}
function TFileDropTarget.Drop
    (
      const dataObj: IDataObject;
      grfKeyState: Longint;
      pt: TPoint;
      var dwEffect: Longint
    ): HResult; stdcall;
var
  Medium : TSTGMedium;
  Format : TFormatETC;
  NumFiles: Integer;
  i : Integer;
  rslt : Integer;
  DropInfo : TDragDropInfo;
  szFilename : array [0..MAX_PATH] of char;
  InClient : Boolean;
  DropPoint : TPoint;
begin
  dataObj._AddRef;
  {
    �������� ������.  ��������� TFormatETC 
    �������� 
    dataObj.GetData, ��� �������� ������ 
    � � ����� �������
    ��� ������ ��������� (��� ���������� 
    ���������� � 
    ��������� TSTGMedium).
  }
  Format.cfFormat := CF_HDROP;
  Format.ptd      := Nil;
  Format.dwAspect := DVASPECT_CONTENT;
  Format.lindex   := -1;
  Format.tymed    := TYMED_HGLOBAL;

  { ������� ������ � ��������� Medium }
  rslt := dataObj.GetData (Format, Medium);

  {
    ���� ��� ������ �������, ����� 
    ���������, ��� ��� �������� ���������
    �������������� FMDD.
  }
  if (rslt = S_OK) then
  begin
    { �������� ���������� ������ �
    ������ �������� }
    NumFiles := DragQueryFile
    (Medium.hGlobal, $FFFFFFFF, NIL, 0);
    InClient := DragQueryPoint
    (Medium.hGlobal, DropPoint);

    { ������� ������ TDragDropInfo }
    DropInfo := TDragDropInfo.Create
    (DropPoint, InClient);

    { ������� ��� ����� � ������ }
    for i := 0 to NumFiles - 1 do
    begin
      DragQueryFile (Medium.hGlobal, i,
      szFilename,
                     sizeof(szFilename));
      DropInfo.Add (szFilename);
    end;
    { ���� ������ ����������, �������� ��� }
    if (Assigned (FOnFilesDropped)) then
    begin
      FOnFilesDropped (DropInfo);
    end;

    DropInfo.Free;
  end;
  if (Medium.unkForRelease = nil) then
    ReleaseStgMedium (Medium);

  dataObj._Release;
  dwEffect := DROPEFFECT_COPY;
  result := S_OK;
  if Assigned(FOnDragLeave) then
  FOnDragLeave(Self);
end;

procedure TFileDropTarget.SetHandle(Handle: THandle);
begin
  FHandle := Handle;
  ActiveX.RegisterDragDrop (Handle, Self);
end;

procedure TFileDropTarget.SetOnDragEnter(const Value: TNotifyEvent);
begin
  FOnDragEnter := Value;
end;

procedure TFileDropTarget.SetOnDragLeave(const Value: TNotifyEvent);
begin
  FOnDragLeave := Value;
end;

procedure TFileDropTarget.SetCanMove(const Value: boolean);
begin
  FCanMove := Value;
end;

initialization
  OleInitialize (Nil);

finalization
  OleUninitialize;

end.
