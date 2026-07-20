unit uDBEditSetting;

interface

type
  TDBEditorSetting = record
    MapSourcePathENC      : string;   //D:\TTT\mapsource\coverageArea
    MapDestPathENC        : string;   //M:\map\mapsea
    OverlayPath           : string;   //M:\map\overlay
    PlottingPath          : string;
    Pattern               : String;   //D:\TTT\mapsource\map\background.gst
    predefPattern         : String;   //M:\map\pattern
    BMPPath               : String;
    ModelPath             : String;

    MapSourceGeosetENC    : string;   //D:\TTT\mapsource\coverage\AreaCoverage.gst
    MapSourcePathVECT     : string;   //D:\TTT\mapsource\map
    MapSourceGeosetVECT   : string;   //D:\TTT\mapsource\map\world.gst
    MapDestPathVECT       : string;   //M:\map\game_area
    MapOverlayStatic      : string;   //M:\map\game_area
    MapOverlayDynamic     : string;   //M:\map\game_area

//    MapENC                : string;   //D:\TTT\map\mapsea
//    SkinPath              : String;
//    SkinName              : string;
//    ProjectName           : string;
//    UserDBEditor          : string;
//    PasswordDBEditor      : string;
    MapTypePath           : string;   //D:\MAP
//    MapDefView            : string;   //D:\MAP\DEF_MAP_VIEW
//    MapGSTGame            : string;   //D:\MAP\GST_GAME
//    MapDefGame            : string;   //D:\MAP\DEF_GAME
    RootRecordPath        : string;
  end;

  function LoadFF_AppDBSetting(const fName: string; var dbEditSett: TDBEditorSetting): boolean;

var
  vAppDBSetting         : TDBEditorSetting;

implementation

  uses

 Classes, IniFiles, SysUtils, uIniFilesProcs;

function LoadFF_AppDBSetting(const fName: string; var dbEditSett: TDBEditorSetting): boolean;
const
   c_appsetting = 'dbeditor';
var
  IniF : TIniFile;
    s    : string;
    str  : string;
begin
   Result := True;
   s     := ExtractFilePath(ParamStr(0));
   str := s;
   s := s + fName;

   IniF  := TIniFile.Create(s);
  try

    with dbEditSett do
    begin
      MapSourcePathENC      := IniFReadstring(inif, c_appsetting, 'MapSourcePathENC', 'D:\Map ASTC\MapSource' );
      MapSourceGeosetENC    := IniFReadstring(inif, c_appsetting, 'MapSourceGeosetENC', 'D:\Map ASTC\MapSource\AreaCoverage.gst' );
      MapDestPathENC        := IniFReadstring(inif, c_appsetting, 'MapDestPathENC', 'D:\Map ASTC\GameArea' );

      MapOverlayStatic      := IniFReadstring(inif, c_appsetting, 'MapOverlayStatic', 'D:\Map ASTC\MapSource\background.gst' );
      MapOverlayDynamic     := IniFReadstring(inif, c_appsetting, 'MapOverlayDynamic', 'D:\Map ASTC\MapSource\background.gst' );

      OverlayPath           := IniFReadstring(inif, c_appsetting, 'OverlayPath', 'D:\Map ASTC\overlay\' );
      PlottingPath          := IniFReadString(IniF, c_appsetting, 'PlottingPath', 'D:\Map ASTC\plotting\');

      BMPPath               := IniFReadstring(inif, c_appsetting, 'BMPPath', str + '\data\Bitmap\' );
      ModelPath             := IniFReadstring(inif, c_appsetting, 'ModelPath', str + '\data\BiImage DBEditor\Interface\Model\' );
      RootRecordPath        := INIFReadString(IniF, c_appsetting, 'rootrecordpath', 'C:\T3RecordPath');

      MapSourcePathVECT     := IniFReadstring(inif, c_appsetting, 'MapSourcePathVECT', 'D:\Map ASTC\MapSource' );
      MapSourceGeosetVECT   := IniFReadstring(inif, c_appsetting, 'MapSourceGeosetVECT', 'D:\Map ASTC\mapsource\world.gst' );
      MapDestPathVECT       := IniFReadstring(inif, c_appsetting, 'MapDestPathVECT', 'M:\map\game_area' );
      Pattern               := IniFReadstring(inif, c_appsetting, 'Pattern', 'D:\Map ASTC\MapSource\background.gst' );
      predefPattern         := IniFReadstring(inif, c_appsetting, 'predefPattern', 'D:\Map ASTC\pattern' );

      //      MapENC                := IniFReadstring(inif, c_appsetting, 'MapENC', 'D:\Map ASTC\MapSea' );
      //      MapGSTGame            := INIFReadString(IniF, c_appsetting, 'MapGSTGame', 'D:\Map ASTC\GameArea');

    end;
  finally
    IniF.DisposeOf
  end;
end;

end.
