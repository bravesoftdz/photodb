{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL)                                                                  }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is UnitVersioningTestDLL.dpr.                                                  }
{                                                                                                  }
{ The Initial Developer of the Original Code is Uwe Schuster.                                      }
{ Portions created by Uwe Schuster are Copyright (C) Uwe Schuster. All rights reserved.            }
{                                                                                                  }
{ Contributor(s):                                                                                  }
{   Uwe Schuster (uschuster)                                                                       }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ sample for TUnitVersioning                                                                       }
{                                                                                                  }
{ Unit owner: Uwe Schuster                                                                         }
{                                                                                                  }
{**************************************************************************************************}

// Last modified: $Date: 2010-10-26 17:27:39 +0200 (Tue, 26 Oct 2010) $

library UnitVersioningTestDLL;

{$I jcl.inc}

uses
  JclUnitVersioning;

const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jcl.svn.sourceforge.net/svnroot/jcl/tags/JCL-2.4-Build4571/jcl/examples/common/unitversioning/UnitVersioningTestDLL.dpr $';
    Revision: '$Revision: 3397 $';
    Date: '$Date: 2010-10-26 17:27:39 +0200 (Tue, 26 Oct 2010) $';
    LogPath: 'JCL\examples\common\unitversioning';
    Extra: '';
    Data: nil
  );

begin
  RegisterUnitVersion(HInstance, UnitVersioning);
end.
