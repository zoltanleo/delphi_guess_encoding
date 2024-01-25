unit uRecomList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmRecomList = class(TForm)
    re1: TRichEdit;
    Button1: TButton;
    oDlg: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  InitDir = 'c:\proj\test_delphi\delphi_recomlist\recom';
var
  frmRecomList: TfrmRecomList;

implementation

{$R *.dfm}

procedure TfrmRecomList.Button1Click(Sender: TObject);
const
  BuffSize = 10;
var
  buff: TBytes;
  preamble: TBytes;
  gpBuff: TBytes;
  ss: TStringStream;
  aEnc: TEncoding;
  kk: Integer;
begin
  kk:= -1;
  ss:= TStringStream.Create;
  try
  if oDlg.Execute then
    begin
  //    re1.Clear;
  //    if (ExtractFileExt(oDlg.FileName) = '.txt')
  //      then re1.Text:=
  //      else


//      SetLength(gpBuff,SizeOf(TEncoding.ANSI.GetPreamble));
//      gpBuff:= TEncoding.ANSI.GetPreamble;

      ss.LoadFromFile(oDlg.FileName);
      ss.Position:= 0;

      SetLength(buff,BuffSize);
      ss.ReadData(buff,Length(buff));
      aEnc:= nil;
      kk:= TEncoding.GetBufferEncoding(buff,aEnc);
//      preamble:= aEnc.GetPreamble;

      aEnc:= TEncoding.ANSI;
      case kk of
        2:
          begin
            if ((buff[0] = ord(#$FE)) and (buff[1] = ord(#$FF)))
              then aEnc:= TEncoding.BigEndianUnicode
              else aEnc:= TEncoding.Unicode;

          end;
        3:
          begin
            if ((buff[0] = ord(#$EF)) and (buff[1] = ord(#$BB)) and (buff[2] = ord(#$BF)))
              then aEnc:= TEncoding.UTF8;
          end;
        else

      end;

      re1.Clear;
      re1.Lines.LoadFromFile(oDlg.FileName);
//      re1.Lines.LoadFromFile(oDlg.FileName, aEnc);

    end;
  finally
    ss.Free;
  end;
//TEncoding.GetBufferEncoding return n char of TEncoding.GetPreamble
//ANSI 0
//UTF8 0
//UTF8 BOM 3
//UTF8 BE 2
//UTF8 LE 2

//ANSI: -
//ASCII: -
//BigEndianUnicode: UTF16 BE
//Default: -
//Unicode: UTF16 LE
//UTF7: -
//UTF8: EF BB BF (UTF8 BOM)
end;

procedure TfrmRecomList.FormCreate(Sender: TObject);
begin
  oDlg.Filter:= 'файлы с текстом(*.txt;*.doc;*.docx;*.rtf;*.odt)|*.txt;*.doc;*.docx;*.rtf;*.odt';
  oDlg.InitialDir:= InitDir;
end;

end.
