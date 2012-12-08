unit uWinAPIRedirections;

interface

uses
  WinApi.Windows,
  System.SysUtils,
  System.StrUtils,
  uAPIHook,
  uStrongCrypt,
  uWinApiRuntime,
  uProgramCommunication,
  uTransparentEncryption,
  uTransparentEncryptor;

{$WARN SYMBOL_PLATFORM OFF}

const
  NTDLLFile = 'ntdll.dll';
  STATUS_NO_SUCH_FILE = $C000000F;

procedure HookPEModule(Module: HModule; Recursive: Boolean = True);
function CreateFileWHookProc(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
                                         lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                         hTemplateFile: THandle): THandle; stdcall;
function OpenFileAHookProc(const lpFileName: LPCSTR; var lpReOpenBuff: TOFStruct; uStyle: UINT): HFILE; stdcall;
function CreateFileAHookProc(lpFileName: PAnsiChar; dwDesiredAccess, dwShareMode: DWORD;
                                         lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                         hTemplateFile: THandle): THandle; stdcall;
function SetFilePointerExHookProc(hFile: THandle; liDistanceToMove: TLargeInteger;
                                         const lpNewFilePointer: PLargeInteger; dwMoveMethod: DWORD): BOOL; stdcall;

function SetFilePointerHookProc(hFile: THandle; lDistanceToMove: Longint;
                                         lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall;
function ReadFileHookProc(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; lpNumberOfBytesRead: PDWORD; lpOverlapped: POverlapped): BOOL; stdcall;
function ReadFileExHookProc(hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; lpOverlapped: POverlapped; lpCompletionRoutine: TPROverlappedCompletionRoutine): BOOL; stdcall;

function CloseHandleHookProc(hObject: THandle): BOOL; stdcall;
function LoadLibraryAHookProc(lpLibFileName: PAnsiChar): HMODULE; stdcall;
function LoadLibraryWHookProc(lpLibFileName: PWideChar): HMODULE; stdcall;
function GetProcAddressHookProc(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;




function GetFileSizeEx(hFile: THandle; var lpFileSize: Int64): BOOL; stdcall; external 'kernel32.dll';

function LdrLoadDll(szcwPath: PWideChar;
                    pdwLdrErr: PULONG;
                    pUniModuleName: PUnicodeString;
                    pResultInstance: PHandle): NTSTATUS; stdcall; external NTDLLFile;

function NtCreateFile(FileHandle: PHANDLE; DesiredAccess: ACCESS_MASK;
                      ObjectAttributes: POBJECT_ATTRIBUTES; IoStatusBlock: PIO_STATUS_BLOCK;
                      AllocationSize: PLARGE_INTEGER; FileAttributes: ULONG; ShareAccess: ULONG;
                      CreateDisposition: ULONG; CreateOptions: ULONG; EaBuffer: PVOID;
                      EaLength: ULONG): NTSTATUS; stdcall; external NTDLLFile;

function NtQueryDirectoryFile(FileHandle: HANDLE; Event: HANDLE; ApcRoutine: PIO_APC_ROUTINE; ApcContext: PVOID;
                              IoStatusBlock: PIO_STATUS_BLOCK; FileInformation: PVOID; FileInformationLength: ULONG;
                              FileInformationClass: FILE_INFORMATION_CLASS; ReturnSingleEntry: ByteBool; FileName: PUnicodeString;
                              RestartScan: ByteBool): NTSTATUS; stdcall; external NTDLLFile;

function NtQueryInformationFile(FileHandle: HANDLE;
                                IoStatusBlock: PIO_STATUS_BLOCK;
                                FileInformation: PVOID;
                                FileInformationLength: ULONG;
                                FileInformationClass: FILE_INFORMATION_CLASS
                                ): NTSTATUS; stdcall; external NTDLLFile;

var
  DefaultDll: string;

implementation

//hooks file opening
function CreateProcessACallbackProc(appName, cmdLine: pchar; processAttr, threadAttr: PSecurityAttributes; inheritHandles: bool; creationFlags: dword; environment: pointer; currentDir: pchar; const startupInfo: TStartupInfo; var processInfo: TProcessInformation) : bool; stdcall;
begin
  Result := CreateProcessANextHook(appName, cmdLine, processAttr, threadAttr, inheritHandles, creationFlags, environment, currentDir, startupInfo, processInfo);
    //If explorer opens files like regedit or netstat - we can now auto inject our DLL into them hooking their API ;)!!!!
  //this will now keep injecting and recurring in every process which is ran through the created ones :)
  InjectDllToTarget(DefaultDll, processInfo.dwProcessId, @InjectedProc, 1000);
end;

//hooks file opening
function CreateProcessWCallbackProc(appName, cmdLine: pwidechar; processAttr, threadAttr: PSecurityAttributes; inheritHandles: bool; creationFlags: dword; environment: pointer; currentDir: pwidechar; const startupInfo: TStartupInfo; var processInfo: TProcessInformation) : bool; stdcall;
begin
  Result := CreateProcessWNextHook(appName, cmdLine, processAttr, threadAttr, inheritHandles, creationFlags, environment, currentDir, startupInfo, processInfo);
  //If explorer opens files like regedit or netstat - we can now auto inject our DLL into them hooking their API ;)!!!!
  //this will now keep injecting and recurring in every process which is ran through the created ones :)
  InjectDllToTarget(DefaultDll, processInfo.dwProcessId, @InjectedProc, 1000);
end;

function DuplicateHandleHookProc (hSourceProcessHandle, hSourceHandle, hTargetProcessHandle: THandle;
                                          lpTargetHandle: PHandle; dwDesiredAccess: DWORD;
                                          bInheritHandle: BOOL; dwOptions: DWORD): BOOL; stdcall;
begin
  if IsEncryptedHandle(hSourceHandle) then
    NotifyEncryptionError('DuplicateHandleHookProc');

  Result := DuplicateHandleNextHook(hSourceProcessHandle, hSourceHandle, hTargetProcessHandle, lpTargetHandle, dwDesiredAccess,
                                    bInheritHandle, dwOptions);
end;

function GetFileAttributesExAHookProc(lpFileName: PAnsiChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL; stdcall;
var
  Attributes: ^WIN32_FILE_ATTRIBUTE_DATA;
  FileSize: Int64;
  LastError: DWORD;
begin
  Result := GetFileAttributesExANextHook(lpFileName, fInfoLevelId, lpFileInformation);

  if fInfoLevelId = GetFileExInfoStandard then
  begin
    LastError := GetLastError;
    if ValidEnryptFileEx(string(AnsiString(lpFileName))) then
    begin
      Attributes := lpFileInformation;
      Int64Rec(FileSize).Lo := Attributes.nFileSizeLow;
      Int64Rec(FileSize).Hi := Attributes.nFileSizeHigh;
      FileSize := FileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);
      Attributes.nFileSizeLow := Int64Rec(FileSize).Lo;
      Attributes.nFileSizeHigh := Int64Rec(FileSize).Hi;
    end;
    SetLastError(LastError);
  end else
    NotifyEncryptionError('GetFileAttributesExA, not GetFileExInfoStandard');
end;

function GetFileAttributesExWHookProc(lpFileName: PWideChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL; stdcall;
var
  Attributes: ^WIN32_FILE_ATTRIBUTE_DATA;
  FileSize: Int64;
  LastError: DWORD;
begin
  Result := GetFileAttributesExWNextHook(lpFileName, fInfoLevelId, lpFileInformation);
  if fInfoLevelId = GetFileExInfoStandard then
  begin
    LastError := GetLastError;
    if ValidEnryptFileEx(lpFileName) then
    begin
      Attributes := lpFileInformation;
      Int64Rec(FileSize).Lo := Attributes.nFileSizeLow;
      Int64Rec(FileSize).Hi := Attributes.nFileSizeHigh;
      FileSize := FileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);
      Attributes.nFileSizeLow := Int64Rec(FileSize).Lo;
      Attributes.nFileSizeHigh := Int64Rec(FileSize).Hi;
    end;
    SetLastError(LastError);
  end else
    NotifyEncryptionError('GetFileAttributesExW, not GetFileExInfoStandard');
end;

function FindFirstFileAHookProc(lpFileName: PAnsiChar; var lpFindFileData: TWIN32FindDataA): THandle; stdcall;
var
  FileSize: Int64;
  LastError: DWORD;
begin
  Result := FindFirstFileANextHook(lpFileName, lpFindFileData);
  LastError := GetLastError;

  if ValidEnryptFileEx(string(AnsiString(lpFileName))) then
  begin
    Int64Rec(FileSize).Lo := lpFindFileData.nFileSizeLow;
    Int64Rec(FileSize).Hi := lpFindFileData.nFileSizeHigh;
    FileSize := FileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);
    lpFindFileData.nFileSizeLow := Int64Rec(FileSize).Lo;
    lpFindFileData.nFileSizeHigh := Int64Rec(FileSize).Hi;
  end;

  SetLastError(LastError);
end;

function FindFirstFileWHookProc(lpFileName: PWideChar; var lpFindFileData: TWIN32FindDataW): THandle; stdcall;
var
  FileSize: Int64;
  LastError: DWORD;
begin
  Result := FindFirstFileWNextHook(lpFileName, lpFindFileData);
  LastError := GetLastError;

  if ValidEnryptFileEx(lpFileName) then
  begin
    Int64Rec(FileSize).Lo := lpFindFileData.nFileSizeLow;
    Int64Rec(FileSize).Hi := lpFindFileData.nFileSizeHigh;
    FileSize := FileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);
    lpFindFileData.nFileSizeLow := Int64Rec(FileSize).Lo;
    lpFindFileData.nFileSizeHigh := Int64Rec(FileSize).Hi;
  end;

  SetLastError(LastError);
