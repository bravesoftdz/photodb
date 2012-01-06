unit uWPDClasses;

interface

uses
  uMemory,
  Winapi.Windows,
  Winapi.ActiveX,
  uPortableClasses,
  uWPDInterfaces,
  Generics.Collections,
  System.Classes,
  System.SysUtils,
  Vcl.Imaging.Jpeg,
  Vcl.Imaging.pngimage,
  uJpegUtils,
  Vcl.Graphics,
  uGraphicUtils,
  uBitmapUtils;

type
  TWPDDeviceManager = class;
  TWPDDevice = class;

  TWPDItem = class(TInterfacedObject, IPDItem)
  private
    FDevice: TWPDDevice;
    FIDevice: IPDevice;
    FItemType: TPortableItemType;
    FName: string;
    FItemKey: string;
    FErrorCode: HRESULT;
    FFullSize, FFreeSize: Int64;
    FItemDate: TDateTime;
    FDeviceID: string;
    FDeviceName: string;
    FWidth: Integer;
    FHeight: Integer;
    procedure ErrorCheck(Code: HRESULT);
    procedure TransferContent(ResourceID: TGUID; Stream: TStream; out ResourceFormat: TGUID);
    procedure ReadProperties;
  public
    constructor Create(ADevice: TWPDDevice; AItemKey: string);
    function GetErrorCode: HRESULT;
    function GetItemType: TPortableItemType;
    function GetName: string;
    function GetItemKey: string;
    function GetFullSize: Int64;
    function GetFreeSize: Int64;
    function GetItemDate: TDateTime;
    function GetDeviceID: string;
    function GetDeviceName: string;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetInnerInterface: IUnknown;
    function ExtractPreview(var PreviewImage: TBitmap): Boolean;
    function SaveToStream(S: TStream): Boolean;
  end;

  TWPDDevice = class(TInterfacedObject, IPDevice)
  private
    FContent: IPortableDeviceContent;
    FManager: TWPDDeviceManager;
    FIManager: IPManager;
    FDevice: IPortableDevice;
    FErrorCode: HRESULT;
    FDeviceID: string;
    FName: string;
    FPropertiesReaded: Boolean;
    FBatteryStatus: Byte;
    FDeviceType: TDeviceType;
    procedure ErrorCheck(Code: HRESULT);
    function GetContent: IPortableDeviceContent;
    procedure InitProps;
    procedure FillItemsCallBack(ParentKey: string; Packet: TList<IPDItem>; var Cancel: Boolean; Context: Pointer);
  public
    constructor Create(AManager: TWPDDeviceManager; Device: IPortableDevice);
    function GetErrorCode: HRESULT;
    function GetName: string;
    function GetDeviceID: string;
    function GetBatteryStatus: Byte;
    function GetDeviceType: TDeviceType;
    procedure FillItems(ItemKey: string; Items: TList<IPDItem>);
    procedure FillItemsWithCallBack(ItemKey: string; CallBack: TFillItemsCallBack; Context: Pointer);
    function GetItemByKey(ItemKey: string): IPDItem;
    function GetItemByPath(Path: string): IPDItem;
    function Delete(ItemKey: string): Boolean;
    property Manager: TWPDDeviceManager read FManager;
    property Content: IPortableDeviceContent read GetContent;
  end;

  TWPDDeviceManager = class(TInterfacedObject, IPManager)
  private
    FManager: IPortableDeviceManager;
    FErrorCode: HRESULT;
    procedure ErrorCheck(Code: HRESULT);
    procedure FillDeviceCallBack(Packet: TList<IPDevice>; var Cancel: Boolean; Context: Pointer);
    procedure FindDeviceCallBack(Packet: TList<IPDevice>; var Cancel: Boolean; Context: Pointer);
  public
    constructor Create;
    function GetErrorCode: HRESULT;
    procedure FillDevices(Devices: TList<IPDevice>);
    procedure FillDevicesWithCallBack(CallBack: TFillDevicesCallBack; Context: Pointer);
    function GetDeviceByName(DeviceName: string): IPDevice;
    property Manager: IPortableDeviceManager read FManager;
  end;

  TFindDeviceContext = class(TObject)
  public
    Name: string;
    Device: IPDevice;
  end;

