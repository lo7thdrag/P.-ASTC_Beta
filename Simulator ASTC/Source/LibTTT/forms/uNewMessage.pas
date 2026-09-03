unit uNewMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uSimMgr_Client,
  uSelectRecipient, uGameData_TTT, uDBCubicles;

type
  TfNewMessage = class(TForm)
    btnTo: TButton;
    btnInfo: TButton;
    edtTo: TEdit;
    edtInfo: TEdit;
    btnSave: TButton;
    btnSend: TButton;
    btnCancel: TButton;
    mmoDisplay: TMemo;
    lblFrom: TLabel;
    edtFrom: TEdit;
    lblPriority: TLabel;
    cbbPrior: TComboBox;
    lblBand: TLabel;
    cbbBand: TComboBox;
    lblSubject: TLabel;
    edtSubject: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnToClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    ToCub : TStrings;
    InfoCub : Tstrings;

    isNew : Boolean;

    { Public declarations }
  end;

var
  fNewMessage: TfNewMessage;

implementation

uses ufToteDisplay, ufTacticalDisplay, uCommTTT, ufrmRightNav, uLibSettingTTT, ufrmRightAtasAir;


{$R *.dfm}

procedure TfNewMessage.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfNewMessage.btnSaveClick(Sender: TObject);
var
  MessageCub : string;
  RecSendMessage : TRecSendMessage;
begin
  MessageCub := mmoDisplay.Text;

  if edtTo.Text = '' then
  begin
    ShowMessage('Send To Or Send Info is Blank, Please Fill The Recipient');
  end
  else
  if mmoDisplay.Text = '' then
  begin
    ShowMessage('Message is Blank, Please Write the Message');
  end
  else
  begin
    ToCub.DelimitedText := edtTo.Text;

    //Send Message -> Sync Message Send to Same Cubicle
    RecSendMessage.RecipientList := ToCub.DelimitedText;
    RecSendMessage.OrderID := 0;

    if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
      RecSendMessage.SendFrom := 0
    else
      RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index;

    if edtSubject.Text = '' then
      RecSendMessage.Subject := 'None'
    else
      RecSendMessage.Subject := edtSubject.Text;
    RecSendMessage.Priority := cbbPrior.ItemIndex;
    RecSendMessage.Band := cbbBand.ItemIndex;
    RecSendMessage.MessageHandling := MessageCub;
    RecSendMessage.Messagetype := 1;
    simMgrClient.netSend_MessageHandling(RecSendMessage);

    Close;
  end;
end;

procedure TfNewMessage.btnSendClick(Sender: TObject);
var
  i,j: Integer;
  MessageCub : string;
  RecSendMessage : TRecSendMessage;
  grp : T3CubicleGroup;
