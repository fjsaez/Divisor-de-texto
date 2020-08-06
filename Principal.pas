unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Graphics, RzStatus, RzPanel, PngSpeedButton, System.ImageList, Vcl.ImgList;

type
  TFPrinc = class(TForm)
    PanelTBar: TPanel;
    PanelOrig: TPanel;
    PanelResult: TPanel;
    MmOrig: TMemo;
    MmResult: TMemo;
    ODialog: TOpenDialog;
    ECaracter: TEdit;
    Label1: TLabel;
    SDialog: TSaveDialog;
    RzStatusBar1: TRzStatusBar;
    StPane: TRzStatusPane;
    PrgStatus: TRzProgressStatus;
    SBAbrir: TPngSpeedButton;
    SBProc: TPngSpeedButton;
    SBGuardar: TPngSpeedButton;
    SBSalir: TPngSpeedButton;
    RzStatusPane1: TRzStatusPane;
    Panel1: TPanel;
    LOrigen: TLabel;
    Panel2: TPanel;
    LResult: TLabel;
    SPaneAcerca: TRzStatusPane;
    BalloonHint: TBalloonHint;
    ImageList1: TImageList;
    procedure SBSalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SBAbrirClick(Sender: TObject);
    procedure ECaracterChange(Sender: TObject);
    procedure SBProcClick(Sender: TObject);
    procedure MmResultChange(Sender: TObject);
    procedure SBGuardarClick(Sender: TObject);
    procedure SPaneAcercaClick(Sender: TObject);
    procedure SPaneAcercaMouseEnter(Sender: TObject);
    procedure SPaneAcercaMouseLeave(Sender: TObject);
    procedure LOrigenMouseEnter(Sender: TObject);
  private
    { Private declarations }
    procedure ValInicio;
  public
    { Public declarations }
  end;

const
  ColorMmConTexto=$FDF0E3;
  ColorMmSinTexto=$FFFFFF;
  ColorSBarActivo=$FFFFFF;
  ColorSBarInactv=$94FFD1;

var
  FPrinc: TFPrinc;

implementation

{$R *.dfm}

uses Acerca;

function ExtraerNombreArchivo(const Arch: string): string;
var
  I: Integer;
begin
  I:=LastDelimiter('\',Arch);
  Result:=Copy(Arch,I+1,Length(Arch)-I);
end;

procedure TFPrinc.ValInicio;
begin
  MmOrig.Clear;
  MmResult.Clear;
  LOrigen.Caption:='';
  LResult.Caption:='';
  SBProc.Enabled:=false;
  SBGuardar.Enabled:=false;
  PrgStatus.TotalParts:=0;
  PrgStatus.PartsComplete:=0;
  PrgStatus.Color:=ColorSBarInactv;
  StPane.Caption:='';
  StPane.Color:=ColorSBarInactv;
end;

procedure TFPrinc.ECaracterChange(Sender: TObject);
begin
  SBProc.Enabled:=(ECaracter.Text<>'') and (Trim(MmOrig.Text)<>'');
end;

procedure TFPrinc.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  ValInicio;
end;

procedure TFPrinc.LOrigenMouseEnter(Sender: TObject);
begin
  TLabel(Sender).ShowHint:=TLabel(Sender).Caption<>'';
  TLabel(Sender).Hint:=TLabel(Sender).Caption;
  BalloonHint.ImageIndex:=0;
  BalloonHint.Title:='Atención';
  BalloonHint.Description:=TLabel(Sender).Caption;
  //BalloonHint.ShowHint;
end;

procedure TFPrinc.MmResultChange(Sender: TObject);
begin
  SBGuardar.Enabled:=MmResult.Text<>'';
end;

procedure TFPrinc.SPaneAcercaClick(Sender: TObject);
begin
  with TFAcerca.Create(Application) do
    try
      BorderIcons:=[biSystemMenu];
      BorderStyle:=bsSingle;
      Position:=poScreenCenter;
      ShowModal;
    finally Free
    end;
end;

procedure TFPrinc.SPaneAcercaMouseEnter(Sender: TObject);
begin
  SPaneAcerca.Color:=$FF2001;
  SPaneAcerca.Font.Color:=$FFFFFF;
  SPaneAcerca.Font.Style:=[fsBold];
end;

procedure TFPrinc.SPaneAcercaMouseLeave(Sender: TObject);
begin
  SPaneAcerca.Color:=$FFFFFF;
  SPaneAcerca.Font.Color:=$000000;
  SPaneAcerca.Font.Style:=[];
end;

// ** botones ** //

procedure TFPrinc.SBAbrirClick(Sender: TObject);
begin
  if ODialog.Execute then
  begin
    ValInicio;
    MmOrig.Lines.LoadFromFile(ODialog.FileName);
    LOrigen.Caption:=' Archivo origen: '+ODialog.FileName;
    MmOrig.Color:=ColorMmConTexto;
    MmResult.Clear;
    MmResult.Color:=ColorMmSinTexto;
    StPane.Caption:=' Total caracteres: '+Length(MmOrig.Text).ToString;
    StPane.Color:=ColorSBarActivo;
  end;
end;

procedure TFPrinc.SBGuardarClick(Sender: TObject);
begin
  SDialog.FileName:=ExtraerNombreArchivo(ODialog.FileName);
  if SDialog.Execute then
  begin
    MmResult.Lines.SaveToFile(SDialog.FileName);
    LResult.Caption:=' Archivo destino: '+SDialog.FileName;
    ShowMessage('El archivo "'+SDialog.FileName+'" fue creado exitosamente');
  end;
end;

procedure TFPrinc.SBProcClick(Sender: TObject);
const
  Salto=#13#10;
var
  I: integer;
  Cadena,Caracter: string;
begin
  MmResult.Clear;
  Cadena:='';
  PrgStatus.Color:=ColorSBarActivo;
  PrgStatus.TotalParts:=Length(MmOrig.Text);
  for I:=1 to Length(MmOrig.Text) do
  begin
    Caracter:=Copy(MmOrig.Text,I,1);
    if Caracter<>ECaracter.Text then Cadena:=Cadena+Caracter
    else
      if Copy(MmOrig.Text,I+1,2)<>Salto then Cadena:=Cadena+Caracter+Salto
                                        else Cadena:=Cadena+Caracter;
    PrgStatus.PartsComplete:=I;
  end;
  MmResult.Color:=ColorMmConTexto;
  MmResult.Text:=Cadena;
end;

procedure TFPrinc.SBSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
