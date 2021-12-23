program Enter;

uses
  Forms,
  Principal in 'Principal.pas' {frmMatrix};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMatrix, frmMatrix);
  Application.Run;
end.