begin
  case vGameDataSetting.Role of
    0:
    begin
      {$REGION ' Plotter '}

      {$ENDREGION}
    end;
    1:
    begin
      {$REGION ' Navigasi '}
      MessageCub := mmoDisplay.Text;

      if edtTo.Text = '' then
      begin
        frmRightNav.addStatus('Send To Or Send Info is Blank, Please Fill The Recipient');
      end
      else
      if mmoDisplay.Text = '' then
      begin
        frmRightNav.addStatus('Message is Blank, Please Write the Message');
      end
      else
      begin
        ToCub.DelimitedText := edtTo.Text;

        //Send Message -> Sync Message Send to Same Cubicle
        RecSendMessage.RecipientList := ToCub.DelimitedText;
        RecSendMessage.OrderID := 0;

        if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
          RecSendMessage.SendFrom := 0
        else if Assigned(simMgrClient.FMyCubGroup) then
          RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index
        else
          RecSendMessage.SendFrom := 0;

        if edtSubject.Text = '' then
          RecSendMessage.Subject := 'None'
        else
          RecSendMessage.Subject := edtSubject.Text;

        RecSendMessage.Priority := cbbPrior.ItemIndex;
        RecSendMessage.Band := cbbBand.ItemIndex;
        RecSendMessage.MessageHandling := MessageCub;

        RecSendMessage.Messagetype := 0;
        simMgrClient.netSend_MessageHandling(RecSendMessage);

        for i := 0 to ToCub.Count - 1 do
        begin
          RecSendMessage.Sendto := 0;

          if LowerCase(ToCub[i]) <> 'controller' then
          begin
            for j := 0 to simMgrClient.Scenario.CubiclesGroupsListFromDB.Count - 1 do
            begin
              grp := simMgrClient.Scenario.CubiclesGroupsListFromDB.Items[j] as T3CubicleGroup;
              if (grp <> nil) and (LowerCase(grp.FData.Group_Identifier) = LowerCase(ToCub[i])) then
              begin
                RecSendMessage.Sendto := grp.FData.Group_Index;
                Break;
              end;
            end;
          end;

          RecSendMessage.Messagetype := 2;
          simMgrClient.AddListQueueMessage(RecSendMessage);
        end;

        Close;
      end;
      {$ENDREGION}
    end;
    2,3:
    begin
      {$REGION ' Firing '}
      MessageCub := mmoDisplay.Text;

      if edtTo.Text = '' then
      begin
        frmRightAtasAir.addStatus('Send To Or Send Info is Blank, Please Fill The Recipient');
      end
      else
      if mmoDisplay.Text = '' then
      begin
        frmRightAtasAir.addStatus('Message is Blank, Please Write the Message');
      end
      else
      begin
        ToCub.DelimitedText := edtTo.Text;

        //Send Message -> Sync Message Send to Same Cubicle
        RecSendMessage.RecipientList := ToCub.DelimitedText;
        RecSendMessage.OrderID := 0;

        if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
          RecSendMessage.SendFrom := 0
        else if Assigned(simMgrClient.FMyCubGroup) then
          RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index
        else
          RecSendMessage.SendFrom := 0;

        if edtSubject.Text = '' then
          RecSendMessage.Subject := 'None'
        else
          RecSendMessage.Subject := edtSubject.Text;

        RecSendMessage.Priority := cbbPrior.ItemIndex;
        RecSendMessage.Band := cbbBand.ItemIndex;
        RecSendMessage.MessageHandling := MessageCub;

        RecSendMessage.Messagetype := 0;
        simMgrClient.netSend_MessageHandling(RecSendMessage);

        for i := 0 to ToCub.Count - 1 do
        begin
          RecSendMessage.Sendto := 0;

          if LowerCase(ToCub[i]) <> 'controller' then
          begin
            for j := 0 to simMgrClient.Scenario.CubiclesGroupsListFromDB.Count - 1 do
            begin
              grp := simMgrClient.Scenario.CubiclesGroupsListFromDB.Items[j] as T3CubicleGroup;
              if (grp <> nil) and (LowerCase(grp.FData.Group_Identifier) = LowerCase(ToCub[i])) then
              begin
                RecSendMessage.Sendto := grp.FData.Group_Index;
                Break;
              end;
            end;
          end;

          RecSendMessage.Messagetype := 2;
          simMgrClient.AddListQueueMessage(RecSendMessage);
        end;

        Close;
      end;
      {$ENDREGION}
    end;
    4:
    begin
      {$REGION ' General '}

      {$ENDREGION}
    end;
  else
    {$REGION ' Other Role '}
    MessageCub := mmoDisplay.Text;

    if edtTo.Text = '' then
    begin
      frmTacticalDisplay.addStatus('Send To Or Send Info is Blank, Please Fill The Recipient');
    end
    else
    if mmoDisplay.Text = '' then
    begin
      frmTacticalDisplay.addStatus('Message is Blank, Please Write the Message');
    end
    else
    begin
      ToCub.DelimitedText := edtTo.Text;

      //Send Message -> Sync Message Send to Same Cubicle
      RecSendMessage.RecipientList := ToCub.DelimitedText;
      RecSendMessage.OrderID := 0;

      if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
        RecSendMessage.SendFrom := 0
      else
        RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index;

      if edtSubject.Text = '' then
        RecSendMessage.Subject := 'None'
      else
        RecSendMessage.Subject := edtSubject.Text;
      RecSendMessage.Priority := cbbPrior.ItemIndex;
      RecSendMessage.Band := cbbBand.ItemIndex;
      RecSendMessage.MessageHandling := MessageCub;
      RecSendMessage.Messagetype := 0;
      simMgrClient.netSend_MessageHandling(RecSendMessage);

      //Add to Queue Message -> Send after time is ready
      for i := 0 to ToCub.Count - 1 do
      begin
        for j := 0 to simMgrClient.Scenario.CubiclesGroupsListFromDB.Count - 1 do
        begin
          grp := simMgrClient.Scenario.CubiclesGroupsListFromDB.Items[j] as T3CubicleGroup;

          if LowerCase(ToCub[i]) = 'controller' then
          begin
            RecSendMessage.Sendto := 0;
            Break;
          end
          else
          if grp <> nil then
          begin
            if LowerCase(grp.FData.Group_Identifier) = LowerCase(ToCub[i]) then
            begin
              RecSendMessage.Sendto := grp.FData.Group_Index;
              Break;
            end;
          end
          else
          begin
            RecSendMessage.Sendto := 0;
            Break;
          end;
        end;

        RecSendMessage.RecipientList := ToCub.DelimitedText;
        RecSendMessage.OrderID := 0;
        RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index;
        if edtSubject.Text = '' then
          RecSendMessage.Subject := 'None'
        else
          RecSendMessage.Subject := edtSubject.Text;
        RecSendMessage.Priority := cbbPrior.ItemIndex;
        RecSendMessage.Band := cbbBand.ItemIndex;
        RecSendMessage.MessageHandling := MessageCub;
        RecSendMessage.Messagetype := 2;
        simMgrClient.AddListQueueMessage(RecSendMessage);
      end;

      //Add to Queue Message -> Send after time is ready -> for controller
      RecSendMessage.RecipientList := ToCub.DelimitedText;
      RecSendMessage.OrderID := 0;

      if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
        RecSendMessage.SendFrom := 0
      else
        RecSendMessage.SendFrom := simMgrClient.FMyCubGroup.FData.Group_Index;

      if edtSubject.Text = '' then
        RecSendMessage.Subject := 'None'
      else
        RecSendMessage.Subject := edtSubject.Text;

      RecSendMessage.Priority := cbbPrior.ItemIndex;
      RecSendMessage.Band := cbbBand.ItemIndex;
      RecSendMessage.MessageHandling := MessageCub;
      RecSendMessage.Messagetype := 3;
      simMgrClient.AddListQueueMessage(RecSendMessage);

      Close;
    end;
    {$ENDREGION}
  end;
