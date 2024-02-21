program day07;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, Math;

type
  THand = array [0 .. 4] of Char;
  cType = (high_card, one_pair, two_pair, three_of_a_kind, full_house,
    four_of_a_kind, five_of_a_kind);

  TPlays = record
    hand: String;
    win: Integer;
  end;

  TResultCountByItems = record
    datas: TArray<Integer>;
    count_excluded: Integer;
  end;

  IsGreaterThanTHand = function(a, b: THand): Boolean;
  GetStrength = function(c: Char): Integer;
  GetTHandType = function(h: THand): cType;

function fnStringToTHand(s: String): THand;
var
  o: THand;
  i: Integer;
begin
  for i := 0 to 4 do
    o[i] := s[i + 1];

  Result := o;
end;

function fnTHandToString(const a: THand): string;
begin
  SetString(Result, PChar(@a[0]), Length(a))
end;

function fnGetStrength(c: Char; const cCards: TArray<Char>): Integer;
var
  iIdx: Integer;
begin
  for iIdx := 0 to Length(cCards) - 1 do
  begin
    Result := 0;
    if cCards[iIdx] = c then
    begin
      Result := iIdx;
      Break
    end;
  end;
end;

function fnGetStrengthOne(c: Char): Integer;
begin
  Result := fnGetStrength(c, ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J',
    'Q', 'K', 'A'])
end;

function fnGetStrengthTwo(c: Char): Integer;
begin
  Result := fnGetStrength(c, ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T',
    'Q', 'K', 'A'])
end;

function fnGetCountByItems(h: THand; exculde: Char = ' '): TResultCountByItems;
var
  iIdx, iIdj, iCount, iExcluded: Integer;
  aCounts: TArray<Integer>;
  aCards: TArray<Char>;
begin
  iExcluded := 0;

  for iIdx := 0 to 4 do
  begin
    if h[iIdx] = exculde then
    begin
      Inc(iExcluded);
    end
    else
    begin
      iCount := -1;
      for iIdj := 0 to Length(aCards) - 1 do
      begin
        if aCards[iIdj] = h[iIdx] then
        begin
          iCount := iIdj;
        end;
      end;

      if iCount = -1 then
      begin
        iCount := Length(aCards);
        Insert(h[iIdx], aCards, iCount + 1);
        Insert(0, aCounts, iCount + 1);
      end;

      Inc(aCounts[iCount]);
    end;
  end;

  Result.datas := aCounts;
  Result.count_excluded := iExcluded;
end;

function fnDeduceType(aCounts: TArray<Integer>): cType;
begin
  Result := cType.high_card;

  if (Length(aCounts) = 1) then
  begin
    Result := cType.five_of_a_kind;
  end
  else if (Length(aCounts) = 2) then
  begin
    if MaxIntValue(aCounts) = 4 then
    begin
      Result := cType.four_of_a_kind;
    end
    else
    begin
      Result := cType.full_house;
    end;
  end
  else if (Length(aCounts) = 3) then
  begin
    if MaxIntValue(aCounts) = 3 then
    begin
      Result := cType.three_of_a_kind;
    end
    else
    begin
      Result := cType.two_pair;
    end;
  end
  else if (Length(aCounts) = 4) then
  begin
    Result := cType.one_pair;
  end;
end;

function fnGetTHandTypeOne(h: THand): cType;
var
  r: TResultCountByItems;
begin

  r := fnGetCountByItems(h);
  Result := fnDeduceType(r.datas);
end;

function fnGetTHandTypeTwo(h: THand): cType;
var
  r: TResultCountByItems;
begin

  r := fnGetCountByItems(h, 'J');

  if r.count_excluded = 0 then
  begin
    Result := fnDeduceType(r.datas);
  end
  else
  begin
    if (Length(r.datas) = 1) or (Length(r.datas) = 0) then
    begin
      Result := cType.five_of_a_kind;
    end
    else if (Length(r.datas) = 2) then
    begin
      if MaxIntValue(r.datas) + r.count_excluded = 4 then
      begin
        Result := cType.four_of_a_kind;
      end
      else
      begin
        Result := cType.full_house;
      end;
    end
    else if (Length(r.datas) = 3) then
    begin
      if MaxIntValue(r.datas) + r.count_excluded = 3 then
      begin
        Result := cType.three_of_a_kind;
      end
      else
      begin
        Result := cType.two_pair;
      end;
    end
    else if (Length(r.datas) = 4) and (r.count_excluded = 1) then
    begin
      Result := cType.one_pair;
    end;
  end;
