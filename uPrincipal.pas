unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Types, System.IOUtils, System.StrUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.RegularExpressions;

type
  TEtiquetas = (CTeEntrada, CTeSaida, NFeEntrada, NFeSaida, NFSeEntrada, NFSeSaida, ValidaManual, Problemas, Duplicados, Encontrados, Progresso, Desnecessarios);
  TXMLContador = array[TEtiquetas] of Integer;
  TfrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    edtCNPJ: TEdit;
    edtCaminhoPasta: TEdit;
    lblCNPJ: TLabel;
    lblDefinePasta: TLabel;
    lblDica: TLabel;
    lblNFeEntrada: TLabel;
    lblNFeSaida: TLabel;
    lblCTeEntrada: TLabel;
    lblCTeSaida: TLabel;
    lblDuplicados: TLabel;
    lblEncontrados: TLabel;
    lblProblemas: TLabel;
    lblValidaManual: TLabel;
    btnCaminhoPasta: TBitBtn;
    pnlRodape: TPanel;
    pbrProgresso: TProgressBar;
    lblNFSeEntrada: TLabel;
    lblNFSeSaida: TLabel;
    lblCTeDesnecessario: TLabel;
    procedure btnCaminhoPastaClick(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function DevolveSoNumeros(const argText: string): string;
    function VerTipoXML(const argCNPJ, argArquivoXML: string): string;
    function ValidaCNPJ(num: string): boolean;
    function MoveArquivoUnico(const argNomeArquivo, argPastaDestino: string): Integer;
    function VerificaCNPJ(const argCNPJ, argTipoOriDes, argArquivoXML:string ; const argIdCNPJ: string = '<CNPJ>'): Boolean;
    procedure AtualizaEtiquetas(const argValores: TXMLContador);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.AtualizaEtiquetas(const argValores: TXMLContador);
begin
  lblNFeEntrada.Caption := 'NFe Entrada: ' + IntToStr(argValores[NFeEntrada]);
  lblNFeSaida.Caption := 'NFe Saída: ' + IntToStr(argValores[NFeSaida]);
  lblNFSeEntrada.Caption := 'NFSe Entrada: ' + IntToStr(argValores[NFSeEntrada]);
  lblNFSeSaida.Caption := 'NFSe Saída: ' + IntToStr(argValores[NFSeSaida]);
  lblCTeEntrada.Caption := 'CTe Entrada: ' + IntToStr(argValores[CTeEntrada]);
  lblCTeSaida.Caption := 'CTe Saída: ' + IntToStr(argValores[CTeSaida]);
  lblProblemas.Caption := 'Problemas: ' + IntToStr(argValores[Problemas]);
  lblValidaManual.Caption := 'Validar Manual: ' + IntToStr(argValores[ValidaManual]);
  lblDuplicados.Caption := 'Duplicados: ' + IntToStr(argValores[Duplicados]);
  lblEncontrados.Caption := 'Arquivos Encontrados: ' + IntToStr(argValores[Encontrados]);
  lblCTeDesnecessario.Caption := 'CTe Desnecessários: ' + IntToStr(argValores[Desnecessarios]);
  pbrProgresso.Position := argValores[Progresso];
end;

procedure TfrmPrincipal.btnCaminhoPastaClick(Sender: TObject);
var
  objPastaPesquisa: TFileOpenDialog;
  objArquivosXML: TStringDynArray;
  varPastaPesquisa, varArquivoXML, varCNPJ, varRetornoXML, varTipoXML: string;
  i, varTesteMoveArquivo: Integer;
  varArrayContador: TXMLContador;
begin
  // Inicializa Contadores
  varArrayContador[CTeEntrada] := 0;
  varArrayContador[CTeSaida] := 0;
  varArrayContador[NFeEntrada] := 0;
  varArrayContador[NFeSaida] := 0;
  varArrayContador[NFSeEntrada] := 0;
  varArrayContador[NFSeSaida] := 0;
  varArrayContador[ValidaManual] := 0;
  varArrayContador[Problemas] := 0;
  varArrayContador[Duplicados] := 0;
  varArrayContador[Encontrados] := 0;
  varArrayContador[Progresso] := 0;
  varArrayContador[Progresso] := 0;
  // Inicializa Etiquetas
  AtualizaEtiquetas(varArrayContador);
  // Define a pasta e o CNPJ a ser pesquisado
  varCNPJ := DevolveSoNumeros(edtCNPJ.Text);
  objPastaPesquisa := TFileOpenDialog.Create(nil);
  try
    objPastaPesquisa.Options := [fdoPickFolders];
    if objPastaPesquisa.Execute then
    begin
      edtCaminhoPasta.Text := objPastaPesquisa.FileName;
      varPastaPesquisa := IncludeTrailingPathDelimiter(objPastaPesquisa.FileName);
      objArquivosXML := TDirectory.GetFiles(objPastaPesquisa.Filename, '*.xml');
      varArrayContador[Encontrados] := Length(objArquivosXML);
      pbrProgresso.Max := varArrayContador[Encontrados];
      AtualizaEtiquetas(varArrayContador);
      Application.ProcessMessages;
      if pbrProgresso.Max > 0 then
      begin
        for i := 0 to High(objArquivosXML) do
        begin
          varArquivoXML := objArquivosXML[i];
          varRetornoXML := VerTipoXML(varCNPJ, varArquivoXML);
          if varRetornoXML = 'Problema' then
            varTipoXML :=  varRetornoXML
          else
            varTipoXML := System.Copy(varRetornoXML, Length(varRetornoXML) - System.StrUtils.PosEx('\', System.StrUtils.ReverseString(varRetornoXML)) + 2, MaxInt);
          // Atualiza Contadores
          varArrayContador[Progresso] := i + 1;
          if varTipoXML = 'CTe-ENTRADA' then
            Inc(varArrayContador[CTeEntrada]);
          if varTipoXML = 'CTe-SAIDA' then
            Inc(varArrayContador[CTeSaida]);
          if varTipoXML = 'CTe-REMETIDO' then
            Inc(varArrayContador[CTeEntrada]);
          if varTipoXML = 'CTe-EXPEDIDO' then
            Inc(varArrayContador[Desnecessarios]);
          if varTipoXML = 'NFe-ENTRADA' then
            Inc(varArrayContador[NFeEntrada]);
          if varTipoXML = 'NFe-SAIDA' then
            Inc(varArrayContador[NFeSaida]);
          if varTipoXML = 'NFSe-ENTRADA' then
            Inc(varArrayContador[NFSeEntrada]);
          if varTipoXML = 'NFSe-SAIDA' then
            Inc(varArrayContador[NFSeSaida]);
          if varTipoXML = '_XML-VALIDAR' then
            Inc(varArrayContador[ValidaManual]);
          if varTipoXML = 'Problema' then
            Inc(varArrayContador[Problemas]);
          if varTipoXML = 'ERRO' then
            ShowMessage('Um erro indeterminado ocorreu!');
          if (varRetornoXML = 'noCNPJ') OR (varRetornoXML = 'ERRO') then
            Inc(varArrayContador[Problemas])
          else if (varTipoXML <> '') OR (varTipoXML <> 'ERRO')  then
          begin
            ForceDirectories(varPastaPesquisa + varRetornoXML + '\');
            varTesteMoveArquivo := MoveArquivoUnico(varArquivoXML, varPastaPesquisa + varRetornoXML + '\');
            if varTesteMoveArquivo = 1 then
              Inc(varArrayContador[Duplicados]);
            if varTesteMoveArquivo = 2 then
              ShowMessage('O arquivo: ' + sLineBreak + varArquivoXML + sLineBreak + ' não pode ser movido!');
          end;
          AtualizaEtiquetas(varArrayContador);
          Application.ProcessMessages;
        end;
      end;
    end;
  finally
    objPastaPesquisa.Free;
  end;
  // ShowMessage('Processamento Concluído!');
  edtCNPJ.SetFocus;
end;

procedure TfrmPrincipal.edtCNPJExit(Sender: TObject);
var
  FormatarCNPJ: string;
  vDoctoCNPJ: string;
begin
  edtCaminhoPasta.Enabled := FALSE;
  if Length(edtCNPJ.Text) <> 0 then
      vDoctoCNPJ := DevolveSoNumeros(edtCNPJ.Text);
      if Length(vDoctoCNPJ) = 14 then
        Begin
           if ValidaCNPJ(vDoctoCNPJ) = True Then
             Begin
                FormatarCNPJ:= Copy(vDoctoCNPJ,  1,2)
                       + '.' + Copy(vDoctoCNPJ,  3,3)
                       + '.' + Copy(vDoctoCNPJ,  6,3)
                       + '/' + Copy(vDoctoCNPJ,  9,4)
                       + '-' + Copy(vDoctoCNPJ, 13,2);
                edtCNPJ.Text:= FormatarCNPJ;
                btnCaminhoPasta.Enabled := TRUE;
                edtCaminhoPasta.Enabled := FALSE;
             End
           Else
             begin
                 ShowMessage('CNPJ com erro. favor verificar');
                 edtCNPJ.SetFocus;
             end;
        End
  else
    begin
      ShowMessage('CNPJ com erro. favor verificar');
      edtCNPJ.SetFocus;
    end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  edtCNPJ.SetFocus;
  btnCaminhoPasta.Enabled := TRUE;
end;

function TfrmPrincipal.MoveArquivoUnico(const argNomeArquivo, argPastaDestino: string): Integer;
var
  NovoNome, NomeArquivo, ExtArquivo, CaminhoDestino: string;
  i: Integer;
begin
  Result := 0;
  NomeArquivo := ExtractFileName(argNomeArquivo);
  ExtArquivo := ExtractFileExt(NomeArquivo);
  CaminhoDestino := IncludeTrailingPathDelimiter(argPastaDestino);
  NovoNome := NomeArquivo;
  i := 0;
  while FileExists(CaminhoDestino + NovoNome) do
  begin
    Inc(i);
    NovoNome := Format('%s (%d)%s', [Copy(NomeArquivo, 1, Length(NomeArquivo) - Length(ExtArquivo)), i, ExtArquivo]);
  end;
  try
    if not DirectoryExists(CaminhoDestino) then
      ForceDirectories(CaminhoDestino);
    if not MoveFile(PChar(argNomeArquivo), PChar(CaminhoDestino + NovoNome)) then
      Result := 2
    else if i > 0 then
      Result := 1
    else
      Result := 0;
  except
    Result := 2;
  end;
end;

function TfrmPrincipal.DevolveSoNumeros(const argText: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(argText) do
  begin
    if CharInSet(argText[I], ['0'..'9']) then
      Result := Result + argText[I];
  end;
end;

function TfrmPrincipal.ValidaCNPJ(num: string): boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  n1:=StrToInt(num[1]);
  n2:=StrToInt(num[2]);
  n3:=StrToInt(num[3]);
  n4:=StrToInt(num[4]);
  n5:=StrToInt(num[5]);
  n6:=StrToInt(num[6]);
  n7:=StrToInt(num[7]);
  n8:=StrToInt(num[8]);
  n9:=StrToInt(num[9]);
  n10:=StrToInt(num[10]);
  n11:=StrToInt(num[11]);
  n12:=StrToInt(num[12]);
  d1:=n12*2+n11*3+n10*4+n9*5+n8*6+n7*7+n6*8+n5*9+n4*2+n3*3+n2*4+n1*5;
  d1:=11-(d1 mod 11);
  if d1>=10 then d1:=0;
  d2:=d1*2+n12*3+n11*4+n10*5+n9*6+n8*7+n7*8+n6*9+n5*2+n4*3+n3*4+n2*5+n1*6;
  d2:=11-(d2 mod 11);
  if d2>=10 then d2:=0;
  calculado:=inttostr(d1)+inttostr(d2);
  digitado:=num[13]+num[14];
  if calculado=digitado then
    ValidaCNPJ:=true
  else
    ValidaCNPJ:=false;
end;

function TfrmPrincipal.VerificaCNPJ(const argCNPJ, argTipoOriDes, argArquivoXML:string ; const argIdCNPJ: string = '<CNPJ>'): Boolean;
var
  varPosOriDes, varPosCNPJ: integer;
  varCNPJ: string;
begin
  varPosOriDes := Pos(argTipoOriDes, argArquivoXML);
  Result := FALSE;
  if varPosOriDes > 0 then
  begin
    varPosCNPJ := Pos(argIdCNPJ, argArquivoXML, varPosOriDes);
    if varPosCNPJ > 0 then
    begin
      if argIdCNPJ = 'chNFe' then
      begin
        if Pos(argCNPJ, argArquivoXML) > 0 then
           Result := TRUE
        else
           Result := FALSE;
      end
      else
      begin
      varCNPJ := Copy(argArquivoXML, varPosCNPJ + 6, 14);
      if varCNPJ = DevolveSoNumeros(argCNPJ) then
         Result := TRUE
      else
         Result := FALSE;
      end;
    end;
  end;
end;

function TfrmPrincipal.VerTipoXML(const argCNPJ, argArquivoXML: string): string;
var
  varXML: TStringList;
  varTipoDocto, varTipoOriDes, varTipoData, varCNPJ, varData: String;
  varPosCNPJ, varPosOriDes: Integer;
begin
  Result := '';
  varXML := TStringList.Create;
  if FileExists(argArquivoXML) then
  begin
    try
     varXML.LoadFromFile(argArquivoXML);

      // Verifica o tipo de documento
      // Verifica se é NFSe
      if (Pos('<NFe>', varXML.Text) > 0) AND (Pos('<DataEmissaoNFe>', varXML.Text) > 0) then
      begin
        varTipoDocto := 'NFSe';
        varTipoData := '<DataEmissaoNFe>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if VerificaCNPJ(argCNPJ, '<CPFCNPJPrestador>', varXML.Text) then
           varTipoOriDes := '-SAIDA'
        else if VerificaCNPJ(argCNPJ, '<CPFCNPJTomador>', varXML.Text) then
          varTipoOriDes := '-ENTRADA';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
      // Verifica se é NFe
      if (Pos('<NFe', varXML.Text) > 0) AND (Pos('<dhEmi>', varXML.Text) > 0) then
      begin
        varTipoDocto := 'NFe';
        varTipoData := '<dhEmi>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if VerificaCNPJ(argCNPJ, '<emit>', varXML.Text) then
           varTipoOriDes := '-SAIDA'
        else if VerificaCNPJ(argCNPJ, '<dest>', varXML.Text) then
          varTipoOriDes := '-ENTRADA';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
      // Verifica se é CTe
      if (Pos('<CTe', varXML.Text) > 0) AND (Pos('<dhEmi>', varXML.Text) > 0) then
      begin
        varTipoDocto := 'CTe';
        varTipoData := '<dhEmi>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if VerificaCNPJ(argCNPJ, '<emit>', varXML.Text) then
           varTipoOriDes := '-SAIDA'
        else if VerificaCNPJ(argCNPJ, '<dest>', varXML.Text) then
          varTipoOriDes := '-ENTRADA'
        else if VerificaCNPJ(argCNPJ, '<rem>', varXML.Text) then
          varTipoOriDes := '-ENTRADA'
        else if VerificaCNPJ(argCNPJ, '<exped>', varXML.Text) then
          varTipoOriDes := '-EXPEDIDO';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
      // Verifica se é ProcEventoNFe
      if ((Pos('<procEventoNFe', varXML.Text) > 0) AND (Pos('<dhEvento>', varXML.Text) > 0)) OR
         ((Pos('<procEventoNFe', varXML.Text) > 0) AND (Pos('<dhRegEvento>', varXML.Text) > 0)) then
      begin
        varTipoDocto := '_XML';
        varTipoData := '<dhEvento>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if NOT (TRegEx.IsMatch(varData, '^\d{4}-\d{2}$')) then
         begin
           varTipoData := '<dhRegEvento>';
           varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
         end;
        if VerificaCNPJ(argCNPJ, '<infEvento', varXML.Text) then
          varTipoOriDes := '-VALIDAR'
        else if VerificaCNPJ(argCNPJ, '<retEvento', varXML.Text) then
          varTipoOriDes := '-VALIDAR'
        else if VerificaCNPJ(argCNPJ, '<dhRegEvento>', varXML.Text, 'chNFe') then
          varTipoOriDes := '-VALIDAR';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
      // Verifica se é ProtNFe
      if (Pos('<protNFe', varXML.Text) > 0) AND (Pos('<dhRecbto>', varXML.Text) > 0) then
      begin
        varTipoDocto := '_XML';
        varTipoData := '<dhRecbto>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if VerificaCNPJ(argCNPJ, '<infProt', varXML.Text, 'chNFe') then
          varTipoOriDes := '-VALIDAR'
        else
          varTipoOriDes := '-VALIDAR';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
      // Verifica se é ProtInutNFe
      if (Pos('<inutNFe', varXML.Text) > 0) AND (Pos('<dhRecbto>', varXML.Text) > 0) then
      begin
        varTipoDocto := '_XML';
        varTipoData := '<dhRecbto>';
        varData := Copy(varXML.Text, Pos(varTipoData, varXML.Text) + Length(varTipoData), 7);
        if VerificaCNPJ(argCNPJ, '<infInut', varXML.Text, 'chNFe') then
          varTipoOriDes := '-VALIDAR'
        else
          varTipoOriDes := '-VALIDAR';
        Result := argCNPJ + '\' + varData + '\' + varTipoDocto + varTipoOriDes;
      end
      else
        Result := 'Problema';
    finally
      varXML.Free;
    end;
  end
  else
    ShowMessage('Não foram encontrados arquivos XML na pasta selecionada.');
end;
end.
