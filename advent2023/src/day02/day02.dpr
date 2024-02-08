program day02;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

function fnSplitInputGame(s: String): TArray<String>;
var
  aData: TArray<String>;
begin;
  aData := s.Split([':']);
  aData[0] := StringReplace(aData[0], 'Game ', '',
    [rfReplaceAll, rfIgnoreCase]);

  Result := aData;
end;

function fnSplitInputSetsOfCubes(s: String): TArray<String>;
begin;
  Result := s.Split([';']);
end;

function fnSplitInputCubes(s: String): TArray<Integer>;
var
  aData: TArray<String>;
  aRecord: TArray<Integer>;
  iSplitResultsLength, idx: Integer;
begin;
  aData := s.Split([',']);
  iSplitResultsLength := Length(aData) - 1;
  aRecord := [0, 0, 0];

  for idx := 0 to iSplitResultsLength do
  begin;
    if aData[idx].indexOf('blue') <> -1 then
    begin
      aRecord[0] := StringReplace(aData[idx], ' blue', '',
        [rfReplaceAll, rfIgnoreCase]).ToInteger();
    end;

    if aData[idx].indexOf('red') <> -1 then
    begin
      aRecord[1] := StringReplace(aData[idx], ' red', '',
        [rfReplaceAll, rfIgnoreCase]).ToInteger();
    end;

    if aData[idx].indexOf('green') <> -1 then
    begin
      aRecord[2] := StringReplace(aData[idx], ' green', '',
        [rfReplaceAll, rfIgnoreCase]).ToInteger();
    end;
  end;

  Result := aRecord;
end;

type
  TSetOfCubes = array [0 .. 2] of Integer;

  TGames = record
    id: Integer;
    SetsOfCubes: TArray<TSetOfCubes>;
    iBMax: Integer;
    iRMax: Integer;
    iGMax: Integer;
  end;

var
  txtInput: TextFile;
  sData: String;
  aGame: TArray<TGames>;

  aTmpArrayString: TArray<String>;
  sTmpSetOfCube: String;
  gTmpGames: TGames;
  iTmpIdx, iTmpIdx1: Integer;
  aTmpArrayInteger: TArray<Integer>;
  aTmpSetOfCube: TSetOfCubes;

begin
  try
    AssignFile(txtInput, '..\..\..\..\inputs\day02\input.txt');
    Reset(txtInput);

    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);
      aTmpArrayString := fnSplitInputGame(sData);
      gTmpGames.id := aTmpArrayString[0].ToInteger();

      aTmpArrayString := fnSplitInputSetsOfCubes(aTmpArrayString[1]);
      iTmpIdx := Length(aTmpArrayString) - 1;
      SetLength(gTmpGames.SetsOfCubes, iTmpIdx);

      gTmpGames.iBMax := 0;
      gTmpGames.iRMax := 0;
      gTmpGames.iGMax := 0;
      for var I := 0 to iTmpIdx do
      begin
        aTmpArrayInteger := fnSplitInputCubes(aTmpArrayString[I]);

        aTmpSetOfCube[0] := aTmpArrayInteger[0];
        aTmpSetOfCube[1] := aTmpArrayInteger[1];
        aTmpSetOfCube[2] := aTmpArrayInteger[2];

        Insert(aTmpSetOfCube, gTmpGames.SetsOfCubes,
          Length(gTmpGames.SetsOfCubes) + 1);

        if gTmpGames.iBMax < aTmpArrayInteger[0] then
          gTmpGames.iBMax := aTmpArrayInteger[0];

        if gTmpGames.iRMax < aTmpArrayInteger[1] then
          gTmpGames.iRMax := aTmpArrayInteger[1];

        if gTmpGames.iGMax < aTmpArrayInteger[2] then
          gTmpGames.iGMax := aTmpArrayInteger[2];
      end;

      Insert(gTmpGames, aGame, Length(aGame) + 1);

    end;
    Close(txtInput);

    iTmpIdx := 0;
    for gTmpGames in aGame do
    begin
      if (gTmpGames.iBMax <= 14) and (gTmpGames.iRMax <= 12) and
        (gTmpGames.iGMax <= 13) then
        iTmpIdx := iTmpIdx + gTmpGames.id;
    end;
    Writeln('First answer: ', iTmpIdx);

    iTmpIdx := 0;
    for gTmpGames in aGame do
    begin
      iTmpIdx1 := 1;
      if (gTmpGames.iBMax > 0) then
        iTmpIdx1 := iTmpIdx1 * gTmpGames.iBMax;

      if (gTmpGames.iRMax > 0) then
        iTmpIdx1 := iTmpIdx1 * gTmpGames.iRMax;

      if (gTmpGames.iGMax > 0) then
        iTmpIdx1 := iTmpIdx1 * gTmpGames.iGMax;

      iTmpIdx := iTmpIdx + iTmpIdx1;
    end;
    Writeln('Next answer: ', iTmpIdx);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;

end.
