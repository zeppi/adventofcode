program day01;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  SearchToken = record
    target: String;
    value: String;
  end;

  MinMax = record
    target: SearchToken;
    value: Integer;
  end;

var
  tokens: array [1 .. 18] of SearchToken;
  i, tmpSearch: Integer;

  found_min, found_max: MinMax;

  txtInput: TextFile;
  sData: String;
  iTotal: Integer;

procedure initTokens();
begin
  with tokens[1] do
  begin
    target := '1';
    value := '1';
  end;

  with tokens[2] do
  begin
    target := '2';
    value := '2';
  end;

  with tokens[3] do
  begin
    target := '3';
    value := '3';
  end;

  with tokens[4] do
  begin
    target := '4';
    value := '4';
  end;

  with tokens[5] do
  begin
    target := '5';
    value := '5';
  end;

  with tokens[6] do
  begin
    target := '6';
    value := '6';
  end;

  with tokens[7] do
  begin
    target := '7';
    value := '7';
  end;

  with tokens[8] do
  begin
    target := '8';
    value := '8';
  end;

  with tokens[9] do
  begin
    target := '9';
    value := '9';
  end;

  with tokens[10] do
  begin
    target := 'one';
    value := '1';
  end;

  with tokens[11] do
  begin
    target := 'two';
    value := '2';
  end;

  with tokens[12] do
  begin
    target := 'three';
    value := '3';
  end;

  with tokens[13] do
  begin
    target := 'four';
    value := '4';
  end;

  with tokens[14] do
  begin
    target := 'five';
    value := '5';
  end;

  with tokens[15] do
  begin
    target := 'six';
    value := '6';
  end;

  with tokens[16] do
  begin
    target := 'seven';
    value := '7';
  end;

  with tokens[17] do
  begin
    target := 'eight';
    value := '8';
  end;

  with tokens[18] do
  begin
    target := 'nine';
    value := '9';
  end;

end;

function fnFoundMin(sData: String; sFound: String): Integer;
begin
  Result := sData.IndexOf(sFound);
end;

function fnFoundMax(sData: String; sFound: String): Integer;
var
  iIdx, iTmp, iFoundLen: Integer;
begin
  iFoundLen := Length(sFound);
  iIdx := sData.IndexOf(sFound);
  iTmp := 0;

  while iTmp <> -1 do
  begin
    iTmp := sData.SubString(iIdx + iFoundLen).IndexOf(sFound);

    if iTmp <> -1 then
    begin
      iIdx := iIdx + iFoundLen + iTmp;
    end;
  end;

  Result := iIdx;
end;

function fnCombineMinMax(fmin: MinMax; fmax: MinMax): Integer;
begin
  Result := 0;
  if (fmin.value = -1) and (fmax.value = -1) then
  begin
    Result := 0;
  end
  else if (fmin.value = -1) and (fmax.value <> -1) then
  begin
    Result := (fmin.target.value + fmin.target.value).toInteger();
  end
  else if (fmin.value <> -1) and (fmax.value = -1) then
  begin
    Result := (fmax.target.value + fmax.target.value).toInteger();
  end
  else
  begin
    Result := (fmin.target.value + fmax.target.value).toInteger();
  end;
end;

procedure processForMinWithTokensTo(i: Integer);
begin
  tmpSearch := -1;
  found_min.value := -1;
  for i := 1 to i do
  begin
    tmpSearch := fnFoundMin(sData, tokens[i].target);
    if (tmpSearch <> -1) and
      ((found_min.value = -1) or (found_min.value > tmpSearch)) then
    begin
      found_min.target := tokens[i];
      found_min.value := tmpSearch;
    end;
  end;
end;

procedure processForMaxWithTokensTo(i: Integer);
begin
  tmpSearch := -1;
  found_max.value := -1;
  for i := 1 to i do
  begin
    tmpSearch := fnFoundMax(sData, tokens[i].target);
    if (tmpSearch <> -1) and
      ((found_max.value = -1) or (found_max.value < tmpSearch)) then
    begin
      found_max.target := tokens[i];
      found_max.value := tmpSearch;
    end;
  end;
end;

begin
  try
    initTokens();

    AssignFile(txtInput, '..\..\..\..\inputs\day01\input.txt');
    Reset(txtInput);

    iTotal := 0;
    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);

      processForMinWithTokensTo(9);
      processForMaxWithTokensTo(9);

      iTotal := iTotal + fnCombineMinMax(found_min, found_max);
    end;
    Close(txtInput);

    Writeln('P1: ' + iTotal.ToString());

    AssignFile(txtInput, '..\..\..\..\inputs\day01\input.txt');
    Reset(txtInput);

    iTotal := 0;
    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);

      processForMinWithTokensTo(18);
      processForMaxWithTokensTo(18);

      iTotal := iTotal + fnCombineMinMax(found_min, found_max);
    end;
    Close(txtInput);

    Writeln('P2: ' + iTotal.ToString());

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;

end.
