program day06;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

function fnGetSpeed(iTime:int64): int64;
begin
  Result := 0;
  if iTime > 0 then Result := iTime;
end;

function fnGetDistanceInMaxTime(iTime, iMaxTime:int64): int64;
begin
  Result := 0;

  if iTime < iMaxTime then
  begin
      Result := fnGetSpeed(iTime) * (iMaxTime - iTime)
  end;

end;

var
  iIdx, iRaceTime, iRaceMax, iProb: int64;
  aPossiblities: array[0..3] of Integer;
begin
  try

    //Race one
    iRaceTime := 48;
    iRaceMax := 390;
    for iIdx := 0 to iRaceTime do
    begin
      if fnGetDistanceInMaxTime(iIdx, iRaceTime) > iRaceMax then
       Inc(aPossiblities[0]);
    end;

    //Race two
    iRaceTime := 98;
    iRaceMax := 1103;
    for iIdx := 0 to iRaceTime do
    begin
      if fnGetDistanceInMaxTime(iIdx, iRaceTime) > iRaceMax then
       Inc(aPossiblities[1]);
    end;

    //Race tree
    iRaceTime := 90;
    iRaceMax := 1112;
    for iIdx := 0 to iRaceTime do
    begin
      if fnGetDistanceInMaxTime(iIdx, iRaceTime) > iRaceMax then
       Inc(aPossiblities[2]);
    end;

    //Race four
    iRaceTime := 83;
    iRaceMax := 1360;
    for iIdx := 0 to iRaceTime do
    begin
      if fnGetDistanceInMaxTime(iIdx, iRaceTime) > iRaceMax then
       Inc(aPossiblities[3]);
    end;

    iProb := 1;
    for iIdx := 0 to 3 do
      iProb := iProb * aPossiblities[iIdx];

    Writeln('Solutin one: ', iProb);

    iRaceTime := 48989083;
    iRaceMax := 390110311121360;
    iProb := 0;
    for iIdx := 0 to iRaceTime do
    begin
      if fnGetDistanceInMaxTime(iIdx, iRaceTime) > iRaceMax then
       Inc(iProb);
    end;

    Writeln('Solutin two: ', iProb);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  readln;
end.
