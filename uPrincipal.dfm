object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Avaliador XML'
  ClientHeight = 256
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 177
    Align = alTop
    TabOrder = 0
    object lblCNPJ: TLabel
      Left = 24
      Top = 24
      Width = 29
      Height = 13
      Caption = 'CNPJ:'
    end
    object lblDefinePasta: TLabel
      Left = 24
      Top = 64
      Width = 91
      Height = 13
      Caption = 'Pasta de Pesquisa:'
    end
    object lblDica: TLabel
      Left = 234
      Top = 24
      Width = 504
      Height = 13
      Caption = 
        '(Informe aqui o CNPJ da empresa que deseja tratar. Os XML de CTe' +
        ' e NFe ser'#227'o organizados de acordo)'
    end
    object lblDuplicados: TLabel
      Left = 24
      Top = 151
      Width = 64
      Height = 13
      Caption = 'Duplicados: 0'
    end
    object lblEncontrados: TLabel
      Left = 324
      Top = 151
      Width = 118
      Height = 13
      Alignment = taCenter
      Caption = 'Arquivos Encontrados: 0'
    end
    object lblCTeDesnecessario: TLabel
      Left = 620
      Top = 151
      Width = 109
      Height = 13
      Caption = 'CTe Desnecess'#225'rios: 0'
    end
    object edtCNPJ: TEdit
      Left = 59
      Top = 21
      Width = 150
      Height = 21
      TabOrder = 0
      OnExit = edtCNPJExit
    end
    object edtCaminhoPasta: TEdit
      Left = 24
      Top = 83
      Width = 699
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object btnCaminhoPasta: TBitBtn
      Left = 729
      Top = 81
      Width = 24
      Height = 24
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        08000000000000010000C40E0000C40E00000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB7B76F6767
        6767676767676767B7FFFF6FF6BFBFBFBFBFBFBFBFBFB7F66FFFFF6FF6BFBFBF
        BFBF7F7F7F7777F66FFFFF6FF6BFBFBFBFBFBF7F7F7F77F66FFFFF6FF6F6F6BF
        BFBFBFBF7F7F7FF66FFFFF6FFFFFF6F6F6F6BFBFBFBF7FF66FFFFF6FF6BFB7B7
        F6F6F6F6F6F6F6FF6FFFFF6FF6BFBFBFB7B7BFBFBFB7B7F677FFFF77F6BFBFBF
        BFF6F6F6F6F6F6FF77FFFF77FFFFFFFFFFF6B7B7B7B7B7BF08FFFF77B7B7B7B7
        B777F6F6F6F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 2
      OnClick = btnCaminhoPastaClick
    end
    object pbrProgresso: TProgressBar
      Left = 24
      Top = 115
      Width = 729
      Height = 30
      TabOrder = 3
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 177
    Width = 780
    Height = 79
    Align = alClient
    TabOrder = 1
    object lblProblemas: TLabel
      Left = 620
      Top = 16
      Width = 86
      Height = 13
      Caption = 'Com Problemas: 0'
    end
    object lblValidaManual: TLabel
      Left = 620
      Top = 48
      Width = 82
      Height = 13
      Caption = 'Validar Manual: 0'
    end
    object lblNFeEntrada: TLabel
      Left = 24
      Top = 16
      Width = 73
      Height = 13
      Caption = 'NFe Entrada: 0'
    end
    object lblNFeSaida: TLabel
      Left = 24
      Top = 48
      Width = 61
      Height = 13
      Caption = 'NFe Sa'#237'da: 0'
    end
    object lblCTeEntrada: TLabel
      Left = 421
      Top = 16
      Width = 73
      Height = 13
      Caption = 'CTe Entrada: 0'
    end
    object lblCTeSaida: TLabel
      Left = 421
      Top = 48
      Width = 61
      Height = 13
      Caption = 'CTe Sa'#237'da: 0'
    end
    object lblNFSeEntrada: TLabel
      Left = 216
      Top = 16
      Width = 79
      Height = 13
      Caption = 'NFSe Entrada: 0'
    end
    object lblNFSeSaida: TLabel
      Left = 216
      Top = 48
      Width = 67
      Height = 13
      Caption = 'NFSe Sa'#237'da: 0'
    end
  end
end