implementation

{ TWPDDeviceManager }

constructor TWPDDeviceManager.Create;
var
  HR: HRESULT;
begin
  FManager := nil;
  FErrorCode := S_OK;

  HR := CoCreateInstance(CLSID_PortableDeviceManager,
                         nil,
                         CLSCTX_INPROC_SERVER,
                         IID_PortableDeviceManager,
                         FManager);

  ErrorCheck(HR);
end;

procedure TWPDDeviceManager.ErrorCheck(Code: HRESULT);
begin
  if Failed(Code) then
    FErrorCode := Code;
end;

procedure TWPDDeviceManager.FillDeviceCallBack(Packet: TList<IPDevice>;
  var Cancel: Boolean; Context: Pointer);
begin
  TList<IPDevice>(Context).AddRange(Packet);
end;

procedure TWPDDeviceManager.FillDevices(Devices: TList<IPDevice>);
begin
  FillDevicesWithCallBack(FillDeviceCallBack, Devices);
end;

procedure TWPDDeviceManager.FillDevicesWithCallBack(CallBack: TFillDevicesCallBack; Context: Pointer);
var
  HR: HRESULT;
  PDISs: array of PWSTR;
  DeviceIDCount: Cardinal;
  I: Integer;
  FDevice: IPortableDevice;
  Key: _tagpropertykey;
  ClientInformation: IPortableDeviceValues;
  Device: TWPDDevice;
  DevList: TList<IPDevice>;
  Cancel: Boolean;
begin
  Cancel := False;
  DevList := TList<IPDevice>.Create;
  try
    HR := FManager.GetDevices(nil, @DeviceIDCount);
    if SUCCEEDED(HR) then
    begin
      SetLength(PDISs, DeviceIDCount);

      HR := FManager.GetDevices(PLPWSTR(PDISs), @DeviceIDCount);

      if SUCCEEDED(HR) then
      begin
        for I := 0 to Integer(DeviceIDCount) - 1 do
        begin
          HR := CoCreateInstance(CLSID_PortableDeviceFTM,
                  nil,
                  CLSCTX_INPROC_SERVER,
                  IID_PortableDeviceFTM,
                  FDevice);


          if SUCCEEDED(HR) then
          begin

            HR := CoCreateInstance(CLSID_PortableDeviceValues,
                                  nil,
                                  CLSCTX_INPROC_SERVER,
                                  IID_PortableDeviceValues,
                                  ClientInformation);

            if SUCCEEDED(HR) then
            begin
              Key.fmtid := WPD_CLIENT_INFO;
              Key.pid := 2;
              HR := ClientInformation.SetStringValue(Key, PChar('Photo Database'));

              if SUCCEEDED(HR) then
              begin

                Key.pid := 3;
                ErrorCheck(ClientInformation.SetUnsignedIntegerValue(Key, 2));

                Key.pid := 4;
                ErrorCheck(ClientInformation.SetUnsignedIntegerValue(key, 3));

                Key.pid := 5;
                ErrorCheck(ClientInformation.SetUnsignedIntegerValue(key, 0)); //build number
              end else
                ErrorCheck(HR);

              if Succeeded(HR) then
              begin
                HR := FDevice.Open(PWideChar(PDISs[I]), ClientInformation);
                //DEVICE IS READY FOR USING
                if Succeeded(HR) then
                begin
                  Device := TWPDDevice.Create(Self, FDevice);
                  if Device.GetDeviceType <> dtOther then
                  begin
                    DevList.Clear;
                    DevList.Add(Device);
                    CallBack(DevList, Cancel, Context);
                    if Cancel then
                      Break;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    F(DevList);
  end;
end;

procedure TWPDDeviceManager.FindDeviceCallBack(Packet: TList<IPDevice>;
  var Cancel: Boolean; Context: Pointer);
var
  Device: IPDevice;
  C: TFindDeviceContext;