end;

function fnIsGreaterThanTHand(a, b: THand; fnGetStrength: GetStrength;
  fnGetTHandType: GetTHandType): Boolean;
var
  cType_a, cType_b: cType;
  iIdx: Integer;
begin
  Result := false;

  cType_a := fnGetTHandType(a);
  cType_b := fnGetTHandType(b);

  if (cType_a > cType_b) then
    Result := true;

  if (cType_a = cType_b) then
  begin
    for iIdx := 0 to 4 do
    begin
      if (a[iIdx] <> b[iIdx]) then
      begin
        Result := (fnGetStrength(a[iIdx]) > fnGetStrength(b[iIdx]));
        Break;
      end;
    end;

  end;
end;

function fnIsGreaterThanTHandOne(a, b: THand): Boolean;
begin
  Result := fnIsGreaterThanTHand(a, b, fnGetStrengthOne, fnGetTHandTypeOne);
end;

function fnIsGreaterThanTHandTwo(a, b: THand): Boolean;
begin
  Result := fnIsGreaterThanTHand(a, b, fnGetStrengthTwo, fnGetTHandTypeTwo);
end;

function fnSortPlay(h: TArray<THand>; fnIsGreaterThanTHand: IsGreaterThanTHand)
  : TArray<THand>;
var
  iIdx, iIdj, iMax: Integer;
  cTmp: THand;
begin
  for iIdx := 0 to Length(h) - 1 do
    for iIdj := 0 to Length(h) - 1 do
    begin
      if not fnIsGreaterThanTHand(h[iIdx], h[iIdj]) then
      begin
        cTmp := h[iIdx];
        h[iIdx] := h[iIdj];
        h[iIdj] := cTmp;
      end;
    end;

  Result := h;
end;

var
  txtInput: TextFile;
  sData: String;
  aDataSplit: TArray<String>;
  tpParty: TArray<TPlays>;
  tmpTplay: TPlays;
  tmpHand: TArray<THand>;
  iIdx, iIdj, iRang, iPoint: Integer;

begin
  try
    AssignFile(txtInput, '..\..\..\..\inputs\day07\input.txt');
    Reset(txtInput);

    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);
      aDataSplit := sData.Split([' ']);
      tmpTplay.hand := StringReplace(aDataSplit[0], sLineBreak, '',
        [rfReplaceAll]);
      tmpTplay.win := StringReplace(aDataSplit[1], sLineBreak, '',
        [rfReplaceAll]).ToInteger();

      Insert(tmpTplay, tpParty, Length(tpParty) + 1);
      Insert(fnStringToTHand(tmpTplay.hand), tmpHand, Length(tmpHand) + 1);
    end;
    Close(txtInput);

    tmpHand := fnSortPlay(tmpHand, fnIsGreaterThanTHandOne);

    iRang := 1;
    iPoint := 0;

    for iIdx := 0 to Length(tmpHand) - 1 do
    begin
      for iIdj := 0 to Length(tpParty) - 1 do
      begin
        if (tpParty[iIdj].hand = fnTHandToString(tmpHand[iIdx])) then
        begin
          iPoint := iPoint + (iRang * tpParty[iIdj].win);
          Inc(iRang);
          Break
        end;
      end;
    end;

    Writeln('Solution one: ', iPoint);

    tmpHand := fnSortPlay(tmpHand, fnIsGreaterThanTHandTwo);

    iRang := 1;
    iPoint := 0;

    for iIdx := 0 to Length(tmpHand) - 1 do
    begin
      for iIdj := 0 to Length(tpParty) - 1 do
      begin
        if (tpParty[iIdj].hand = fnTHandToString(tmpHand[iIdx])) then
        begin
          iPoint := iPoint + (iRang * tpParty[iIdj].win);
          Inc(iRang);
          Break
        end;
      end;
    end;

    Writeln('Solution two: ', iPoint);

    Readln;
  except
    on e: Exception do
      Writeln(e.ClassName, ': ', e.Message);
  end;

end.
