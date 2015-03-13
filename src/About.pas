{ $Id: About.pas,v 1.3 2005/03/24 05:08:32 judison Exp $ }

unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmAbout = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblCopyright: TLabel;
    memoGPL: TMemo;
    memoAuthors: TMemo;
    TabSheet4: TTabSheet;
    memoThanks: TMemo;
    TabSheet5: TTabSheet;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

end.
