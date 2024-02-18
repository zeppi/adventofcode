program day05;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, System.Threading, System.SyncObjs;

var
  txtInput: TextFile;
  sData: String;
  aStringLines: TArray<String>;

  sItemTmp: String;

  aSeedsCandidate: TArray<Int64>;
  aMaps: TArray<TArray<TArray<Int64>>>;
  iIdx, iCaptureMode, iMap, iIdj: Integer;
  iIdm, iSeed, iSoil, iFertilizer, iWater, iLight, iTemperature, iHumidity,
    iLocation, iMinlocation, iSeedsLen, iTmpSeed: Int64;

  Tasks: array of ITask;
  aMinLocation: TArray<Int64>;
  Lock: TCriticalSection;

function fnSplitToInteger(s: String): TArray<Int64>;
var
  aInt: TArray<Int64>;
  split: TArray<String>;
  item: String;
begin
  split := s.split([' ']);

  for item in split do
  begin
    Insert(StrToInt64(StringReplace(item, ' ', '', [rfReplaceAll, rfIgnoreCase])
      ), aInt, Length(aInt) + 1);
  end;
  Result := aInt;
end;

function fnSplitTokenToInteger(token, s: String): TArray<Int64>;
var
  split: TArray<String>;
begin
  split := s.split([token]);
  Result := fnSplitToInteger(split[1]);
end;

function fnGetTargetFromSource(aMap: TArray<TArray<Int64>>; s: Int64): Int64;
var
  iMap: Integer;
  iSrc, iDst, iLgt: Int64;
begin
  Result := s;

  for iMap := 0 to Length(aMap) - 1 do
  begin
    iSrc := aMap[iMap][1];
    iDst := aMap[iMap][0];
    iLgt := aMap[iMap][2];

    if (s >= iSrc) and (s <= iSrc + iLgt) then
    begin
      Result := s + (iDst - iSrc);
      Break;
    end;
  end;
end;

procedure prcAddMiniLendthInArray(v: Int64);
begin
  Lock.Acquire;
  Insert(v, aMinLocation, Length(aMinLocation) + 1);
  Lock.Release;
end;

begin
  try
    AssignFile(txtInput, '..\..\..\..\inputs\day05\input.txt');
    Reset(txtInput);

    while not Eof(txtInput) do
    begin
      Readln(txtInput, sData);
      Insert(StringReplace(sData, sLineBreak, '', [rfReplaceAll]), aStringLines,
        Length(aStringLines) + 1);
    end;
    Close(txtInput);

    iCaptureMode := -1;
    for iIdx := 0 to 6 do
      Insert(nil, aMaps, Length(aMaps) + 1);

    for sItemTmp in aStringLines do
    begin
      if sItemTmp.IndexOf('seeds: ') <> -1 then
      begin
        aSeedsCandidate := fnSplitTokenToInteger('seeds: ', sItemTmp);
      end;

      if (iCaptureMode <> -1) and (sItemTmp <> '') and
        not(sItemTmp.IndexOf(' map:') <> -1) then
      begin
        Insert(fnSplitToInteger(sItemTmp), aMaps[iCaptureMode],
          Length(aMaps[iCaptureMode]) + 1);
      end;

      if sItemTmp.IndexOf(' map:') <> -1 then
      begin
        if sItemTmp.IndexOf('seed-to-soil') <> -1 then
          iCaptureMode := 0;
        if sItemTmp.IndexOf('soil-to-fertilizer') <> -1 then
          iCaptureMode := 1;
        if sItemTmp.IndexOf('fertilizer-to-water') <> -1 then
          iCaptureMode := 2;
        if sItemTmp.IndexOf('water-to-ligh') <> -1 then
          iCaptureMode := 3;
        if sItemTmp.IndexOf('light-to-temperature') <> -1 then
          iCaptureMode := 4;
        if sItemTmp.IndexOf('temperature-to-humidity') <> -1 then
          iCaptureMode := 5;
        if sItemTmp.IndexOf('humidity-to-location') <> -1 then
          iCaptureMode := 6;
      end;
    end;

    iMinlocation := High(Int64);
    for iSeed in aSeedsCandidate do
    begin
      iSoil := fnGetTargetFromSource(aMaps[0], iSeed);
      iFertilizer := fnGetTargetFromSource(aMaps[1], iSoil);
      iWater := fnGetTargetFromSource(aMaps[2], iFertilizer);
      iLight := fnGetTargetFromSource(aMaps[3], iWater);
      iTemperature := fnGetTargetFromSource(aMaps[4], iLight);
      iHumidity := fnGetTargetFromSource(aMaps[5], iTemperature);
      iLocation := fnGetTargetFromSource(aMaps[6], iHumidity);

      if iLocation < iMinlocation then
        iMinlocation := iLocation;

    end;
    Writeln('Min location 1: ', iMinlocation);

    iIdj := 0;
    iIdx := 0;

    iMinlocation := High(Int64);
    Lock := TCriticalSection.Create;

    while iIdj < Length(aSeedsCandidate) do
    begin
      iSeed := aSeedsCandidate[iIdj];
      Inc(iIdj);

      iSeedsLen := aSeedsCandidate[iIdj];
      Inc(iIdj);
      setlength(Tasks, iIdx + 1);

      Tasks[iIdx] := TTask.Create(
        procedure
        var
          iMinl, iSeedTmp, iSeedsLenTmp, iTmpSeedTmp, iSoilTmp, iFertilizerTmp,
            iWaterTmp, iLightTmp, iTemperatureTmp, iHumidityTmp,
            iLocationTmp: Int64;
        begin
          iMinl := High(Int64);
          iSeedTmp := iSeed;
          iSeedsLenTmp := iSeedsLen;

          iTmpSeedTmp := iSeedTmp + iSeedsLenTmp;

          while iSeedTmp <= iTmpSeedTmp do
          begin
            iSoilTmp := fnGetTargetFromSource(aMaps[0], iSeedTmp);
            iFertilizerTmp := fnGetTargetFromSource(aMaps[1], iSoilTmp);
            iWaterTmp := fnGetTargetFromSource(aMaps[2], iFertilizerTmp);
            iLightTmp := fnGetTargetFromSource(aMaps[3], iWaterTmp);
            iTemperatureTmp := fnGetTargetFromSource(aMaps[4], iLightTmp);
            iHumidityTmp := fnGetTargetFromSource(aMaps[5], iTemperatureTmp);
            iLocationTmp := fnGetTargetFromSource(aMaps[6], iHumidityTmp);

            if iLocationTmp < iMinl then
              iMinl := iLocationTmp;

            Inc(iSeedTmp);
          end;

          prcAddMiniLendthInArray(iMinl);

        end);
      Tasks[iIdx].Start();
      Sleep(100);

      Inc(iIdx);
      Inc(iSeed);

    end;

    TTask.WaitForAll(Tasks);

    iMinlocation := High(Int64);

    for iIdm in aMinLocation do
      if iIdm < iMinlocation then
        iMinlocation := iIdm;

    Writeln('Min location 2: ', iMinlocation);
    Lock.Free;

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
