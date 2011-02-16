unit Language;
                                                                          
interface

uses
  uConstants;

const
 TEXT_MES_UNKNOWN_ERROR_F = 'Непредвиденная ошибка! %s';
 TEXT_MES_KEY_SAVE = 'Ключ для активации сохранён! Перезапустите приложение для результата!';
 TEXT_MES_WAIT_FOR_A_MINUTE = 'Пожалуйста, подождите минуту...';
 TEXT_MES_READING_DB = 'Чтение базы данных...';
 TEXT_MES_READING_GROUPS_DB = 'Чтение базы данных групп';
 TEXT_MES_INITIALIZATION = 'Инициализация';
 TEXT_MES_FULL_PATH = 'Полное имя';
 TEXT_MES_CLEAR = 'Очистить';

 TEXT_MES_CLEANING_ITEM = 'Очистка... [%s]';
 TEXT_MES_CLEANING_STOPED = 'Очистка остановлена';

 TEXT_MES_PIXEL_FORMAT_D = '%dpx.';
 TEXT_MES_CREATING = 'Создание';
 TEXT_MES_UNABLE_SHOW_FILE = 'Невозможно отобразить файл:';
 TEXT_MES_OPEN = 'Открыть';
 TEXT_MES_CREATE_NEW = 'Создать новую';
 TEXT_MES_RATING_FORMATA = 'Оценка = %s';
 TEXT_MES_ID_FORMATA = 'ID = %s';
 TEXT_MES_DIMENSIONS = 'Разрешение : %s x %s';
 TEXT_MES_UPDATING_REC_FORMAT = 'Запись №%s [%s]';
 TEXT_MES_PAUSED = 'Пауза...';

 TEXT_MES_PROGRAM_CODE = 'Код вашей копии программы:';
 TEXT_MES_ACTIVATION_NAME = 'Имя для активации:';
 TEXT_MES_ACTIVATION_KEY = 'Введите сюда ключ для активации:';
 TEXT_MES_SET_CODE = 'Установить код';
 TEXT_MES_ACTIVATION_CAPTION = 'Активация';
 TEXT_MES_REG_TO = 'Зарегистрировано на:';
 TEXT_MES_FILE = 'Файл';

 TEXT_MES_NEEDS_ACTIVATION = 'Необходима активизация программы';
 TEXT_MES_LIMIT_RECS = 'Вы работаете в неактивированной БД!'+#13+'Вы можете добавить только %s записей!'+#13+'Выберите "Справка" в меню в окне поиска"';

 TEXT_MES_PACKING_MAIN_DB_FILE = 'Упаковка файлов БД...';
 TEXT_MES_PACKING_GROUPS_DB_FILE = 'Упаковка файла с группами...';
 TEXT_MES_PACKING_END = 'Упаковка закончена...';
 TEXT_MES_PACKING_BEGIN = 'Упаковка началась...';
 TEXT_MES_REC_FROM_RECS_FORMAT = 'Запись #%s из %s';
 TEXT_MES_MAIN_DB_AND_ADD_SAME = 'Главная и добавочная БД совпадают!';
 TEXT_MES_ADD_DB_RECS_FORMAT = 'Добавочная БД (%s Rec)';
 TEXT_MES_ADD_NEW_RECS = 'Добавлять новые записи';
 TEXT_MES_ADD_REC_WITHOUT_FILES = 'Добавлять записи без файлов';
 TEXT_MES_ADD_RATING = 'Добавлять оценку';
 TEXT_MES_ADD_ROTATE = 'Добавлять поворот';
 TEXT_MES_ADD_PRIVATE = 'Добавлять личные';
 TEXT_MES_ADD_KEYWORDS = 'Добавлять ключевые слова';
 TEXT_MES_ADD_GROUPS = 'Добавлять группы';
 TEXT_MES_ADD_NIL_COMMENT = 'Добавлять пустые комментарии';
 TEXT_MES_ADD_COMMENT = 'Добавлять комментарии';
 TEXT_MES_ADD_NAMED_COMMENT = 'Добавлять именованые комментарии';
 TEXT_MES_ADD_DATE = 'Добавлять дату';
 TEXT_MES_ADD_LINKS = 'Добавлять ссылки';
 TEXT_MES_IGNORE_KEYWORDS = 'Игнорировать слова';
 TEXT_MES_IMPORTING_OPTIONS_CAPTION = 'Настройки импорта';
 TEXT_MES_REPLACE_GROUP_BOX = 'Заменить';
 TEXT_MES_ON__REPLACE_ = 'на';
 TEXT_MES_USE_CURRENT_DB = 'Использовать текущую БД';
 TEXT_MES_USE_ANOTHER_DB = 'Использовать другую БД';
 TEXT_MES_MAIN_DB = 'Главная БД';
 TEXT_MES_ADD_DB = 'Добавочная БД';
 TEXT_MES_RES_DB = 'Результирующая БД';
 TEXT_MES_BY_AUTHOR = 'Автор';
 TEXT_MES_LIST_IGNORE_WORDS = 'Список игнорируемых слов:';

 TEXT_MES_SAVING_GROUPS = 'Сохранение групп';
 TEXT_MES_HELP_HINT = 'Помощь';

 TEXT_MES_CONVERTING = 'Обработка... (&%%)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT = 'Обновление записи %s из %s [%s]';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CRYPTED_POSTPONED = 'Обновление записи %s из %s [%s] отложено (зашифрована)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CD_DVD_CANCELED_INFO_F = 'Обновление записи %s из %s [%s] отменено (CD\DVD файлы обновляются из окна управлениями дисками)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_CRYPTED_FIXED = 'Для записи %s из %s [%s] удалён предпросмотр (файл зашифрован, а запись - нет)';
 TEXT_MES_RECREATINH_TH_FOR_ITEM_FORMAT_ERROR = 'Ошибка обновления записи %s';
 TEXT_MES_RECREATINH_TH_FORMAT_ERROR = 'Ошибка обновления записей';
 TEXT_MES_UPDATING_DESCTIPTION = 'Обновление БД';
 TEXT_MES_HOME_PAGE = 'Сайт программы';
 TEXT_MES_GET_CODE = 'Получить код';

 TEXT_MES_NEW_UPDATING_CAPTION = 'Доступна новая версия - %s';
 TEXT_MES_DOWNLOAD_NOW = 'Загрузить сейчас!';
 TEXT_MES_REMAIND_ME_LATER = 'Напомнить мне потом';

 TEXT_MES_NEXT_HELP = 'Далее...';
 TEXT_MES_HELP_FIRST = '     Для добавления фотографий в Базу Данных (БД) выберите пункт "Проводник" в контекстном меню, затем найдите ваши фотографии и в меню выберите "добавить объекты".'#13#13'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13#13;
 TEXT_MES_CLOSE_HELP = 'Вы действительно хотите отказаться от помощи?';
 TEXT_MES_HELP_1 = '     Найдите в проводнике папку с вашими фотографиями и, выделив фотографии, в меню выберите "Добавить объект(ы)".'#13#13'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13;
 TEXT_MES_HELP_2 = '     Нажмите на кнопку "Добавить объект(ы)" чтобы добавить фотографии в БД. После этого к фотографии можно добавлять информацию.'#13#13'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13;
 TEXT_MES_HELP_3 = '     Теперь фотографии, у которых не отображается иконка (+) в верхнем левом углу находятся в БД. Они доступны по поиску в окне поиска и к ним доступно контекстное меню со свойствами. Дальнейшая справка доступна из главного меню (Справка -> Справка).'#13' '#13;

 TEXT_MES_HELP_ACTIVATION_FIRST = '     Вы хотите получить справку, как активировать программу? Если ДА, то нажмите на кнопку "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13;
 TEXT_MES_HELP_ACTIVATION_1 = '     Для активации программы в контекстном меню выберите пункт "Справка"->"Активация программы"'#13#13'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13;
 TEXT_MES_HELP_ACTIVATION_2 = '     Для активации программы в контекстном меню выберите пункт "Справка"->"Активация программы"'#13#13'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13;
 TEXT_MES_HELP_ACTIVATION_3 = '     Нажмите на кнопку "'+TEXT_MES_GET_CODE+'", после чего запустится почтовая программа с новым письмом, в заголовке которого дана вся необходимая  для активации информация.'#13'вам необходимо отослать это письмо или же (если почтовая программа не запустилась)'+
 ' самим отправить письмо на адрес '+ProgramMail+', в котором нужно указать код программы и её версию.'#13#13+'     Нажмите "'+TEXT_MES_NEXT_HELP+'" для дальнейшей помощи.'#13'     Или нажмите на крестик сверху, чтобы справка более не отображалась.'#13' '#13#13' '#13;
 TEXT_MES_HELP_ACTIVATION_4 = '     В течении суток вам будет выслан код активации, который нужно ввести в это окно и нажать на кнопку "'+TEXT_MES_SET_CODE+'". После этого программа будет активирована.'#13' '#13;
 TEXT_MES_WAIT_ACTION = 'Пожалуйста, подождите, пока программа выполнит текущую операцию и обновит базу данных.';

 TEXT_MES_USE_SCANNING_BY_FILENAME = 'Использовать узнавание при совпадении имени';
 TEXT_MES_LOAD_IMAGE = 'Загрузить изображение';
 TEXT_MES_DIRECTORY_NOT_EXISTS_F = 'Директория "%s" не найдена';
 TEXT_MES_OPEN_ACTIVATION_FORM = 'Открыть форму активации';