end;

function GetFileSizeHookProc(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall;
var
  FileSize: Int64;
begin
  Result := GetFileSizeNextHook(hFile, lpFileSizeHigh);
  if IsEncryptedHandle(hFile) then
  begin
    Int64Rec(FileSize).Lo := Result;
    Int64Rec(FileSize).Hi := 0;
    if Assigned(lpFileSizeHigh) then
      Int64Rec(FileSize).Hi := PCardinal(lpFileSizeHigh)^;

    FileSize := FileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);

    Result := Int64Rec(FileSize).Lo;
    if Assigned(lpFileSizeHigh) then
      PCardinal(lpFileSizeHigh)^ := Int64Rec(FileSize).Hi;
  end;
end;

function GetFileSizeExHookProc(hFile: THandle; var lpFileSize: Int64): BOOL; stdcall;
begin
  Result := GetFileSizeExNextHook(hFile, lpFileSize);
  if IsEncryptedHandle(hFile) then
    lpFileSize := lpFileSize - SizeOf(TEncryptedFileHeader) - SizeOf(TEncryptFileHeaderExV1);
end;

function CreateFileMappingAHookProc(hFile: THandle; lpFileMappingAttributes: PSecurityAttributes;
                                        flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD; lpName: PAnsiChar): THandle; stdcall;
