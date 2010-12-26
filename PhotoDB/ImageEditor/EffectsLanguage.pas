unit EffectsLanguage;

interface

//{$DEFINE ENGL}
{$DEFINE RUS}

const
 {$IFDEF RUS}
 TEXT_MES_EX_EFFECTS = '�������';
 TEXT_MES_PREVIEW = '������������';
 TEXT_MES_SHARPEN = '����������';
 TEXT_MES_EYE_COLOR = '���� ����';
 TEXT_MES_COLOR_GREEN = '������';
 TEXT_MES_COLOR_BLUE = '�����';
 TEXT_MES_COLOR_BROWN = '����������';
 TEXT_MES_COLOR_BLACK = '׸����';
 TEXT_MES_COLOR_GRAY = '�����';
 TEXT_MES_COLOR_CUSTOM = '������������...';
 TEXT_MES_SMOOTH_METHOD = '���������� �����������';
 TEXT_MES_BASE_METHOD = '������� �����������';
 TEXT_MES_METHOD = '�����';
 TEXT_MES_PROPORTIONS = '���������:';
// TEXT_MES_CUSTOM_GRAYSCALE = '������������ �����\�����';
// TEXT_MES_GRAYSCALE_TEXT = '������� - ׸���\����� [%d]:';
// TEXT_MES_SEPIA_TEXT = '�������� ������� [%d]';
// TEXT_MES_CUSTOM_SEPIA = '������������ Sepia';
// TEXT_MES_DISORDER = '�������';
// TEXT_MES_DISORDER_F = '������� [%d]';
// TEXT_MES_INVERSE = '�������������';
// TEXT_MES_AUTO_LEVELS = '�����������';
// TEXT_MES_AUTO_COLORS = '��������';
// TEXT_MES_GRAYSCALE = '׸���\�����';
// TEXT_MES_COLOR_NOISE = '������� ���';
// TEXT_MES_MONO_NOISE = '������������� ���';
 TEXT_MES_FISH_EYE = '����� ����';
 TEXT_MES_SPLIT_BLUR = '�������� ��������';
 TEXT_MES_TWIST = '�����������';
 TEXT_MES_SHARPNESS_SMOOTH_METHOD = '����������� � sharpness';
 TEXT_MES_DRAW_STYLE_NORMAL = '�������';
 TEXT_MES_DRAW_STYLE_SUM = '�����';
 TEXT_MES_DRAW_STYLE_DARK = 'Ҹ����';
 TEXT_MES_DRAW_STYLE_WHITE = '�������';
 TEXT_MES_DRAW_STYLE_COLOR = '����';
 TEXT_MES_DRAW_STYLE_INV_COLOR = '��������������� ����';
 TEXT_MES_DRAW_STYLE_CHANGE_COLOR = '������ �����';
 TEXT_MES_DRAW_STYLE_DIFFERENCE = '�������';
 TEXT_MES_OPTIMIZE_IMAGE = '�������������� �����������';
 TEXT_MES_ANTIALIAS = '�����������';
// TEXT_MES_CUSTOM_USER_EFFECT = '������������ ������';
 TEXT_MES_FILTER_WORK = '������ ������� "%s"';
 TEXT_MES_TRANSPARENCY = '������������';
 TEXT_MES_TRANSPARENCY_F = '������������ [%s]';
 {$ENDIF}


 {$IFDEF ENGL}
 TEXT_MES_EX_EFFECTS = 'Effects';
 TEXT_MES_PREVIEW = 'Preview';
 TEXT_MES_SHARPEN = 'Sharpen';
 TEXT_MES_EYE_COLOR = 'Eye color';
 TEXT_MES_COLOR_GREEN = 'Green';
 TEXT_MES_COLOR_BLUE = 'Blue';
 TEXT_MES_COLOR_BROWN = 'Brown';
 TEXT_MES_COLOR_BLACK = 'Black';
 TEXT_MES_COLOR_GRAY = 'Gray';
 TEXT_MES_COLOR_CUSTOM = 'Custom...';
 TEXT_MES_SMOOTH_METHOD = 'Smooth';
 TEXT_MES_BASE_METHOD = 'Base resize';
 TEXT_MES_METHOD = 'Method';
 TEXT_MES_PROPORTIONS = 'Proportions:';

 TEXT_MES_CUSTOM_GRAYSCALE = 'Custom grayscale';
 TEXT_MES_GRAYSCALE_TEXT = 'Colored - Grayscale [%d]:';
// TEXT_MES_SEPIA_TEXT = 'Sepia value [%d]';
 TEXT_MES_CUSTOM_SEPIA = 'Custom Sepia';
 TEXT_MES_DISORDER = 'Disorder';
 TEXT_MES_INVERSE = 'Inverse';
 TEXT_MES_AUTO_LEVELS = 'AutoLevels';
 TEXT_MES_AUTO_COLORS = 'AutoColors';
 TEXT_MES_GRAYSCALE = 'Grayscale';
 TEXT_MES_COLOR_NOISE = 'Color noise';
// TEXT_MES_MONO_NOISE = 'Mono noise';
 TEXT_MES_FISH_EYE = 'Fish eye';
 TEXT_MES_SPLIT_BLUR = 'Split blur';
 TEXT_MES_TWIST = 'Twist';
 TEXT_MES_SHARPNESS_SMOOTH_METHOD = 'Resizing with sharpness';

 TEXT_MES_DRAW_STYLE_NORMAL = 'Normal';
 TEXT_MES_DRAW_STYLE_SUM = 'Sum';
 TEXT_MES_DRAW_STYLE_DARK = 'Dark';
 TEXT_MES_DRAW_STYLE_WHITE = 'White';
 TEXT_MES_DRAW_STYLE_COLOR = 'Color';
 TEXT_MES_DRAW_STYLE_INV_COLOR = 'Inverse color';
 TEXT_MES_DRAW_STYLE_CHANGE_COLOR = 'Change color';
 TEXT_MES_DRAW_STYLE_DIFFERENCE = 'Difference';
 TEXT_MES_OPTIMIZE_IMAGE = 'Optimize image';
 TEXT_MES_ANTIALIAS = 'AntiAlias';
// TEXT_MES_CUSTOM_USER_EFFECT = 'Custom Effect';
 TEXT_MES_FILTER_WORK = 'Filter "%s" working';
 TEXT_MES_TRANSPARENCY = 'Transparency';
 TEXT_MES_TRANSPARENCY_F = 'Transparency [%s]';

 {$ENDIF}

implementation

end.
