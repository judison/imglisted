unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, ActnList, ToolWin, Menus, ExtDlgs, ExtCtrls, StdCtrls, AppEvnts;

type
  TFrmMain = class(TForm)
    ImageList: TImageList;
    ListView: TListView;
    ToolBar1: TToolBar;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    ActnList: TActionList;
    ImageListToolBar: TImageList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    Sep1: TToolButton;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    actExit: TAction;
    Exit1: TMenuItem;
    OpenDialog: TOpenPictureDialog;
    SaveDialog: TSavePictureDialog;
    Edit1: TMenuItem;
    actInsert: TAction;
    actRemove: TAction;
    btnInsert: TToolButton;
    btnRemove: TToolButton;
    Insert1: TMenuItem;
    Remove1: TMenuItem;
    Sep2: TToolButton;
    PopupMenu: TPopupMenu;
    Remove2: TMenuItem;
    pnlImageEdit: TPanel;
    actPaintSave: TAction;
    actPaintCancel: TAction;
    PanelEdit: TPanel;
    ImageEdit: TImage;
    Panel2: TPanel;
    ToolBar2: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    Splitter1: TSplitter;
    actSaveAs: TAction;
    SaveAs1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    PnlCurColor: TPanel;
    ColorDialog: TColorDialog;
    procedure actOpenExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actRemoveExecute(Sender: TObject);
    procedure ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure actRemoveUpdate(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure ImageEditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelEditResize(Sender: TObject);
    procedure pnlImageEditResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actPaintSaveUpdate(Sender: TObject);
    procedure actPaintCancelUpdate(Sender: TObject);
    procedure actPaintSaveExecute(Sender: TObject);
    procedure actPaintCancelExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure ActnListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure About1Click(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PnlCurColorClick(Sender: TObject);
  private
    EdMod: Boolean;
    CurFileName: string;
    Modified: Boolean;
    procedure DrawPoint;
    procedure GetColor;
    procedure OpenFile(FN: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses About;

{$R *.DFM}

procedure TFrmMain.OpenFile(FN: string);
var
  Img: TBitmap;
  I: Integer;
begin
  //
  CurFileName := FN;
  //
  ListView.Items.Clear;
  ImageList.Clear;
  //
  Img := TBitmap.Create;
  try
  Img.LoadFromFile(CurFileName);
  ImageList.AddMasked(Img, clFuchsia);
  finally
  Img.Free;
  end;
  //
  for I := 0 to ImageList.Count - 1 do
    with ListView.Items.Add do
    begin
      ImageIndex := I;
      Caption := Format('%.3d', [I]);
    end;
  Modified := False;
  EdMod := False;
end;

procedure TFrmMain.actOpenExecute(Sender: TObject);
begin
  OpenDialog.Title := 'Open ImageList';
  if OpenDialog.Execute then
    OpenFile(OpenDialog.FileName);
end;

procedure TFrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.actNewExecute(Sender: TObject);
begin
  ImageList.Clear;
  ListView.Items.Clear;
  //
  EdMod := False;
  Modified := False;
  CurFileName := '';
end;

procedure TFrmMain.actSaveAsExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    CurFileName := SaveDialog.FileName;
    actSave.Execute;
  end;
end;

procedure TFrmMain.actSaveExecute(Sender: TObject);
var
  Img: TBitmap;
  I: Integer;
begin
  if CurFileName = '' then
    actSaveAs.Execute
  else
  begin
    Img := TBitmap.Create;
    try
      Img.Width := ImageList.Count * 16;
      Img.Height := 16;
      Img.Canvas.Brush.Color := clFuchsia;
      Img.Canvas.FillRect(Rect(0, 0, Img.Width, img.Height));
      //
      for I := 0 to ImageList.Count - 1 do
        ImageList.Draw(Img.Canvas, I * 16, 0, I);
      //
      Img.SaveToFile(CurFileName);
      Modified := False;
    finally
      Img.Free;
    end;
  end;
end;

procedure TFrmMain.actInsertExecute(Sender: TObject);
var
  Img: TBitmap;
  CC: Integer;
  I: Integer;
begin
//
  OpenDialog.Title := 'Insert Image(s)';
  if OpenDialog.Execute then
  begin
    //
    CC := ImageList.Count;
    Img := TBitmap.Create;
    Img.LoadFromFile(OpenDialog.FileName);
    ImageList.AddMasked(Img, clFuchsia);
    Img.Free;
    //
    for I := CC to ImageList.Count - 1 do
      with ListView.Items.Add do
      begin
        ImageIndex := I;
        Caption := Format('%.3d', [I])
      end;
    Modified := True;
  end;
end;

procedure TFrmMain.actRemoveExecute(Sender: TObject);
begin
//
  if ListView.Selected <> nil then
  begin
    ImageList.Delete(ListView.Selected.Index);
    ListView.Items.Delete(ListView.Items.Count - 1);
    Modified := True;
  end;
end;

procedure TFrmMain.ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if ListView.GetItemAt(X, Y) <> nil then
  begin
    ImageList.Move(ListView.Selected.Index, ListView.GetItemAt(X, Y).Index);
    Modified := True;
  end;
end;

procedure TFrmMain.ListViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListView;
end;

procedure TFrmMain.actRemoveUpdate(Sender: TObject);
begin
  actRemove.Enabled := ListView.SelCount > 0;
end;

procedure TFrmMain.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  bmp: TBitmap;
begin
  //
  if ImageEdit.Picture.Bitmap = nil then
    ImageEdit.Picture.Bitmap := TBitmap.Create;

  bmp := ImageEdit.Picture.Bitmap;
  ImageEdit.Visible := ListView.Selected <> nil;
  if ListView.Selected <> nil then
  begin
    bmp.Canvas.Brush.Color := clFuchsia;
    bmp.Canvas.FillRect(Rect(0, 0, 16, 16));
    ImageList.Draw(bmp.Canvas, 0, 0, ListView.Selected.Index);
  end;
  EdMod := False;
end;

procedure TFrmMain.DrawPoint;
var
  RPos: TPoint;
  F: Integer;
begin
  F := ImageEdit.Width div 16;
  RPos := ImageEdit.ScreenToClient(Mouse.CursorPos);
  ImageEdit.Canvas.Pixels[RPos.X div F, RPos.Y div F] := ColorDialog.Color;
  EdMod := True;
end;

procedure TFrmMain.GetColor;
var
  RPos: TPoint;
  F: Integer;
begin
  F := ImageEdit.Width div 16;
  RPos := ImageEdit.ScreenToClient(Mouse.CursorPos);
  ColorDialog.Color := ImageEdit.Canvas.Pixels[RPos.X div F, RPos.Y div F];
  PnlCurColor.Color := ColorDialog.Color;
end;

procedure TFrmMain.ImageEditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//
  if Button = mbLeft then
    DrawPoint
  else if Button = mbRight then
    GetColor;
end;

procedure TFrmMain.ImageEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    DrawPoint;
end;

procedure TFrmMain.ImageEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DrawPoint;
end;

procedure TFrmMain.PanelEditResize(Sender: TObject);
begin
  //
  PanelEdit.Height := PanelEdit.Width;
end;

procedure TFrmMain.pnlImageEditResize(Sender: TObject);
begin
  pnlImageEdit.Width := pnlImageEdit.Width - ((pnlImageEdit.Width - 13) mod 16);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  EdMod := False;
  Modified := False;
  CurFileName := '';
  if FileExists(ParamStr(1)) then
    OpenFile(ParamStr(1));
end;

procedure TFrmMain.actPaintSaveUpdate(Sender: TObject);
begin
  actPaintSave.Enabled := EdMod;
end;

procedure TFrmMain.actPaintCancelUpdate(Sender: TObject);
begin
  actPaintCancel.Enabled := EdMod;
end;

procedure TFrmMain.actPaintSaveExecute(Sender: TObject);
begin
  ImageList.ReplaceMasked(ListView.Selected.Index, ImageEdit.Picture.Bitmap, clFuchsia);
  Modified := True;
end;

procedure TFrmMain.actPaintCancelExecute(Sender: TObject);
begin
  ListViewChange(nil, nil, ctText);
end;

procedure TFrmMain.ActnListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actSave.Enabled := Modified and (ImageList.Count > 0);
  actSaveAs.Enabled := (ImageList.Count > 0);
  if CurFileName = '' then
    Caption := 'ImageList Editor'
  else
    Caption := 'ImageList Editor - ' + CurFileName;
  if Modified then
    StatusBar.Panels[1].Text := 'Modified'
  else
    StatusBar.Panels[1].Text := '';

end;

procedure TFrmMain.About1Click(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TFrmMain.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[2].Text := GetLongHint(Application.Hint);
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  res: word;
begin
  if Modified then
  begin
    Res := MessageDlg('The current file has been modified.' + #13#10 + 'Do you want to save the file before closing it?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if Res = mrYes then
      actSave.Execute
    else if Res <> mrNo then
      CanClose := False;
  end;
end;

procedure TFrmMain.PnlCurColorClick(Sender: TObject);
begin
  ColorDialog.Execute;
  PnlCurColor.Color := ColorDialog.Color;
end;

end.

