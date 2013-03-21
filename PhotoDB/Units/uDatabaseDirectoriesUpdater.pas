unit uDatabaseDirectoriesUpdater;

interface

uses
  Winapi.Windows,
  Winapi.ActiveX,
  Generics.Defaults,
  Generics.Collections,
  System.SyncObjs,
  System.SysUtils,
  System.Classes,
  System.Math,
  Vcl.Forms,
  Data.DB,

  Dmitry.CRC32,
  Dmitry.Utils.System,

  CommonDBSupport,
  UnitINI,
  UnitDBDeclare,
  UnitDBKernel,

  uConstants,
  uRuntime,
  uMemory,
  uGUIDUtils,
  uInterfaces,
  uAssociations,
  uDBAdapter,
  uDBForm,
  uDBThread,
  wfsU,
  uGOM,
  uDBTypes,
  uDBUtils,
  uLogger,
  uCounters,
  uFormInterfaces,
  uDBUpdateUtils,
  uDBPopupMenuInfo,
  uLockedFileNotifications,
  uCDMappingTypes,
  uSettings;

type
  TDatabaseTask = class(TObject)
  protected
    FCollectionFile: string;
    FFileName: string;
  public
    function IsPrepaired: Boolean;
    constructor Create(CollectionFile, FileName: string);
    property CollectionFile: string read FCollectionFile;
    property FileName: string read FFileName;
  end;

  TUpdateTask = class(TDatabaseTask)
  private
    FID: Integer;
  public
    constructor Create(CollectionFile: string; ID: Integer; FileName: string); overload;
    procedure Execute;
    property ID: Integer read FID;
  end;

  TAddTask = class(TDatabaseTask)
  private
    FData: TDBPopupMenuInfoRecord;
    procedure NotifyAboutFileProcessing(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
  public
    constructor Create(CollectionFile: string; Data: TDBPopupMenuInfoRecord); overload;
    constructor Create(CollectionFile: string; FileName: string); overload;
    destructor Destroy; override;
    procedure Execute(Items: TArray<TAddTask>);
    property Data: TDBPopupMenuInfoRecord read FData;
  end;

  TDatabaseDirectory = class(TDataObject)
  private
    FPath: string;
    FName: string;
    FIcon: string;
    FSortOrder: Integer;
  public
    constructor Create(Path, Name, Icon: string; SortOrder: Integer);
    function Clone: TDataObject; override;
    procedure Assign(Source: TDataObject); override;
    property Path: string read FPath write FPath;
    property Name: string read FName write FName;
    property Icon: string read FIcon write FIcon;
    property SortOrder: Integer read FSortOrder write FSortOrder;
  end;

  TDatabaseDirectoriesUpdater = class(TDBThread)
  private
    FQuery: TDataSet;
    FThreadID: TGUID;
    FSkipExtensions: string;
    FCollectionFile: string;
    FAddRawFiles: Boolean;
    function IsDirectoryChangedOnDrive(Directory: string; ItemSizes: TList<Int64>; ItemsToAdd: TList<string>; ItemsToUpdate: TList<TUpdateTask>): Boolean;
    procedure AddItemsToDatabase(Items: TList<string>);
    procedure UpdateItemsInDatabase(Items: TList<TUpdateTask>);
    function GetIsValidThread: Boolean;
    function CanAddFileAutomatically(FileName: string): Boolean;
    property IsValidThread: Boolean read GetIsValidThread;
  protected
    procedure Execute; override;
  public
    constructor Create(CollectionFile: string);
    destructor Destroy; override;
  end;

  IUserDirectoriesWatcher = interface
    ['{ED4EF3E3-43A6-4D86-A40D-52AA1DFAD299}']
    procedure Execute;
    procedure StartWatch;
    procedure StopWatch;
  end;

  TUserDirectoriesWatcher = class(TInterfacedObject, IUserDirectoriesWatcher, IDirectoryWatcher)
  private
    FWatchers: TList<TWachDirectoryClass>;
    FState: TGUID;
    FCollectionFile: string;
    procedure StartWatch;
    procedure StopWatch;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    procedure DirectoryChanged(Sender: TObject; SID: TGUID; pInfos: TInfoCallBackDirectoryChangedArray);
    procedure TerminateWatcher(Sender: TObject; SID: TGUID; Folder: string);
  end;

  TDatabaseTaskPriority = (dtpNormal, dtpHigh);

  TUpdaterStorage = class(TObject)
  private
    FSync: TCriticalSection;
    FTotalItemsCount: Integer;
    FEstimateRemainingTime: TTime;
    FTasks: TList<TDatabaseTask>;
    function GetEstimateRemainingTime: TTime;
    function GetActiveItemsCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SaveStorage;
    procedure RestoreStorage;

    function Take<T: TDatabaseTask>(Count: Integer): TArray<T>;
    function TakeOne<T: TDatabaseTask>: T;
    procedure Add(Task: TDatabaseTask; Priority: TDatabaseTaskPriority = dtpHigh);
    procedure AddRange(Tasks: TList<TDatabaseTask>; Priority: TDatabaseTaskPriority = dtpHigh);

    procedure UpdateRemainingTime(Conter:  TSpeedEstimateCounter);
    property EstimateRemainingTime: TTime read GetEstimateRemainingTime;

    property TotalItemsCount: Integer  read FTotalItemsCount;
    property ActiveItemsCount: Integer read GetActiveItemsCount;
  end;

  TDatabaseUpdater = class(TDBThread)
  private
    FSpeedCounter: TSpeedEstimateCounter;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function UpdaterStorage: TUpdaterStorage;

implementation

const
  cAddImagesAtOneStep = 4;

var
  DirectoriesScanID: TGUID = '{00000000-0000-0000-0000-000000000000}';
  FUpdaterStorage: TUpdaterStorage = nil;
  FStorageLock: TCriticalSection = nil;

function UpdaterStorage: TUpdaterStorage;
begin
  if FUpdaterStorage = nil then
  begin
    FUpdaterStorage := TUpdaterStorage.Create;
    FUpdaterStorage.RestoreStorage;
  end;

  Result := FUpdaterStorage;
end;

procedure FillDatabaseDirectories(FolderList: TList<TDatabaseDirectory>);
const
  UpdaterDirectoriesFormat = '\Updater\Databases\{0}';

var
  Reg: TBDRegistry;
  DBPrefix, FName, FPath, FIcon: string;
  I, SortOrder: Integer;
  S: TStrings;
  DD: TDatabaseDirectory;

begin
  FolderList.Clear;

  Reg := TBDRegistry.Create(REGISTRY_CURRENT_USER);
  try
    DBPrefix := ExtractFileName(dbname) + IntToStr(StringCRC(dbname));

    Reg.OpenKey(GetRegRootKey + FormatEx(UpdaterDirectoriesFormat, [DBPrefix]), True);
    S := TStringList.Create;
    try
      Reg.GetKeyNames(S);

      for I := 0 to S.Count - 1 do
      begin
        Reg.CloseKey;
        Reg.OpenKey(GetRegRootKey + FormatEx(UpdaterDirectoriesFormat, [DBPrefix]) + S[I], True);

        FName := '';
        FPath := '';
        FIcon := '';
        SortOrder := 0;
        if Reg.ValueExists('Path') then
          FPath := Reg.ReadString('Path');
        if Reg.ValueExists('Icon') then
          FIcon := Reg.ReadString('Icon');
        if Reg.ValueExists('SortOrder') then
          SortOrder := Reg.ReadInteger('SortOrder');

        if (S[I] <> '') and (FPath <> '') then
        begin
          DD := TDatabaseDirectory.Create(S[I], FPath, FIcon, SortOrder);
          FolderList.Add(DD);
        end;
      end;
    finally
      F(S);
    end;
  finally
    F(Reg);
  end;

  DD := TDatabaseDirectory.Create('d:\dmitry\my pictures\photoes', 'TEST', '', 0);
  //DD := TDatabaseDirectory.Create('D:\dmitry\my pictures\photoes', 'TEST', '', 0);
  FolderList.Add(DD);

  FolderList.Sort(TComparer<TDatabaseDirectory>.Construct(
     function (const L, R: TDatabaseDirectory): Integer
     begin
       Result := L.SortOrder - R.SortOrder;
     end
  ));
end;

{ TDatabaseDirectory }

procedure TDatabaseDirectory.Assign(Source: TDataObject);
var
  DD: TDatabaseDirectory;
begin
  DD := Source as TDatabaseDirectory;
  Self.Path := DD.Path;
  Self.Name := DD.Name;
  Self.Icon := DD.Icon;
  Self.SortOrder := DD.SortOrder;
end;

function TDatabaseDirectory.Clone: TDataObject;
begin
  Result := TDatabaseDirectory.Create(Path, Name, Icon, SortOrder);
end;

constructor TDatabaseDirectory.Create(Path, Name, Icon: string; SortOrder: Integer);
begin
  Self.Path := Path;
  Self.Name := Name;
  Self.Icon := Icon;
  Self.SortOrder := SortOrder;
end;
  
{ TDatabaseDirectoriesUpdater }

function TDatabaseDirectoriesUpdater.CanAddFileAutomatically(
  FileName: string): Boolean;
var
  Ext: string;
begin
  if not FAddRawFiles and IsRAWImageFile(FileName) then
    Exit(False);

  if FSkipExtensions <> '' then
  begin
    Ext := AnsiLowerCase(ExtractFileExt(FileName));
    if FSkipExtensions.IndexOf(AnsiLowerCase(Ext)) > 0 then
      Exit(False);
  end;

  Exit(True);
end;

constructor TDatabaseDirectoriesUpdater.Create(CollectionFile: string);
begin
  inherited Create(nil, False);
  FCollectionFile := CollectionFile;
  FThreadID := GetGUID;
  DirectoriesScanID := FThreadID;

  FSkipExtensions := AnsiLowerCase(Settings.ReadString('Updater', 'SkipExtensions'));
  FAddRawFiles := Settings.ReadBool('Updater', 'AddRawFiles', False);

  FQuery := GetQuery(True);
end;

destructor TDatabaseDirectoriesUpdater.Destroy;
begin
  FreeDS(FQuery);
  inherited;
end;

procedure TDatabaseDirectoriesUpdater.Execute;
var
  FolderList: TList<TDatabaseDirectory>;
  DD: TDatabaseDirectory;
  Directories: TQueue<string>;
  ItemsToAdd: TList<string>;
  ItemsToUpdate: TList<TUpdateTask>;
  ItemSizes: TList<Int64>;
  Found: Integer;
  OldMode: Cardinal;
  SearchRec: TSearchRec;
  Dir: string;
begin
  inherited;
  FreeOnTerminate := True;

  CoInitializeEx(nil, COM_MODE);
  try

    Directories := TQueue<string>.Create;
    ItemsToAdd := TList<string>.Create;
    ItemsToUpdate := TList<TUpdateTask>.Create;
    ItemSizes := TList<Int64>.Create;
    OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
    try

      //list of directories to scan
      FolderList := TList<TDatabaseDirectory>.Create;
      try
        FillDatabaseDirectories(FolderList);
        for DD in FolderList do
          Directories.Enqueue(DD.Path);

      finally
        FreeList(FolderList);
      end;

      while Directories.Count > 0 do
      begin
        if DBTerminating or not IsValidThread then
          Break;

        Dir := Directories.Dequeue;
        Dir := IncludeTrailingBackslash(Dir);

        ItemSizes.Clear;
        ItemsToAdd.Clear;
        FreeList(ItemsToUpdate, False);
        Found := FindFirst(Dir + '*.*', faDirectory, SearchRec);
        try
          while Found = 0 do
          begin
            if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
            begin
              if (faDirectory and SearchRec.Attr = 0) and IsGraphicFile(SearchRec.Name) and CanAddFileAutomatically(SearchRec.Name) then
              begin
                ItemSizes.Add(SearchRec.Size);
                ItemsToAdd.Add(Dir + SearchRec.Name);
              end;

              if faDirectory and SearchRec.Attr <> 0 then
                Directories.Enqueue(Dir + SearchRec.Name);
            end;
            Found := System.SysUtils.FindNext(SearchRec);
          end;
        finally
          FindClose(SearchRec);
        end;

        if IsDirectoryChangedOnDrive(Dir, ItemSizes, ItemsToAdd, ItemsToUpdate) and IsValidThread then
        begin
          if ItemsToAdd.Count > 0 then
            AddItemsToDatabase(ItemsToAdd);
          if ItemsToUpdate.Count > 0 then
            UpdateItemsInDatabase(ItemsToUpdate);
        end;
      end;

    finally
      SetErrorMode(OldMode);
      F(ItemSizes);
      F(ItemsToAdd);
      FreeList(ItemsToUpdate);
      F(Directories);
    end;
  finally
    CoUninitialize;
  end;
end;

function TDatabaseDirectoriesUpdater.GetIsValidThread: Boolean;
begin
  Result := FThreadID = DirectoriesScanID;
end;

function TDatabaseDirectoriesUpdater.IsDirectoryChangedOnDrive(
  Directory: string; ItemSizes: TList<Int64>; ItemsToAdd: TList<string>; ItemsToUpdate: TList<TUpdateTask>): Boolean;
var
  I, J: Integer;
  DA: TDBAdapter;
  FileName: string;
begin
  SetSQL(FQuery, 'Select ID, FileSize, Name FROM $DB$ WHERE FolderCRC = ' + IntToStr(GetPathCRC(Directory, False)));
  if TryOpenCDS(FQuery) then
  begin
    if not FQuery.IsEmpty then
    begin
      FQuery.First;
      DA := TDBAdapter.Create(FQuery);
      try
        for I := 1 to FQuery.RecordCount do
        begin
          FileName := AnsiLowerCase(Directory + DA.Name);

          for J := ItemsToAdd.Count - 1 downto 0 do
            if(AnsiLowerCase(ItemsToAdd[J]) = FileName) then
            begin
              if (ItemSizes[J] <> DA.FileSize) then
                ItemsToUpdate.Add(TUpdateTask.Create(FCollectionFile, Da.ID, ItemsToAdd[J]));

              ItemsToAdd.Delete(J);
              ItemSizes.Delete(J);
            end;

          FQuery.Next;
        end;

      finally
        F(DA);
      end;
    end;

    Exit((ItemsToAdd.Count > 0) or (ItemsToUpdate.Count > 0));

  end else
    Exit(True);
end;

procedure TDatabaseDirectoriesUpdater.UpdateItemsInDatabase(
  Items: TList<TUpdateTask>);
begin
  UpdaterStorage.AddRange(TList<TDatabaseTask>(Items));
  Items.Clear;
end;

procedure TDatabaseDirectoriesUpdater.AddItemsToDatabase(Items: TList<string>);
var
  FileName: string;
  AddTasks: TList<TAddTask>;
begin
  AddTasks := TList<TAddTask>.Create;
  try
     for FileName in Items do
       AddTasks.Add(TAddTask.Create(FCollectionFile, FileName));

     UpdaterStorage.AddRange(TList<TDatabaseTask>(AddTasks));
  finally
     F(AddTasks);
  end;
end;

{ TUserDirectoriesWatcher }

constructor TUserDirectoriesWatcher.Create;
begin
  FWatchers := TList<TWachDirectoryClass>.Create;
  GOM.AddObj(Self);
end;

destructor TUserDirectoriesWatcher.Destroy;
begin
  StopWatch;
  FreeList(FWatchers);
  GOM.RemoveObj(Self);
  inherited;
end;

procedure TUserDirectoriesWatcher.Execute;
begin
  inherited;
  StartWatch;
  FCollectionFile := dbname;
  TDatabaseDirectoriesUpdater.Create(FCollectionFile);
end;

procedure TUserDirectoriesWatcher.StartWatch;
var
  Watch: TWachDirectoryClass;
  FolderList: TList<TDatabaseDirectory>;
  DD: TDatabaseDirectory;
begin
  StopWatch;
  FState := GetGUID;

  //list of directories to watch
  FolderList := TList<TDatabaseDirectory>.Create;
  try
    FillDatabaseDirectories(FolderList);
    for DD in FolderList do
    begin
      Watch := TWachDirectoryClass.Create;
      FWatchers.Add(Watch);
      Watch.Start(DD.Path, Self, Self, FState, True);
    end;

  finally
    FreeList(FolderList);
  end;
end;

procedure TUserDirectoriesWatcher.StopWatch;
var
  I: Integer;
begin
  for I := 0 to FWatchers.Count - 1 do
    FWatchers[I].StopWatch;
  
  FreeList(FWatchers, False);
end;

procedure TUserDirectoriesWatcher.DirectoryChanged(Sender: TObject; SID: TGUID;
  pInfos: TInfoCallBackDirectoryChangedArray);
var
  Info: TInfoCallback;
begin
  if FState <> SID then
    Exit;

  for Info in pInfos do
  begin

    if (Info.FNewFileName <> '') and TLockFiles.Instance.IsFileLocked(Info.FNewFileName) then
      Continue;
    if (Info.FOldFileName <> '') and TLockFiles.Instance.IsFileLocked(Info.FOldFileName) then
      Continue;

    case Info.FAction of
      FILE_ACTION_ADDED:
        UpdaterStorage.Add(TAddTask.Create(FCollectionFile, Info.FNewFileName));
      FILE_ACTION_REMOVED,
      FILE_ACTION_RENAMED_NEW_NAME:
        Break;
      FILE_ACTION_MODIFIED:
        UpdaterStorage.Add(TUpdateTask.Create(FCollectionFile, 0, Info.FNewFileName));
    end;
  end;
end;

procedure TUserDirectoriesWatcher.TerminateWatcher(Sender: TObject; SID: TGUID;
  Folder: string);
begin
  //do nothing for now
end;

{ TDatabaseTask }

constructor TDatabaseTask.Create(CollectionFile, FileName: string);
begin
  FCollectionFile := CollectionFile;
  FFileName := FileName;
end;

function TDatabaseTask.IsPrepaired: Boolean;
var
  hFile: THandle;
begin
  Result := False;

  //don't allow to write to file and try to open file
  hFile := CreateFile(PChar(FFileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  try
    Result := (hFile <> INVALID_HANDLE_VALUE) and (hFile <> 0);
  finally
    if Result then
      CloseHandle(hFile);
  end;
end;

{ TUpdateTask }

constructor TUpdateTask.Create(CollectionFile: string; ID: Integer; FileName: string);
begin
  inherited Create(CollectionFile, FileName);
  FFileName := FileName;
  FID := ID;
end;

procedure TUpdateTask.Execute;
begin
  try
    if FID = 0 then
      FID := GetIdByFileName(FFileName);

    UpdateImageRecord(nil, FFileName, ID);
  except
    on e: Exception do
      EventLog(e);
  end;
end;

{ TAddTask }

constructor TAddTask.Create(CollectionFile: string; Data: TDBPopupMenuInfoRecord);
begin
  if Data = nil then
    raise Exception.Create('Can''t create task for null task!');

  inherited Create(CollectionFile, Data.FileName);

  FData := Data.Copy;
end;

constructor TAddTask.Create(CollectionFile: string; FileName: string);
begin
  inherited Create(CollectionFile, FileName);
  FData := TDBPopupMenuInfoRecord.CreateFromFile(FileName);
  FData.Include := True;
end;

destructor TAddTask.Destroy;
begin
  F(FData);
  inherited;
end;

procedure TAddTask.Execute(Items: TArray<TAddTask>);
var
  I: Integer;
  ResArray: TImageDBRecordAArray;
  Infos: TDBPopupMenuInfo;
  Info: TDBPopupMenuInfoRecord;
  Res: TImageDBRecordA;
begin
  try
    Infos := TDBPopupMenuInfo.Create;
    try
      for I := 0 to Length(Items) - 1 do
        Infos.Add(Items[I].Data.Copy);

      ResArray := GetImageIDWEx(Infos, False);
      try
        for I := 0 to Length(ResArray) - 1 do
        begin
          Res := ResArray[I];
          Info := Infos[I];

          if Res.Jpeg = nil then
          begin
            //failed to load image
            Continue;
          end;

          //decode jpeg in background for fasten drawing in GUI
          Res.Jpeg.DIBNeeded;

          TThread.Synchronize(nil,
            procedure
            begin
              NotifyAboutFileProcessing(Info, Res);
              FormUpdateStatus.ShowForm(True);
            end
          );

          //new file in collection
          if Res.Count = 0 then
          begin
            TDatabaseUpdateManager.AddFile(Info, Res);
            Continue;
          end;

          if Res.Count = 1 then
          begin
            //moved file
            if (StaticPath(Res.FileNames[0]) and not FileExists(Res.FileNames[0])) or (Res.Attr[0] = Db_attr_not_exists) then
            begin
              TDatabaseUpdateManager.MergeWithExistedInfo(Res.IDs[0], Info, Res);
              Continue;
            end;

            //the same file
            if AnsiLowerCase(Res.FileNames[0]) = AnsiLowerCase(Info.FileName) then
              Continue;
          end;

          //add file as diplicate
          TDatabaseUpdateManager.AddFileAsDuplicate(Info, Res);
        end;

      finally
        for I := 0 to Length(ResArray) - 1 do
          if ResArray[I].Jpeg <> nil then
             ResArray[I].Jpeg.Free;
      end;
    finally
      F(Infos);
    end;

  except
    on e: Exception do
      EventLog(e);
  end;
end;

procedure TAddTask.NotifyAboutFileProcessing(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
var
  EventInfo: TEventValues;
begin
  EventInfo.ReadFromInfo(Info);
  EventInfo.JPEGImage := Res.Jpeg;
  DBKernel.DoIDEvent(Application.MainForm as TDBForm, LastInseredID, [EventID_FileProcessed], EventInfo);
end;

{ TUpdaterStorage }

procedure TUpdaterStorage.Add(Task: TDatabaseTask; Priority: TDatabaseTaskPriority = dtpHigh);
begin
  FSync.Enter;
  try
    if Priority = dtpNormal then
      FTasks.Add(Task);
    if Priority = dtpHigh then
      FTasks.Insert(0, Task);

    Inc(FTotalItemsCount);
  finally
    FSync.Leave;
  end;
end;

procedure TUpdaterStorage.AddRange(Tasks: TList<TDatabaseTask>; Priority: TDatabaseTaskPriority = dtpHigh);
begin
  FSync.Enter;
  try
    if Priority = dtpNormal then
      FTasks.AddRange(Tasks.ToArray());
    if Priority = dtpHigh then
      FTasks.InsertRange(0, Tasks.ToArray());

    Inc(FTotalItemsCount, Tasks.Count);
  finally
    FSync.Leave;
  end;
end;

constructor TUpdaterStorage.Create;
begin
  FSync := TCriticalSection.Create;
  FTasks := TList<TDatabaseTask>.Create;
  TDatabaseUpdater.Create;
  FEstimateRemainingTime := 0;
  FTotalItemsCount := 0;
end;

destructor TUpdaterStorage.Destroy;
begin
  FUpdaterStorage.SaveStorage;
  F(FSync);
  FreeList(FTasks);
  inherited;
end;

function TUpdaterStorage.GetActiveItemsCount: Integer;
begin
  FSync.Enter;
  try
    Result := FTasks.Count;
  finally
    FSync.Leave;
  end;
end;

function TUpdaterStorage.GetEstimateRemainingTime: TTime;
begin
  FSync.Enter;
  try
    Result := FEstimateRemainingTime;
  finally
    FSync.Leave;
  end;
end;

procedure TUpdaterStorage.UpdateRemainingTime(Conter: TSpeedEstimateCounter);
begin
  FSync.Enter;
  try
    FEstimateRemainingTime := Conter.GetTimeRemaining(100 * FTasks.Count);
  finally
    FSync.Leave;
  end;
end;

procedure TUpdaterStorage.RestoreStorage;
begin
  //not implemented (is it really needed for users?)
end;

procedure TUpdaterStorage.SaveStorage;
begin
  //not implemented (is it really needed for users?)
end;

function TUpdaterStorage.Take<T>(Count: Integer): TArray<T>;
var
  I: Integer;
  FItems: TList<T>;
begin
  FSync.Enter;
  try
    FItems := TList<T>.Create;
    try
      for I := 0 to FTasks.Count - 1 do
        if (FTasks[I] is T) and FTasks[I].IsPrepaired then
        begin
          FItems.Add(FTasks[I]);
          if FItems.Count = Count then
            Break;
        end;

      for I := 0 to FItems.Count - 1 do
        FTasks.Remove(FItems[I]);

      Result := FItems.ToArray();
    finally
      F(FItems);
    end;
  finally
    FSync.Leave;
  end;
end;

function TUpdaterStorage.TakeOne<T>: T;
var
  Tasks: TArray<T>;
begin
  Tasks := Take<T>(1);
  if Length(Tasks) = 0 then
    Exit(nil);

  Exit(Tasks[0]);
end;

{ TDatabaseUpdater }

constructor TDatabaseUpdater.Create;
begin
  inherited Create(nil, False);
  FSpeedCounter := TSpeedEstimateCounter.Create(60 * 1000); //60 sec is estimate period
end;

destructor TDatabaseUpdater.Destroy;
begin
  F(FSpeedCounter);
  inherited;
end;

procedure TDatabaseUpdater.Execute;
var
  Task: TDatabaseTask;
  AddTasks: TArray<TAddTask>;
  UpdateTask: TUpdateTask;
begin
  inherited;
  FreeOnTerminate := True;

  //task will work in background
  while True do
  begin
    if DBTerminating then
      Break;

    AddTasks := UpdaterStorage.Take<TAddTask>(cAddImagesAtOneStep);
    try
      if Length(AddTasks) > 0 then
      begin
        AddTasks[0].Execute(AddTasks);
        FSpeedCounter.AddSpeedInterval(100 * Length(AddTasks));

        UpdaterStorage.UpdateRemainingTime(FSpeedCounter);
      end;
    finally
      for Task in AddTasks do
        Task.Free;
    end;

    if DBTerminating then
      Break;

    UpdateTask := UpdaterStorage.TakeOne<TUpdateTask>();
    try
      if UpdateTask <> nil then
      begin
        UpdateTask.Execute;
        FSpeedCounter.AddSpeedInterval(100 * 1);
      end;
    finally
      F(UpdateTask);
    end;
  end;
end;

initialization
  FStorageLock := TCriticalSection.Create;

finalization
  F(FUpdaterStorage);
  F(FStorageLock);

end.

