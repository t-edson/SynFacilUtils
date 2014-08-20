{Programa ejemplo de uso de la librería para implementar editores "utilEditSyn".
                                        Por Tito Hinostroza   11/07/2014 }
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, ActnList, StdActns, SynFacilUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    acArcAbrir: TAction;
    acArcGuaCom: TAction;
    acArcGuardar: TAction;
    acArcNuevo: TAction;
    acArcSalir: TAction;
    acBusBuscar: TAction;
    acBusBusSig: TAction;
    acBusRem: TAction;
    acEdiCopy: TEditCopy;
    acEdiCut: TEditCut;
    acEdiModCol: TAction;
    acEdiPaste: TEditPaste;
    acEdiRedo: TAction;
    acEdiSelecAll: TAction;
    acEdiUndo: TAction;
    AcHerConfig: TAction;
    ActionList: TActionList;
    acVerPanArc: TAction;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    mnLenguajes: TMenuItem;
    mnRecientes: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    SynEdit1: TSynEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    acVerBarEst: TAction;
    acVerNumLin: TAction;
    procedure acArcAbrirExecute(Sender: TObject);
    procedure acArcGuaComExecute(Sender: TObject);
    procedure acArcGuardarExecute(Sender: TObject);
    procedure acArcNuevoExecute(Sender: TObject);
    procedure acArcSalirExecute(Sender: TObject);
    procedure acEdiRedoExecute(Sender: TObject);
    procedure acEdiSelecAllExecute(Sender: TObject);
    procedure acEdiUndoExecute(Sender: TObject);
    procedure ChangeEditorState;
    procedure editChangeFileInform;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  private
    edit: TSynFacilEditor;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  edit := TSynFacilEditor.Create(SynEdit1, 'SinNombre', 'pas');
  edit.OnChangeEditorState:=@ChangeEditorState;
  edit.OnChangeFileInform:=@editChangeFileInform;
  //define paneles
  edit.PanFileSaved := StatusBar1.Panels[0]; //panel para mensaje "Guardado"
  edit.PanCursorPos := StatusBar1.Panels[1];  //panel para la posición del cursor

  edit.PanForEndLin := StatusBar1.Panels[2];  //panel para el tipo de delimitador de línea
  edit.PanCodifFile := StatusBar1.Panels[3];  //panel para la codificación del archivo
  edit.PanLangName  := StatusBar1.Panels[4];  //panel para el lenguaje
  edit.PanFileName  := StatusBar1.Panels[5];  //panel para el nombre del archivo

  edit.NewFile;        //para actualizar estado
  edit.InitMenuRecents(mnRecientes, nil);  //inicia el menú "Recientes"
  edit.InitMenuLanguages(mnLenguajes, '.\languages');
  edit.LoadSyntaxFromPath;  //para que busque el archivo apropiado
//  edit.LoadSyntaxFromFile('.\languages\c.xml');
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if edit.SaveQuery then CanClose := false;   //cancela
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  edit.Free;
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
begin
  //Carga archivo arrastrados
  if edit.SaveQuery then Exit;   //Verifica cambios
  edit.LoadFile(FileNames[0]);
  edit.LoadSyntaxFromPath;  //para que busque el archivo apropiado
end;

procedure TForm1.ChangeEditorState;
begin
  acArcGuardar.Enabled:=edit.Modified;
  acEdiUndo.Enabled:=edit.CanUndo;
  acEdiRedo.Enabled:=edit.CanRedo;
  //Para estas acciones no es necesario controlarlas, porque son acciones pre-determinadas
//  acEdiCortar.Enabled  := edit.canCopy;
//  acEdiCopiar.Enabled := edit.canCopy;
//  acEdiPegar.Enabled:= edit.CanPaste;
end;

procedure TForm1.editChangeFileInform;
begin
  //actualiza nombre de archivo
  Caption := 'Editor - ' + edit.NomArc;
end;

/////////////////// Acciones de Archivo /////////////////////
procedure TForm1.acArcNuevoExecute(Sender: TObject);
begin
  edit.NewFile;
  edit.LoadSyntaxFromPath;  //para que busque el archivo apropiado
end;

procedure TForm1.acArcAbrirExecute(Sender: TObject);
begin
  OpenDialog1.Filter:='Text files|*.txt|All files|*.*';
  edit.OpenDialog(OpenDialog1);
  edit.LoadSyntaxFromPath;  //para que busque el archivo apropiado
end;

procedure TForm1.acArcGuardarExecute(Sender: TObject);
begin
  edit.SaveFile;
end;

procedure TForm1.acArcGuaComExecute(Sender: TObject);
begin
  edit.SaveAsDialog(SaveDialog1);
  edit.LoadSyntaxFromPath;  //para que busque el archivo apropiado
end;

procedure TForm1.acArcSalirExecute(Sender: TObject);
begin
  Form1.Close;
end;
//////////// Acciones de Edición ////////////////
procedure TForm1.acEdiUndoExecute(Sender: TObject);
begin
  edit.Undo;
end;
procedure TForm1.acEdiRedoExecute(Sender: TObject);
begin
  edit.Redo;
end;
procedure TForm1.acEdiSelecAllExecute(Sender: TObject);
begin
  SynEdit1.SelectAll;
end;

end.

