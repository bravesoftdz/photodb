unit Language;
                                                                          
interface                                                                 

{$DESCRIPTION 'Photo DB v2.2 (������� ������)'}

Const

 ProgramMail = 'illusdolphin@gmail.com';
 TEXT_MES_PRODUCT_VERSION = '2.2';
 TEXT_MES_WARNING = '��������';
 
 TEXT_MES_UNKNOWN_ERROR_F = '�������������� ������! %s';
 TEXT_MES_CONFIRM = '�������������';
 TEXT_MES_INFORMATION = '����������';
 TEXT_MES_SETUP = '���������';        
 TEXT_MES_QUESTION = '������';
 TEXT_MES_FILE_EXISTS_NO_ACTION = '���� � ����� ������ ��� ����������! �������� ������ ��� �����.';
 TEXT_MES_FILE_EXISTS = '���� � ����� ������ ��� ����������! ��������?';
 TEXT_MES_FILE_EXISTS_1 = '���� %s ��� ����������!'+#13+'��������?';
 TEXT_MES_KEY_SAVE = '���� ��� ��������� �������! ������������� ���������� ��� ����������!';
 TEXT_MES_DEL_USER_CONFIRM = '�� ������������� ������ ������� ����� ������������?'+#13+'������������ = "%s"';
 TEXT_MES_ADD_DRIVE = '�� ������������� ������ �������� ���� � ��� ��������?';
 TEXT_MES_DIR_NOT_FOUND = '���������� ����� ����������:'+#13+'%s';
 TEXT_MES_DB_FILE_NOT_VALID = '������ ���� �� �������� ���������� ������ PhotoDB!';
 TEXT_MES_QUIT_SETUP = '�� ������������� ������ ����� �� ���������?';
 TEXT_MES_PROG_IS_NEW = '�� ��������� ��� ����������� ����� ����� ������ ���������!'+#13+'�� ������ ����������?';
 TEXT_MES_PROG_IS = '�� ��������� ��� ����������� ��� ���������!'+#13+'�� ������ ����������?';
 TEXT_MES_DIR_CR_FAILED = '���������� ������� ����������'+#13+'%s'+#13+'����������, �������� ������ ����������';
 TEXT_MES_SETUP_EXIT = TEXT_MES_QUIT_SETUP;
 TEXT_MES_WAIT_FOR_A_MINUTE = '����������, ��������� ������...';
 TEXT_MES_READING_DB = '������ ���� ������...';
 TEXT_MES_READING_GROUPS_DB = '������ ���� ������ �����';
 TEXT_MES_FILE_NOT_FOUND = '���� �� �����!';
 TEXT_MES_INST_BDE = '��������� DBE...';
 TEXT_MES_WAIT_MIN = TEXT_MES_WAIT_FOR_A_MINUTE ;
 TEXT_MES_QUERY_EX = '������ �����������... ';
 
 TEXT_MES_SEARCH = '�����';
 TEXT_MES_DONE = '���������';
 TEXT_MES_STOPING = '���������';
 TEXT_MES_WAITING = '��������';
 
 TEXT_MES_RESULT = '���������';
 TEXT_MES_IDENT = '�����';
 TEXT_MES_SEARCH_TEXT = '����� ������';
 TEXT_MES_CALCULATING = '����������';
 TEXT_MES_INITIALIZE = '�������������';
 TEXT_MES_INITIALIZATION = '�������������';
 TEXT_MES_SIZE = '������';
 TEXT_MES_ITEM = '�������';
 TEXT_MES_ITEMS = '��������';
 TEXT_MES_ADMIN = 'Administrator';   //�� ���������������!
 TEXT_MES_NO_RES = '��� �����������';
 
 TEXT_MES_GUEST = '�����';                                                                                        
 TEXT_MES_MANAGEA = '<����������>';
 TEXT_MES_GROUPSA = '<������>';
 
 TEXT_MES_ID = 'ID';
 TEXT_MES_GENERATING = ' ������... ';
 TEXT_MES_RATING = '������';
 TEXT_MES_COMMENT = '�����������';
 TEXT_MES_NAME = '���';
 TEXT_MES_FULL_PATH = '������ ���';
 TEXT_MES_COMMENTS = '�����������';
 TEXT_MES_KEYWORDS = '�������� �����';
 TEXT_MES_OWNER = '��������';
 TEXT_MES_DATE = '����';
 TEXT_MES_WIDTH = '������';
 TEXT_MES_HEIGHT = '������';
 TEXT_MES_COLLECTION = '���������';
 TEXT_MES_VAL_NOT_SETS = '<�������� �� �����������>';
 TEXT_MES_DATE_NOT_EXISTS = '<���� ���>';
 TEXT_MES_VAR_COM = '<��������� �����������>';
 TEXT_MES_PROGRESS_PR = '����������... (&%%)';
 TEXT_MES_LOAD_QUERY_PR = '�������� �������... (&%%)';
 TEXT_MES_RES_REC = '��������� = %s �������';
 TEXT_MES_SEARCH_FOR_REC = '����������� �����...';
 TEXT_MES_SEARCH_FOR_REC_FROM = '����� %s �������...';
 TEXT_MES_1 = '�� ������������� ������ ������� ����� ������ � ������������ � ��� �������?';
 TEXT_MES_2 = '��������� ���� �� ��������...'+#13+'��������� �������������� ����������?';
 TEXT_MES_3 = '������ � SQL �������. Query:'+#13;
 TEXT_MES_4 = '����������, �������� �������� ������ ��������� � ����������� �����';
 TEXT_MES_SERCH_PR = '����������, ��������� ���� ����������� �����...';
 TEXT_MES_UNABLE_FIND_IMAGE = '���������� ����� ������ �����������!';
 TEXT_MES_SLIDE_SHOW = '��������';
 TEXT_MES_SELECT_ALL = '�������� ��';
 TEXT_MES_SHOW_UPDATER = '�������� ���� ����������';
 TEXT_MES_HELP = '�������';
 TEXT_MES_MANAGE_DB = '���������� ��';
 TEXT_MES_OPTIONS = '���������';
 TEXT_MES_SAVE_AS_TABLE = '��������� ��� �������';
 TEXT_MES_LOAD_RES = '��������� ����������';
 TEXT_MES_SAVE_RES = '��������� ����������';
 TEXT_MES_NEW_PANEL = '����� ������';
 TEXT_MES_EXPLORER = '���������';
 TEXT_MES_FIND_TARGET = '�����';
 TEXT_MES_GENERAL = '�����';
 TEXT_MES_DO_SEARCH_NOW = '�����...';
 TEXT_MES_PANELS = '������';
 TEXT_MES_PROPERTIES = '��������';
 TEXT_MES_PROPERTY = '��������';
 TEXT_MES_DATE_NOT_EX = '���� ���';
 TEXT_MES_DATE_EX = '���� ������������';
 TEXT_MES_DATE_NOT_SETS = '���� �� �����������';
 TEXT_MES_EDIT_GROUPS = '������������� ������';
 TEXT_MES_GROUPS_MANAGER = '���������� ��������';
 TEXT_MES_RATING_NOT_SETS = '������ �� �����������';
 TEXT_MES_SET_COM = '���������� �����������';
 TEXT_MES_SET_COM_NOT = '����������� �� ����������';
 TEXT_MES_CUT = '��������';
 TEXT_MES_COPY_ITEM = '���������� �������';
 
 TEXT_MES_PASTE = '��������';
 TEXT_MES_UNDO = '�������';
 TEXT_MES_SET_VALUE = '���������� ��������';
 TEXT_MES_NOT_AVALIABLE = '�� ��������';
 TEXT_MES_ADD_FILE = '�������� ����';
 TEXT_MES_SHELL = '���������';
 
 TEXT_MES_CLEAR = '��������';
 TEXT_MES_CLOSE = '�������';
 TEXT_MES_LOAD_FROM_FILE = '��������� �� �����';
 TEXT_MES_SAVE_TO_FILE = '��������� � ����';
 TEXT_MES_DBITEM = '����� � ��';
 TEXT_MES_SEARCH_FOR_IT = '�����';
 TEXT_MES_COLOR_THEME = '�������� ����';
 TEXT_MES_MAIN_COLOR = '������� ����';
 TEXT_MES_MAIN_F_COLOR = '������� ���� ������';
 TEXT_MES_LIST_COLOR = '���� �������';
 TEXT_MES_LIST_F_COLOR = '���� ������ �������';
 TEXT_MES_EDIT_COLOR = '���� ����� ��������������';
 TEXT_MES_EDIT_F_COLOR = '���� ������ ����� ��������������';
 TEXT_MES_LABEL_COLOR = '���� ��������';
 TEXT_MES_LOAD_THEME = '��������� ����';
 TEXT_MES_RESET = '�����';
 TEXT_MES_SAVE_THEME_TO_FILE = '��������� ������� ���� � ����';
 TEXT_MES_SHOW_PREVIEW = '���������� ������������';
 TEXT_MES_HINTS = '������������';
 TEXT_MES_ANIMATE_SHOW = '������������� �����';
 TEXT_MES_SHOW_SHADOW = '����� ����';
 TEXT_MES_USERS = '������������';
 TEXT_MES_OK = '��';
 TEXT_MES_CANCEL = '������';
 TEXT_MES_SHELL_EXTS = '����������:';
 TEXT_MES_SHOW_CURRENT_OBJ = '���������� ������� �������:';
 TEXT_MES_FOLDERS = '�����';
 TEXT_MES_SIMPLE_FILES = '������� ����';
 TEXT_MES_IMAGE_FILES = '�����������';
 TEXT_MES_HIDDEN_FILES = '������� �����';
 TEXT_MES_TH_OPTIONS = '����� ��������������:';
 TEXT_MES_SHOW_ATTR = '���������� ��������';
 TEXT_MES_SHOW_TH_FOLDRS = '���������� ������������ ��� �����';
 TEXT_MES_SAVE_TH_FOLDRS = '��������� ������������ ��� �����';
 TEXT_MES_SHOW_TH_IMAGE = '���������� ������������ ��� �����������';
 TEXT_MES_VAR_WIDTH = '��������� ������';
 TEXT_MES_VAR_HEIGHT = '��������� ������';
 TEXT_MES_ALL_IN = '��� � %s';
 TEXT_MES_VAR_LOCATION = '<��������� ����������>';
 TEXT_MES_VAR_FILES = '<��������� �����>';
 TEXT_MES_ALL_PX = '��� - %spx.';
 TEXT_MES_SELECTED_ITEMS = '������� %s ���������';
 TEXT_MES_CLEANING_ITEM = '�������... [%s]';
 TEXT_MES_CLEANING_STOPED = '������� �����������';
 TEXT_MES_LOG_ON_CAPTION = '����';
 TEXT_MES_LOG_ON = '�����!';
 TEXT_MES_AUTO_LOG_ON = '���� ����';
 TEXT_MES_CH_USER = '�������� ������������';
 TEXT_MES_ADD_NEW_USER = '�������� ������ ������������';
 TEXT_MES_DEL_USER = '������� ������������';
 TEXT_MES_CANCEL_AS_DEF = '������ "�� ���������"';
 TEXT_MES_PANEL_CAPTION = '������ (%s)';
 TEXT_MES_QUICK_INFO = '���.';
 TEXT_MES_CANT_LOAD_IMAGE = '���������� ��������� ����������� �� �����:'+#13+'%s';
 TEXT_MES_MY_COMPUTER = '��� ���������';
 TEXT_MES_VIEW_WITH_DB = '�������� � ������� PhotoDB';
 TEXT_MES_BROWSE_WITH_DB = '��������� � ������� PhotoDB';
 TEXT_MES_ERROR_KERNEL_DLL = '���������� ��������� ���������� "kernel.dll"';
 TEXT_MES_PIXEL_FORMAT = '%spx.';                                            
 TEXT_MES_PIXEL_FORMAT_D = '%dpx.';
 TEXT_MES_BYTES = '���';
 TEXT_MES_KB = '��';
 TEXT_MES_MB = '��';
 TEXT_MES_GB = '��';
 TEXT_MES_ERROR_LOGON = '������ �����! (���������� � ������� ��������� �� ������� (FAQ)';
 TEXT_MES_ERROR_USER_NOT_FOUND = '������������ �� ������!';
 TEXT_MES_ERROR_TABLE_NOT_FOUND = '���� ������������� �� �������! (���������� � ������� ��������� �� ������� (FAQ))';
 TEXT_MES_ERROR_USER_ALREADY_EXISTS = '������������ ��� ����������!!!';
 TEXT_MES_ERROR_PASSWORD_WRONG = '������ �������!';
 TEXT_MES_CREATING = '��������';
 TEXT_MES_UNABLE_SHOW_FILE = '���������� ���������� ����:';
 TEXT_MES_NO_DB_FILE = '<��� �����>';
 TEXT_MES_OPEN = '�������';
 TEXT_MES_CREATE_NEW = '������� �����';
 TEXT_MES_FIND = '�����';
 TEXT_MES_EXIT = '�����';
 TEXT_MES_USE_AS_DEFAULT_DB = '������������ �� �� ���������';
 TEXT_MES_SELECT_DATABASE = '������� ��';
 TEXT_MES_SIZE_FORMAT = '������ : %s';
 TEXT_MES_SIZE_FORMATA = '������ = %s';
 TEXT_MES_NEW_DB_SIZE_FORMAT = '������ ����� ���� (��������������) = %s';  
 TEXT_MES_NEW_DB_SIZE_FORMAT_10000 = '������ ����� ���� (�������������� ��� 10000 �������) = %s';
 TEXT_MES_RATING_FORMATA = '������ = %s';
 TEXT_MES_ID_FORMATA = 'ID = %s';
 TEXT_MES_DIMENSIONS = '���������� : %s x %s';
 TEXT_MES_ADD_USER_CAPTION = '�������� ������������';
 TEXT_MES_PASSWORD = '������';
 TEXT_MES_NEW_PASSWORD = '����� ������';
 TEXT_MES_CH_USER_CAPTION = '�������� ������������';
 TEXT_MES_CREATE_ADMIN_CAPTION = '�������� ��������������';
 TEXT_MES_UPDATING_REC_FORMAT = '������ �%s [%s]';
 TEXT_MES_PAUSED = '�����...';
 TEXT_MES_DEL_FROM_DB = '������� ���������� �� ��';
 TEXT_MES_DEL_FILE = '������� ����';
 TEXT_MES_REFRESH_ITEM = '��������';
 TEXT_MES_RENAME = '�������������';
 TEXT_MES_ROTATE_90 = '90* ��';
 TEXT_MES_ROTATE_180 = '180*';
 TEXT_MES_ROTATE_270 = '90* ���';
 TEXT_MES_ROTATE_0 = '���';
 TEXT_MES_ROTATE = '�������';
 TEXT_MES_PRIVATE = '������� ������';
 TEXT_MES_COMMON = '������� �����';
 TEXT_MES_SHOW_FOLDER = '�������� �����';
 TEXT_MES_SEND_TO = '��������� �';
 TEXT_MES_EDITA = '<�������������>';
 TEXT_MES_DEL_FROM_DB_CONFIRM = '�� ������������� ������ ������� ��� ���������� �� ��?';
 TEXT_MES_DEL_FILE_CONFIRM = '��� ���������� �������� �����! ����������?';
 TEXT_MES_SHELL_OPEN_CONFIRM_FORMAT = '�� ������� %s ��������.'+#13+'����������� ����� ������� �� ����� ��������� ������ ����������!'+#13+' ����������?';
 TEXT_MES_PROGRAM_CODE = '��� ����� ����� ���������:';
 TEXT_MES_ACTIVATION_NAME = '��� ��� ���������:';
 TEXT_MES_ACTIVATION_KEY = '������� ���� ���� ��� ���������:';
 TEXT_MES_SET_CODE = '���������� ���';
 TEXT_MES_ACTIVATION_CAPTION = '���������';
 TEXT_MES_CLOSE_FORMAT = '������� [%s]';
 TEXT_MES_REG_TO = '���������������� ��:';
 TEXT_MES_COPY_NOT_ACTIVATED = '<����� �� ������������>';
 TEXT_MES_ADD_DISK = '�������� ����';
 TEXT_MES_ADD_DIRECTORY = '�������� ����������';
 TEXT_MES_ADDFILE = '�������� ����';
 TEXT_MES_MANY_FILES = '����� ������';
 TEXT_MES_FILES = '�����';
 TEXT_MES_NEW_FOLDER = '����� �����';
 TEXT_MES_REC_PRIVATE = '������ ������';
 TEXT_MES_SEL_PLACE_TO_COPY_ONE = '�������� �����, ���� �� ������ ����������� "%s". ����� ������� ������ "��"';
 TEXT_MES_SEL_PLACE_TO_COPY_MANY = '�������� �����, ���� �� ������ ����������� ��� %s �������. ����� ������� ������ "��"';
 TEXT_MES_SEL_PLACE_TO_MOVE_ONE = '�������� �����, ���� �� ������ ����������� "%s". ����� ������� ������ "��"';
 TEXT_MES_SEL_PLACE_TO_MOVE_MANY = '�������� �����, ���� �� ������ ����������� ��� %s items. ����� ������� ������ "��"';
 TEXT_MES_IMAGE_PRIVIEW = '������������:';
 TEXT_MES_DELETE = '�������';
 TEXT_MES_COPY_TO = '����������� � ';
 TEXT_MES_MOVE_TO = '����������� � ';
 TEXT_MES_TASKS = '������';
 TEXT_MES_NEW_WINDOW = '����� ����';
 
 TEXT_MES_DIRECTORY = '����������';
 
 TEXT_MES_OPEN_IN_NEW_WINDOW = '������� � ����� ����';
 TEXT_MES_ADD_FOLDER = '�������� �����';
 TEXT_MES_MAKE_NEW_FOLDER = '�������';
 TEXT_MES_OPEN_IN_SEARCH_WINDOW = '������� � ���� ������';
 TEXT_MES_GO_TO_SEARCH_WINDOW = '������� � ���� ������';
 TEXT_MES_FILE = '����';
 TEXT_MES_FILE_NAME = '��� �����';
 TEXT_MES_ACCESS = '������';

 TEXT_MES_BACK = '�����';
 TEXT_MES_NEXT = '���������';
 TEXT_MES_FORWARD = '�����';
 TEXT_MES_UP = '�����';
 TEXT_MES_VIEW = '���';
 TEXT_MES_SHOW_EXPLORER_PANEL = '�������� ������ ����������';
 TEXT_MES_SHOW_INFO_PANEL = '�������� ������ � �����������';
 TEXT_MES_SHOW_FOLDERS = '���������� �����';
 TEXT_MES_SHOW_FILES = '���������� �����';
 TEXT_MES_SHOW_HIDDEN = '���������� �������';
 TEXT_MES_SHOW_ONLY_COMMON = '���������� ������ �����';
 TEXT_MES_SHOW_PRIVATE = '���������� ������';
 TEXT_MES_TOOLS = '������';
 TEXT_MES_SHOW_DB_MANAGER = '���������� ��';
 TEXT_MES_SEARCHING = '�����';
 TEXT_MES_CONNECTING_TO_DB = '���������� � ��...';
 TEXT_MES_GETTING_INFO_FROM_DB = '��������� ���������� �� ��...';
 TEXT_MES_READING_FOLDER = '������ �����...';
 TEXT_MES_LOADING_INFO = '�������� ����������...';
 TEXT_MES_LOADING_FOLDERS = '�������� �����...';
 TEXT_MES_LOADING_IMAGES = '�������� �����������...';
 TEXT_MES_LOADING_FILES = '�������� ������...';
 TEXT_MES_LOADING_TH = '�������� ��������������';
 TEXT_MES_LOADING_TH_FOR_IMAGES = '�������� ������������� ��� �����������...';
 TEXT_MES_LOADING_TH_FOR_FOLDERS = '�������� ������������� ��� �����...';
 TEXT_MES_READING_MY_COMPUTER = '������ ����������� ����� ����������...';
 TEXT_MES_NO_FILE = '<��� �����>';
 TEXT_MES_SEL_FOLDER_DB_FILES = '�������� ����� � ������ ��';
 TEXT_MES_SEL_FOLDER_INSTALL = '�������� ������������ ���������� ';
 TEXT_MES_ENTER_NAME = '������� ���� ���';
 TEXT_MES_NAMEA = '<���>';
 TEXT_MES_SUPPORTED_TYPES = '�������������� ���� ������:';
 TEXT_MES_SUPPORTED_TYPES_CHECKED = '- ���� ����� ����������� � ������� PhotoDB';
 TEXT_MES_SUPPORTED_TYPES_GRAYED = '- ����� �������� ����� ��� �������';
 TEXT_MES_SUPPORTED_TYPES_UNCHECKED = '- ���������� �� ��������������';
 TEXT_MES_TO_INSTALL = '������� ������ "����������" ��� ������ ���������';
 TEXT_MES_CHECK_ALL = '������� ��';
 TEXT_MES_UNCHECK_ALL = '�������� ���';
 TEXT_MES_DEFAULT = '�� ���������';
 TEXT_MES_EXIT_SETUP = '�����';
 TEXT_MES_INSTALL = '����������';
 TEXT_MES_INSTALL_CAPTION = '���������';
 TEXT_MES_I_ACCEPT = '� �������� � ����� �����������';
 TEXT_MES_END_FOLDER = '�������� ����� ���������';
 TEXT_MES_END_DB_FOLDER = '����� � ������� ���� ������';
 TEXT_MES_DEF_DB = '���� ������ �� ���������';
 TEXT_MES_MOVE_PRIVATE = '���������� ������ ������';
 TEXT_MES_EXIS_SETUP = '����� �� ���������';
 TEXT_MES_IDAPI_NEED = '������: Borland Database Engine (BDE) �� �������!' + #13+ 'BDE ���������� ��� ������ ���������, ����� ��������� � ���������...';
 TEXT_MES_IDAPI_NOT_FOUND = '������: Borland Database Engine (BDE) �� �������!' + #13+'��������� �� ����� ������������ ������ ��� ������� ����������....';
 TEXT_MES_COPYING_NEW_FILES = '����������� ����� ������';
 TEXT_MES_CURRENT_FILE = '������� ����';
 TEXT_MES_COPYING_PR = '�����������... (&%%)';
 TEXT_MES_REGISTRY_ENTRIES = '����� �������...';
 TEXT_MES_WAIT = '����������, ���������... ';
 TEXT_MES_CREATING_CHORTCUTS = '�������� �������...';
 TEXT_MES_DISCRIPTION = '�������� ���� ����������';
 TEXT_MES_DB_EXISTS_ADD_NEW = '�������� �� ��� ����������!'+#13+'������ �� �� �������� � �� ������?';
 TEXT_MES_CANT_CREATE_END_DB = '���������� ������� ���� ��!';
 TEXT_MES_MOVING_DB = '����������� ��';
 TEXT_MES_CURRENT_REC = '������� ������';
 TEXT_MES_ADDING_INSTALL_FORMAT = '������ %s �� %s  [%s]';
 TEXT_MES_DELETING_FILES = '�������� ������';
 TEXT_MES_DELETING_DB_FILES = '�������� ������ ��';
 TEXT_MES_DELETING_PR = '��������... (&%%)';
 TEXT_MES_WAIT_PR = '����������, �����... (&%%)';
 TEXT_MES_DELETING_REG_ENTRIES = '�������� ������� � �������...';
 TEXT_MES_DELETING_CHORTCUTS = '�������� �������...';
 TEXT_MES_DELETING_TEMP_FILES = '�������� ��������� ������...';
 TEXT_MES_CLOSE_OPENED_PROGRAM = '����������, �������� �������� ��������� � ����������� �����';
 TEXT_MES_UNINSTALL = '��������';
 TEXT_MES_UNINSTALL_CAPTION = '�������� ���������';
 TEXT_MES_UNINSTALL_LIST = '����������';
 TEXT_MES_PROGRAM_FILES = '����� ���������';
 TEXT_MES_DB_FILES = '����� ��';
 TEXT_MES_REG_ENTRIES = '������ � �������';
 TEXT_MES_CHORTCUTS = '������';
 TEXT_MES_ADDING_FILE_PR = '���������� ������... (&%%)';
 TEXT_MES_NOW_FILE = '<������� ����>';
 TEXT_MES_NO_FILE_TO_ADD = '��� ������ ��� ����������';
 TEXT_MES_LAST_FILE = '��������� ����...';
 TEXT_MES_PAUSE = '�����';
 TEXT_MES_UNPAUSE = '���������';
 TEXT_MES_NO_ANY_FILEA = '<��� ������>';
 TEXT_MES_BREAK_BUTTON = '��������!';
 TEXT_MES_STAY_ON_TOP = '���������� ������ ����';
 TEXT_MES_LAYERED = '������������';
 TEXT_MES_HIDE = '��������';
 TEXT_MES_FILL = '���';
 TEXT_MES_AUTO = '�������������';
 TEXT_MES_AUTO_ANSWER = '���������';
 TEXT_MES_NONE = '���';
 TEXT_MES_REPLACE_ALL = '�������� ���';
 TEXT_MES_ADD_ALL = '�������� ���';
 TEXT_MES_SKIP_ALL = '���������� ���';
 TEXT_MES_ASK_ABOUT_DUBLICATES = '�������� � ����������';
 TEXT_MES_NEEDS_ACTIVATION = '���������� ����������� ���������';
 TEXT_MES_LIMIT_RECS = '�� ��������� � ���������������� ��!'+#13+'�� ������ �������� ������ %s �������!'+#13+'�������� "�������" � ���� � ���� ������"';
 TEXT_MES_LIMIT_TIME_END = '����� ������ ��������� �������! �� ������ �������������� ������ �����!';
 TEXT_MES_ALIAS_NOT_FOUND_CREATE = '����� %s �� ������!'+#13+'������ �� �� ��� �������?';
 TEXT_MES_ALIAS_NOT_FOUND = '����� �� ������';
 TEXT_MES_CANT_CREATE_ALIAS = '����� �� ������!'+#13+'��������� ����� �������';
 TEXT_MES_UNABLE_TO_SAVE_CONFIG_FILE = '���������� ��������� ���� ��������!';
 TEXT_MES_PACKING_QUESTION = '�� ������������� ������ ��������� �������?'+#13+'�������� ������� ��� ��������� ������� ���������...';
 TEXT_MES_EXPORT_QUESTION = '�� ������������� ������ �������������� �������?';
 TEXT_MES_IMPORT_QUESTION = '�� ������������� ������ ������������� �������?';
 TEXT_MES_BACK_UP_QUESTION = '�� ������������� ������ ������� ��������� �����?';
 TEXT_MES_DB_OPTIONS = '��������� ��';
 TEXT_MES_PACK_TABLE = '��������� ��';
 TEXT_MES_EXPORT_TABLE = '��������������';
 TEXT_MES_IMPORT_TABLE = '�������������';
 TEXT_MES_BACK_UP_DB = '��������� �����';
 TEXT_MES_CLEANING = '�������';
 TEXT_MES_WHERE = '���';
 TEXT_MES_EXES_SQL = '��������� SQL';
 TEXT_MES_SELECTED_INFO = '����������:';
 TEXT_MES_FIELD = '����';
 TEXT_MES_CURRENT_DATABASE = '������� ��';
 TEXT_MES_FILEA = '<����>';
 TEXT_MES_NO_FILEA = '<��� �����>';
 TEXT_MES_DB_FILE_MANAGER = '��������� ����� ��';
 TEXT_MES_GO_TO_REC_ID = '������� � ������ � ID';
 TEXT_MES_MANAGER_DB_CAPTION = '���������� ��';
 TEXT_MES_PACKING_MAIN_DB_FILE = '�������� ������ ��...';
 TEXT_MES_PACKING_GROUPS_DB_FILE = '�������� ����� � ��������...';
 TEXT_MES_PACKING_END = '�������� ���������...';
 TEXT_MES_WELCOME_FORMAT = '����� ���������� � %s!';
 TEXT_MES_PACKING_BEGIN = '�������� ��������...';
 TEXT_MES_PACKING_TABLE = '�������� �������:';
 TEXT_MES_CMD_CAPTION = '���� ������';
 TEXT_MES_CMD_TEXT = '��������� ���� ��������� �������� ��������...';
 TEXT_MES_EXPORT_WINDOW_CAPTION = '������� �������';
 TEXT_MES_EXPORT_PRIVATE = '������� ������ �������';
 TEXT_MES_EXPORT_ONLY_RATING = '������� ������ ������� � �������';
 TEXT_MES_EXPORT_REC_WITHOUT_FILES = '������� ������� ��� ������';
 TEXT_MES_EXPORT_GROUPS = '�������������� ������';
 TEXT_MES_BEGIN_EXPORT = '������ �������';
 TEXT_MES_REC = '������';
 TEXT_MES_REC_FROM_RECS_FORMAT = '������ #%s �� %s';
 TEXT_MES_CLEANING_CAPTION = '�������';
 TEXT_MES_DELETE_NOT_VALID_RECS = '������� �������� ������';
 TEXT_MES_VERIFY_DUBLICATES = '��������� ���������';
 TEXT_MES_MARK_DELETED_FILES = '�������� �������� �����';
 TEXT_MES_ALLOW_AUTO_CLEANING = '��������� �����������';
 TEXT_MES_STOP_NOW = '����������';
 TEXT_MES_START_NOW = '������';
 TEXT_MES_IMPORTING_CAPTION = '������ ��';
 TEXT_MES_RECS_ADDED = '������� ���������:';
 TEXT_MES_RECS_UPDATED = '������� ���������:';
 TEXT_MES_RECS_ADDED_PR = '&%% (���������)';
 TEXT_MES_RECS_UPDATED_PR = '&%% (���������)';
 TEXT_MES_STATUS = '������';
 TEXT_MES_STATUSA = '<������>';
 TEXT_MES_CURRENT_ACTION = '������� ��������';
 TEXT_MES_ACTIONA = '<��������';
 TEXT_MES_MAIN_DB_AND_ADD_SAME = '������� � ���������� �� ���������!';
 TEXT_MES_MAIN_DB_RECS_FORMAT = '������� �� (%s Rec)';
 TEXT_MES_ADD_DB_RECS_FORMAT = '���������� �� (%s Rec)';
 TEXT_MES_RES_DB_RECS_FORMAT = '�������������� �� (%s Rec)';
 TEXT_MES_ADD_NEW_RECS = '��������� ����� ������';
 TEXT_MES_ADD_REC_WITHOUT_FILES = '��������� ������ ��� ������';
 TEXT_MES_ADD_RATING = '��������� ������';
 TEXT_MES_ADD_ROTATE = '��������� �������';
 TEXT_MES_ADD_PRIVATE = '��������� ������';
 TEXT_MES_ADD_KEYWORDS = '��������� �������� �����';
 TEXT_MES_ADD_GROUPS = '��������� ������';
 TEXT_MES_ADD_NIL_COMMENT = '��������� ������ �����������';
 TEXT_MES_ADD_COMMENT = '��������� �����������';
 TEXT_MES_ADD_NAMED_COMMENT = '��������� ���������� �����������';
 TEXT_MES_ADD_DATE = '��������� ����';
 TEXT_MES_ADD_LINKS = '��������� ������';
 TEXT_MES_IGNORE_KEYWORDS = '������������ �����';
 TEXT_MES_IMPORTING_OPTIONS_CAPTION = '��������� �������';
 TEXT_MES_REPLACE_GROUP_BOX = '��������';
 TEXT_MES_ON__REPLACE_ = '��';
 TEXT_MES_USE_CURRENT_DB = '������������ ������� ��';
 TEXT_MES_USE_ANOTHER_DB = '������������ ������ ��';
 TEXT_MES_MAIN_DB = '������� ��';
 TEXT_MES_ADD_DB = '���������� ��';
 TEXT_MES_RES_DB = '�������������� ��';
 TEXT_MES_BY_AUTHOR = '�����';
 TEXT_MES_LIST_IGNORE_WORDS = '������ ������������ ����:';
 TEXT_MES_EDIT_GROUPS_CAPTION = '������������� ������';
 TEXT_MES_GROUP_MANAGER_BUTTON = '����������';
 TEXT_MES_NEW_GROUP_BUTTON = '����� ������';
 TEXT_MES_AVALIABLE_GROUPS = '��������� ������:';
 TEXT_MES_CURRENT_GROUPS = '������� ������:';
 TEXT_MES_DELETE_ITEM = '�������';
 TEXT_MES_GREATE_GROUP = '�������� ������';
 TEXT_MES_CHANGE_GROUP = '��������� ������';
 TEXT_MES_CREATE_GROUP_CAPTION = '�������� ����� ������';
 TEXT_MES_PRIVATE_GROUP = '������ ������';
 TEXT_MES_COMMON_GROUP = '����� ������';
 TEXT_MES_GROUP_COMMENTA = '<����������� ��� ������>';
 TEXT_MES_NEW_GROUP_NAME = '<�����������>';
 TEXT_MES_DELETE_GROUP_CONFIRM = '�� ������������� ������ ������� ��� ������?'+#13+'������ = "%s"';
 TEXT_MES_ADD_GROUP = '���������� ������';
 TEXT_MES_DELETE_GROUP = '�������� ������';
 TEXT_MES_QUICK_GROUP_INFO = '���������� � ������';
 TEXT_MES_CHANGE_GROUP_CAPTION = '�������� ������';
 TEXT_MES_QUICK_INFO_CAPTION = '���������� � ������';
 TEXT_MES_GROUP_NOT_FOUND = '������ �� �������!';
 TEXT_MES_GROUP_CREATED_AT = '������� %s';
 TEXT_MES_GROUP = '������';
 TEXT_MES_GROUP_ATTRIBUTES = '��������:';
 TEXT_MES_GROUP_DATE_CREATED = '���� ��������:';
 TEXT_MES_GROUP_COMMENT = '�����������:';
 TEXT_MES_CHANGE_DATE_CAPTION = '�������� ���� � �����';
 TEXT_MES_GO_TO_CURRENT_DATE_ITEM = '������� � ������� ����';
 TEXT_MES_DATE_NOT_EXISTS_ITEM = '���� ���';
 TEXT_MES_DATE_EXISTS_ITEM = '���� ������������';
 TEXT_MES_SLIDE_CAPTION = '�������� - %s   [%d/%d]';
 TEXT_MES_SLIDE_NEXT = '���������';
 TEXT_MES_SLIDE_PREVIOUS = '����������';
 TEXT_MES_SLIDE_TIMER = '������';
 TEXT_MES_SLIDE_STOP_TIMER = '���������� ������';
 TEXT_MES_SLIDE_FIND_ITEM = TEXT_MES_FIND_TARGET;
 TEXT_MES_SLIDE_FULL_SCREEN = '�� ���� �����';
 TEXT_MES_SLIDE_NORMAL = '�� ���������� �����';
 TEXT_MES_ADD_ONLY_THIS_FILE = '������ ���� ����';
 TEXT_MES_ADD_ALL_FOLDER = '��� ����� � �����';
 TEXT_MES_ADD_TO_DB = '�������� � ��';
 TEXT_MES_DRAWING_FAILED = '������ ����������!';
 TEXT_MES_DBITEM_FORMAT = '����� � �� [%s]';
 TEXT_MES_START_TIMER = '��������� ������';
 TEXT_MES_STOP_TIMER = TEXT_MES_SLIDE_STOP_TIMER ;
 TEXT_MES_DATE_NOT_EXISTS_BOX = '���� �����������...';
 TEXT_MES_DATE_BOX_TEXT_TO_SET_DATE = '�������� "���� ����������" � ����������� ����...';
 TEXT_MES_DELETE_FROM_LIST = '������� ������� �� ������';
 TEXT_MES_SETUP_RUNNING = '� ������ ������ �������� ��������� ���������. ����������, �������� � � ����������� �����.';
 TEXT_MES_UNINSTALL_CONFIRM = '�� ������������� ������ ������� ��� ���������?';
 TEXT_MES_APPLICATION_NOT_VALID = '���������� ����������! ��������, ��� ��� ������������ �����-���� �������!';
 TEXT_MES_REPLACE_GROUP = '� ���� ������ ������� ������ "%s". ��� ������ � ���� ������� ��� ������� � ������������ ��?';
 TEXT_MES_ABORT = '��������';
 TEXT_MES_SAVING_IN_PROGRESS = '���������� �����������...';
 TEXT_MES_SAVING_DATASET_CAPTION = '���������� �����������';
 TEXT_MES_SAVING_GROUPS = '���������� �����';
 TEXT_MES_SAVING_GROUPS_TEXT = '���������� ������ %s';
 TEXT_MES_ERROR_ADDING_GROUP = '������ �������� ������ "%s"';
 TEXT_MES_SELECT_TEMP_DIR = '����������, �������� ����������, ���� ����� �������� ��������� �����. Ÿ ������ �� ������ ��������� 80 ��������!';
 TEXT_MES_SELECT_TEMP_DIR_DIALOG = TEXT_MES_SELECT_TEMP_DIR;