begin
  Result := CreateFileMappingANextHook(hFile, lpFileMappingAttributes, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, lpName);
  if IsEncryptedHandle(hFile) then
    AddFileMapping(hFile, Result);
end;

function CreateFileMappingWHookProc(hFile: THandle; lpFileMappingAttributes: PSecurityAttributes;
                                        flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD; lpName: PWideChar): THandle; stdcall;
begin
  Result := CreateFileMappingWNextHook(hFile, lpFileMappingAttributes, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, lpName);
  if IsEncryptedHandle(hFile) then
    AddFileMapping(hFile, Result);
end;

function MapViewOfFileHookProc(hFileMappingObject: THandle; dwDesiredAccess: DWORD;
                                dwFileOffsetHigh, dwFileOffsetLow: DWORD; dwNumberOfBytesToMap: SIZE_T): Pointer; stdcall;
begin
  if IsInternalFileMapping(hFileMappingObject) then
  begin
    Result := GetInternalFileMapping(hFileMappingObject, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
    Exit;
  end;

  Result := MapViewOfFileNextHook(hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
end;

function UnmapViewOfFileHookProc(lpBaseAddress: Pointer): BOOL; stdcall;
begin
  //TODO: free block
  Result := UnmapViewOfFileNextHook(lpBaseAddress);
end;

function MapViewOfFileExHookProc(hFileMappingObject: THandle; dwDesiredAccess: DWORD;
                                dwFileOffsetHigh, dwFileOffsetLow: DWORD; dwNumberOfBytesToMap: SIZE_T; lpBaseAddress: Pointer): Pointer; stdcall;
begin
  if lpBaseAddress = nil then
    Exit(MapViewOfFileHookProc(hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap));

  NotifyEncryptionError('MapViewOfFileEx, lpBaseAddress');
  Result := MapViewOfFileNextHook(hFileMappingObject, dwDesiredAccess, dwFileOffsetHigh, dwFileOffsetLow, dwNumberOfBytesToMap);
end;

function _lopenHookProc(const lpPathName: LPCSTR; iReadWrite: Integer): HFILE; stdcall;
begin
 if MessageBox(0, '�������: _lopen', '��������� ?', MB_YESNO or MB_ICONQUESTION) = IDYES then
    result := _lOpenNextHook( lpPathName,iReadWrite)
  else
    result := 0;
end;

function _lreadHookProc(hFile: HFILE; lpBuffer: Pointer; uBytes: UINT): UINT; stdcall;
var
  dwCurrentFilePosition: Int64;
begin
  dwCurrentFilePosition := FileSeek(hFile, Int64(0), FILE_CURRENT);

  result := _lReadNextHook(hFile, lpBuffer, uBytes);

  ReplaceBufferContent(hFile, lpBuffer, dwCurrentFilePosition, uBytes, Result, nil, nil);
end;

function _lcreatHookProc(const lpPathName: LPCSTR; iAttribute: Integer): HFILE; stdcall;
begin
  if MessageBox(0, '�������: _lcreat', '��������� ?', MB_YESNO or MB_ICONQUESTION) = IDYES then
    result := _lCreatNextHook(lpPathName, iAttribute)
  else
    result := 0;
end;

function GetModuleName(hModule: HMODULE): string;
var
  szFileName: array[0..MAX_PATH] of Char;
  ModuleFileLength: Integer;
begin
  FillChar(szFileName, SizeOf(szFileName), #0);
  ModuleFileLength := GetModuleFileName(hModule, szFileName, MAX_PATH);
  SetString(Result, szFileName, ModuleFileLength);
end;

function IsSystemDll(dllName: string): Boolean;
begin
  //disable hook by dll name, currenltly can inject to any dll
  Result := False;
end;

procedure ProcessDllLoad(Module: HModule; lpLibFileName: string);
begin
  if (Module > 0) and not IsSystemDll(lpLibFileName) then
    HookPEModule(Module, False);
end;

function LoadLibraryExAHookProc(lpLibFileName: PAnsiChar; hFile: THandle; dwFlags: DWORD): HMODULE; stdcall;
begin
  Result := LoadLibraryExANextHook(lpLibFileName, hFile, dwFlags);
end;

function LoadLibraryExWHookProc(lpLibFileName: PWideChar; hFile: THandle; dwFlags: DWORD): HMODULE; stdcall;
begin
  Result := LoadLibraryExWNextHook(lpLibFileName, hFile, dwFlags);
end;

function LoadLibraryWHookProc(lpLibFileName: PWideChar): HMODULE; stdcall;
begin
  Result := LoadLibraryWNextHook(lpLibFileName);
end;

function LoadLibraryAHookProc(lpLibFileName: PAnsiChar): HMODULE; stdcall;
begin
  Result := LoadLibraryANextHook(lpLibFileName);
end;

{ .: NT_SUCCESS :. }
function NT_SUCCESS(const Status: NTSTATUS): Boolean;
begin
  Result := (Integer(Status) >= 0);
end;

function LdrLoadDllHookProc(szcwPath: PWideChar;
                    pdwLdrErr: PULONG;
                    pUniModuleName: PUnicodeString;
                    pResultInstance: PHandle): NTSTATUS; stdcall;
var
  LastError: DWORD;
begin
  Result := LdrLoadDllNextHook(szcwPath, pdwLdrErr, pUniModuleName, pResultInstance);
  if (pResultInstance <> nil) and (pResultInstance^ > 0) then
  begin
    LastError := GetLastError;

    ProcessDllLoad(pResultInstance^, pUniModuleName.Buffer);

    SetLastError(LastError);
  end;
end;

function NtCreateFileHookProc(FileHandle: PHANDLE; DesiredAccess: ACCESS_MASK;
                              ObjectAttributes: POBJECT_ATTRIBUTES; IoStatusBlock: PIO_STATUS_BLOCK;
                              AllocationSize: PLARGE_INTEGER; FileAttributes: ULONG; ShareAccess: ULONG;
                              CreateDisposition: ULONG; CreateOptions: ULONG; EaBuffer: PVOID;
                              EaLength: ULONG): NTSTATUS; stdcall;
var
  LastError: DWORD;
  lpFileName: PWideChar;
begin
  Result := NtCreateFileNextHook(FileHandle, DesiredAccess, ObjectAttributes, IoStatusBlock,
                                 AllocationSize, FileAttributes, ShareAccess, CreateDisposition,
                                 CreateOptions, EaBuffer, EaLength);
  if NT_SUCCESS(Result) then
  begin

    LastError := GetLastError;

    lpFileName := ObjectAttributes.ObjectName.Buffer;

    if IsHookStarted then
    begin
      if FILE_TYPE_DISK = GetFileType(Result) {not StartsStr('\\.', string(AnsiString(lpFileName))) and not IsSystemPipe(string(AnsiString(lpFileName)))} then
      begin                                      //TODO: use overlaped if use this hook
        if ValidEncryptFileExHandle(FileHandle^, False) then
        begin
          if (DesiredAccess and GENERIC_WRITE > 0) then
          begin
            CloseHandle(FileHandle^);
            FileHandle^ := INVALID_HANDLE_VALUE;
            Result := ERROR_ACCESS_DENIED;
            SetLastError(ERROR_ACCESS_DENIED);
            Exit;
          end;                                                           //TODO: use overlaped if use this hook
          InitEncryptedFile(string(AnsiString(lpFileName)), FileHandle^, False);
        end;
      end;
    end;

    SetLastError(LastError);

  end;
end;

procedure ProcessFSAttributes(FileHandle: HANDLE; FileInformation: PVOID; FileInformationLength: ULONG;
                              FileInformationClass: FILE_INFORMATION_CLASS; STATUS: NTSTATUS);
var
  FullFileName: string;
  DirectoryName: PWideChar;
  Offset: ULONG;

  FileDirectoryInfo: PFILE_DIRECTORY_INFORMATION;
  FileFullDirectoryInfo: PFILE_FULL_DIRECTORY_INFORMATION;
  FileBothDirectoryInfo: PFILE_BOTH_DIRECTORY_INFORMATION;
begin
  if not (NT_SUCCESS(STATUS)) then
    Exit;

  if not (FileInformationClass in [FileDirectoryInformation,
                                   FileFullDirectoryInformation,
                                   FileBothDirectoryInformation{,
                                   FileNamesInformation}]) or
                                   (STATUS = STATUS_NO_SUCH_FILE) or
                                   (FileInformationLength = 0) then Exit;

  //get firectory name
  GetMem(DirectoryName, 1024 + 1);
  GetFinalPathNameByHandle(FileHandle, DirectoryName, 1024, VOLUME_NAME_DOS or VOLUME_NAME_NONE);
  FreeMem(DirectoryName);

  FileFullDirectoryInfo := nil;
  Offset := 0;

  case (FileInformationClass) of
    FileDirectoryInformation:
    begin
      repeat

        FileDirectoryInfo := Pointer((NativeUInt(FileInformation) + Offset));

        FullFileName := string(DirectoryName) + string(FileDirectoryInfo.FileName);
        if ValidEnryptFileEx(FullFileName) then
          FileDirectoryInfo.EndOfFile := FileDirectoryInfo.EndOfFile - 75;

        Offset := Offset + FileDirectoryInfo.NextEntryOffset;

        until (FileDirectoryInfo.NextEntryOffset = 0);
      end;

    FileFullDirectoryInformation:
      begin
        repeat

          FileFullDirectoryInfo := Pointer((NativeUInt(FileInformation) + Offset));

          FullFileName := string(DirectoryName) + string(FileFullDirectoryInfo.FileName);
          if ValidEnryptFileEx(FullFileName) then
            FileFullDirectoryInfo.EndOfFile := FileFullDirectoryInfo.EndOfFile - 75;

          Offset := Offset + FileFullDirectoryInfo.NextEntryOffset;

        until (FileFullDirectoryInfo.NextEntryOffset = 0);

      end;

    FileBothDirectoryInformation:
      begin
        repeat

          FileBothDirectoryInfo := Pointer((NativeUInt(FileInformation) + Offset));

          FullFileName := string(DirectoryName) + string(FileBothDirectoryInfo.FileName);
          if ValidEnryptFileEx(FullFileName) then
            FileFullDirectoryInfo.EndOfFile := FileFullDirectoryInfo.EndOfFile - 75;

          Offset := Offset + FileBothDirectoryInfo.NextEntryOffset;

        until (FileBothDirectoryInfo.NextEntryOffset = 0);

      end;

    FileNamesInformation:
      begin
      (*FileNamesInfo = NULL;
      do
      {
        LastFileNamesInfo = FileNamesInfo;
        FileNamesInfo = (PVOID)((ULONG)FileInformation + Offset);
        if (FileNamesInfo->FileName[0] == 0x5F00)
        {
          if (!FileNamesInfo->NextEntryOffset)
          {
            if(LastFileNamesInfo) LastFileNamesInfo->NextEntryOffset = 0;
            else status = STATUS_NO_SUCH_FILE;
            return status;
          } else
          if (LastFileNamesInfo) LastFileNamesInfo->NextEntryOffset += FileNamesInfo->NextEntryOffset;
        }

        Offset += FileNamesInfo->NextEntryOffset;
      } while (FileNamesInfo->NextEntryOffset);
    break; *)
      end;
  end;

end;

function NtQueryDirectoryFileHookProc(FileHandle: HANDLE; Event: HANDLE; ApcRoutine: PIO_APC_ROUTINE; ApcContext: PVOID;
                              IoStatusBlock: PIO_STATUS_BLOCK; FileInformation: PVOID; FileInformationLength: ULONG;
                              FileInformationClass: FILE_INFORMATION_CLASS; ReturnSingleEntry: ByteBool; FileName: PUnicodeString;
                              RestartScan: ByteBool): NTSTATUS; stdcall;
begin
  Result := NtQueryDirectoryFileNextHook(FileHandle, Event, ApcRoutine, ApcContext, IoStatusBlock,
                                         FileInformation, FileInformationLength, FileInformationClass,
                                         ReturnSingleEntry, FileName, RestartScan);

  ProcessFSAttributes(FileHandle, FileInformation, FileInformationLength, FileInformationClass, Result);
end;

function NtQueryInformationFileHookProc(FileHandle: HANDLE;
                                IoStatusBlock: PIO_STATUS_BLOCK;
                                FileInformation: PVOID;
                                FileInformationLength: ULONG;
                                FileInformationClass: FILE_INFORMATION_CLASS
                                ): NTSTATUS; stdcall;
begin
  Result := NtQueryInformationFileNextHook(FileHandle, IoStatusBlock, FileInformation,
                                           FileInformationLength, FileInformationClass);

 // ProcessFSAttributes(FileHandle, FileInformation, FileInformationLength, FileInformationClass, Result);
end;

procedure HookPEModule(Module: HModule; Recursive: Boolean = True);
begin
  {$IFDEF DEBUG}
  HookCode(Module, Recursive,   @CreateProcessA,     @CreateProcessACallbackProc, @CreateProcessANextHook);
  HookCode(Module, Recursive,   @CreateProcessW,     @CreateProcessWCallbackProc, @CreateProcessWNextHook);

  {REPLACED BY LdrLoadDll}
  hookCode(Module, Recursive,   @LoadLibraryA,       @LoadLibraryAHookProc, @LoadLibraryANextHook);
  hookCode(Module, Recursive,   @LoadLibraryW,       @LoadLibraryWHookProc, @LoadLibraryWNextHook);

  hookCode(Module, Recursive,   @LoadLibraryExA,     @LoadLibraryExAHookProc, @LoadLibraryExANextHook);
  hookCode(Module, Recursive,   @LoadLibraryExW,     @LoadLibraryExWHookProc, @LoadLibraryExWNextHook);

  {ANOTHER HOOKS}
  hookCode(Module, Recursive,   @DuplicateHandle,    @DuplicateHandleHookProc, @DuplicateHandleNextHook);

  {REPLACED BY NtCreateFile}

  {NOT IMPLEMENTED HOOKS}
  hookCode(Module, Recursive,   @_lopen,             @_lopenHookProc, @_lopenNextHook);
  hookCode(Module, Recursive,   @_lcreat,            @_lcreatHookProc, @_lcreatNextHook);
  {$ENDIF}

  hookCode(Module, Recursive,   @LdrLoadDll,         @LdrLoadDllHookProc, @LdrLoadDllNextHook);
  //hookCode(Module, Recursive,   @NtCreateFile,           @NtCreateFileHookProc,           @NtCreateFileNextHook);
  //hookCode(Module, Recursive,   @NtQueryDirectoryFile,   @NtQueryDirectoryFileHookProc,   @NtQueryDirectoryFileNextHook);
  //hookCode(Module, Recursive,   @NtQueryInformationFile, @NtQueryInformationFileHookProc, @NtQueryInformationFileNextHook);

  hookCode(Module, Recursive,   @GetProcAddress,     @GetProcAddressHookProc, @GetProcAddressNextHook);

  hookCode(Module, Recursive,   @GetFileSize,        @GetFileSizeHookProc, @GetFileSizeNextHook);
  hookCode(Module, Recursive,   @GetFileSizeEx,      @GetFileSizeExHookProc, @GetFileSizeExNextHook);

  hookCode(Module, Recursive,   @FindFirstFileA,     @FindFirstFileAHookProc, @FindFirstFileANextHook);
  hookCode(Module, Recursive,   @FindFirstFileW,     @FindFirstFileWHookProc, @FindFirstFileWNextHook);

  hookCode(Module, Recursive,   @GetFileAttributesExA, @GetFileAttributesExAHookProc, @GetFileAttributesExANextHook);
  hookCode(Module, Recursive,   @GetFileAttributesExW, @GetFileAttributesExWHookProc, @GetFileAttributesExWNextHook);

  hookCode(Module, Recursive,   @CreateFileA,        @CreateFileAHookProc, @CreateFileANextHook);
  hookCode(Module, Recursive,   @CreateFileW,        @CreateFileWHookProc, @CreateFileWNextHook);

  hookCode(Module, Recursive,   @OpenFile,           @OpenFileAHookProc, @OpenFileNextHook);

  hookCode(Module, Recursive,   @SetFilePointerEx,   @SetFilePointerExHookProc, @SetFilePointerExNextHook);
  hookCode(Module, Recursive,   @SetFilePointer,     @SetFilePointerHookProc, @SetFilePointerNextHook);
  hookCode(Module, Recursive,   @_lread,             @_lreadHookProc, @_lreadNextHook);
  hookCode(Module, Recursive,   @ReadFile,           @ReadFileHookProc, @ReadFileNextHook);
  hookCode(Module, Recursive,   @ReadFileEx,         @ReadFileExHookProc, @ReadFileExNextHook);

  hookCode(Module, Recursive,   @CloseHandle,        @CloseHandleHookProc, @CloseHandleNextHook);

  hookCode(Module, Recursive,   @CreateFileMappingA, @CreateFileMappingAHookProc, @CreateFileMappingANextHook);
  hookCode(Module, Recursive,   @CreateFileMappingW, @CreateFileMappingWHookProc, @CreateFileMappingWNextHook);

  hookCode(Module, Recursive,   @MapViewOfFile,      @MapViewOfFileHookProc, @MapViewOfFileNextHook);
  hookCode(Module, Recursive,   @MapViewOfFileEx,    @MapViewOfFileExHookProc, @MapViewOfFileExNextHook);

  hookCode(Module, Recursive,   @UnmapViewOfFile,    @UnmapViewOfFileHookProc, @UnmapViewOfFileNextHook);
end;

procedure FixProcAddress(hModule: HMODULE; lpProcName: LPCSTR; var proc: FARPROC);
var
  Module, ProcName: string;
begin
  if ULONG_PTR(lpProcName) shr 16 = 0 then
    Exit;
  Module := AnsiLowerCase(ExtractFileName(GetModuleName(hModule)));
  ProcName := AnsiLowerCase(string(AnsiString(lpProcName)));

  if (Module = 'kernel32.dll') then
  begin
    if ProcName = AnsiLowerCase('_lopen') then
      proc :=  @_lopenHookProc;
    if ProcName = AnsiLowerCase('_lread') then
      proc :=  @_lreadHookProc;
    if ProcName = AnsiLowerCase('_lcreat') then
      proc :=  @_lcreatHookProc;

    if ProcName = AnsiLowerCase('LoadLibraryA') then
      proc :=  @LoadLibraryAHookProc;
    if ProcName = AnsiLowerCase('LoadLibraryW') then
      proc :=  @LoadLibraryWHookProc;
    if ProcName = AnsiLowerCase('LoadLibraryExA') then
      proc :=  @LoadLibraryExAHookProc;
    if ProcName = AnsiLowerCase('LoadLibraryExW') then
      proc :=  @LoadLibraryExWHookProc;

    if ProcName = AnsiLowerCase('GetProcAddress') then
      proc :=  @GetProcAddressHookProc;

    if ProcName = AnsiLowerCase('FindFirstFileA') then
      proc :=  @FindFirstFileAHookProc;
    if ProcName = AnsiLowerCase('FindFirstFileW') then
      proc :=  @FindFirstFileWHookProc;

    if ProcName = AnsiLowerCase('GetFileAttributesExA') then
      proc :=  @GetFileAttributesExAHookProc;
    if ProcName = AnsiLowerCase('GetFileAttributesExW') then
      proc :=  @GetFileAttributesExWHookProc;

    if ProcName = AnsiLowerCase('GetFileSize') then
      proc := @GetFileSizeHookProc;
    if ProcName = AnsiLowerCase('GetFileSizeEx') then
      proc := @GetFileSizeExHookProc;

    if ProcName = AnsiLowerCase('DuplicateHandle') then
      proc :=  @DuplicateHandleHookProc;

    if ProcName = AnsiLowerCase('CreateFileMappingA') then
      proc := @CreateFileMappingAHookProc;
    if ProcName = AnsiLowerCase('CreateFileMappingW') then
      proc := @CreateFileMappingWHookProc;
    if ProcName = AnsiLowerCase('MapViewOfFile') then
      proc := @MapViewOfFileHookProc;
    if ProcName = AnsiLowerCase('MapViewOfFileEx') then
      proc := @MapViewOfFileExHookProc;
    if ProcName = AnsiLowerCase('UnmapViewOfFile') then
      proc := @UnmapViewOfFileHookProc;

    if ProcName = AnsiLowerCase('OpenFile') then
      proc := @OpenFileAHookProc;
    if ProcName = AnsiLowerCase('CreateFileA') then
      proc := @CreateFileAHookProc;
    if ProcName = AnsiLowerCase('CreateFileW') then
      proc := @CreateFileWHookProc;

    if ProcName = AnsiLowerCase('SetFilePointer') then
      proc := @SetFilePointerHookProc;
    if ProcName = AnsiLowerCase('SetFilePointerEx') then
      proc := @SetFilePointerExHookProc;

    if ProcName = AnsiLowerCase('ReadFile') then
      proc := @ReadFileHookProc;
    if ProcName = AnsiLowerCase('ReadFileEx') then
      proc := @ReadFileExHookProc;

    if ProcName = AnsiLowerCase('CloseHandle') then
      proc := @CloseHandleHookProc;
  end;
end;

function GetProcAddressHookProc(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
begin
  Result := GetProcAddressNextHook(hModule, lpProcName);

  if IsHookStarted then
    FixProcAddress(hModule, lpProcName, Result);
end;

function OpenFileAHookProc(const lpFileName: LPCSTR; var lpReOpenBuff: TOFStruct; uStyle: UINT): HFILE; stdcall;
begin
  Result := OpenFileNextHook(lpFileName, lpReOpenBuff, uStyle);

  if IsHookStarted then
    if ValidEnryptFileEx(string(AnsiString(lpFileName))) then
      InitEncryptedFile(string(AnsiString(lpFileName)), Result, False);
end;

function CreateFileAHookProc(lpFileName: PAnsiChar; dwDesiredAccess, dwShareMode: DWORD;
                                         lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                         hTemplateFile: THandle): THandle; stdcall;
var
  LastError: DWORD;
begin
  if dwFlagsAndAttributes and FILE_FLAG_NO_BUFFERING = FILE_FLAG_NO_BUFFERING then
    dwFlagsAndAttributes := dwFlagsAndAttributes xor FILE_FLAG_NO_BUFFERING; //remove flag, unsupported!

  Result := CreateFileANextHook(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile );
  LastError := GetLastError;

  if IsHookStarted then
  begin
    if FILE_TYPE_DISK = GetFileType(Result) then
    begin
      if ValidEncryptFileExHandle(Result, dwFlagsAndAttributes and FILE_FLAG_OVERLAPPED > 0) then
      begin
        if (dwDesiredAccess and GENERIC_WRITE > 0) then
        begin
          CloseHandle(Result);
          Result := INVALID_HANDLE_VALUE;
          SetLastError(ERROR_ACCESS_DENIED);
          Exit;
        end;

        InitEncryptedFile(string(AnsiString(lpFileName)), Result, dwFlagsAndAttributes and FILE_FLAG_OVERLAPPED > 0);
      end;
    end;
  end;

  SetLastError(LastError);
end;

function CreateFileWHookProc(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
                                         lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                         hTemplateFile: THandle): THandle; stdcall;
var
  LastError: DWORD;
begin
  if dwFlagsAndAttributes and FILE_FLAG_NO_BUFFERING = FILE_FLAG_NO_BUFFERING then
    dwFlagsAndAttributes := dwFlagsAndAttributes xor FILE_FLAG_NO_BUFFERING; //remove flag

  Result := CreateFileWNextHook( lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile );
  LastError := GetLastError;

  if IsHookStarted then
  begin
    if FILE_TYPE_DISK = GetFileType(Result) then
    begin
      if ValidEncryptFileExHandle(Result, dwFlagsAndAttributes and FILE_FLAG_OVERLAPPED > 0) then
      begin
        if (dwDesiredAccess and GENERIC_WRITE > 0) then
        begin
          CloseHandle(Result);
          Result := INVALID_HANDLE_VALUE;
          SetLastError(ERROR_ACCESS_DENIED);
          Exit;
        end;
        InitEncryptedFile(lpFileName, Result, dwFlagsAndAttributes and FILE_FLAG_OVERLAPPED > 0);
      end;
    end;
  end;

  SetLastError(LastError);
end;

function SetFilePointerHookProc(hFile: THandle; lDistanceToMove: Longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall;
begin
  Result := FixFileSize(hFile, lDistanceToMove, lpDistanceToMoveHigh, dwMoveMethod, SetFilePointerNextHook);
end;

function SetFilePointerExHookProc(hFile: THandle; liDistanceToMove: TLargeInteger; const lpNewFilePointer: PLargeInteger; dwMoveMethod: DWORD): BOOL; stdcall;
begin
  Result := FixFileSizeEx(hFile, liDistanceToMove, lpNewFilePointer, dwMoveMethod, SetFilePointerExNextHook);
end;

function ReadFileHookProc(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD; lpNumberOfBytesRead: PDWORD; lpOverlapped: POverlapped): BOOL; stdcall;
var
  dwCurrentFilePosition: Int64;
  LastError: DWORD;
  lpNumberOfBytesTransferred: DWORD;
begin

  LastError := GetLastError;
  dwCurrentFilePosition := FileSeek(hFile, Int64(0), FILE_CURRENT);
  SetLastError(LastError);

  if Assigned(lpOverlapped) then
  begin
    Int64Rec(dwCurrentFilePosition).Lo := lpOverlapped^.Offset;
    Int64Rec(dwCurrentFilePosition).Hi := lpOverlapped^.OffsetHigh;

    Result := ReadFileNextHook(hFile, Buffer, nNumberOfBytesToRead, lpNumberOfBytesRead, lpOverlapped);
    LastError := GetLastError;
    if not Result and (GetLastError = ERROR_IO_PENDING) then
    begin
      if GetOverlappedResult(hFile, lpOverlapped^, lpNumberOfBytesTransferred, True) then
      begin
        ReplaceBufferContent(hFile, Buffer, dwCurrentFilePosition, lpNumberOfBytesTransferred, lpNumberOfBytesTransferred, lpOverlapped, @Result);
        SetLastError(LastError);
      end;
    end;
  end else
  begin
    Result := ReadFileNextHook(hFile, Buffer, nNumberOfBytesToRead, lpNumberOfBytesRead, lpOverlapped);

    if (lpNumberOfBytesRead <> nil) and (lpNumberOfBytesRead^ > 0) then
    begin
      LastError := GetLastError;
      ReplaceBufferContent(hFile, Buffer, dwCurrentFilePosition, nNumberOfBytesToRead, lpNumberOfBytesRead^, nil, @Result);
      SetLastError(LastError);
    end;
  end;
end;

function ReadFileExHookProc(hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; lpOverlapped: POverlapped; lpCompletionRoutine: TPROverlappedCompletionRoutine): BOOL; stdcall;
begin
  //TODO: support this method
  NotifyEncryptionError('ReadFileEx');
  Result := ReadFileExNextHook(hFile, lpBuffer, nNumberOfBytesToRead, lpOverlapped, lpCompletionRoutine);
end;

function CloseHandleHookProc(hObject: THandle): BOOL; stdcall;
var
  LastError: Cardinal;
begin
  Result := CloseHandleNextHook(hObject);
  LastError := GetLastError;
  CloseFileHandle(hObject);
  SetLastError(LastError);
end;

initialization
  SetEncryptionErrorHandler(NotifyEncryptionError);

end.
