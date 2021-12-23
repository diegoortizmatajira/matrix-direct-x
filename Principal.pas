unit Principal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Menus, ImgList, ExtCtrls, DIB, DXClass, DXDraws, ExtDlgs,
  JPEG;

const
  Alto = 60;
  Ancho = 90;
  Delta = $FF div Alto;
type
  TCripto = record
   Columna: Array [1..Alto] of Char;
   Color: Array [1..Alto] of TColor;
   Cabeza: Byte;
   Destino: Byte;
  end;

  TMatrix = class
   iPulso: Record
               Activo: Boolean;
               X: Byte;
               Y: Byte;
               R: Byte;
              end;
   Contenido: Array[1..Ancho] of TCripto;
   Back: TPicture;
  public
    constructor Create;
    procedure ActualizaColumna(i: byte);
    procedure Avanza;
    procedure Pulso(X,Y: Byte);
    procedure ReloadInfo;
  end;

  TfrmMatrix = class(TForm)
    Timer: TDXTimer;
    PaintX: TDXDraw;
    Opendlg: TOpenPictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject; LagCount: Integer);
    procedure PaintXMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    w,h: Byte;
  public
    Matrix: TMatrix;
    procedure Enter_the_Matrix;
    procedure Dibuja;
  end;

var
  frmMatrix: TfrmMatrix;

implementation

{$R *.DFM}

function Genera_Criptograma: Char;
const
 i = 33;
begin
 Result:= Char(Random(255-i)+i);
end;

procedure TfrmMatrix.Enter_the_Matrix;
begin
 Matrix:= TMatrix.Create;
 h:= Canvas.TextHeight('W');
 w:= Canvas.TextWidth ('W') + 3;
 Timer.Enabled := true;
end;

procedure TfrmMatrix.FormCreate(Sender: TObject);
begin
 Randomize;
 Enter_the_Matrix;
end;

procedure TMatrix.ActualizaColumna(i: byte);
var
 j: byte;
begin
 Contenido[i].Color[Contenido[i].Cabeza]:= RGB(0,$FF,0);
 for j:= Contenido[i].Cabeza - 1 downto 1 do
 begin
  Contenido[i].Color[j]:= Contenido[i].Color[j+1] - TColor(RGB(0,Delta,0));
 end;
 for j:= Alto downto Contenido[i].Cabeza + 2 do
 begin
  Contenido[i].Color[j]:= Contenido[i].Color[j-1];
 end;
end;

procedure TMatrix.Avanza;
var
 i,P: byte;
begin
 for i:= 1 to Ancho do
 begin
  P:= Random(100);
  if P <= 90 then
  begin
   if Contenido[i].Cabeza < Contenido[i].Destino then
    inc(Contenido[i].Cabeza)
   else
   begin
    Contenido[i].Cabeza := random(Alto) + 1;
    Contenido[i].Destino := random(Alto) + 1;
   end;
   Contenido[i].Columna[Contenido[i].Cabeza]:= Genera_Criptograma;
   ActualizaColumna(i);
  end;
  if P < 5 then
  begin
   iPulso.Activo := iPulso.R < 50;
   if iPulso.Activo then
    inc(iPulso.R);
  end;
 end;

end;

constructor TMatrix.Create;
var
 i, j: byte;
begin
 iPulso.Activo := false;
 for i:= 1 to Ancho do
 begin
  for j:= 1 to Alto do
  begin
   Contenido[i].Columna[j]:= Genera_Criptograma;
   Contenido[i].Color[j]:= clBlack;
  end;
  Contenido[i].Cabeza := random(Alto) + 1;
  ActualizaColumna(i);
 end;
end;

procedure TMatrix.Pulso(X,Y: Byte);
begin
 iPulso.Activo := True;
 iPulso.X:= X;
 iPulso.Y:= Y;
 iPulso.R:= 0;
end;

procedure TMatrix.ReloadInfo;
begin
 if frmMatrix.Opendlg.Execute then
 begin
  if Back = nil then
   Back:= TPicture.Create;
  Back.LoadFromFile(frmMatrix.Opendlg.Filename);
 end;
end;

procedure TfrmMatrix.FormClick(Sender: TObject);
begin
 Timer.Enabled := not Timer.Enabled;
end;

procedure TfrmMatrix.Dibuja;
var
 i,j: byte;
 xp, yp, ang: ShortInt;
const
 DelAng = 36;
begin
 If not PaintX.CanDraw then
  Exit;
 With PaintX.Surface do
 begin
  Fill(0);
  Canvas.CopyMode := cmSrcAnd;
  Canvas.Font := Self.Font;
  Canvas.brush.Color := clBlack;
  Canvas.FillRect(Rect(0,0,PaintX.Width,PaintX.Height));
  for i:= 0 to Ancho-1 do
   for j:= 0 to Alto-1 do
   begin
    if j+1 = Matrix.Contenido[i+1].Cabeza then
     Canvas.Font.Color := RGB(160,255,160)
    else
     Canvas.Font.Color := Matrix.Contenido[i+1].Color[j+1];
    Canvas.TextOut(i*w,j*h,Matrix.Contenido[i+1].Columna[j+1]);
   end;
  if Matrix.iPulso.Activo then
   with Matrix.iPulso do
   for i:= R-2 to R+2 do
    for ang:= 1 to 2*DelAng do
    begin
     Xp:= X + trunc(i*Cos(ang*3.1416/DelAng)) - 1;
     Yp:= Y + trunc(i*Sin(ang*3.1416/DelAng)) - 1;
     Canvas.Font.Color := RGB(80,255,80); //clLime;
     if (Xp >= 0)and(Xp < Ancho)and(Yp >= 0)and(Yp < Alto) then
     begin
      Matrix.Contenido[Xp+1].Columna[Yp+1]:= Genera_Criptograma;
      Canvas.TextOut(Xp*w,Yp*h,Matrix.Contenido[Xp+1].Columna[Yp+1]);
     end
     else
      Activo := False;
    end;
  if Matrix.Back <> nil then
   Canvas.StretchDraw(Rect(0,0,PaintX.Width,PaintX.Height),Matrix.Back.Graphic);
  Canvas.Release;
 end;
 PaintX.Flip;
end;

procedure TfrmMatrix.TimerTimer(Sender: TObject; LagCount: Integer);
begin
 Matrix.Avanza;
 Dibuja;
end;

procedure TfrmMatrix.PaintXMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 case Button of
  mbLeft:  Matrix.Pulso(X div w, Y div h);
  mbRight: Matrix.ReloadInfo;
 end;
end;

end.