// TEXT_MES_FILE_NOT_AVALIABLE_BDE = '<�� �������� ���� BDE �� �����������>';
 TEXT_MES_FILE_ONLY_MDB = '<�������� ���� ���� ������ ������������� ������>';
 TEXT_MES_HELP_NO_RECORDS_IN_DB_FOUND = '���� �� ������ �������� ����������� � ��, �������� "���������" � ����������� ����';
 TEXT_MES_HELP_HINT = '������';
 TEXT_MES_GROUPS_REPLACE_CAPTION = '������ �����';
 TEXT_MES_READING_FOLDER_FORMAT = '������ ����� [%s �������� �������]';
 TEXT_MES_ALLOW_FAST_CLEANING = '��������� ������� �������';
 TEXT_MES_CHOOSE_GROUP_ACTION_ADD_GROUP = '�������� ������';
 TEXT_MES_CHOOSE_GROUP_ACTION_IMPORT_IN_GROUP = '������������� �';
 TEXT_MES_CHOOSE_GROUP_ACTION_ADD_WITH_ANOTHER_NAME = '�������� � ������';
 TEXT_MES_CHOOSE_GROUP_ACTION_NO_NOT_ADD = '�� ��������� ��� ������';
 TEXT_MES_OLD_PASSWORD = '������ ������';
 TEXT_MES_DONT_USE_EXT = '�� ������������ ��� ����������';
 TEXT_MES_USE_THIS_PROGRAM = '������������ ��� ��������� �� ���������';
 TEXT_MES_USE_ITEM = '������������ ����� � ����';
 TEXT_MES_SEARCH_PLUGINS = '����� ����������...';
 TEXT_MES_AVALIABLE_THEMES = '��������� �������� �����:';
 TEXT_MES_DELETING_PLUGINS = '�������� ����������';
 TEXT_MES_DELETING_THEMES = '�������� ���';


 TEXT_MES_GROUPA = '<������>';

 TEXT_MES_WS_DATE_BETWEEN = '���� �����';
 TEXT_MES_WS_RATING_BETWEEN = '������  �����';
 TEXT_MES_WS_ID_BETWEEN = 'ID �����';
 TEXT_MES_WS_SHOW_PRIVATE = '���������� ������';
 TEXT_MES_WS_SHOW_COMMON = '���������� �����';
 TEXT_MES_OPEN_IN_EXPLORER = '������� � ����������';

 TEXT_MES_ADD_OBJECT = '�������� ������';
 TEXT_MES_ADD_OBJECTS = '�������� �������';

 TEXT_MES_NO_GROUPS = '� ����� ���� ������ ��� �� ����� ������. �� ������ ������� ����� ������?';

 TEXT_MES_CONVERTING = '���������... (&%%)';
 TEXT_MES_REPLACE_EXT = '�� ������������� ������ �������� ���������� ��� �������?';

 TEXT_MES_CHOOSE_ACTION = '�������� ����������� ��������';
 TEXT_MES_PATH = '����������';
 TEXT_MES_CURRENT_FILE_INFO = '������� ���������� �� �����';
 TEXT_MES_REPLACE_AND_DELETE_DUBLICATES = '�������� � ������� ���������';
 TEXT_MES_SKIP = '����������';
 TEXT_MES_SKIP_FOR_ALL = '���������� ���';
 TEXT_MES_REPLACE = '��������';
 TEXT_MES_REPLACE_FOR_ALL = '�������� ���';
 TEXT_MES_ADD = '��������';
 TEXT_MES_ADD_FOR_ALL = '�������� ���';
 TEXT_MES_DELETE_FILE = '������� ����';
 TEXT_MES_DELETE_FILE_CONFIRM = '�� ������������� ������ ������� ���� ����?';

 TEXT_MES_DB_FILE_INFO = '������� ���������� �� ��';
 TEXT_MES_UPDATER_CAPTION = '���� ���������� ��';
 TEXT_MES_RECREATING_TH_TABLE = '����';
 TEXT_MES_BEGIN_RECREATING_TH_TABLE = '������ ���������� �������. ��� ������ ��������, ���������� - ���������... (����� �������� ��������, ������� Ctrl+B)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT = '���������� ������ %s �� %s [%s]';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CRYPTED_POSTPONED = '���������� ������ %s �� %s [%s] �������� (�����������)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CD_DVD_CANCELED_INFO_F = '���������� ������ %s �� %s [%s] �������� (CD\DVD ����� ����������� �� ���� ������������ �������)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CRYPTED_FIXED = '��� ������ %s �� %s [%s] ����� ������������ (���� ����������, � ������ - ���)';
 TEXT_MES_RECREATING = '����������...';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_ERROR = '������ ���������� ������ %s';
 TEXT_MES_RECREATINH_TH_FORMAT_ERROR = '������ ���������� �������';
 TEXT_MES_BREAK_RECREATING_TH = '�� ������������� ������ �������� ������� ��������?';
 TEXT_MES_ENTER_NAME_ERROR = '�������, ����������, ���� ���';
 TEXT_MES_UPDATING_DESCTIPTION = '���������� ��';
 TEXT_MES_DB_EXISTS__USE_NEW = '�������� �� ��� ����������! �� ������������� ������ ������������ ����� ������� "%s" (��� �������� �)?'#13'YES - �������� ������'#13'NO - ������������ ����� ������� (������ ����� �������!)'#13'ABORT - �� ��������� ��������';
 TEXT_MES_SLIDE_SHOW_STEPS_OPTIONS = '���������� ����� ��� �����-��� - %s';
 TEXT_MES_SLIDE_SHOW_GRAYSCALE_OPTIONS = '�������� ��� �������� � �����-����� ���� (��������) - %s.';
 TEXT_MES_USE_COOL_STRETCH = '������������ ������������ ����������';
 TEXT_MES_SET_AS_DESKTOP_WALLPAPER = '������� �������� �������� �����';
 TEXT_MES_SLIDE_SHOW_SLIDE_DELAY = '�������� ����� ������� (%s)';
 TEXT_MES_USE_EXTERNAL_VIEWER = '������������ ������ �����������';
 TEXT_MES_MANAGE_GROUPS = '���������� ��������';

 TEXT_MES_NETWORK = '����';
 TEXT_MES_READING_NETWORK = '����� �����';
 TEXT_MES_READING_WORKGROUP = '����� �����������';
 TEXT_MES_READING_COMPUTER = '�������� ����������';
 TEXT_MES_WORKGROUP = '������� ������';
 TEXT_MES_COMPUTER = '���������';
 TEXT_MES_SHARE = '������';
 TEXT_MES_ERROR_OPENING_COMPUTER = '������ �������� ����������';
 TEXT_MES_ERROR_OPENING_WORKGROUP = '������ �������� ����������';
 TEXT_MES_ERROR_OPENING_FOLDER = '����� �������� ����������';
 TEXT_MES_ADDRESS = '  ����� ';

 TEXT_MES_SEARCH_FOR_GROUP = '����� ���������� ������';

 TEXT_MES_ZOOM_OUT = '���������';
 TEXT_MES_ZOOM_IN = '���������';
 TEXT_MES_REAL_SIZE = '�������� ������';
 TEXT_MES_BEST_SIZE = '��������� ������';
 
 TEXT_MES_ABOUT = '� ���������';
 TEXT_MES_ACTIVATION = '��������� ���������';
 TEXT_MES_HOME_PAGE = '���� ���������';
 TEXT_MES_CONTACT_WITH_AUTHOR = '��������� � �������';
 TEXT_MES_GET_CODE = '�������� ���';
 TEXT_MES_EXT_IN_USE = '������� ����������:';

 TEXT_MES_IDAPI_INSTALL_CONFIRM = '���������� BDE ������?';

 TEXT_MES_IDAPI_NOT_INSTELLED = '���� �� ����������� ��������� (BDE) ���������� �������. ����������, �������������� ����������';



 TEXT_MES_CRYPT_FILE = '����������� ����';
 TEXT_MES_DECRYPT_FILE = '������������ ����';
 TEXT_MES_REMOVE_IMAGE_PASS_F = '�� ������������� ������ ������������ ���� "%s"?';
 TEXT_MES_PASSWORD_INVALID = '������ �������';
 TEXT_MES_PASSWORDS_DIFFERENT = '�������� ������ �� ���������!';
 TEXT_MES_DECRYPT = '������������';
 TEXT_MES_CRYPTING = '����������';
 TEXT_MES_CRYPT = '�����������';
 TEXT_MES_ENTER_PASSWORD = '������ ������';
 TEXT_MES_ENTER_PASS_HERE = '������� ������ ��� �������� ����� "%s" ����:';

 TEXT_MES_CLOSE_PASSWORD_FILE_LIST = '������ ����'; 
 TEXT_MES_SHOW_PASSWORD_FILE_LIST = '�������� �����';
 TEXT_MES_PASSWORD_FILE_LIST_INFO = '������ �����, ��������� �����, ����������� ����� �������.';

 TEXT_MES_MANY_FALES_PASSWORD_INFO = '������� ������ ��� �������� ������ ������ (������� '+TEXT_MES_SHOW_PASSWORD_FILE_LIST+' ��� ����������� ������) ����:';
 TEXT_MES_SAVE_PASS_SESSION = '��������� ������ �� ����� ������';
 TEXT_MES_SAVE_PASS_IN_INI_DIRECTORY = '��������� ������ � ���������� (�� �������������)';
 TEXT_MES_PASSWORD_NEEDED = '��������� ������';
 TEXT_MES_CRYPT_IMAGE = '����������� ������(�)';
 TEXT_MES_PASS = '������� ���� ������:';
 TEXT_MES_PASS_CONFIRM = '������������� ������:';
 TEXT_MES_SHOW_PASSWORD = '���������� ������ ��� �����';
 TEXT_MES_SAVE_CRC = '��������� ����������� �����';

 TEXT_MES_LOADING_ICONS = '�������� ������...';

 TEXT_MES_EXPORT_CRYPTED_IF_PASSWORD_EXISTS = '�������������� �������������, ���� ������ ������';
 TEXT_MES_EXPORT_CRYPTED = '�������������� ������������� ������';
 TEXT_MES_CANNOT_CREATE_FILE_F = '���������� ������� ���� "%s"';

 TEXT_MES_ORIGINAL_FILE_NAME = '������������ ��� �����';
 TEXT_MES_NEW_FILE_NAME = '����� ��� �����';

 TEXT_MES_MASK_FOR_FILE = '����� ����� ��������';
 TEXT_MES_BEGIN_MASK = '����������� #%3d [%date]';
 TEXT_MES_MASK_FOR_FILE_CAPTION = '�������� �������������� ������';
 TEXT_MES_INFO = '����������';
 TEXT_MES_MASK_INFO = '����� �����, � ������ �������� %d ���������� �� ���������� ����� (���� ����� d ����� �����, �� ��� ��������� ���������� ���������� �����)'#13'%date ���������� �� ������� ����'#13'%fn - ������������ ��� ����� (��� ����������)';

 TEXT_MES_CONVERT = '��������������';
 TEXT_MES_RESIZE = '�������� ������';
 TEXT_MES_CHOOSE_FORMAT = '���������� ������� ������� ������!';
 TEXT_MES_JPEG_COMPRESS = 'JPEG ���������� (%d%%):';

 TEXT_MES_BY_CENTER = '�� ������';
 TEXT_MES_BY_TILE = '���������';
 TEXT_MES_BY_STRETCH = '���������';
 TEXT_MES_ROTATE_IMAGE = '��������� �����������';
 TEXT_MES_CHANGE_SIZE = '�������� ������';
 TEXT_MES_CHANGE_SIZE_CAPTION= '��������� ������� �����������';
 TEXT_MES_CHANGE_SIZE_INFO = '�� ������ �������� ������ ��������� �������� � �������������� �� � ������ ������. (���� ���������� � ������ ������� �� ��������������, �� �� ����� ������������� �������������)';
 TEXT_MES_CHANGE_SIZE_100x100 = '�������������� � 100�100';
 TEXT_MES_CHANGE_SIZE_200x200 = '�������������� � 200�200';
 TEXT_MES_CHANGE_SIZE_600x800 = '�������������� � 600�800';
 TEXT_MES_CHANGE_SIZE_CUSTOM = '������������ ������:';
 TEXT_MES_SAVE_ASPECT_RATIO = '��������� ���������';
 TEXT_MES_USE_ZOOM = '�������� �� ������������� �������:';
 TEXT_MES_JPEG_OPTIONS = '����� JPEG';
 TEXT_MES_TRY_KEEP_ORIGINAL_FORMAT = '�� ����������� ������������ ������';
 TEXT_MES_CONVERT_TO = '�������������� �:';
 TEXT_MES_FILE_ACTIONS = '�������� ��������';
 TEXT_MES_REPLACE_IMAGES = '�������� �������� �����������';
 TEXT_MES_MAKE_NEW_IMAGES = '��������� ����� �����������';
 TEXT_MES_SAVE_SETTINGS_BY_DEFAULT = '��������� ���������';

 TEXT_MES_ROTATE_IMAGE_INFO = '�� ������ ��������� ��������� ������� � �������������� �� � ������ ������. (���� ���������� � ������ ������� �� ��������������, �� �� ����� ������������� �������������)';
 TEXT_MES_ROTATE_CAPTION = '��������� �����������';

 TEXT_MES_CONVERT_IMAGE_INFO = '�� ������ �������������� ��������� ������� ������ ������, ��������� ����:';
 TEXT_MES_CONVERT_CAPTION = '��������������� �����������';
 TEXT_MES_JPEG_CAPTION = '���������� JPEG';
 TEXT_MES_JPEG_INFO = '�������� ����� ��� ���������� � JPEG ������:';
 TEXT_MES_JPEG_PROGRESSIVE_MODE = '������������� �����';
 TEXT_MES_JPEG = 'JPEG';


 TEXT_MES_SECURITY_INFO = '��������: ��� ����� �� ��� �����������������, ����������� ���������. ���� �� ������ ������ � �����-���� ������������, �� ������������ ��� �� �������!';
 TEXT_MES_SECURITY_USE_SAVE_IN_SESSION = '������������� ��������� ������ ��� ������� ������';
 TEXT_MES_SECURITY_USE_SAVE_IN_INI = '������������� ��������� ������ � ���������� (�� �������������)';
 TEXT_MES_SECURITY_CLEAR_SESSION = '�������� ������� ������ � ������';
 TEXT_MES_SECURITY_CLEAR_INI = '�������� ������� ������ � ����������';
 TEXT_MES_SECURITY = '������������';

 TEXT_MES_REFRESH_ID = '�������� ������ � ��';
 TEXT_MES_REFRESH ='��������';
 TEXT_MES_AUTO_ADD_KEYWORDS = '������������� ��������� �������� �����';
 TEXT_MES_COMMENTS_FOR_GROUP = '����������� ��� ������';
 TEXT_MES_KEYWORDS_FOR_GROUP = '�������� ����� ��� ������';

 TEXT_MES_ENTER_IM_PASSWORD = '������� ������ ��� �������(��):';
 TEXT_MES_REENTER_IM_PASSWORD = '����������� ������:';

 TEXT_MES_SLIDE_CAPTION_EX = '�������� - %s   [%dx%d] %f%%   [%d/%d]';
 TEXT_MES_SLIDE_CAPTION_EX_WAITING = '�������� - %s   [%dx%d] %f%%   [%d/%d] - ��� �������� ������ ��������� �����������...';

 TEXT_MES_NEW_SEARCH = '����� ���� ������';

 TEXT_MES_SHOW_DUBLICATES = '�������� ���������';
 TEXT_MES_DUBLICATES = '���������';
 TEXT_MES_DEL_DUBLICATES  = '������� ������ ���������';
 TEXT_MES_MANAGER_DB = '���������� ��';

 TEXT_MES_UNABLE_SHOW_FILE_F = '���������� ���������� ����:'#13'%s';
 TEXT_MES_DIRECT_X_FAILTURE = '������ ������������� ������������ ������';
 TEXT_MES_NEW_UPDATING_CAPTION = '�������� ����� ������ - %s';
 TEXT_MES_DOWNLOAD_NOW = '��������� ������!';
 TEXT_MES_REMAIND_ME_LATER = '��������� ��� �����';
 TEXT_MES_NEW_COMMAND = '����� ����� ����';
 TEXT_MES_USER_MENU = '����';
 TEXT_MES_USER_SUBMENU = '�������������';
 TEXT_MES_USER_MENU_ITEM = '����� ����';
 TEXT_MES_CAPTION = '���������';
 TEXT_MES_EXECUTABLE_FILE = '����������� ����';
 TEXT_MES_EXECUTABLE_FILE_PARAMS = '��������� �������';
 TEXT_MES_ICON = '������';
 TEXT_MES_USE_SUBMENU = '�������� � �������';

 TEXT_MES_USER_SUBMENU_ICON = '������ �������';
 TEXT_MES_USER_SUBMENU_CAPTION = '��������� �������';
 TEXT_MES_USE_USER_MENU_FOR_ID_MENU = 'ID ����';
 TEXT_MES_USE_USER_MENU_FOR_VIEWER = '���������';
 TEXT_MES_USE_USER_MENU_FOR_EXPLORER = '����������';
 TEXT_MES_USE_USER_MENU_FOR = '������������ ���� ���:';
 TEXT_MES_REMOVE_USER_MENU_ITEM = '�������';
 TEXT_MES_ADD_NEW_USER_MENU_ITEM = '�������� ����� �����';

 TEXT_MES_SORT_BY_FILE_NAME = '����������� �� ����� �����';
 TEXT_MES_SORT_BY_FILE_SIZE = '����������� �� ������� �����';
 
 TEXT_MES_NEEDS_INTERNET_CONNECTION = '���������� �������� ���������� �� ����������� �.�. �� ���������� ���������� � ����������';
 TEXT_MES_CANNOT_FIND_SITE = '�� ������� �������� ���������� �� �����������';
 TEXT_MES_NO_UPDATES = '�� ���������� ����� ������ ���������';
 TEXT_MES_GET_UPDATING = '��������� ����������';
 TEXT_MES_ITEM_DOWN = '����';
 TEXT_MES_ITEM_UP = '�����';
 TEXT_MES_CAN_CHANGE_EXT = '�������� ����������';
 TEXT_MES_MANY_FILES_F = '%d ��������';
 TEXT_MES_DO_SLIDE_SHOW = '�����-���';
 TEXT_MES_DB_INFO = '���������� �� ��:';
 TEXT_MES_BEGIN_NO = '������ �:';
 TEXT_MES_NEXT_HELP = '�����...';
 TEXT_MES_HELP_FIRST = '     ��� ���������� ���������� � ���� ������ (��) �������� ����� "���������" � ����������� ����, ����� ������� ���� ���������� � � ���� �������� "�������� �������".'#13#13'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13#13;
 TEXT_MES_CLOSE_HELP = '�� ������������� ������ ���������� �� ������?';
 TEXT_MES_HELP_1 = '     ������� � ���������� ����� � ������ ������������ �, ������� ����������, � ���� �������� "�������� ������(�)".'#13#13'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13;
 TEXT_MES_HELP_2 = '     ������� �� ������ "�������� ������(�)" ����� �������� ���������� � ��. ����� ����� � ���������� ����� ��������� ����������.'#13#13'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13;
 TEXT_MES_HELP_3 = '     ������ ����������, � ������� �� ������������ ������ (+) � ������� ����� ���� ��������� � ��. ��� �������� �� ������ � ���� ������ � � ��� �������� ����������� ���� �� ����������. ���������� ������� �������� �� �������� ���� (������� -> �������).'#13' '#13;

 TEXT_MES_APPLICATION_FAILED = '���������� ���� ������� �����������. ��������, ��� �������. � ��������� ������� ��� ����� ���� ������� ������� � ��, ��� ����� ���� ��������� ��������� ��. �� ������ ��������� ��� �������� ������?';
 TEXT_MES_SLIDE_SHOW_SPEED = '�������������� �������� ��� �����-��� - %s ms.';
 TEXT_MES_FULL_SCREEN_SLIDE_SPEED = '�������� ������� ��� �������������� ������ - %s ms.';

 TEXT_MES_CLEAR_FOLDER_IMAGES_CASH = '�������� ��� ��������������';
 TEXT_MES_CLEAR_ICON_CASH = '�������� ��� ������';
 TEXT_MES_HELP_ACTIVATION_FIRST = '     �� ������ �������� �������, ��� ������������ ���������? ���� ��, �� ������� �� ������ "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13;
 TEXT_MES_HELP_ACTIVATION_1 = '     ��� ��������� ��������� � ����������� ���� �������� ����� "�������"->"��������� ���������"'#13#13'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13;

 TEXT_MES_HELP_ACTIVATION_2 = '     ��� ��������� ��������� � ����������� ���� �������� ����� "�������"->"��������� ���������"'#13#13'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13;
 TEXT_MES_HELP_ACTIVATION_3 = '     ������� �� ������ "'+TEXT_MES_GET_CODE+'", ����� ���� ���������� �������� ��������� � ����� �������, � ��������� �������� ���� ��� ����������� ��� ��������� ����������.'#13'��� ���������� �������� ��� ������ ��� �� (���� �������� ��������� �� �����������)'+
 ' ����� ��������� ������ �� ����� '+ProgramMail+', � ������� ����� ������� ��� ��������� � � ������.'#13#13+'     ������� "'+TEXT_MES_NEXT_HELP+'" ��� ���������� ������.'#13'     ��� ������� �� ������� ������, ����� ������� ����� �� ������������.'#13' '#13#13' '#13;
 TEXT_MES_HELP_ACTIVATION_4 = '     � ������� ����� ��� ����� ������ ��� ���������, ������� ����� ������ � ��� ���� � ������ �� ������ "'+TEXT_MES_SET_CODE+'". ����� ����� ��������� ����� ������������.'#13' '#13;

 TEXT_MES_MENU_BUSY = '��������� ���������� ��������...';
 TEXT_MES_IMAGE_EDITOR_W ='����������� ��������';
 TEXT_MES_IMAGE_EDITOR = '��������';

 TEXT_MES_IM_LOADING_JPEG = '�������� JPEG �������...';
 TEXT_MES_IM_LOADING_GIF = '�������� GIF �������...';
 TEXT_MES_IM_LOADING_BMP = '�������� BMP �������...';
 TEXT_MES_IM_UNDO = '��������';
 TEXT_MES_IM_REDO = '���������';
 TEXT_MES_CROP = '������������';
 TEXT_MES_EFFECTS = '�������';
 TEXT_MES_COLORS = '�����';
 TEXT_MES_RED_EYE = '������� ����';
 TEXT_MES_IM_RESIZE = '������';
 TEXT_MES_IM_REAL_SIZE = '100%';
 TEXT_MES_IM_FIT_TO_SIZE = '���������';
 TEXT_MES_IM_KEEP_PROPORTIONS = '��������� ���������:';
 TEXT_MES_IM_CLOSE_TOOL_PANEL = '������� ����������';
 TEXT_MES_IM_APPLY = '���������';

 TEXT_MES_IM_CHOOSE_ACTION = '�������� ��������';
 TEXT_MES_IM_ROTATE_LEFT = '��������� �����';
 TEXT_MES_IM_ROTATE_RIGHT = '��������� ������';
 TEXT_MES_IM_ROTATE_180 = '��������� �� 180';
 TEXT_MES_IM_FLIP_HORISONTAL = '�������� �� �����������';
 TEXT_MES_IM_FLIP_VERTICAL = '�������� �� ���������';
 TEXT_MES_IM_ROTATE_USTOM_ANGLE = '������������ ����';
 TEXT_MES_IM_ACTION = '��������';
 TEXT_MES_BK_COLOR = '���� ����';
 TEXT_MES_IM_USE_ZOOM = '�������� �� �������:';

 TEXT_MES_WAIT_ACTION = '����������, ���������, ���� ��������� �������� ������� �������� � ������� ���� ������.';
 TEXT_MES_SET = '����������';

 TEXT_MES_USER_CHANGE_ACCESS = '�������� �����';
 TEXT_MES_SELECT_RIGHTS_F = '�������� ����� ��� ������������ "%s" � ������� �� ������ "'+TEXT_MES_OK+'"';

 TEXT_MES_RIGHTS_DELETE = '��������';
 TEXT_MES_RIGHTS_ADD = '����������';
 TEXT_MES_RIGHTS_CHANGE_DB_NAME = '��������� ��';
 TEXT_MES_RIGHTS_SET_PRIVATE = '��������� ������ ���������';
 TEXT_MES_RIGHTS_SET_RATING = '��������� ������';
 TEXT_MES_RIGHTS_SET_INFO = '��������� ����������';
 TEXT_MES_RIGHTS_CHANGE_PASSWORD = '��������� ������';
 TEXT_MES_RIGHTS_EDIT_IMAGE = '������ ���������';
 TEXT_MES_RIGHTS_SHOW_PRIVATE = '����� ������ ����������';
 TEXT_MES_RIGHTS_SHOW_OPTIONS = '���������� �����';
 TEXT_MES_RIGHTS_ADMIN_TOOLS = '���������� ��������� ���������';
 TEXT_MES_RIGHTS_CRITICAL_FILE_OPERATIONS = '����������� �������� ��������';
 TEXT_MES_RIGHTS_NORMAL_FILE_OPERATIONS = '���������� �������� ��������';
 TEXT_MES_RIGHTS_MANAGE_GROUPS = '���������� ��������';
 TEXT_MES_RIGHTS_EXECUTE = '����������';
 TEXT_MES_RIGHTS_CRYPT = '����������';
 TEXT_MES_RIGHTS_SHOW_PATH = '���������� ����';
 TEXT_MES_RIGHTS_PRINT = '������';
 TEXT_MES_RIGHTS_EDIT_GROUPS = '������������� ������';

 TEXT_MES_SORT_BY_ID = '���������� �� ID';
 TEXT_MES_SORT_BY_NAME = '���������� �� �����';
 TEXT_MES_SORT_BY_RATING = '���������� �� ������';
 TEXT_MES_SORT_BY_DATE = '���������� �� ����';
 TEXT_MES_SORT_BY_SIZE = '���������� �� �������';
 TEXT_MES_SORT_BY_FILESIZE = '���������� �� �����';
 
 TEXT_MES_SORT_INCREMENT = '�� �����������';
 TEXT_MES_SORT_DECREMENT = '�� ��������';

 TEXT_MES_OTHER_TASKS = '������ ������';
 TEXT_MES_EXPORT_IMAGES = '������� �����������';
 TEXT_MES_FONT = '�����';
 TEXT_MES_EXPORT_IMAGES_INFO = '��� ������ ������� ������� �� ������ �������������� ���������� �� ��, �������� � ��� �������������� ��������,'+
 ' ����� �������� �� ��, � ����� ��������� � ����������� "������ �������"';
 TEXT_MES_OUTPUT_FOLDER = '�������� �����';
 TEXT_MES_APPLY_TRANSFORM = '��������� ��������� ��������:';
 TEXT_MES_ADD_COPYRIGHT_TEXT = '�������� ������ �������:';
 TEXT_MES_APLY_ROTATE = '��������� �����������';
 TEXT_MES_OPEN_FILE = '������� ����';

 TEXT_MES_CONTRAST = '�������������: [%d]';
 TEXT_MES_BRIGHTNESS = '������� : [%d]';
 TEXT_MES_RED_EYE_EFFECT_SIZE_F = '���� [%d]';
 TEXT_MES_SEL_FOLDER_TO_IMAGES = '�������� �����, ���� ����� ��������� ����������� � ������� �� ������ "'+TEXT_MES_OK+'"';

 TEXT_MES_FULL_SCREEN = '�� ���� �����';

 TEXT_MES_R_F = 'R [%d]';
 TEXT_MES_G_F = 'G [%d]';
 TEXT_MES_B_F = 'B [%d]';

 TEXT_MES_NEW_TEXT_LABEL_CAPTION = '�����:';
 TEXT_MES_NEW_TEXT_LABEL = '��� �����';

 TEXT_MES_FONT_NAME_LABEL_CAPTION = '��� ������:';
 TEXT_MES_FONT_NAME_EDIT = '��� �����';
 TEXT_MES_FONT_SIZE_LABEL_CAPTION = '������ ������';
 TEXT_MES_FONT_COLOR = '���� ������';
 TEXT_MES_SAVE_SETTINGS = '��������� ���������';

 TEXT_MES_TEXT_ROTATION_0 = '���������� �����';
 TEXT_MES_TEXT_ROTATION_90 = '������� �� 90*';
 TEXT_MES_TEXT_ROTATION_180 = '������� �� 180*';
 TEXT_MES_TEXT_ROTATION_270 = '������� �� 270*';
 TEXT_MES_TEXT_ROTATION = '������� ������';

 TEXT_MES_ORIENTATION_LABEL = '���������� ������';

 TEXT_MES_EDITOR_BRUSH_SIZE_LABEL = '������ ����� [%d]';
 TEXT_MES_EDITOR_BRUSH_COLOR_LABEL = '���� �����';

 TEXT_MES_EDITOR_ENABLE_OUTLINE_TEXT = '��������� ������';
 TEXT_MES_EDITOR_OUTLINE_TEXT_SIZE = '��������:';
 TEXT_MES_OUTLINE_TEXT_COLOR = '����:';

 TEXT_MES_PRINT = '������';
 TEXT_MES_SEL_FOLDER_FOR_IMAGES = '�������� ����� ��� ���������� �����������';
 TEXT_MES_USE_ANOTHER_FOLDER = '������������ �����:';
 TEXT_MES_TYPE = '������';
 TEXT_MES_PHOTO = '����:';
 TEXT_MES_D_ITEMS = '%d ����';

 TEXT_MES_ADD_PRINTER = '�������� �������';
 TEXT_MES_PRINTER_SETUP = '��������� ��������';
 TEXT_MES_DO_PRINT = '����������';
 TEXT_MES_PRINTER_MAIN_FORM_CAPTION = '����� ������ �����������';
 TEXT_MES_GENERATING_PRINTER_PREVIEW = '��������� ������������� ��� ������';
 TEXT_MES_PRINTING = '��� ������...';
 TEXT_MES_WAIT_UNTIL_PRINTING = '����������, ��������� ���� ������������ ����� �� ������...';

 TEXT_MES_TPSS_FULL_SIZE = '������ ������';
 TEXT_MES_TPSS_C35 = '35 ���������� �� ��������';
 TEXT_MES_TPSS_20X25C1 = '20x25 ��, 1 ����';
 TEXT_MES_TPSS_13X18C1 = '13x18 ��, 1 ����';
 TEXT_MES_TPSS_13X18C2 = '13x18 ��, 2 ����';
 TEXT_MES_TPSS_10X15C1 = '10x15 ��, 1 ����';
 TEXT_MES_TPSS_10X15C2 = '10x15 ��, 2 ����';
 TEXT_MES_TPSS_10X15C3 = '10x15 ��, 3 ����';
 TEXT_MES_TPSS_9X13C1 = '9x13 ��, 1 ����';
 TEXT_MES_TPSS_9X13C2 = '9x13 ��, 2 ����';
 TEXT_MES_TPSS_9X13C4 = '9x13 ��, 4 ����';
 TEXT_MES_TPSS_C9 = '9 ���������� �� ��������';
 TEXT_MES_TPSS_4X6C4 = '4x6 ��, 1 ���� � 4� ����������';
 TEXT_MES_TPSS_3X4C6 = '3x4 ��, 1 ���� � 6� ����������';

 TEXT_MES_CURRENT_FORMAT = '������� ������:';
 TEXT_MES_PRINT_RANGE = '������� ������';
 TEXT_MES_PRINT_RANGE_CURRENT = '������� ��������';
 TEXT_MES_PRINT_RANGE_ALL = '��� ��������';
 TEXT_MES_COPY_TO_FILE = '���������� � ����';
 TEXT_MES_CROP_IMAGES = '����������� ����';
 TEXT_MES_USE_CUSTOM_SIZE = '������������ ������';
 TEXT_MES_CUSTOM_SIZE = '������������ ������:';
 TEXT_MES_PAGE = '��������';
 TEXT_MES_PRINT_FORMATS = '������� ������';
 TEXT_MES_MAKE_IMAGE = '������� �����������';

 TEXT_MES_EXIF = 'EXIF';
 TEXT_MES_GISTOGRAMM = '�����������';
 TEXT_MES_GISTOGRAMM_IMAGE = '����������� �����������';
 TEXT_MES_EFFECTIVE_RANGE_F = '����������� �������� - %d..%d';
 TEXT_MES_CHANEL = '�����';
 TEXT_MES_CHANEL_GRAY = '׸���\�����';
 TEXT_MES_CHANEL_R = '������� �����';
 TEXT_MES_CHANEL_G = '������ �����';
 TEXT_MES_CHANEL_B = '����� �����';

 TEXT_MES_BRUSH = '�����';

 TEXT_MES_OTHER_PLACES = '������ �����';
 TEXT_MES_MY_PICTURES = '��� ��������';
 TEXT_MES_MY_DOCUMENTS = '��� ���������';
 TEXT_MES_DESKTOP = '������� ����';

 TEXT_MES_SHADOW_COLOR = '���� "����"';
 TEXT_MES_ACTIONS = '��������';
 TEXT_MES_EXPORT = '�������';
 TEXT_MES_TEXT = '�����';
 TEXT_MES_PRINT_SELECT_FORMAT = '    �������� ������ ��� ������ � ������ ����� � ������ �������� �� ��������� �������';

 TEXT_MES_FILE_EXISTS_REPLACE = '���� "%s" ��� ����������! �� ������ ��� ��������?';
 TEXT_MES_VIRTUAL_FILE = '����������� ����, �������� ����������.';
 TEXT_MES_SELECTED_OBJECTS = '��������� �������';
 TEXT_MES_IMAGE_CHANGED_SAVE_Q = '����������� ���� ��������, ���������?';
 TEXT_MES_CANT_OPEN_IMAGE_BECAUSE_EDITING = '���������� ������� ����������� �.�. ����������� �������������� ������� �����������.';
 TEXT_MES_CANT_SAVE_IMAGE_BECAUSE_USER_HAVENT_RIGHTS = '���������� ��������� ����������� �.�. ������������ �� ����� ���� �� ������ �����������';

 TEXT_MES_SHOW_EXIF_MARKER = '���������� EXIF ���������';

 TEXT_MES_GROUP_ALREADY_EXISTS = '������ � ����� ������ ��� ����������! ����������, �������� ������ ���';
 TEXT_MES_NEW_GROUP = '<����� ������>';
 TEXT_MES_USE_SCANNING_BY_FILENAME = '������������ ��������� ��� ���������� �����';
 TEXT_MES_SHOW_OTHER_PLACES = '���������� ������ "������ �����"';

 TEXT_MES_PROGRESS_FORM = '����������� ��������';
 TEXT_MES_NO_USB_DRIVES = '�� ������� ������� ������';
 TEXT_MES_GET_PHOTOS = '�������� ����������';
 TEXT_MES_REMOVEBLE_DRIVE = '������� ��������';
 TEXT_MES_OPEN_THIS_FOLDER = '������� ��� �����';
 TEXT_MES_GET_PHOTOS_CAPTION = '��������� ����������';
 TEXT_MES_PHOTOS_DATE = '���� ����������:';
 TEXT_MES_FOLDER_MASK = '����� ����� �����:';
 TEXT_MES_COMMENT_FOR_FOLDER = '����������� � �����:';
 TEXT_MES_YOU_COMMENT = '��� �����������';
 TEXT_MES_END_FOLDER_A = '�������� �����:';
 TEXT_MES_METHOD_A = '�����:';
 TEXT_MES_MOVE = '�����������';
 TEXT_MES_FOLDER_NAME_A = '��� �����:';
 TEXT_MES_YEAR_A = '�.';
 TEXT_MES_CANT_CREATE_DIRECTORY_F = '���������� ������� ����������: "%s"';
 TEXT_MES_PHOTOS_NOT_FOUND_IN_DRIVE_F = '���������� �� �������� "%s" �� �������';
 TEXT_MES_NO_EXIF_HEADER = 'Exif ��������� �� ������';
