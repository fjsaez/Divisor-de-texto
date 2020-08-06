program DivisorTexto;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FPrinc},
  Acerca in 'Acerca.pas' {FAcerca};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Divisor de archivos de texto';
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
