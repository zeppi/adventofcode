program day03;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.Character;

type
  TPosNum = record
    idx: Integer;
    idy: Integer;
    content: String;
  end;

  TaPosNum = TArray<TArray<TPosNum>>;
var
  txtInput: TextFile;
  sData: String;
  aStringLines: TArray<String>;

  iSizeY, iSizeX: Integer;
  iIdi, iIdj, iIwi, iIwj, iVisiteY, iVisiteX: Integer;
  sTmpValue: Char;
  sTmpNumber: String;
  aNumberCandidate: TArray<String>;
  bIsCandidate: Boolean;
  iSumOne: Integer;

  tmpPosNum, itemPosNum: TPosNum;
  bIsIin: Boolean;
  aPosNum: TArray<TPosNum>;
  aCandidate: TaPosNum;

function fnGetPosNumber(m: TArray<String>; y: Integer; x: Integer ): TPosNum;
var
  p: TPosNum;
  iX, iL: Integer;
  sContent: String;
begin
  iX := x;
  sContent := '';
  iL := Length(m[y]);
  p.idy := y;

  // find the first position
  while (iX >= 1) and System.Character.IsNumber(m[y][iX]) do
    Dec(iX);

  Inc(iX);
  p.idx := iX;

  // find number
  while (iX <= iL) and System.Character.IsNumber(m[y][iX]) do
  begin
    sContent := sContent + m[y][iX];
    Inc(iX);
  end;

  p.content := sContent;

  Result := p;
end;

begin
  try
    AssignFile(txtInput, '..\..\..\..\inputs\day03\input.txt');
    Reset(txtInput);

    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);
      Insert(StringReplace(sData, sLineBreak, '', [rfReplaceAll]), aStringLines, Length(aStringLines) + 1);
    end;
    Close(txtInput);

    //  1 to iSizeX
    iSizeX := Length(aStringLines[0]);

    // 0 to iSizeY
    iSizeY := Length(aStringLines) - 1;

    // One
    sTmpNumber := '';
    bIsCandidate := false;

    for iIdi := 0 to iSizeY do
      for iIdj := 1 to iSizeX do
        begin
          sTmpValue := aStringLines[iIdi][iIdj];

          if System.Character.IsNumber(sTmpValue) then
          begin
            sTmpNumber := sTmpNumber + sTmpValue;

            for iIwi := -1 to 1 do
              for iIwj := -1 to 1 do
                begin
                   iVisiteY := iIdi + iIwi;
                   iVisiteX := iIdj + iIwj;

                   if (iVisiteY >= 0)
                    and (iVisiteY <= iSizeY)
                    and (iVisiteX >= 1)
                    and (iVisiteX <= iSizeX) then
                   begin
                    if (aStringLines[iVisiteY][iVisiteX] <> '.') and (not System.Character.IsNumber(aStringLines[iVisiteY][iVisiteX])) then
                      bIsCandidate := true;
                   end;
                end;

          end;

          if (not System.Character.IsNumber(sTmpValue)) and (Length(sTmpNumber) > 0) then
          begin
            if bIsCandidate then
              Insert(sTmpNumber, aNumberCandidate, Length(aNumberCandidate) + 1);

            sTmpNumber := '';
            bIsCandidate := false;
          end;
        end;

    if (Length(sTmpNumber) > 0) then
    begin
      if bIsCandidate then
        Insert(sTmpNumber, aNumberCandidate, Length(aNumberCandidate) + 1);

      sTmpNumber := '';
    end;

    iSumOne := 0;
    for sTmpNumber in aNumberCandidate do
      iSumOne := iSumOne + sTmpNumber.ToInteger();

     Writeln('First sum: ', iSumOne);

    // Two
    sTmpNumber := '';
    bIsCandidate := false;

    for iIdi := 0 to iSizeY do
      for iIdj := 1 to iSizeX do
        begin
          sTmpValue := aStringLines[iIdi][iIdj];
          if sTmpValue = '*' then
          begin
            SetLength(aPosNum, 0);

            for iIwi := -1 to 1 do
              for iIwj := -1 to 1 do
                begin
                   iVisiteY := iIdi + iIwi;
                   iVisiteX := iIdj + iIwj;

                   if (iVisiteY >= 0)
                    and (iVisiteY <= iSizeY)
                    and (iVisiteX >= 1)
                    and (iVisiteX <= iSizeX)
                    and (System.Character.IsNumber(aStringLines[iVisiteY][iVisiteX])) then
                   begin
                      tmpPosNum := fnGetPosNumber(aStringLines, iVisiteY, iVisiteX);
                      bIsIin := false;
                      for itemPosNum in aPosNum do
                      begin
                        if (itemPosNum.idx = tmpPosNum.idx) and (itemPosNum.idy = tmpPosNum.idy)  then
                          bIsIin := true;
                      end;

                      if not bIsIin then
                        Insert(tmpPosNum, aPosNum, Length(aPosNum) + 1);
                   end;
                end;

                if Length(aPosNum) = 2 then
                  Insert(aPosNum, aCandidate, Length(aCandidate) + 1);
          end;
        end;

    iSumOne := 0;
    for aPosNum in aCandidate do
    begin
      iSumOne := iSumOne + (aPosNum[0].content.ToInteger() * aPosNum[1].content.ToInteger())
    end;

    Writeln('Next sum: ', iSumOne);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;

end.