// 'Exif Header is not valid'
 TEXT_MES_GET_MULTIMEDIA_FILES = '�������� �������������� �����';
 TEXT_MES_INSERT_IMAGE = '�������';

 TEXT_MES_SHOW_LAST = '�� ���������:';
 TEXT_MES_SHOW_LAST_DAYS = '����';
 TEXT_MES_SHOW_LAST_WEEKS = '������';
 TEXT_MES_SHOW_LAST_MONTH = '�������';
 TEXT_MES_SHOW_LAST_YEARS = '���';

 TEXT_MES_LOAD_IMAGE = '��������� �����������';
 TEXT_MES_NEW_EDITOR = '����� ��������';
 TEXT_MES_COPY_CURRENT_ROW = '���������� ������� ������';
 TEXT_MES_COPY_ALL_INFO = '���������� ��� ����������';

 TEXT_MES_SPEC_QUERY = '������� ������������ �������:';
 TEXT_MES_DELETED = '��������';

 TEXT_MES_NEW_TEXT_FILE = '��������� ����';
 TEXT_MES_MAKE_NEW = '������� �����...';
 TEXT_MES_MAKE_NEW_TEXT_FILE = '��������� ����';
 TEXT_MES_UNABLE_TO_CREATE_FILE_F = '���������� ������� ���� "%s"';
 TEXT_MES_UNABLE_TO_CREATE_DIRECTORY_F = '���������� ������� ���������� "%s"';
 TEXT_MES_NEXT_ON_CLICK = '"���������" ��� �����';
 TEXT_MES_INCLUDE_IN_BASE_SEARCH = '��������� � ������� �����';
 TEXT_MES_LINKS_FOR_PHOTOS = '������ � ����������(��)';

 TEXT_MES_LINKS = '������';

 TEXT_MES_ADD_LINK = '�������� ������';
 TEXT_MES_EDIT_LINK = '�������� ������';

 TEXT_MES_LINK_TYPE = '��� ������';
 TEXT_MES_LINK_NAME = '��� ������';
 TEXT_MES_LINK_VALUE = '��������';
 TEXT_MES_LINK_FORM_CAPTION = '���������� �������� ������';
 TEXT_MES_SELECT_DIRECTORY = '�������� ����������';
 TEXT_MES_ADDITIONAL = '�������������';
 TEXT_MES_ADDITIONAL_PROPERTY = '������';
 TEXT_MES_OPEN_FOLDER = '������� �����';
 TEXT_MES_USE_HOT_SELECT_IN_LISTVIEWS = '������������ ��������� ��� ��������� � �������';
 TEXT_MES_CHANGE_LINK = '�������� ������';
 TEXT_MES_GLOBAL = '����������';
 TEXT_MES_CANT_ADD_LINK_ALREADY_EXISTS = '������ � ����� ������ ��� ����������!'#13'����������, ������� ������ ���';
 TEXT_MES_ROTATE_WITHOUT_PROMT = '������������ ����������� �� ����� �� ��������� �������������';
 TEXT_MES_ROTATE_EVEN_IF_FILE_IN_DB = '���� ���� ���� � ��, ������������ �� �����';

 TEXT_MES_VIEW_SC_LEFT_ARROW = '����� (������� �����)';
 TEXT_MES_VIEW_SC_RIGHT_ARROW = '����� (������� ������)';
 TEXT_MES_VIEW_SC_FIT_TO_SIZE = '��������� ��� ���� (Ctrl+F)';
 TEXT_MES_VIEW_SC_FULL_SIZE = '�������� ������ (Ctrl+A)';
 TEXT_MES_VIEW_SC_SLIDE_SHOW = '�����-��� (Ctrl+S)';
 TEXT_MES_VIEW_SC_FULLSCREEN = '�� ���� ����� (Ctrl+Enter)';
 TEXT_MES_VIEW_SC_ZOOM_IN = '��������� (Ctrl+I)';
 TEXT_MES_VIEW_SC_ZOOM_OUT = '��������� (Ctrl+O)';
 TEXT_MES_VIEW_SC_ROTATE_LEFT = '��������� ����� (Ctrl+L)';
 TEXT_MES_VIEW_SC_ROTATE_RIGHT = '��������� ������ (Ctrl+R)';
 TEXT_MES_VIEW_SC_DELETE = '������� (Ctrl+D)';
 TEXT_MES_VIEW_SC_PRINT = '������ (Ctrl+P)';
 TEXT_MES_VIEW_SC_RATING = '������� (Ctrl+������)';
 TEXT_MES_VIEW_SC_EDITOR = '�������� (Ctrl+E)';
 TEXT_MES_VIEW_SC_INFO = '�������� (Ctrl+Z)';

 TEXT_MES_USE_WIDE_SEARCH = '����������� �����';
 TEXT_MES_VAR_VALUES = '��������� ��������';
 TEXT_MES_QUERY_FAILED = '���� ������ ������ ��������� ���������, �� � ����������� ���� �������� ����� "'+TEXT_MES_MANAGE_DB+'"'+#13' � � ����������� ���� ������� �� ������ "'+TEXT_MES_PACK_TABLE+'",'+#13' ����� ���� ������� "��\OK" � ������������� ����������';
 TEXT_MES_DIRECTORY_NOT_EXISTS_F = '���������� "%s" �� �������';
 TEXT_MES_SORT_GROUPS = '����������� ������';
 TEXT_MES_INCLUDE_IN_QUICK_LISTS = '�������� � ������ �������� ������';
 TEXT_MES_RELATED_GROUPS = '��������� ������';

 TEXT_MES_NEED_FILESD_PLEASE_WAIT_F = '� ���� �� (%s) ����� ��������� ����� ���� "%s" ����������� ��� ������, ����������, ��������� ��������� ����� ����� ������� �� ������ Ok\��';
 TEXT_MES_EX_COPY = '�����';
 TEXT_MES_SELECT_PLACE_TO_COPY = '������� �����, ���� ����������� ������ ����� (� ������ �����)';
 TEXT_MES_COPY_WITH_FOLDER = '���������� � ������';
 TEXT_MES_USE_GDI_PLUS = '������������ GDI+';
 TEXT_MES_GDI_PLUS_DISABLED_INFO = 'GDI+ ����������, ���������� � ������� ��� ������� ��������';
 TEXT_MES_DB_PATH_INVALID = '�������� ���� � ��!'#13'���� �� ����� ��������� ������� ���� � ����������� ��������';
 TEXT_MES_DB_READ_ONLY_CHANGE_ATTR_NEEDED = '���� ���� ������ ����� ������� "������ ������"! ������� ������� � ���������� �����';
 TEXT_MES_FRIENDS = '������';
 TEXT_MES_FAMILY = '�����';
 TEXT_MES_CANT_MAKE_ACTION_BECAUSE_USER_HAVENT_NORMAL_FILE_ACTION_RIGHTS = '���������� ��������� �������� �.�. ������������ �� ����� ���� �� ������� �������� ��������';
 TEXT_MES_UNABLE_GET_PHOTOS_COPY_MOVE_ERROR = '��������� ������ � �������� ��������� ����������'+#13+'�������� �� ��������� ����������� ���������� � ��������, ������� �������� ������ ��� ������';
 TEXT_MES_ADDING_FOLDER = '��������� ������ ������...';
 TEXT_MES_CANT_WRITE_TO_FILE_F = '���������� �������� � ���� "%s"'#13'��������, ���� ����� ������ �����������...';
 TEXT_MES_OPEN_ACTIVATION_FORM = '������� ����� ���������';
 TEXT_MES_INSTALL_BDE_ANYWAY = '������������� BDE � ����� ������';

