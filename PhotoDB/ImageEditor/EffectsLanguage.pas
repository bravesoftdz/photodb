unit EffectsLanguage;

interface

//{$DEFINE ENGL}
{$DEFINE RUS}

const
 {$IFDEF RUS}
 TEXT_MES_EX_EFFECTS = '�������';
 TEXT_MES_PREVIEW = '������������';
 TEXT_MES_SHARPEN = '����������';

 TEXT_MES_SMOOTH_METHOD = '���������� �����������';
 TEXT_MES_BASE_METHOD = '������� �����������';
 TEXT_MES_METHOD = '�����';
 TEXT_MES_PROPORTIONS = '���������:';

 TEXT_MES_FISH_EYE = '����� ����';
 TEXT_MES_SPLIT_BLUR = '�������� ��������';
 TEXT_MES_TWIST = '�����������';
 TEXT_MES_SHARPNESS_SMOOTH_METHOD = '����������� � sharpness';

 TEXT_MES_OPTIMIZE_IMAGE = '�������������� �����������';
 TEXT_MES_ANTIALIAS = '�����������';
 TEXT_MES_FILTER_WORK = '������ ������� "%s"';
 TEXT_MES_TRANSPARENCY = '������������';
 TEXT_MES_TRANSPARENCY_F = '������������ [%s]';
 {$ENDIF}


 {$IFDEF ENGL}
 TEXT_MES_EX_EFFECTS = 'Effects';
 TEXT_MES_PREVIEW = 'Preview';
 TEXT_MES_SHARPEN = 'Sharpen';

 TEXT_MES_SMOOTH_METHOD = 'Smooth';
 TEXT_MES_BASE_METHOD = 'Base resize';
 TEXT_MES_METHOD = 'Method';
 TEXT_MES_PROPORTIONS = 'Proportions:';

 TEXT_MES_CUSTOM_GRAYSCALE = 'Custom grayscale';
 TEXT_MES_GRAYSCALE_TEXT = 'Colored - Grayscale [%d]:';
 TEXT_MES_SHARPNESS_SMOOTH_METHOD = 'Resizing with sharpness';

 TEXT_MES_OPTIMIZE_IMAGE = 'Optimize image';
 TEXT_MES_ANTIALIAS = 'AntiAlias';
// TEXT_MES_CUSTOM_USER_EFFECT = 'Custom Effect';
 TEXT_MES_FILTER_WORK = 'Filter "%s" working';
 TEXT_MES_TRANSPARENCY = 'Transparency';
 TEXT_MES_TRANSPARENCY_F = 'Transparency [%s]';

 {$ENDIF}

implementation

end.
