object frmMatrix: TfrmMatrix
  Left = 265
  Top = 128
  BorderStyle = bsNone
  Caption = 'frmMatrix'
  ClientHeight = 394
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Courier New'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClick = FormClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PaintX: TDXDraw
    Left = 0
    Top = 0
    Width = 492
    Height = 394
    AutoInitialize = True
    AutoSize = True
    Color = clBtnFace
    Display.BitCount = 16
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Display.Height = 600
    Display.Width = 800
    Options = [doAllowReboot, doWaitVBlank, doCenter, doRetainedMode, doHardware, doSelectDriver]
    SurfaceHeight = 394
    SurfaceWidth = 492
    Align = alClient
    TabOrder = 0
    OnMouseDown = PaintXMouseDown
  end
  object Timer: TDXTimer
    ActiveOnly = True
    Enabled = True
    Interval = 0
    OnTimer = TimerTimer
    Left = 16
    Top = 80
  end
  object Opendlg: TOpenPictureDialog
    Filter = 
      'All (*.dib;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.dib;*.jpg;*.j' +
      'peg;*.bmp;*.ico;*.emf;*.wmf|Device Independent Bitmap (*.dib)|*.' +
      'dib|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpe' +
      'g|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles '
    Left = 16
    Top = 32
  end
end