//v2.0
 
 TEXT_MES_SHOW_ALL_GROUPS = '���������� ��� ������';
 TEXT_MES_DELETE_UNUSED_KEY_WORDS = '������� �������� �������� �����';
 TEXT_MES_FIX_DATE_AND_TIME = '��������� ���� � EXIF';
 TEXT_MES_MOVE_TO_GROUP = '����������� � ������';
 TEXT_MES_SELECT_GROUP = '����� ������';
 TEXT_MES_SELECT_GROUP_TEXT = '��������, ����������, ����������� ������';
 TEXT_MES_UNABLE_TO_MOVE_GROUP_F = '������ ��� ����������� ������: "%s"';
 TEXT_MES_RELOAD_INFO = '������������� ���� � �������, ����� ����������� ���������';
 TEXT_MES_UNABLE_TO_RENAME_GROUP_F = '������ ��� �������������� ������: "%s"';
 TEXT_MES_UNABLE_TO_DELETE_GROUP_F = '������ ��� �������� ������: "%s"';
 TEXT_MES_GROUP_RENAME_GROUP_CONFIRM = '�� ������������� ������ ������������� ������? (����� �������������� ��� ��)';
 TEXT_MES_CREATE_BACK_UP_EVERY = '��������� ��������� ����� ������:';
 TEXT_MES_DAYS = '����';
 TEXT_MES_DELETE_GROUP_IN_TABLE_CONFIRM = '�� ������ ������� ���������� �� ���� ������ (%s) �� ���� ��? (����������)';
 TEXT_MES_TIME_EXISTS = '����� �����������';
 TEXT_MES_TIME_NOT_SETS = '����� �� �����������';

 TEXT_MES_DATE_EXISTS = '���� �����������';
 TEXT_MES_NO_DATE_1 = '���� ���';
 TEXT_MES_TIME = '�����';
 TEXT_MES_TIME_NOT_EXISTS = '������� ���';
 TEXT_MES_MANY_INSTANCES_OF_PROEPRTY = '��������� �������� ���������� ����� ���� �������';
 TEXT_MES_AND_OTHERS = ' � ������...';
 TEXT_MES_UNABLE_TO_SHOW_INFO_ABOUT_SELECTED_FILES = '������ ��� ��������� �������� � ���������� ���������!';
 TEXT_MES_MENU_NOT_AVALIABLE_0 = '���������� �������� ���� (�������������� ����)';
 TEXT_MES_ERROR_EXESQSL_BY_REASON_F = '������ ��� ���������� �������:'#13'%s'#13'%s';
 TEXT_MES_GO_TO_CURRENT_TIME = '������� � �������� �������';
 TEXT_MES_GROUPS_EDIT_INFO = '����������� ������ "-->" ����� �������� ������ � ���������� �������� � ������ "<--" ����� ������� ��';
 TEXT_MES_SEL_NEW_PLACE = '�������� �����';
 TEXT_MES_NEW_PLACE = '����� �����';
 TEXT_MES_SHOW_PLACE_IN = '���������� �:';
 TEXT_MES_USER_DEFINED_PLACES = '�������������� �����:';
 TEXT_MES_PLACES = '�����:';
 TEXT_MES_ACTION_BREAKED_ITEM_FORMAT = '�������� ���� �������� �� ������ %s �� %s [%s]';
 TEXT_MES_BACKUPS = '��������� �����:';
 TEXT_MES_RESTORE_DB = '������������';
 TEXT_MES_RESTORE_DB_CONFIRM_F = '�� ������������� ������ ������������ ��� ����� �� ("%s")?'#13'(������� �� ����� ���������� � ������ ���������)'#13'������������� ���������� ����� ������ ������� ��������������';
 TEXT_MES_DELETE_DB_BACK_UP_CONFIRM_F = '�� ������������� ������ ������� ��� ����� �� ("%s")?';
 TEXT_MES_RESTORING_TABLE = '�������������� ��:';
 TEXT_MES_BEGIN_RESTORING_TABLE = '������ ���������� �������. ���������� - ���������...';
 TEXT_MES_RESTORING = '��������������';
 TEXT_MES_ERROR_CREATE_BACK_UP_DEFAULT_DB = '������! �� ������� ������� ��������� ����� ������� ��!';
 TEXT_MES_ERROR_COPYING_DB = '�� ������� ������������ �� (%s)! ������� �� ����� ���� ���������� ��� �������������! ����� ������� ���������� ������������ ���� "%s" � ������� ��������� ��������� ����� ����� ��';
 TEXT_MES_HELP_CREATE_ADMIN = '������� � ��� ���� ������ (����� �� ���� ����������) ��� ������� ������ ��������������, � ��������� ���� ������ � ���� "'+TEXT_MES_CONFIRM+'", ����� ���� ������� �� ������ "'+TEXT_MES_OK+'". ������ ������ ����� ����������� ��� ����� � ��.'#13#13;
 TEXT_MES_HELP_LOGIN = '������� ������, ������� �� ��������� ��� ������� ������ �������������� � ������� �� ������ "'+TEXT_MES_LOG_ON+'".'#13'����������� ���� "'+TEXT_MES_AUTO_LOG_ON+'" ����� �� ������� ������ ��� ������ (���� ����� �������������� �������������).'#13#13;
 TEXT_MES_SIZE_FORMATB = '%s �� %s';
 TEXT_MES_FREE_SPACE = '�������� �� �����';
