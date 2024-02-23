program day8;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  TNode = record
    id: String;
    left: String;
    right: String;
  end;

function fnSearchId(aPaths: TArray<TNode>; s: String): TNode;
var
  tmp: TNode;
begin
  for tmp in aPaths do
  begin
    if tmp.id = s then
    begin
      Result := tmp;
      Break;
    end;
  end;
end;

function PGCD(a, b: Int64): Int64;
begin
  while b <> 0 do
  begin
    Result := a mod b;
    a := b;
    b := Result;
  end;
  Result := a;
end;

function PPCM(a, b: Int64): Int64;
begin
  Result := (a * b) div PGCD(a, b);
end;

var
  TFile: TextFile;
  sData: String;
  aData, aTmpSplit: TArray<String>;
  sInstuction: String;
  iSteps, iIdx, iStart, iCountLoop, iIdj: Integer;
  aPaths, aNodeTmp: TArray<TNode>;
  nodeTmp: TNode;
  bZZZisFound: Boolean;

  aStarts, aStepsFoundsInTwo: TArray<Integer>;
  i64Step: Int64;
begin
  try
{$REGION 'Read input file'}
    Assign(TFile, '..\..\..\..\inputs\day08\input.txt');
    Reset(TFile);

    while not Eof(TFile) do
    begin
      Readln(TFile, sData);
      Insert(sData, aData, Length(aData) + 1);
    end;

    Close(TFile);
{$ENDREGION}
{$REGION 'Init}
    sInstuction := aData[0];

    // 1. Search AAA
    iStart := 0;

    for iIdx := 2 to Length(aData) - 1 do
    begin
      aTmpSplit := aData[iIdx].Split([' ', '=', '(', ')', ',']);

      nodeTmp.id := aTmpSplit[0];
      nodeTmp.left := aTmpSplit[4];
      nodeTmp.right := aTmpSplit[6];

      if nodeTmp.id = 'AAA' then
        iStart := Length(aPaths);

      if nodeTmp.id[3] = 'A' then
        Insert(Length(aPaths), aStarts, Length(aStarts) + 1);

      Insert(nodeTmp, aPaths, Length(aPaths) + 1);
    end;
{$ENDREGION}
{$REGION 'go in path one'}
    bZZZisFound := false;
    iCountLoop := 0; // avoid infinte loop
    iIdx := 1;
    iSteps := 0;
    nodeTmp := aPaths[iStart];

    while (not bZZZisFound) and (iCountLoop < 1000000) do
    begin
      Inc(iCountLoop);

      // 2. Fallow the instruction
      if sInstuction[iIdx] = 'L' then
      begin
        nodeTmp := fnSearchId(aPaths, nodeTmp.left);
      end
      else
      begin
        nodeTmp := fnSearchId(aPaths, nodeTmp.right);
      end;

      // 2.1 Count each step
      Inc(iSteps);

      // 2.2 if found ZZZ stop
      if nodeTmp.id = 'ZZZ' then
        bZZZisFound := true;

      // 2.3 if enstuction is end and not found ZZZ start again instruction
      Inc(iIdx);
      if iIdx > Length(sInstuction) then
      begin
        iIdx := 1;
      end;
    end;
{$ENDREGION}
    Writeln('Solution one: ', iSteps);

{$REGION 'go in path two'}
    bZZZisFound := false;
    iCountLoop := 0; // avoid infinte loop
    iIdx := 1;
    iSteps := 0;
    SetLength(aNodeTmp, Length(aStarts));
    SetLength(aStepsFoundsInTwo, Length(aStarts));

    for iIdj := 0 to Length(aStarts) - 1 do
    begin
      aNodeTmp[iIdj] := aPaths[aStarts[iIdj]];
      aStepsFoundsInTwo[iIdj] := 0;

      iCountLoop := 0;
      bZZZisFound := false;

      while (not bZZZisFound) and (iCountLoop < 10000000) do
      begin
        Inc(iCountLoop);

        // 2. Fallow the instruction
        if sInstuction[iIdx] = 'L' then
        begin
          aNodeTmp[iIdj] := fnSearchId(aPaths, aNodeTmp[iIdj].left);
        end
        else
        begin
          aNodeTmp[iIdj] := fnSearchId(aPaths, aNodeTmp[iIdj].right);
        end;

        // 2.1 Count each step
        Inc(aStepsFoundsInTwo[iIdj]);

        // 2.2 if found Z at end stop
        if aNodeTmp[iIdj].id[3] = 'Z' then bZZZisFound := true;

        // 2.3 if enstuction is end and not found Z start again instruction
        Inc(iIdx);
        if iIdx > Length(sInstuction) then
        begin
          iIdx := 1;
        end;
      end;
    end;

    // 3. PPCM
    i64Step := aStepsFoundsInTwo[0];
    for iIdx := 1 to Length(aStepsFoundsInTwo) - 1 do
    begin
      i64Step := PPCM(i64Step, aStepsFoundsInTwo[iIdx]);
     end;

{$ENDREGION}
    Writeln('Solution two:', i64Step);
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
