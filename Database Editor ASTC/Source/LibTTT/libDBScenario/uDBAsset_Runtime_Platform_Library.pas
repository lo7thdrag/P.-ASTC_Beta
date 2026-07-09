unit uDBAsset_Runtime_Platform_Library;

interface

uses
  tttData, Classes, uDBNote_Storage;


type



  TRuntime_Platform_Library = class
  public
    FData     : TRecRuntime_Platform_Library;
    FNote  : TNote_Storage ;
    FPlatform_Library_Entry : TList;
    FScenario : TRecScenario_Definition;
    FResource_Allocation   : TRecResource_Allocation;
  private

  public


  end;

  TPlatform_Library_Entry = class
  public
    FData   : TRecPlatform_Library_Entry;
  end;


implementation




end.