begin
  C := TFindDeviceContext(Context);

  for Device in Packet do
    if Device.Name = C.Name then
    begin
      C.Device := Device;
      Cancel := True;
    end;
end;

function TWPDDeviceManager.GetDeviceByName(DeviceName: string): IPDevice;
var
  Context: TFindDeviceContext;
begin
  Context := TFindDeviceContext.Create;
  try
    Context.Name := DeviceName;
    try
      FillDevicesWithCallBack(FindDeviceCallBack, Context);
    finally
      Result := Context.Device;
    end;
  finally
    F(Context);
  end;
end;

function TWPDDeviceManager.GetErrorCode: HRESULT;
begin
  Result := FErrorCode;
end;

{ TWPDDevice }

constructor TWPDDevice.Create(AManager: TWPDDeviceManager; Device: IPortableDevice);
var
  HR: HRESULT;
  cchFriendlyName: DWORD;
  pszFriendlyName: PWChar;
  pszDevID: PWChar;
begin
  FDevice := Device;
  FBatteryStatus := 255;
  FDeviceType := dtOther;
  FPropertiesReaded := False;
  FContent := nil;
  FName := DEFAULT_PORTABLE_DEVICE_NAME;

  if FDevice = nil then
    raise EInvalidOperation.Create('Device is null!');

  FDevice := Device;
  FManager := AManager;
  FIManager := AManager;

  FDevice.GetPnPDeviceID(pszDevID);
  FDeviceID := pszDevID;
  // First, pass NULL as the PWSTR return string parameter to get the total number
  // of characters to allocate for the string value.

  cchFriendlyName := 0;
  HR := FManager.Manager.GetDeviceFriendlyName(PChar(FDeviceID), nil, @cchFriendlyName);

  // Second allocate the number of characters needed and retrieve the string value.
  if (SUCCEEDED(HR) and (cchFriendlyName > 0)) then
  begin
    GetMem(pszFriendlyName, cchFriendlyName * SizeOf(WChar));
    if (pszFriendlyName <> nil) then
    begin
      HR := FManager.Manager.GetDeviceFriendlyName(PChar(FDeviceID), pszFriendlyName, @cchFriendlyName);
      if (Failed(HR)) then
        FName := DEFAULT_PORTABLE_DEVICE_NAME
      else
        FName := pszFriendlyName;

      FreeMem(pszFriendlyName);
    end else
      FName := DEFAULT_PORTABLE_DEVICE_NAME;
  end else
    ErrorCheck(HR);

end;

function TWPDDevice.Delete(ItemKey: string): Boolean;
begin
  Result := False;
end;

procedure TWPDDevice.ErrorCheck(Code: HRESULT);
begin
  if Failed(Code) then
    FErrorCode := Code;
end;

procedure TWPDDevice.FillItems(ItemKey: string; Items: TList<IPDItem>);
begin
  FillItemsWithCallBack(ItemKey, FillItemsCallBack, Items);
end;

procedure TWPDDevice.FillItemsCallBack(ParentKey: string;
  Packet: TList<IPDItem>; var Cancel: Boolean; Context: Pointer);
begin
  TList<IPDItem>(Context).AddRange(Packet);
end;

procedure TWPDDevice.FillItemsWithCallBack(ItemKey: string;
  CallBack: TFillItemsCallBack; Context: Pointer);
const
  NUM_OBJECTS_TO_REQUEST = 10;
var
  HR: HRESULT;
  cFetched: DWORD;
  dwIndex: DWORD;
  Cancel: Boolean;
  EnumObjectIDs: IEnumPortableDeviceObjectIDs;
  ObjectIDArray:  array[0 .. NUM_OBJECTS_TO_REQUEST - 1] of PWSTR;
  ObjectKey: string;
  ItemList: TList<IPDItem>;
  Item: IPDItem;
  ParentPath: string;
