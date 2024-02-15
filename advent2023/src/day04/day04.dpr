program day04;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.Math;

var
  txtInput: TextFile;
  sData: String;
  aStringLines: TArray<String>;

  iTotalPoint, iPoints, iTmpPoints, iSplitSize, iIdi, iIdj, iCard, iTmpWin, iTmp: Integer;
  sItemData: String;
  aYourNumber, aWinNumber, aTmpSplit, aTmp: TArray<String>;
  aWinsCard: TArray<Integer>;

begin
  try
    AssignFile(txtInput, '..\..\..\..\inputs\day04\input.txt');
    Reset(txtInput);

    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);
      Insert(StringReplace(sData, sLineBreak, '', [rfReplaceAll]), aStringLines,
        Length(aStringLines) + 1);
      Insert(0, aWinsCard, Length(aWinsCard) + 1);
    end;
    Close(txtInput);

    iTotalPoint := 0;
    iCard := 0;
    for sItemData in aStringLines do
    begin
      iPoints := 0;
      iTmpWin := 0;
      aTmpSplit := sItemData.Split(['|']);

      aTmp := aTmpSplit[0].Split([' ']);
      iSplitSize := Length(aTmp) - 1;

      // First 2 are etiquette card
      for iIdi := 2 to iSplitSize do
      begin
        if aTmp[iIdi] <> '' then
        begin
          Insert(aTmp[iIdi], aWinNumber, Length(aWinNumber) + 1);
        end;
      end;

      aTmp := aTmpSplit[1].Split([' ']);
      iSplitSize := Length(aTmp) - 1;

      for iIdi := 0 to iSplitSize do
      begin
        if aTmp[iIdi] <> '' then
        begin
          Insert(aTmp[iIdi], aYourNumber, Length(aYourNumber) + 1);
        end;
      end;

      for iIdi := 0 to Length(aWinNumber) - 1 do
        for iIdj := 0 to Length(aYourNumber) - 1 do
        begin
          if aWinNumber[iIdi] = aYourNumber[iIdj] then
          begin
            Inc(iTmpWin);
            if iPoints = 0 then
            begin
              Inc(iPoints);
            end
            else
            begin
              iPoints := iPoints * 2;
            end;
          end;
        end;

      for iIdi := 0 to aWinsCard[iCard] do
      begin
          iTmp := iTmpWin;
          while iTmp > 0 do
          begin
              Inc(aWinsCard[iCard + iTmp]);
              Dec(iTmp);
          end;
      end;

      Inc(aWinsCard[iCard]);
      Inc(iCard);

      iTotalPoint := iTotalPoint + iPoints;
      SetLength(aWinNumber, 0);
      SetLength(aYourNumber, 0);
    end;

    Writeln('Sun one: ', iTotalPoint);
    Writeln('Sum two: ', SumInt(aWinsCard));

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