//v2.0

 TEXT_MES_ACTION_BREAKED_ITEM_FORMAT = 'Действие было прервано на записи %s из %s [%s]';
 TEXT_MES_DELETE_DB_BACK_UP_CONFIRM_F = 'Вы действительно хотите удалить эту копию БД ("%s")?';
 TEXT_MES_ERROR_CREATE_BACK_UP_DEFAULT_DB = 'Ошибка! Не удалось сделать резервную копию текущей БД!';
 TEXT_MES_ERROR_COPYING_DB = 'Не удалось восстановить БД (%s)! Текущая БД может быть повреждена или отсутствовать! После запуска попробуйте восстановить файл "%s" в котором находится резервная копия вашей БД';

 TEXT_MES_UNKNOWN = 'Неизвестно';
 TEXT_MES_FIXED_TH_FOR_ITEM = 'Обновлена информация у файла "%s"';
 TEXT_MES_FAILED_TH_FOR_ITEM = 'Не удалось получить информацию у файла "%s" по причине: %s';
 TEXT_MES_CURRENT_ITEM_F = 'Текущая запись %s из %s [%s]';
 TEXT_MES_CURRENT_ITEM_LINK_BAD = 'Неверная ссылка в записи #%d [%s]. Ссылка "%s" типа "%s"';
 TEXT_MES_BAD_LINKS_CAPTION = 'Битые ссылки';
 TEXT_MES_BACKUPING = 'Копирование';

 TEXT_MES_CURRENT_ITEM_UPDATED_DUBLICATES = 'Обновлена запись #%d [%s]';
 TEXT_MES_DB_VIEW_ABOUT_F = 'Автономная база данных созданная с помощью "%s". В этой программе отключены многие функции, доступные в полной версии.';
 TEXT_MES_CONVETRING_ENDED = 'Конвертирование БД завершено!';

 TEXT_MES_CREATING_DB = 'Создание базы данных';
 TEXT_MES_CREATING_DB_OK = 'Создание БД успешно завершено';
 TEXT_MES_OPENING_DATABASES = 'Открытие БД';               
 TEXT_MES_CONVERTION_IN_PROGRESS = 'Конвертирование структуры...';
 TEXT_MES_UPDATING_SETTINGS_OK = 'Обновление настроек базы завершено!';
 TEXT_MES_DB_NAME = 'Имя БД';
 TEXT_MES_ENTER_CUSTOM_DB_NAME = 'Введите имя новой БД:';
 TEXT_MES_DO_YOU_WANT_REPLACE_ICON_QUESTION = 'Вы хотите заменить иконку у конечной БД?';
 TEXT_MES_FILES_ALREADY_EXISTS_REPLACE = 'Папка содержит уже файлы с такими именами, заменить их?';
 TEXT_MES_CONVERTING_ERROR_F = 'Произошла ошибка во время конвертации базы! (%s)';
 TEXT_MES_UNKNOWN_DB = 'Неизвестная база';
 TEXT_MES_CANNOT_DELETE_FILE_NEW_NAME_F = 'Не удаётся удалить файл %s, возможно он занят другой программой или процессом. Будет использовано другое имя (имя_файла_1)';

 TEXT_MES_RECREATING_PREVIEWS = 'Обновление предпросмотров в базе...';
 TEXT_MES_BACKUP_SUCCESS = 'Резервное копирование успешно завершено';
 TEXT_MES_FILES_MERGED = 'Файл объединён';
 TEXT_MES_RECORD_NOT_FOUND_F = 'Запись %d не найдена по ключу -> расширенный поиск';
 TEXT_MES_RECORD_NOT_FOUND_ERROR_F = 'Запись %d не найдена! [%s]';

 TEXT_MES_DB_FILE_NOT_FOUND_ERROR = 'Файл базы не найдён при запуске приложения!'#13'Выберите другой файл или создайте новый.';
 TEXT_MES_UNABLE_TO_COPY_DISK = 'Невозможно скопировать файлы в конечное рамещение! Проверьте, имеются ли права записи в указанную директорию!';
 TEXT_MES_UNABLE_TO_DELETE_ORIGINAL_FILES = 'Не удалось удалить оригинальные файлы! Проверьте, имеете ли Вы право на удаление файлов. Попробуйте позже вручную удалить эти файлы.';
 TEXT_MES_ICONS_OPEN_MASK = 'Все поддерживаемые форматы|*.exe;*.ico;*.dll;*.ocx;*.scr|Иконки (*.ico)|*.ico|Исполняемые файлы (*.exe)|*.exe|Dll файлы (*.dll)|*.dll';

implementation

end.