begin
  Cancel := False;

  if ItemKey = '' then
    ItemKey := WPD_DEVICE_OBJECT_ID;

  ParentPath := PortableItemNameCache.GetPathByKey(FDeviceID, ItemKey);

  ItemList := TList<IPDItem>.Create;
  try

    HR := Content.EnumObjects(0,                        // Flags are unused
                              PWideChar(ItemKey),       // Starting from the passed in object
                              nil,                      // Filter is unused
                              EnumObjectIDs);

    // Loop calling Next() while S_OK is being returned.
    while SUCCEEDED(HR) do
    begin

      HR := EnumObjectIDs.Next(NUM_OBJECTS_TO_REQUEST,    // Number of objects to request on each NEXT call
                               @ObjectIDArray,            // Array of PWSTR array which will be populated on each NEXT call
                               cFetched);                 // Number of objects written to the PWSTR array

      if cFetched = 0 then
        Break;
      if (SUCCEEDED(HR)) then
      begin
        // Traverse the results of the Next() operation and recursively enumerate
        // Remember to free all returned object identifiers using CoTaskMemFree()

        for dwIndex := 0 to cFetched - 1 do
        begin
          ObjectKey := string(ObjectIDArray[dwIndex]);

          Item := TWPDItem.Create(Self, ObjectKey);
          ItemList.Add(Item);

          PortableItemNameCache.AddName(FDeviceID, Item.ItemKey, ItemKey, ParentPath + '\' + Item.Name);

          CallBack(ItemKey, ItemList, Cancel, Context);
          if Cancel then
            Break;
          ItemList.Clear;
        end;

        FreeList(ItemList, False);
      end;
    end;
  finally
    F(ItemList);
  end;
end;

function TWPDDevice.GetBatteryStatus: Byte;
begin
  InitProps;
  Result := FBatteryStatus;
end;

function TWPDDevice.GetDeviceID: string;
begin
  Result := FDeviceID;
end;

function TWPDDevice.GetDeviceType: TDeviceType;
begin
  InitProps;
  Result := FDeviceType;
end;

function TWPDDevice.GetErrorCode: HRESULT;
begin
  Result := FErrorCode;
end;

function TWPDDevice.GetItemByKey(ItemKey: string): IPDItem;
begin
  Result := TWPDItem.Create(Self, ItemKey);
end;

function TWPDDevice.GetItemByPath(Path: string): IPDItem;
var
  ItemKey, CurrentPath: string;
  HR: HRESULT;
  pFilter: IPortableDeviceValues;
  ppenum: IEnumPortableDeviceObjectIDs;
  Key: _tagpropertykey;
  cFetched: Cardinal;
  ObjectID: PWSTR;
  PathParts: TStrings;
  I: Integer;
begin
  ItemKey := PortableItemNameCache.GetKeyByPath(FDeviceID, Path);
  if ItemKey = EMPTY_PATH then
  begin
    ItemKey := WPD_DEVICE_OBJECT_ID;

    PathParts := TStringList.Create;
    try
      PathParts.Delimiter := '\';
      PathParts.DelimitedText := Path;
      CurrentPath := '';

      HR := CoCreateInstance(CLSID_PortableDeviceValues, nil, CLSCTX_INPROC_SERVER, IID_PortableDeviceValues, pFilter);

      if Succeeded(HR) then
      begin
        for I := 0 to PathParts.Count - 1 do
        begin
          if PathParts[I] = '' then
            Continue;

          CurrentPath := '\' + PathParts[I];
          Key.fmtid := PKEY_GenericObj;
          Key.pid := WPD_OBJECT_NAME;
          HR := pFilter.SetStringValue(Key, PChar(PathParts[I]));
          if Succeeded(HR) then
          begin
            HR := FContent.EnumObjects(0,
                                       PChar(ItemKey),
                                       pFilter,
                                       ppenum);

            if Succeeded(HR) then
            begin
              HR := ppenum.Next(1,            // Number of objects to request on each NEXT call
                                @ObjectID,    // Array of PWSTR array which will be populated on each NEXT call
                                cFetched);    // Number of objects written to the PWSTR array

              if Succeeded(HR) and (cFetched = 1) then
              begin
                PortableItemNameCache.AddName(FDeviceID, string(ObjectID), ItemKey, CurrentPath);
                ItemKey := string(ObjectID);
              end;
            end;
          end;
        end;
      end;
    finally
      F(PathParts);
    end;
  end;
  Result := GetItemByKey(ItemKey);
end;

function TWPDDevice.GetName: string;
begin
  Result := FName;
end;

procedure TWPDDevice.InitProps;
var
  HR: HRESULT;
  ppProperties: IPortableDeviceProperties;
  Key: _tagpropertykey;
  PropertiesToRead: IPortableDeviceKeyCollection;
  ppValues: IPortableDeviceValues;
  V: Cardinal;
begin
  if FPropertiesReaded then
    Exit;

  FPropertiesReaded := True;

  HR := CoCreateInstance(CLSID_PortableDeviceKeyCollection, nil, CLSCTX_INPROC_SERVER, IID_PortableDeviceKeyCollection, PropertiesToRead);
  if (SUCCEEDED(HR)) then
    HR := Content.Properties(ppProperties)
  else
    ErrorCheck(HR);

  ErrorCheck(HR);

  key.fmtid := PKEY_DeviceObj;
  key.pid := WPD_DEVICE_POWER_LEVEL;
  HR := PropertiesToRead.Add(key);
  ErrorCheck(HR);

  key.fmtid := PKEY_DeviceObj;
  key.pid := WPD_DEVICE_TYPE;
  HR := PropertiesToRead.Add(key);
  ErrorCheck(HR);

  // 3. Request the properties from the device.
  HR :=  ppProperties.GetValues(PChar(WPD_DEVICE_OBJECT_ID),    // The object whose properties we are reading
                                PropertiesToRead,               // The properties we want to read
                                ppValues);                      // Result property values for the specified object

  if (SUCCEEDED(HR)) then
  begin
    key.fmtid := PKEY_DeviceObj;
    key.pid := WPD_DEVICE_POWER_LEVEL;
    HR := ppValues.GetUnsignedIntegerValue(key, V);
    if Succeeded(HR) then
      FBatteryStatus := Byte(V);

    key.fmtid := PKEY_DeviceObj;
    key.pid := WPD_DEVICE_TYPE;
    HR := ppValues.GetUnsignedIntegerValue(key, V);
    if Succeeded(HR) then
    begin
      case V of
        WPD_DEVICE_TYPE_CAMERA:
          FDeviceType := dtCamera;
        WPD_DEVICE_TYPE_MEDIA_PLAYER,
        WPD_DEVICE_TYPE_PHONE:
          FDeviceType := dtPhone;
        WPD_DEVICE_TYPE_VIDEO:
          FDeviceType := dtVideo;
        WPD_DEVICE_TYPE_PERSONAL_INFORMATION_MANAGER,
        WPD_DEVICE_TYPE_AUDIO_RECORDER,
        WPD_DEVICE_TYPE_GENERIC:
      end;
    end;

  end else
    ErrorCheck(HR);
end;

function TWPDDevice.GetContent: IPortableDeviceContent;
begin
  if FContent = nil then
    ErrorCheck(FDevice.Content(FContent));

  Result := FContent;
end;

{ TWPDItem }

constructor TWPDItem.Create(ADevice: TWPDDevice; AItemKey: string);
begin
  FDevice := ADevice;
  FIDevice := ADevice; //to store reference to interface
  FItemKey := AItemKey;
  FErrorCode := S_OK;
  FItemType := piFile;
  FName := AItemKey;
  FFreeSize := 0;
  FFullSize := 0;
  FItemDate := MinDateTime;
  FDeviceID := ADevice.FDeviceID;
  FDeviceName := ADevice.FName;
  FWidth := 0;
  FHeight := 0;
  ReadProperties;
end;

procedure TWPDItem.ErrorCheck(Code: HRESULT);
begin
  if Failed(Code) then
    FErrorCode := Code;
end;

function TWPDItem.ExtractPreview(var PreviewImage: TBitmap): Boolean;
var
  MS: TMemoryStream;
  FormatGUID: TGUID;
  J: TJpegImage;
  PNG: TPngImage;
  W, H: Integer;
  CroppedImage: TBitmap;
begin
  Result := False;
  MS := TMemoryStream.Create;
  try
    TransferContent(WPD_RESOURCE_THUMBNAIL, MS, FormatGUID);
    MS.Seek(0, soFromBeginning);
    if FormatGUID = WPD_OBJECT_FORMAT_BMP then
    begin
      PreviewImage.LoadFromStream(MS);
      Result := not PreviewImage.Empty;
    end else if FormatGUID = WPD_OBJECT_FORMAT_JFIF then
    begin
      J := TJpegImage.Create;
      try
        J.LoadFromStream(MS);
        Result := not J.Empty;
        if Result then
          AssignJpeg(PreviewImage, J);
      finally
        F(J);
      end;
    end else if FormatGUID = WPD_OBJECT_FORMAT_PNG then
    begin
      PNG := TPngImage.Create;
      try
        PNG.LoadFromStream(MS);
        Result := not PNG.Empty;
        if Result then
          AssignGraphic(PreviewImage, PNG);
      finally
        F(PNG);
      end;
    end;
  finally
    F(MS);
  end;
  if Result and (FWidth > 0)  and (FHeight > 0) then
  begin

    W := FWidth;
    H := FHeight;
    ProportionalSize(PreviewImage.Width, PreviewImage.Height, W, H);
    if ((W <> PreviewImage.Width) or (H <> PreviewImage.Height)) and (W > 0) and (H > 0) then
    begin
      CroppedImage := TBitmap.Create;
      try
        CroppedImage.PixelFormat := pf24Bit;
        CroppedImage.SetSize(W, H);
        DrawImageExRect(CroppedImage, PreviewImage, PreviewImage.Width div 2 - W div 2, PreviewImage.Height div 2 - H div 2, W, H, 0, 0);
        F(PreviewImage);
        Exchange(PreviewImage, CroppedImage);
      finally
        F(CroppedImage);
      end;
    end;
  end;
end;

function TWPDItem.GetDeviceID: string;
begin
  Result := FDeviceID;
end;

function TWPDItem.GetDeviceName: string;
begin
  Result := FDeviceName;
end;

function TWPDItem.GetErrorCode: HRESULT;
begin
  Result := FErrorCode;
end;

function TWPDItem.GetFreeSize: Int64;
begin
  Result := FFreeSize;
end;

function TWPDItem.GetFullSize: Int64;
begin
  Result := FFullSize;
end;

function TWPDItem.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TWPDItem.GetInnerInterface: IUnknown;
begin
  Result := nil;
end;

function TWPDItem.GetItemDate: TDateTime;
begin
  Result := FItemDate;
end;

function TWPDItem.GetItemKey: string;
begin
  Result := FItemKey;
end;

function TWPDItem.GetItemType: TPortableItemType;
begin
  Result := FItemType;
end;

function TWPDItem.GetName: string;
begin
  Result := FName;
end;

function TWPDItem.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TWPDItem.ReadProperties;
var
  HR: HRESULT;
  ppProperties: IPortableDeviceProperties;
  PropertiesToRead: IPortableDeviceKeyCollection;
  Key: _tagpropertykey;
  ppValues: IPortableDeviceValues;
  pszObjectName: PChar;
  ObjectTypeGUID: TGUID;
  Size: Int64;
  V: tag_inner_PROPVARIANT;
  W, H: Integer;
begin
  HR := CoCreateInstance(CLSID_PortableDeviceKeyCollection, nil, CLSCTX_INPROC_SERVER, IID_PortableDeviceKeyCollection, PropertiesToRead);
  if (SUCCEEDED(HR)) then
  begin
    HR := FDevice.Content.Properties(ppProperties);

    if Succeeded(HR) then
    begin

      Key.fmtid := PKEY_GenericObj;
      Key.pid := WPD_OBJECT_NAME;
      ErrorCheck(PropertiesToRead.Add(key));

      Key.fmtid := PKEY_GenericObj;
      Key.pid := WPD_OBJECT_CONTENT_TYPE;
      ErrorCheck(PropertiesToRead.Add(key));

      HR :=  ppProperties.GetValues(PChar(FItemKey),    // The object whose properties we are reading
                                    PropertiesToRead,   // The properties we want to read
                                    ppValues);          // Result property values for the specified object

      if Succeeded(HR) then
      begin

        Key.fmtid := PKEY_GenericObj;
        Key.pid := WPD_OBJECT_NAME;
        HR := ppValues.GetStringValue(key, pszObjectName);
        if (SUCCEEDED(HR)) then
          FName := pszObjectName;

        Key.fmtid := PKEY_GenericObj;
        Key.pid := WPD_OBJECT_CONTENT_TYPE;
        HR := ppValues.GetGuidValue(key, ObjectTypeGUID);

        if (SUCCEEDED(HR)) then
        begin
          if ObjectTypeGUID = WPD_CONTENT_TYPE_FOLDER then
              FItemType := piDirectory;
          if ObjectTypeGUID = WPD_CONTENT_TYPE_IMAGE then
              FItemType := piImage;
          if ObjectTypeGUID = WPD_CONTENT_TYPE_VIDEO then
              FItemType := piVideo;
          if ObjectTypeGUID = WPD_CONTENT_TYPE_FUNCTIONAL_OBJECT then
              FItemType := piStorage;
        end;

        PropertiesToRead.Clear;
        case FItemType of
          piImage,
          piVideo,
          piFile:
          begin
            Key.fmtid := PKEY_GenericObj;
            Key.pid := WPD_OBJECT_SIZE;
            ErrorCheck(PropertiesToRead.Add(key));

            Key.fmtid := PKEY_GenericObj;
            Key.pid := WPD_OBJECT_DATE_CREATED;
            ErrorCheck(PropertiesToRead.Add(key));

            key.fmtid := WPD_MEDIA_PROPERTIES_V1;
            Key.pid := WPD_MEDIA_WIDTH;
            PropertiesToRead.Add(key);

            key.fmtid := WPD_MEDIA_PROPERTIES_V1;
            Key.pid := WPD_MEDIA_HEIGHT;
            PropertiesToRead.Add(key);

            HR :=  ppProperties.GetValues(PChar(FItemKey),    // The object whose properties we are reading
                                          PropertiesToRead,   // The properties we want to read
                                          ppValues);          // Result property values for the specified object

            if Succeeded(HR) then
            begin
              Key.fmtid := PKEY_GenericObj;
              Key.pid := WPD_OBJECT_SIZE;
              if ppValues.GetSignedLargeIntegerValue(key, Size) = S_OK then
                FFullSize := Size;

              Key.fmtid := PKEY_GenericObj;
              Key.pid := WPD_OBJECT_DATE_CREATED;
              if ppValues.GetValue(key, V) = S_OK then
                FItemDate := V.__MIDL____MIDL_itf_PortableDeviceApi_0001_00000001.date;

              key.fmtid := WPD_MEDIA_PROPERTIES_V1;
              Key.pid := WPD_MEDIA_WIDTH;
              if ppValues.GetSignedIntegerValue(key, W) = S_OK then
                FWidth := W;

              key.fmtid := WPD_MEDIA_PROPERTIES_V1;
              Key.pid := WPD_MEDIA_HEIGHT;
              if ppValues.GetSignedIntegerValue(key, H) = S_OK then
                FHeight := H;
            end;
          end;
          piStorage:
          begin
            Key.fmtid := WPD_STORAGE_OBJECT_PROPERTIES_V1;
            Key.pid := WPD_STORAGE_CAPACITY;
            ErrorCheck(PropertiesToRead.Add(key));

            Key.fmtid := WPD_STORAGE_OBJECT_PROPERTIES_V1;
            Key.pid := WPD_STORAGE_FREE_SPACE_IN_BYTES;
            ErrorCheck(PropertiesToRead.Add(key));

            HR :=  ppProperties.GetValues(PChar(FItemKey),    // The object whose properties we are reading
                                          PropertiesToRead,   // The properties we want to read
                                          ppValues);          // Result property values for the specified object

            if Succeeded(HR) then
            begin
              Key.fmtid := WPD_STORAGE_OBJECT_PROPERTIES_V1;
              Key.pid := WPD_STORAGE_CAPACITY;
              if ppValues.GetSignedLargeIntegerValue(key, Size) = S_OK then
                FFullSize := Size;

              Key.fmtid := WPD_STORAGE_OBJECT_PROPERTIES_V1;
              Key.pid := WPD_STORAGE_FREE_SPACE_IN_BYTES;
              if ppValues.GetSignedLargeIntegerValue(key, Size) = S_OK then
                FFreeSize := Size;
            end;
          end;
        end;


      end else
        ErrorCheck(HR);

    end else
      ErrorCheck(HR);
  end else
    ErrorCheck(HR);

end;

function TWPDItem.SaveToStream(S: TStream): Boolean;
var
  FormatGUID: TGUID;
begin
  TransferContent(WPD_RESOURCE_DEFAULT, S, FormatGUID);
  Result := FErrorCode = S_OK;
end;

//WPD_RESOURCE_THUMBNAIL or WPD_RESOURCE_DEFAULT
procedure TWPDItem.TransferContent(ResourceID: TGUID; Stream: TStream; out ResourceFormat: TGUID);
const
  DefaultBufferSize: Integer = 2 * 1024 * 1024;
var
  HR: HRESULT;
  pObjectDataStream: IStream;
  Buff: PByte;
  cbOptimalTransferSize: DWORD;
  Key: _tagpropertykey;
  ButesRead: Longint;
  ppResources: IPortableDeviceResources;
  ppResourceAttributes: IPortableDeviceValues;
  BufferSize, ReadBufferSize: Int64;
  ResFormat: TGUID;
begin
  ResourceFormat := WPD_OBJECT_FORMAT_JFIF;
  BufferSize := DefaultBufferSize;
  HR := FDevice.Content.Transfer(ppResources);
  if (SUCCEEDED(HR)) then
  begin

    HR := ppResources.GetResourceAttributes(PChar(FItemKey),
                                            Key,
                                            ppResourceAttributes);
    if (SUCCEEDED(HR)) then
    begin
      key.fmtid := WPD_RESOURCE_ATTRIBUTES_V1;
      Key.pid := WPD_RESOURCE_ATTRIBUTE_OPTIMAL_READ_BUFFER_SIZE;
      if SUCCEEDED(ppResourceAttributes.GetSignedLargeIntegerValue(key, ReadBufferSize)) then
        BufferSize := ReadBufferSize;

      key.fmtid := WPD_RESOURCE_ATTRIBUTES_V1;
      Key.pid := WPD_RESOURCE_ATTRIBUTE_FORMAT;
      if SUCCEEDED(ppResourceAttributes.GetGuidValue(key, ResFormat)) and (ResFormat.D1 > 0) then
        ResourceFormat := ResFormat;
    end;

    cbOptimalTransferSize := BufferSize;
    Key.fmtid := ResourceID;
    Key.pid := 0;
    HR := ppResources.GetStream(PChar(FItemKey),         // Identifier of the object we want to transfer
                                Key,                     // We are transferring the default resource (which is the entire object's data)
                                STGM_READ,               // Opening a stream in READ mode, because we are reading data from the device.
                                cbOptimalTransferSize,   // Driver supplied optimal transfer size
                                pObjectDataStream);

    if (SUCCEEDED(HR)) then
    begin

      GetMem(Buff, BufferSize);
      try
        repeat
          pObjectDataStream.Read(Buff, BufferSize, @ButesRead);
          Stream.WriteBuffer(Buff[0], ButesRead);
        until (ButesRead = 0);
      finally
        FreeMem(Buff);
      end;
      pObjectDataStream.Commit(0);

    end else
      ErrorCheck(HR);
  end else
    ErrorCheck(HR);

end;


end.