// TEXT_MES_SQL_VERIFYING_FAILED = '� ���� �������� ������ �� ����������� ��������� (BDE) ��������� ������.'#13'��������, ��������� ���������� �� ��������� ��� ��������. ������������� �������������� ��������� BDE.';
 TEXT_MES_SQL_VERIFYING_FAILED = 'BDE �� ����������� �� ���������� � � ��������� ��������� ���� "BdeInst.dll" �����������.'#13'���� ��� ���������� �������� �� ������ ����� ������ (�� ���������� ������) ���������� �� ������ �� ���� ���������';
 TEXT_MES_DBE_DLL_LOADING_FAILED_F = '������ �������� ����� "BdeInst.dll"!'#13'�������� ���� �������� ��� ����������� � ����:'#13'%s';
 TEXT_MES_GROUPS_LIST = '��������� ������:';
 TEXT_MES_CONTENTS = '����������';
 TEXT_MES_SELECT_FONT = '������� �����';
 TEXT_MES_SELECT_FONT_INFO = '�������� ����������� ����� �� ������ � ������� �� ������ "'+TEXT_MES_OK+'"';
 TEXT_MES_OLD_FONT_NAME = '������ �����';
 TEXT_MES_NEW_FONT_NAME = '����� �����';
 TEXT_MES_USE_MAIN_MENU_IN_SEARCH_FORM = '���������� ������� ���� � ���� ������';
 TEXT_MES_OPEN_TABLE_ERROR_F = '������ �������� ������� "%s"';
 TEXT_MES_LIST_OF_KEYWORDS_CAPTION = '������ �������� ����';
 TEXT_MES_LIST_OF_KEYWORDS_TEXT = '� ���� ������ ��� �������� ����� �� ������� ���� ������. ������ �������� �� ������ ����� ����������� � ����� ������.';
 TEXT_MES_GET_LIST_OF_KEYWORDS = '�������� ������ �������� ����';
 TEXT_MES_LOADING_KEYWORDS = '���������� ����������� ������, ��������� ����������...';
 TEXT_MES_CD_ROM_DRIVE = 'CD-ROM';
 TEXT_MES_NO_CD_ROM_DRIVES = '�� ������� CD-ROM ���������';
 TEXT_MES_CD_ROM_DRIVES = 'CD-ROM �����';
 TEXT_MES_REMOVABLE_DRIVES = '������� �����';
 TEXT_MES_SPECIAL_LOCATION = '����������� ����������';
 TEXT_MES_SEL_FOLDER_IMPORT_PHOTOS = '�������� ����� ��� ������� ���������� � ��:';
 TEXT_MES_PHOTOS_NOT_FOUND_IN_PACH_F = '���������� �� ���������� ����: "%s" �� �������';
 TEXT_MES_MAKE_DB_TREE = '��������� ������ �� ��';
 TEXT_MES_MAKE_DB_TREE_CAPTION = '������ ������ ������� ��';
 TEXT_MES_DO_MAKE_DB_TREE = '��������� ������';
 TEXT_MES_MAKEING_DB_TREE = '���������� ������...';
 TEXT_MES_ERROR_ITEM = '������ �����������';
 TEXT_MES_UNKNOWN = '����������';
 TEXT_MES_YOU_HAVENT_RIGHTS_FOR_FULL_ACCESS_NEW_IMAGE_WILL_COPIED_IN_NEW_FILE = '� ��� ������������ ���� �� ������ ������ ������ ��������. ����� ����������� ����� ����������� � ����� ����.';
 TEXT_MES_CRYPT_FILE_WITHOUT_PASS_MOT_ADDED = '�� ������� �������� � �� ���� ��� ��������� ������. ��� ��������� �������� "�������" � ����������� ����'#13#13;
 TEXT_MES_HISTORY = '�������';
 TEXT_MES_NO_HISTORY = '������� �����';
 TEXT_MES_HISTORY_INFO = '� ������ ������ ��������� �����, ������� �� �����-���� �������� �� ���� ���������:';
 TEXT_MES_ASK_AGAIN = '�� ���������� �����';
 TEXT_MES_FIXED_TH_FOR_ITEM = '��������� ���������� � ����� "%s"';
 TEXT_MES_FAILED_TH_FOR_ITEM = '�� ������� �������� ���������� � ����� "%s" �� �������: %s';
 TEXT_MES_CURRENT_ITEM_F = '������� ������ %s �� %s [%s]';
 TEXT_MES_CURRENT_ITEM_LINK_BAD = '�������� ������ � ������ #%d [%s]. ������ "%s" ���� "%s"';
 TEXT_MES_BAD_LINKS_TABLE = '����� ��������� ����� ���������������� ������ �� ��:';
 TEXT_MES_BAD_LINKS_TABLE_WORKING = '����������� �����, ����������, ���������... '#13'(�� ���������� ��� ����� ���������� � ����� ������)';
 TEXT_MES_BAD_LINKS_TABLE_WORKING_1 = '����������� �����';
 TEXT_MES_RECREATE_IDEX_QUESTION = '�� ������������� ������ ��������������� IDEx � �������? �������������� ������� ��� ��������� �������.';
 TEXT_MES_SHOW_BAD_LINKS_QUESTION = '�� ������������� ������ ����������� ������� �� ���������������� ������? ������������ ������� ��� ��������� �������.';
 TEXT_MES_RECTEATE_IDEX_CAPTION = '����������� IDEx';
 TEXT_MES_BAD_LINKS_CAPTION = '����� ������';
 TEXT_MES_NEW_NAME = '����� ���';
 TEXT_MES_ENTER_NEW_NAME = '������� ����� ��� ����� � ������� �� "'+TEXT_MES_OK+'"';
 TEXT_MES_RECORDS_ADDED = '������� ���������';
 TEXT_MES_RECORDS_UPDATED = '������� ���������';
 TEXT_MES_SCAN_IMAGE = '����� �������';
 TEXT_MES_ALLOW_VIRTUAL_CURSOR_IN_EDITOR = '����������� ������ � ���������';
 TEXT_MES_PATH_TOO_LONG = '���� � ������������ ��������� ����� �������:'#13'%s'#13'� ���� ��������� ����� ���������� ��������, ����� �� �������� - ��������� ��������� � ����� � ����� �������� ����';
 TEXT_MES_SHOW = '��������';
 TEXT_MES_USER = '������������';
 TEXT_MES_EDIT = '�������������';
 TEXT_MES_GROUPS = '������';
 TEXT_MES_NEW = '�����';   
 TEXT_MES_NEW_W = '�����';
 TEXT_MES_SAVE = '���������';
 TEXT_MES_COPY = '�����������';
 TEXT_MES_STOP = '����';
 TEXT_MES_ERROR = '������';
 TEXT_MES_PROCESSING = '���������';
 TEXT_MES_ORIGINAL = '��������';
 TEXT_MES_ADD_PROC_IMTH_AND_ADD_ORIG_TO_PROC_PHOTO = '������� ������ ���� � ���������� (� ��������� ����������� ������ �� ���� ��������)';
 TEXT_MES_ADD_PROC_IMTH = '������� ������ ���� � ����������';

 TEXT_MES_ADD_ORIG_IMTH_AND_ADD_PROC_TO_ORIG_PHOTO = '������� ������ ���� � ���������� (� ��������� ����������� ������ �� ��� ���������)';
 TEXT_MES_ADD_ORIG_IMTH = '������� ������ ���� � ����������';

 TEXT_MES_PACKING_WILL_BEGIN_AT_NEXT_STARTUP = '�������� ������� ��� ��������� ������� ���������!';

 TEXT_MES_BACK_UPING_WILL_BEGIN_AT_NEXT_STARTUP = '�������������� ������� ��� ��������� ������� ���������!';
 TEXT_MES_BACK_UP_TABLE = '�������� ��������� ����� ��';
 TEXT_MES_BACKUPING = '�����������';
 TEXT_MES_DB_BY_DEFAULT = '��';
 TEXT_MES_ENTER_NEW_NAME_FOR_DB = '����� ��� ��� ��';
 TEXT_MES_DO_YOU_REALLY_WANT_TO_DENELE_DB_F = '�� ������������� ������ ������� ��� �� (%s)?';
 TEXT_MES_SELECT_BK_COLOR = '������� ���� ����';
 TEXT_MES_PRINT_ERROR_F = '���������� ������� ����� ������ �� �������: '#13'%s';
 TEXT_MES_ACTIONS_FORM = '��������';

 SORT_BY = '����������� ��...';    
 SORT_BY_NO_SORTING  = '��� ����������';
 SORT_BY_FILENAME  = '����� �����';
 SORT_BY_SIZE = '�������';
 SORT_BY_TYPE = '����';
 SORT_BY_MODIFIED  = '���� ���������';
 SORT_BY_RATING  = '������';
 SORT_BY_SET_FILTER = '���������� ������';
 SORT_BY_NUMBER = '������';
 TEXT_MES_ENTER_FILTER = '������� ������ (�����) �� ����������� ������';
 TEXT_MES_FILTER = '������';
 TEXT_MES_RENAME_FOLDER_WITH_DB_F = '� ������ ����� (%s) ���������� %s ���������� �� ��!'#13'��������������� ���������� � ��?';

 TEXT_MES_SEL_FOLDER_SPLIT_DB = '����������, �������� ����� ��� ���������� ����� ��';
 TEXT_MES_SPLIT_DB_CAPTION = '�������� ��';
 TEXT_MES_DELETE_RECORDS_AFTER_FINISH = '������� ������ �� ���������';
 TEXT_MES_FILES_AND_FOLDERS = '����� � �����:';
 TEXT_MES_SPLIT_DB_INFO = '���������� � ������ ����� � �����, � ������� ���������� �����������, ������� ���������� ��������� � ������ ��';
 TEXT_MES_METHOD = '�����';
 TEXT_MES_SELECT_DB_PLEASE = '����������, �������� ������ ���� ������';
 TEXT_MES_REALLY_SPLIT_IN_DB_F = '�� ������������� ������ ������� �� � ������������ ������ ����:'#13'"%s" ?'#13'��������:'#13'�� ����� �������� ������ ���� ����� ����������!';
 TEXT_MES_SELECTED_COLOR = '���� ���������';
 TEXT_MES_RELOAD_DATA = '������������� ������ � �����?';

 TEXT_MES_OPTIMIZE_TO_FILE_SIZE = '�������������� ��� ������:';
 TEXT_MES_WAINT_DB_MANAGER = '����������, ��������� ���� �������� �� ���������. ��� ����� ������ ��������� �����...';
 TEXT_MES_WAINT_OPENING_QUERY = '����������, ��������� ���� ����������� ������';

 TEXT_MES_DO_UPDATE_IMAGES_ON_IMAGE_CHANGES = '������� �� ���������� ������ � ��������� ������ (��������� ������ - ������� help)';

 TEXT_MES_ENTER_TEXT = '������� �����';
 TEXT_MES_ENTER_CAPTION_OF_PANEL = '������� �������� ������:';
 TEXT_MES_APPLY_ACTION = '��������� ��������';

 TEXT_MES_APPLY_ACTION_DIR = '�������� ����������, ���� ����� ���������� ������������ �����';
 TEXT_MES_WRITE_ERROR_F = '�������� ������ ��� ������ ������!'#13'%s';
 TEXT_MES_DRIVE_FULL = '���� ����������!';

 TEXT_MES_DO_ADD_DB = '�������� ��';
 TEXT_MES_DB_TYPE = '��� ��:';
 TEXT_MES_DB_IS_OLD_DB = '���� ������ Paradox ��������� � ����� ������������� � ����������� ��������'#13'������������� ������������ �� Access';

 TEXT_MES_DELETING_SCRIPTS = '�������� ��������';
 TEXT_MES_THEMES = '�������� ����';                
 TEXT_MES_SCRIPTS = '�������';
 TEXT_MES_DEFAULT_DB_NAME = 'MyDB';
 TEXT_MES_SELECT_DB = '������� ��';
 TEXT_MES_MOVING_DB_INIT = '������������� �������! ����� ������ ��������� �����';

 TEXT_MES_NO_RECORDS_FOUNDED_TO_SAVE = '��� ��������� ������� ��� ����������';
 TEXT_MES_MAKE_FOLDERVIEWER = '������� ��-������';
 TEXT_MES_OPTIMIZANG_DUBLICATES = '����������� ����������... (Ctrl+B ��� �����������)';
 TEXT_MES_OPTIMIZANG_DUBLICATES_WORKING = '����������� ������������ ��, ����������, ���������... ';
 TEXT_MES_OPTIMIZANG_DUBLICATES_WORKING_1 = '����������� ������������ ��';
 TEXT_MES_OPTIMIZING_DUBLICATES = '�������������� ���������';
 TEXT_MES_OPTIMIZING_DUBLICATES_QUESTION = '�� ������������� ������ �������������� ��������� � �������?'+#13+'����������� ������� ��� ��������� ������� ���������...';

 TEXT_MES_CURRENT_ITEM_UPDATED_DUBLICATES = '��������� ������ #%d [%s]';

 TEXT_MES_INCLUDE_SUBFOLDERS_QUERY = '�������� ��������?';
 TEXT_MES_DB_VIEW_ABOUT_F = '���������� ���� ������ ��������� � ������� "%s". � ���� ��������� ��������� ������ �������, ��������� � ������ ������.';
 TEXT_MES_SELECT_FOLDER = '�������� �����';
 TEXT_MES_RUN_EXPLORER_AT_ATARTUP = '��������� ��������� ��� �������';
 TEXT_MES_USE_SPECIAL_FOLDER = '������������ �����';
 TEXT_MES_NO_ADD_SMALL_FILES_WITH_WH = '�� ��������� � �� �����, �������� ������:';
 TEXT_MES_LIST_DB_ITEMS_LOADING = '������ ������� ���� ���� ���������� �������� ������!';

 TEXT_MES_SORT_BY_FILE_NUMBER = '����������� �� ������ �����';
 TEXT_MES_SORT_BY_MODIFIED = '����������� �� ���� ���������';
 TEXT_MES_SORT_BY_FILE_TYPE = '����������� �� ����';

 TEXT_MES_WARNING_CONFLICT_RENAME_FILE_NAMES = '��������� �������� ��� ������!'#13'��� �������������� ����� ����� ����� ���������� �����, ��� �����������!'#13'�������� ����� ������ ����� ������ ��������.';
 TEXT_MES_CONFLICT_FILE_NAMES = '�������� ��� ������! ';
 TEXT_MES_UNKNOWN_DB_VERSION = '����������� ������ ��';
 TEXT_MES_DIALOG_CONVERTING_DB = '���� ������ ������� ��� �������������� ���� ���� ������ �� ������ ������� � ������.';
 TEXT_MES_CONVERT_TO_BDE = '�������������� � *.db (Paradox)';
 TEXT_MES_CONVERT_TO_MDB = '�������������� � *.photodb (PhotoDB)';
 TEXT_MES_CONVERTING_CAPTION = '��������������� ��';
 TEXT_MES_CONVERTING_FIRST_STEP = '�������� �������� ��� �� ��� ��������������� (*.db (Paradox) �� �������� ������ ��� ������������� ��������������� ���������)';
 TEXT_MES_CONVERTING_SECOND_STEP = '��������� ���� ���������� �������������� ��, ��� ����� ����������� ��������� �����...';
 TEXT_MES_CONVERTING_IMAGE_SIZES_STEP = '�� ������ ��������� ������� � �������� ������ ����������� � ��, � ����� ������� ������� �� ��������� ���� ������������� � ���������� ����������� '+'(�� ����� �������� � ���������� ��� ����������� ����)';
 TEXT_MES_CONVERT_DB = '�������������� ��';
 TEXT_MES_DO_YOU_REALLY_WANT_TO_CLOSE_THIS_DIALOG = '�� ������������� ������ ������� ���� ������?';
 TEXT_MES_CONVETRING_ENDED = '��������������� �� ���������!';
 TEXT_MES_FINISH = '�����!';


 TEXT_MES_CREATING_DB = '�������� ���� ������';
 TEXT_MES_CREATING_DB_OK = '�������� �� ������� ���������';
 TEXT_MES_OPENING_DATABASES = '�������� ��';               
 TEXT_MES_CONVERTING_ENDED = '��������������� ���������!';
 TEXT_MES_CONVERTION_IN_PROGRESS = '��������������� ���������...';
 TEXT_MES_CONVERTING_DB_QUESTION = '�� ������ ��������������� ���� ��? ��������������� ������� ����� ����������� ���������.';
 TEXT_MES_UPDATING_SETTINGS_OK = '���������� �������� ���� ���������!';
 TEXT_MES_IMPORT_IMAGES_CAPTION = '������ ����� ����������� � ��';
 TEXT_MES_IMPORTING_IMAGES_INFO = '���� ������ ������� ��� �������� � �� ���� ���������� ��� ������ �����������';

 TEXT_MES_IMPORTING_IMAGES_FIRST_STEP = '�������� ����� ������ ����� ������������� �����������';
 TEXT_MES_FOLDERS_TO_ADD = '����� ��� �������';
 TEXT_MES_CURRENT_DB_FILE = '������� ���� ��';
 MAKE_MES_NEW_DB_FILE = '����� ���� ��';
 TEXT_MES_DB_FILE = '���� ��';
 TEXT_MES_IMPORTING_IMAGES_SECOND_STEP = '�������� �������������� ����� ������� �����������.';
 TEXT_MES_IMPORTING_IMAGES_THIRD_STEP = '������� �� "'+TEXT_MES_START_NOW+'" � ��������� ���� ��������� ����� � ������� ��� ���� �����������. ��� ����� ����������� ����� ������� � ����������� �� �������� ������ �����������.';
 TEXT_MES_AKS_ME = '�������� ����';
 TEXT_MES_IF_CONFLICT_IMPORTING_DO = '��� ���������� ����������';
 TEXT_MES_CALCULATION_IMAGES = '������� �����������...';
 TEXT_MES_CURRENT_SIZE_F = '������� ������ - %s';
 TEXT_MES_IMAGES_COUNT_F = '������� ���������� - %d';

 TEXT_MES_PROCESSING_IMAGES = '��������� �����������';
 TEXT_MES_PROCESSING_SIZE_F = '������ %s �� %s';
 TEXT_MES_IMAGES_PROCESSED_COUNT_F = '���������� %d �� %d';

 TEXT_MES_TIME_REM_F = '�������� ������� - %s (&%%%%)'; //with progres

 TEXT_MES_WAIT_LOADING_WORK = '��������� ���� ��������� ����������� ���������� ������';

 TEXT_MES_CHOOSE_DATE_RANGE = '�������� ���:';
 TEXT_MES_APPLY = '���������';

 TEXT_MES_LESS_THAN = '�����';
 TEXT_MES_MORE_THAN = '�����';
 TEXT_MES_SHOW_DATE_OPTIONS = '��������� ����';
 TEXT_MES_RECORDS_FOUNDED = '��������� ������';
 TEXT_MES_OTHERS = '������';
 TEXT_MES_BACKUPING_GROUP = '��������� �����������';
 TEXT_MES_SHOW_GROUPS_IN_SEARCH = '��������� �� ������ � ����������';
 TEXT_MES_PASSWORDS = '������';
 
 TEXT_MES_VIEW_THUMBNAILS = '������ �������';
 TEXT_MES_VIEW_LIST = '������';
 TEXT_MES_VIEW_TILE = '������';
 TEXT_MES_VIEW_ICONS = '������';   
 TEXT_MES_VIEW_LIST2 = '�������';
 TEXT_MES_USE_WINDOWS_THEME = '���� Windows';

 TEXT_MES_CANNOT_RENAME_FILE = '������ ��� �������������� �������';
 TEXT_MES_DB_NAME = '��� ��';
 TEXT_MES_ENTER_CUSTOM_DB_NAME = '������� ��� ����� ��:';
 TEXT_MES_DO_YOU_WANT_REPLACE_ICON_QUESTION = '�� ������ �������� ������ � �������� ��?';
 TEXT_MES_MOVING_FILES_NOW = '� ������ ������ ������������ ����������� ������ � ������ ����. �� ������ ������� ����? ���� ������������ ����� �� �� �� ����� �� ����� ��������������� ���������� �� ��!';

 TEXT_MES_NO_PLACES_TO_IMPORT = '�� ������� �� ������ ���� ��� ���������� - ����������� ����������. ������� �� ������ "'+TEXT_MES_ADD_FOLDER+'" ����� �������� ���� � �����������.';

 TEXT_MES_FILES_ALREADY_EXISTS_REPLACE = '����� �������� ��� ����� � ������ �������, �������� ��?';

 TEXT_MES_LOADING_BIG_IMAGES = '�������� ������� ��������';  
 TEXT_MES_LOADING_BIG_IMAGES_F = '�������� ������� �������� (%s)';

 TEXT_MES_BIG_IMAGE_FORM_SELECT = '������ ��������';
 TEXT_MES_BIG_IMAGE_SIZES = '�������:';
 TEXT_MES_OTHER_BIG_SIZE_F = '%dx%d �����';

 TEXT_MES_PROGRAMM_NOT_INSTALLED = '��������� �� ����������� ��������� ��� ����������� ����� ������������ �������.'#13'�� ������ ��������� ������� ����������� ��������� � �������?';
 TEXT_MES_ERROR_DURING_CONVERTING_IMAGE_F_DO_NEXT = '��������� ������ ��� ����������� �����:'#13'%s'#13'���������� ���������������?';
 TEXT_MES_ERROR_DURING_CONVERTING_IMAGE_F = '��������� ������ ��� ����������� �����:'#13'%s';

 TEXT_MES_DO_YOU_REALLY_WANT_CANCEL_OPERATION = '�� ������������� ������ �������� ���������� ������� ��������?';

 TEXT_MES_LOADING___ = '��������...';
 TEXT_MES_PHOTO_SERIES_DATES_ = '����� ���������� �� �����:';
 TEXT_MES_ACTION_DOWNLOAD_DATE = '�����';

 TEXT_MES_SIMPLE_COPY_BY_DATE = '��������� �����';
 TEXT_MES_MERGE_UP_BY_DATE = '���������� �����';
 TEXT_MES_MERGE_DOWN_BY_DATE = '���������� ����';
 TEXT_MES_DONT_COPY_BY_DATE = '�� ������������';
 TEXT_MES_SHOW_IMAGES = '�������� �����������';
 TEXT_MES_SCAN_IMAGES_DATES = '������������ �����';

 TEXT_MES_DO_YOU_REALLY_WANT_TO_THIS_ITEM = '�� ������������� ������ ������� ���� �����?';
 TEXT_MES_ALL_GROUPS = '��� ������';
 TEXT_MES_CLEAR_SEARCH_TEXT = '';
 TEXT_MES_NULL_TEXT = '������ �����';
 TEXT_MES_SORTING = '����������';


 TEXT_MES_STENOGRAPHIA = '������� ������';
 TEXT_MES_DO_STENO = '������ ������ � �����������';
 TEXT_MES_DO_DESTENO = '������� ������ �� �����������';
 TEXT_MES_FILE_IS_TOO_BIG = '���� ������� �������!';
 TEXT_MES_FILE_FILTER_FILES_LESS_THAN = '��� ����� (������<%s)|*?*';
 TEXT_MES_FILE_NAME_F = '��� ����� = "%s"';
 TEXT_MES_MAX_FILE_SIZE_F = '������������ ������ = %s';
 TEXT_MES_NORMAL_FILE_SIZE_F = '���������� ������ = %s';
 TEXT_MES_GOOD_FILE_SIZE_F = '��������� ������ = %s';
 TEXT_MES_FILE_SIZE_F = '������ ����� - %s';
 TEXT_MES_INFORMATION_FILE_NAME = '���� � �������:';
 TEXT_MES_STENO_USE_FILTER = '������������ ������ ��� ������ �����';
 TEXT_MES_STENO_USE_FILTER_MAX = '������������ ������ (�������� ��������� ��������)';
 TEXT_MES_STENO_USE_FILTER_NORMAL = '���������� ������ (����������� ���������)';
 TEXT_MES_STENO_USE_FILTER_GOOD = '������ ������ (���������)';
 TEXT_MES_OPEN_IMAGE = '������� �����������';
 TEXT_MES_ADD_INFO_AND_SAVE_IMAGE = '�������� ���. � ���������';
 TEXT_MES_DESTENO_IMAGE = '������� ����������';
 TEXT_MES_PHOTO_DB = 'Photo DataBase';
 TEXT_MES_ERROR_INITIALIZATION = '������ ������������� ���������';
 TEXT_MES_ERROR_RUNNING = '������ �� ����� ���������� ���������';    
 TEXT_MES_ERROR_RUNNING_F = '������ �� ����� ���������� ���������: %s';
 ERROR_CREATING_APP_DATA_DIRECTORY_MAY_NE_PROBLEMS = '�� ������� ������� ����� ��� �������� ������ � ������� "%s"! �� ����� ������ ��������� �������� ��������!';
 ERROR_CREATING_APP_DATA_DIRECTORY_TEMP_MAY_BE_PROBLEMS = '�� ������� ������� ����� ��� �������� ������ � ���������� ������� "%s"! �� ����� ������ ��������� �������� ��������!';
 TEXT_MES_CONFIRMATION = '�������������';
 TEXT_MES_ERROR_MOVING_GROUP_F = '��������� ������ �� ����� ����������� ������ %s � ������ %s (%s)';
 TEXT_MES_STENO_IMAGE_IS_NOT_VALID = '����������� �� �������� ������� ���������� ��� ������ ������ �� ��������������!';
 TEXT_MES_FILE_INFO_NOT_CRYPTED = '���������� � ����� �� ����� �����������!';
 TEXT_MES_FILE_INFO_NOT_VERIFYED = '���������� ���������� � �����! ����������� ����� �� �������!';
 TEXT_MES_CONVERTING_ERROR_F = '��������� ������ �� ����� ����������� ����! (%s)';
 TEXT_MES_UNKNOWN_DB = '����������� ����';
 TEXT_MES_LOADING_PHOTODB = '�������� PhotoDB '+TEXT_MES_PRODUCT_VERSION;

 TEXT_MES_CONVERTATION_JPEG_QUALITY = 'JPEG ��������';
 TEXT_MES_CONVERTATION_JPEG_QUALITY_INFO = '������������� �������� ������ �����������, �������� � ����. ��������� �������� 1-100';
 TEXT_MES_CONVERTATION_TH_SIZE = '����������� � ��';
 TEXT_MES_CONVERTATION_TH_SIZE_INFO = '��� �������� ������ ������������ �� ��������� ���� ������';
 TEXT_MES_CONVERTATION_HINT_SIZE = '������������';
 TEXT_MES_CONVERTATION_HINT_SIZE_INFO = '������ ������������� � ������������';
 TEXT_MES_CONVERTATION_PANEL_PREVIEW_SIZE = '������';
 TEXT_MES_CONVERTATION_PANEL_PREVIEW_SIZE_INFO = '������ ����������� � ������ �� ���������';

 TEXT_MES_IMAGE_SIZE_FORMAT = '������ ����������� = %s';
 TEXT_MES_DB_VERSION_INVALID_CONVERT_AVALIABLE = '������ �� �� ����� ���� ������������ ��� ���������������, �.�. ��� ������� ��� ������ �� ������� �������� ���������. ��������� ������ ����������� ���?';
 TEXT_MES_INVALID_DB_VERSION_INFO = '���� ��� ������ ������ ������� ��������� (���� PhotoDB '+TEXT_MES_PRODUCT_VERSION+') � ��� ���������� ������ ������ ���� ��������������.';
 TEXT_MES_CANNOT_DELETE_FILE_NEW_NAME_F = '�� ������ ������� ���� %s, �������� �� ����� ������ ���������� ��� ���������. ����� ������������ ������ ��� (���_�����_1)';
 TEXT_MES_LOAD_DIFFERENT_IMAGE = '��������� ������ �����������';

 TEXT_MES_CLOSE_DIALOG = '������� ������';
 TEXT_MES_SKIP_THIS_FILES = '���������� ��� �����';
 TEXT_MES_COPY_TEXT = '���������� �����';
 TEXT_MES_RECREATING_PREVIEWS = '���������� �������������� � ����...';
 TEXT_MES_BACKUP_SUCCESS = '��������� ����������� ������� ���������';
 TEXT_MES_PROSESSING_ = '�����������:';
 TEXT_MES_FILES_MERGED = '���� ��������';
 TEXT_MES_RECORD_NOT_FOUND_F = '������ %d �� ������� �� ����� -> ����������� �����';
 TEXT_MES_RECORD_NOT_FOUND_ERROR_F = '������ %d �� �������! [%s]';
 TEXT_MES_LOADING_BREAK = '�������� ��������...';
 TEXT_MES_CANT_WRITE_EXIF_TO_FILE_F  = '������ ������ EXIF-���������� � ����! ���� ����� ������� ��� EXIF';
 TEXT_MES_CANT_MODIRY_EXIF_TO_FILE_F = '������ �������������� EXIF-���������� ��� �����! ���� ����� ������� ��� ��������� EXIF';
 TEXT_MES_DB_NAME_PATTERN = '����� ����';
 TEXT_MES_USE_ANOTHER_DB_FILE = '������������ ������ ����:';
 TEXT_MES_NEW_DB_FILE = '<����� ���� ��>';
 TEXT_MES_ERROR_DB_FILE_F = '�������� ��� �������������� ���� '#13'"%s"!'#13' ��������� ������� ����� ��� ���������� �������� ��� ����� �������� �� - ��������, ���� ��� ������ � ���������� ������ ��������� � ���������� ��� ��������������� � ������� ������';
 TEXT_MES_THANGE_FILES_PATH_IN_DB = '������� ���� ��� ������ � ����';

 TEXT_MES_SHOW_HISTORY = '�������� ���� �������';
 TEXT_MES_UPDATER_OPEN_IMAGE = '�������';
 TEXT_MES_UPDATER_OPEN_FOLDER = '���������';
 TEXT_MES_PROCESSING_STATUS = '������ ��������:';
 TEXT_MES_UPDATER_INFO_SIZE_FORMAT = '������ [%s]';
 TEXT_MES_READD_ALL = '�������� �� � ���� ��� ���';
 TEXT_MES_ALL_FORMATS = '��� ������� (%s)';
 TEXT_MES_ERROR_WRITING_THEME = '�� ������� �������� ���� � ����!';
 TEXT_MES_CHANGE_DB_PATH_CAPTION = '�������� ���� ��� ������ � ����';
 TEXT_MES_CHANGE_DB_PATH_INFO = '���� � ��� ���������� ������������ �������� ����� ������ (� �������, ��������� ����� �����), �� � ������� ������� ������� ����� ������ ��������� ������ � ������ � ����.';
 TEXT_MES_SCAN_IN_DB = '�����������';
 TEXT_MES_CHOOSE_PATH = '�������';
 TEXT_MES_CHANGE_DB_PATH_FROM = '���� ��� ������:';  
 TEXT_MES_CHANGE_DB_PATH_TO = '����� ����:';
 TEXT_MES_CHOOSE_FOLDER = '�������� �����';
 TEXT_MES_CHANGE_ONLY_IF_END_PATH_EXISTS = '�������� ������ ������������ ����';
 TEXT_MES_CHANGING_PATH_OK = '����� ���� � �� ������ �������! ����� �������� %d �����. ������������� ������ � ����� ��� ���������� ���������!';
 TEXT_MES_CHANGING_PATH_FAILED = '��� ����� ���� �������� ������:'#13'%s';
 TEXT_MES_SELECT_DB_CAPTION = '������ ������\��������\�������������� ��';
 TEXT_MES_SELECT_DB_OPTIONS = '�������� ������ ��������';
 TEXT_MES_SELECT_DB_OPTION_1 = '�������� ������ ����� ���� ������';  
 TEXT_MES_SELECT_DB_OPTION_2 = '������������ ������������ ���� �� ������ �����';
 TEXT_MES_SELECT_DB_OPTION_3 = '������������ ������������������ ����';
 TEXT_MES_SELECT_DB_OPTION_STEP1 = '�������� ������ �������� �� ������ � ������� �� ������ "'+TEXT_MES_NEXT+'"';

 TEXT_MES_DB_NAME_AND_LOCATION = '�������� � ����������������� ������';
 TEXT_MES_DB_ENTER_NEW_DB_NAME = '������� ��� ��� ����� ����';
 TEXT_MES_CHOOSE_NEW_DB_PATH = '�������� ���� ��� ����� ����';
 TEXT_MES_CHOOSE_ICON = '������� ������';
 TEXT_MES_SELECT_DB_FILE = '������� ����';
 TEXT_MES_ICON_PREVIEW = '������������ ������';
 TEXT_MES_SELECT_ICON = '������� ������';
 TEXT_MES_NO_DB_FILE_SELECTED = '�� ������ ���� ���� ������! �������� ���� � ���������� �����';
 TEXT_MES_VALUE  = '��������';

 TEXT_MES_NEW_DB_WILL_CREATE_WITH_THIS_OPTIONS = '����� ���� ����� ������� �� ���������� �����������:'#13#13;
 TEXT_MES_NEW_DB_NAME_FORMAT = '��� ����: "%s"';
 TEXT_MES_NEW_DB_PATH_FORMAT = '���� � ����: "%s"';  
 TEXT_MES_NEW_DB_ICON_FORMAT = '���� � ������: "%s"';  
 TEXT_MES_NEW_DB_IMAGE_SIZE_FORMAT = '������ ����������� � ����: %dpx';
 TEXT_MES_NEW_DB_IMAGE_QUALITY_FORMAT = '�������� �����������: %dpx';
 TEXT_MES_NEW_DB_IMAGE_HINT_FORMAT = '������������ : %dpx';
 TEXT_MES_NEW_DB_IMAGE_PANEL_PREVIEW = '����������� � ������ : %dpx';

 TEXT_MES_SELECT_DB_FROM_LIST = '������� �� �� ������';
 TEXT_MES_SELECT_FILE_ON_HARD_DISK = '�������� ���� � �����';
 TEXT_MES_CHANGE_DB_OPTIONS = '�������� ����� ��';
 TEXT_MES_CREATE_EXAMPLE_DB = '������� ����������� ����*';
 TEXT_MES_DB_DESCRIPTION = '�������� ����';
 TEXT_MES_DB_PATH = '���� � ����';
 TEXT_MES_OPEN_FILE_LOCATION = '������� ����������������� �����';
 TEXT_MES_CHANGE_FILE_LOCATION = '�������� ������������ �����';
 TEXT_MES_PRESS_THIS_LINK_TO_CONVERT_DB = '��� ��������� �������� �������������� � �������� ��������� ������ ����������� ����';
 TEXT_MES_DB_CREATED_SUCCESS_F = '���� "%s" ������� �������';
 TEXT_MES_ADD_DEFAULT_GROUPS_TO_DB = '�������� ����������� ������';
 TEXT_MES_APPLICATION_PREV_FOUND_BUT_SEND_MES_FAILED = '�������� ���������� ����� ����������, �� �������� ���������� �� ������� � ������� 5 ������! ��������� ��� ���� ����� ����������?';
 TEXT_MES_SHOW_FILE_IN_EXPLORER = '�������� ���� � ����������';

 TEXT_MES_PROGRESS_FILL_COLOR = '���� ������� ��������-����';
 TEXT_MES_PROGRESS_FONT_COLOR = '���� ������ ��������-����';
 TEXT_MES_PROGRESS_BACK_COLOR = '���� ���� ��������-����';

 TEXT_MES_USE_FULL_RECT_SELECT = '������������ ������ ��������� � �������';
 TEXT_MES_LIST_VIEW_ROUND_RECT_SIZE = '������ �����������:';
 TEXT_MES_SELECT_DB_AT_FIRST = '������ �������� ���� ���� ������!';

 TEXT_MES_UNABLE_TO_RENAME_FILE_TO_FILE_F = '��������� ������ ��� �������������� ����� "%s" � "%s"!'#13'%s';
 TEXT_MES_DB_FILE_NOT_FOUND_ERROR = '���� ���� �� ����� ��� ������� ����������!'#13'�������� ������ ���� ��� �������� �����.';

 TEXT_MES_VIEWER_REST_IN_MEMORY_CLOSE_Q = '����������� ������� ����������, ������� ���?';

 TEXT_MES_LISENCE_FILE_BOT_FOUND = '���� � ������������ ����������� �� ������! ��������� ����� ����������!';
 TEXT_MES_NO_RATING = '��� ������';
 TEXT_MES_IMAGES_NOT_FOUND_UPDATER_CLOSED = '����������� �� �������! ���� ����� �������!';
 TEXT_MES_IMAGES_SORT_BY_COMPARE_RESULT = '�� ���������';
 TEXT_MES_ICON_OPTIONS = '��������� ������';
 TEXT_MES_INTERNAL_NAME = '������������ ���';
 TEXT_MES_UNABLE_TO_FIND_PASS_FOR_FILE_F = '�� ������ ����� ����� � �����: "%s"';
 TEXT_MES_UNABLE_TO_ADD_FILE_F = '�� ������� �������� ����: "%s"';
 TEXT_MES_FILE_NOT_EXISTS_F = '�� ������ ���� "%s"';
 TEXT_MES_USE_SLIDE_SHOW_FAST_LOADING = '������������ ������� �������� ������ (�� � ����)';
 TEXT_MES_ERROR_ICONS_DLL = '�� ������� ���������� icons.dll! ��� �������� ����� ������ ��� ����������, ������ ��� ����� ����� ����������!';
 TEXT_MES_SLIDE_PAGE_CATION = '   �������� %d �� %d';
 TEXT_MES_DEFAULT_PROGRESS_TEXT = '��������... (&%%)';

 TEXT_MES_LOGIN_MODE_CAPTION = '����� ����� � ����';
 TEXT_MES_LOGIN_MODE_USE_LOGIN = '������������ ���� �� �����\������';
 TEXT_MES_LOGIN_MODE_NO_LOGIN = '�� ������������ ���� �� �����\������, ���� ����� �������������� � ������������� �������';
 TEXT_MES_NO_LOGO = '��� ����';
 TEXT_MES_ERROR_CREATING_DEFAULT_USER_F = '��������� ������ �� ����� �������� ������������ ������������! ��� ������ %d';

 TEXT_MES_UPDATING_SYSTEM_INFO = '���������� ��������� ����������...';
 
 TEXT_MES_CD_EXPORT_CAPTION = '������� ���������� �� ������� ����';
 TEXT_MES_CD_EXPORT_INFO = '������ ������ ������� ��� ��������� ����� ����������, ���������� �� ������ ����� - �� CD\DVD ����.'+' ��� ���� ���������� � ����������� ��������� � ����, � ��� ������������� ��������� ���������� ��������� �������� ��� �������� ��������������� ����.'#13'��������� �� ���������� ������ �� ����, � ����� ���� ��������� ����� ��������������� ��� ������ �� ����.'+' ����� �������� �� ���� ������ ����� ����������� ������������������ ���������!';
 TEXT_MES_CD_EXPORT_LABEL_DEFAULT = '?��� �����';
 TEXT_MES_CREATE_CD_WITH_LABEL = '������� CD\DVD � ������';
 TEXT_MES_ADD_CD_ITEMS = '��������';
 TEXT_MES_REMOVE_CD_ITEMS = '�������';
 TEXT_MES_CREATE_DIRECTORY = '������� ����������';
 TEXT_MES_CD_EXPORT_LIST_VIEW_LOCUMN_FILE_NAME = '��� �����'; 
 TEXT_MES_CD_EXPORT_LIST_VIEW_LOCUMN_FILE_SIZE = '������';
 TEXT_MES_CD_EXPORT_LIST_VIEW_LOCUMN_DB_ID = 'ID �� ����';
 TEXT_MES_CD_EXPORT_DELETE_ORIGINAL_FILES = '������� ������������ ����� ����� �������� ��������';
 TEXT_MES_CD_EXPORT_MODIFY_DB = '��������������� ���������� � �� ����� �������� ��������';
 TEXT_MES_DO_CD_EXPORT = '��������������!';
 TEXT_MES_CD_EXPORT_DIRECTORY = '���������� ��� ��������';
 TEXT_MES_CHOOSE_DIRECTORY = '������� ����������';
 TEXT_MES_CD_EXPORT_SIZE = '������ ������ ��� ��������';
 TEXT_MES_SELECT_PLACE_TO_CD_EXPORT = '�������� ����� ��� �������� ������';
 TEXT_MES_ENTER_NEW_VIRTUAL_DIRECTORY_NAME = '������� ��� ��� ����� ����������';
 TEXT_MES_ENTER_CD_LABEL_TO_IDENTIFY_DISK = '����������, ������� ����� ����� ������� ��������� ��������� ����!'#13'� �������� ������ ������������ ������� ":","\" � "?"';
 TEXT_MES_CD_EXPORT_HASNT_ANY_DB_FILE = '�������������� ������ �� ����� �� ������ �����, ���������� � ������� ����� ������! �������� �� �� ������� ������ ����! ���������� �������?';
 TEXT_MES_CD_EXPORT_OK_F = '����� ��� ������ �� ���� ������� �������������� � ����� "%s"!';
 TEXT_MES_UNABLE_TO_COPY_DISK_FULL_F = '��������� ����������� �����, �.�. ���������� ������������� ���������� ���������� ����� �� �����! ���������� %s, � �������� %s!';
 TEXT_MES_UNABLE_TO_COPY_DISK = '���������� ����������� ����� � �������� ���������! ���������, ������� �� ����� ������ � ��������� ����������!';
 TEXT_MES_UNABLE_TO_DELETE_ORIGINAL_FILES = '�� ������� ������� ������������ �����! ���������, ������ �� �� ����� �� �������� ������. ���������� ����� ������� ������� ��� �����.';

 TEXT_MES_CD_MAPPING_CAPTION = '�������� ������';
 TEXT_MES_CD_MAP_FILE = 'DBCDMap.map';
 TEXT_MES_CD_LOCATION = '���������� �����';
 TEXT_MES_CD_MOUNED_PERMANENT = '��������';
 TEXT_MES_REMOVE_CD_LOCATION = '�������� ���� �� ������';
 TEXT_MES_ADD_CD_LOCATION = '������� ���� � �����';

 TEXT_MES_UNABLE_TO_FIND_FILE_CDMAP_F = '�� ������� ����� ���� '+TEXT_MES_CD_MAP_FILE+' �� ������ "%s"';
 TEXT_MES_CD_DVD_SELECT = '������� ����';
 TEXT_MES_CD_MAPPING_INFO = '� ���� ���� �� ������ ������� ���������� ������ � ������������, ��� ����� ������� �������� ����� � ������� ����������� ����� ��� ������� ���� '+TEXT_MES_CD_MAP_FILE;
 TEXT_MES_CD_MAP_QUESTION_CAPTION = '�������� �����';
 TEXT_MES_CD_MAP_QUESTION_INFO_F = '�� ������� ��� ��������� ����, ������� ��������� �� ������� �������� (� �������, CD\DVD)'+#13+'��������, ����������, ���� � ������������ � ������ "%s" � �������� ����� "'+TEXT_MES_CD_DVD_SELECT+'" ��� ����������� ��������������� ������.'+#13+'�� ������ ������� ��� ���������� � �������, ��� � ���� '+TEXT_MES_CD_MAP_FILE+' �� �����.';
 TEXT_MES_DONT_ASK_ME_AGAIN = '�� ���������� �����';
 TEXT_MES_DISK = '����';
 TEXT_MES_LOADED_DIFFERENT_DISK_F = '��� �������� ���� � ������ "%s", � ��������� ���� � ������ "%s"! �� ������ ������� ���� ������?';
 TEXT_MES_CANNOT_USE_CD_IMAGE_FOR_THIS_OPERATION_PLEASE_COPY_IT_OR_USE_DIFFERENT_IMAGE = '������ ������������ ��� ����� �������� ����, ����������� �� �����! ���������� ���� � ������ ����� ��� �������� ������ ����.';
 TEXT_MES_EXPLORER_CD_DVD = '������� ������� ����';
 TEXT_MES_REFRESH_DB_FILES_ON_CD = '�������� ������ � ���� ��� ������� �����';


 TEXT_MES_GO_BACK = '������� �����';
 TEXT_MES_GO_FORWARD = '������� �����';
 TEXT_MES_GO_UP = '������� �� ������� ����';

 TEXT_MES_MENU_RELOADED = '������ ���� ������� ����������!';

 TEXT_MES_UNABLE_TO_FIND_FILE_CDMAP_IN_FOLDER_USE_IT_F = '� ���� ����� �� ������ ���� '+TEXT_MES_CD_MAP_FILE+'! �� ����� ������������ ������ ����� ��� �������� ������� ����� "%s"?';
 TEXT_MES_USE_SMALL_TOOLBAR_ICONS = '����������� ��������� ������ ��� ��������';
 TEXT_MES_CREATE_PORTABLE_DB = '������� ������������ ���� ������ �� �����';

 TEXT_MES_ICONS_OPEN_MASK = '��� �������������� �������|*.exe;*.ico;*.dll;*.ocx;*.scr|������ (*.ico)|*.ico|����������� ����� (*.exe)|*.exe|Dll ����� (*.dll)|*.dll';

  implementation

end.
