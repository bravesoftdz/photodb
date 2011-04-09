unit uLangUtils;

interface

uses
  Windows;

type
  TGetUserDefaultUILanguage  =  function: LANGID; stdcall;

function PrimaryLangID(lgid: Word): Integer;
function GetUserDefaultUILanguage: LANGID;

implementation

{
he primary langauge codes are:

0x00 LANG_NEUTRAL Neutral
0x01 LANG_ARABIC Arabic
0x02 LANG_BULGARIAN Bulgarian
0x03 LANG_CATALAN Catalan
0x04 LANG_CHINESE Chinese
0x05 LANG_CZECH Czech
0x06 LANG_DANISH Danish
0x07 LANG_GERMAN German
0x08 LANG_GREEK Greek
0x09 LANG_ENGLISH English
0x0a LANG_SPANISH Spanish
0x0b LANG_FINNISH Finnish
0x0c LANG_FRENCH French
0x0d LANG_HEBREW Hebrew
0x0e LANG_HUNGARIAN Hungarian
0x0f LANG_ICELANDIC Icelandic
0x10 LANG_ITALIAN Italian
0x11 LANG_JAPANESE Japanese
0x12 LANG_KOREAN Korean
0x13 LANG_DUTCH Dutch
0x14 LANG_NORWEGIAN Norwegian
0x15 LANG_POLISH Polish
0x16 LANG_PORTUGUESE Portuguese
0x18 LANG_ROMANIAN Romanian
0x19 LANG_RUSSIAN Russian
0x1a LANG_CROATIAN Croatian
0x1a LANG_SERBIAN Serbian
0x1b LANG_SLOVAK Slovak
0x1c LANG_ALBANIAN Albanian
0x1d LANG_SWEDISH Swedish
0x1e LANG_THAI Thai
0x1f LANG_TURKISH Turkish
0x20 LANG_URDU Urdu
0x21 LANG_INDONESIAN Indonesian
0x22 LANG_UKRANIAN Ukrainian
0x23 LANG_BELARUSIAN Belarusian
0x24 LANG_SLOVENIAN Slovenian
0x25 LANG_ESTONIAN Estonian
0x26 LANG_LATVIAN Latvian
0x27 LANG_LITHUANIAN Lithuanian
0x29 LANG_FARSI Farsi
0x2a LANG_VIETNAMESE Vietnamese
0x2b LANG_ARMENIAN Armenian
0x2c LANG_AZERI Azeri
0x2d LANG_BASQUE Basque
0x2f LANG_MACEDONIAN FYRO Macedonian
0x36 LANG_AFRIKAANS Afrikaans
0x37 LANG_GEORGIAN Georgian
0x38 LANG_FAEROESE Faeroese
0x39 LANG_HINDI Hindi
0x3e LANG_MALAY Malay
0x3f LANG_KAZAK Kazak
0x40 LANG_KYRGYZ Kyrgyz
0x41 LANG_SWAHILI Swahili
0x43 LANG_UZBEK Uzbek
0x44 LANG_TATAR Tatar
0x45 LANG_BENGALI Bengali
0x46 LANG_PUNJABI Punjabi
0x47 LANG_GUJARATI Gujarati
0x48 LANG_ORIYA Oriya
0x49 LANG_TAMIL Tamil
0x4a LANG_TELUGU Telugu
0x4b LANG_KANNADA Kannada
0x4c LANG_MALAYALAM Malayalam
0x4d LANG_ASSAMESE Assamese
0x4e LANG_MARATHI Marathi
0x4f LANG_SANSKRIT Sanskrit
0x50 LANG_MONGOLIAN Mongolian
0x56 LANG_GALICIAN Galician
0x57 LANG_KONKANI Konkani
0x58 LANG_MANIPURI Manipuri
0x59 LANG_SINDHI Sindhi
0x5a LANG_SYRIAC Syriac
0x60 LANG_KASHMIRI Kashmiri
0x61 LANG_NEPALI Nepali
0x65 LANG_DIVEHI Divehi
0x7f LANG_INVARIANT

The sublanguage codes are:

0x00 SUBLANG_NEUTRAL Language neutral
0x01 SUBLANG_DEFAULT User Default
0x02 SUBLANG_SYS_DEFAULT System Default
0x01 SUBLANG_ARABIC_SAUDI_ARABIA Arabic (Saudi Arabia)
0x02 SUBLANG_ARABIC_IRAQ Arabic (Iraq)
0x03 SUBLANG_ARABIC_EGYPT Arabic (Egypt)
0x04 SUBLANG_ARABIC_LIBYA Arabic (Libya)
0x05 SUBLANG_ARABIC_ALGERIA Arabic (Algeria)
0x06 SUBLANG_ARABIC_MOROCCO Arabic (Morocco)
0x07 SUBLANG_ARABIC_TUNISIA Arabic (Tunisia)
0x08 SUBLANG_ARABIC_OMAN Arabic (Oman)
0x09 SUBLANG_ARABIC_YEMEN Arabic (Yemen)
0x0a SUBLANG_ARABIC_SYRIA Arabic (Syria)
0x0b SUBLANG_ARABIC_JORDAN Arabic (Jordan)
0x0c SUBLANG_ARABIC_LEBANON Arabic (Lebanon)
0x0d SUBLANG_ARABIC_KUWAIT Arabic (Kuwait)
0x0e SUBLANG_ARABIC_UAE Arabic (U.A.E.)
0x0f SUBLANG_ARABIC_BAHRAIN Arabic (Bahrain)
0x10 SUBLANG_ARABIC_QATAR Arabic (Qatar)
0x01 SUBLANG_AZERI_LATIN Azeri (Latin)
0x02 SUBLANG_AZERI_CYRILLIC Azeri (Cyrillic)
0x01 SUBLANG_CHINESE_TRADITIONAL Chinese (Traditional)
0x02 SUBLANG_CHINESE_SIMPLIFIED Chinese (Simplified)
0x03 SUBLANG_CHINESE_HONGKONG Chinese (Hong Kong SAR, PRC)
0x04 SUBLANG_CHINESE_SINGAPORE Chinese (Singapore)
0x05 SUBLANG_CHINESE_MACAU Chinese (Macau SAR)
0x01 SUBLANG_DUTCH Dutch
0x02 SUBLANG_DUTCH_BELGIAN Dutch (Belgian)
0x01 SUBLANG_ENGLISH_US English (US)
0x02 SUBLANG_ENGLISH_UK English (UK)
0x03 SUBLANG_ENGLISH_AUS English (Australian)
0x04 SUBLANG_ENGLISH_CAN English (Canadian)
0x05 SUBLANG_ENGLISH_NZ English (New Zealand)
0x06 SUBLANG_ENGLISH_EIRE English (Ireland)
0x07 SUBLANG_ENGLISH_SOUTH_AFRICA English (South Africa)
0x08 SUBLANG_ENGLISH_JAMAICA English (Jamaica)
0x09 SUBLANG_ENGLISH_CARIBBEAN English (Caribbean)
0x0a SUBLANG_ENGLISH_BELIZE English (Belize)
0x0b SUBLANG_ENGLISH_TRINIDAD English (Trinidad)
0x0c SUBLANG_ENGLISH_ZIMBABWE English (Zimbabwe)
0x0d SUBLANG_ENGLISH_PHILIPPINES English (Philippines)
0x01 SUBLANG_FRENCH French
0x02 SUBLANG_FRENCH_BELGIAN French (Belgian)
0x03 SUBLANG_FRENCH_CANADIAN French (Canadian)
0x04 SUBLANG_FRENCH_SWISS French (Swiss)
0x05 SUBLANG_FRENCH_LUXEMBOURG French (Luxembourg)
0x06 SUBLANG_FRENCH_MONACO French (Monaco)
0x01 SUBLANG_GERMAN German
0x02 SUBLANG_GERMAN_SWISS German (Swiss)
0x03 SUBLANG_GERMAN_AUSTRIAN German (Austrian)
0x04 SUBLANG_GERMAN_LUXEMBOURG German (Luxembourg)
0x05 SUBLANG_GERMAN_LIECHTENSTEIN German (Liechtenstein)
0x01 SUBLANG_ITALIAN Italian
0x02 SUBLANG_ITALIAN_SWISS Italian (Swiss)
0x02 SUBLANG_KASHMIRI_INDIA Kashmiri (India)
0x01 SUBLANG_KOREAN Korean
0x01 SUBLANG_LITHUANIAN Lithuanian
0x01 SUBLANG_MALAY_MALAYSIA Malay (Malaysia)
0x02 SUBLANG_MALAY_BRUNEI_DARUSSALAM Malay (Brunei Darassalam)
0x02 SUBLANG_NEPALI_INDIA Nepali (India)
0x01 SUBLANG_NORWEGIAN_BOKMAL Norwegian (Bokmal)
0x02 SUBLANG_NORWEGIAN_NYNORSK Norwegian (Nynorsk)
0x01 SUBLANG_PORTUGUESE_BRAZILIAN Portuguese (Brazilian)
0x02 SUBLANG_PORTUGUESE Portuguese
0x02 SUBLANG_SERBIAN_LATIN Serbian (Latin)
0x03 SUBLANG_SERBIAN_CYRILLIC Serbian (Cyrillic)
0x01 SUBLANG_SPANISH Spanish (Castilian)
0x02 SUBLANG_SPANISH_MEXICAN Spanish (Mexican)
0x03 SUBLANG_SPANISH_MODERN Spanish (Modern)
0x04 SUBLANG_SPANISH_GUATEMALA Spanish (Guatemala)
0x05 SUBLANG_SPANISH_COSTA_RICA Spanish (Costa Rica)
0x06 SUBLANG_SPANISH_PANAMA Spanish (Panama)
0x07 SUBLANG_SPANISH_DOMINICAN_REPUBLIC Spanish (Dominican Republic)
0x08 SUBLANG_SPANISH_VENEZUELA Spanish (Venezuela)
0x09 SUBLANG_SPANISH_COLOMBIA Spanish (Colombia)
0x0a SUBLANG_SPANISH_PERU Spanish (Peru)
0x0b SUBLANG_SPANISH_ARGENTINA Spanish (Argentina)
0x0c SUBLANG_SPANISH_ECUADOR Spanish (Ecuador)
0x0d SUBLANG_SPANISH_CHILE Spanish (Chile)
0x0e SUBLANG_SPANISH_URUGUAY Spanish (Uruguay)
0x0f SUBLANG_SPANISH_PARAGUAY Spanish (Paraguay)
0x10 SUBLANG_SPANISH_BOLIVIA Spanish (Bolivia)
0x11 SUBLANG_SPANISH_EL_SALVADOR Spanish (El Salvador)
0x12 SUBLANG_SPANISH_HONDURAS Spanish (Honduras)
0x13 SUBLANG_SPANISH_NICARAGUA Spanish (Nicaragua)
0x14 SUBLANG_SPANISH_PUERTO_RICO Spanish (Puerto Rico)
0x01 SUBLANG_SWEDISH Swedish
0x02 SUBLANG_SWEDISH_FINLAND Swedish (Finland)
0x01 SUBLANG_URDU_PAKISTAN Urdu (Pakistan)
0x02 SUBLANG_URDU_INDIA Urdu (India)
0x01 SUBLANG_UZBEK_LATIN Uzbek (Latin)
0x02 SUBLANG_UZBEK_CYRILLIC
}

function PrimaryLangID(lgid: Word): Integer;
begin
  result := lgid and $3FF;
end;

var
  hKernel:                      HMODULE  =  0;
  _GetUserDefaultUILanguage:    TGetUserDefaultUILanguage = nil;

function GetUserDefaultUILanguage: LANGID;
begin
  // Check function assignment
  if Assigned(_GetUserDefaultUILanguage) then
     // Call function
     result:=_GetUserDefaultUILanguage
  else
  begin
     // Fail the call and set the last error
     SetLastError(ERROR_INVALID_HANDLE);
     result:=0;
  end;
end;

initialization

  // Get library handle
  hKernel := GetModuleHandle('kernel32');

  // Check handle
  if (hKernel <> 0) then
     // Get function address
     @_GetUserDefaultUILanguage:=GetProcAddress(hKernel, 'GetUserDefaultUILanguage')
  else
     // Set function address to nil
     @_GetUserDefaultUILanguage:=nil;

end.