end;

procedure TfNewMessage.btnToClick(Sender: TObject);
begin
  if not Assigned(fSelectRecipient) then
      fSelectRecipient := TfSelectRecipient.Create(self);

  fSelectRecipient.ShowModal;
end;

procedure TfNewMessage.FormCreate(Sender: TObject);
begin
  ToCub := TStringList.Create;
  ToCub.Delimiter := ';';
  InfoCub := TStringList.Create;
  InfoCub.Delimiter := ';';

  edtInfo.Enabled := False;
  edtTo.Enabled := False;
end;

procedure TfNewMessage.FormShow(Sender: TObject);
begin
  if simMgrClient.ISInstructor or simMgrClient.ISWasdal then
  begin
    edtFrom.Text := 'Controller'
  end
  else if simMgrClient.ISWasdal then
    edtFrom.Text := 'Wasdal'
  else
  begin
    edtFrom.Text := simMgrClient.FMyCubGroup.FData.Group_Identifier;
  end;

  if isNew then
  begin
    edtInfo.Text := '';
    edtTo.Text := '';
    edtSubject.Text := '';
    mmoDisplay.Lines.Clear;

    cbbPrior.Text := cbbPrior.Items[0];
    cbbBand.Text := cbbBand.Items[0];
  end;
end;

end.
