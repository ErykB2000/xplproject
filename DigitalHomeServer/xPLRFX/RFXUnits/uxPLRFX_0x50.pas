(***********************************************************)
(* xPLRFX                                                  *)
(* part of Digital Home Server project                     *)
(* http://www.digitalhomeserver.net                        *)
(* info@digitalhomeserver.net                              *)
(***********************************************************)
unit uxPLRFX_0x50;

interface

Uses uxPLRFXConst, u_xPL_Message, u_xpl_common, SysUtils, uxPLRFXMessages;

procedure RFX2xPL(Buffer : BytesArray; xPLMessages : TxPLRFXMessages);

implementation

(*

Type $50 - Temperature Sensors

Buffer[0] = packetlength = $08;
Buffer[1] = packettype
Buffer[2] = subtype
Buffer[3] = seqnbr
Buffer[4] = id1
Buffer[5] = id2
Buffer[6] = temperaturehigh:7/temperaturesign:1
Buffer[7] = temperaturelow
Buffer[8] = battery_level:4/rssi:4

Test strings :

08500502770000D389
0850021DFB0100D770
08500502770000D389

xPL Schema

sensor.basic
{
  device=(temp1-temp10) 0x<hex sensor id>
  type=temp
  current=<degrees celsius>
  units=c
}

sensor.basic
{
  device=(temp1-temp10) 0x<hex sensor id>
  type=battery
  current=0-100
}

*)

const
  // Type
  TEMPERATURE  = $50;

  // Subtype
  TEMP1  = $01;
  TEMP2  = $02;
  TEMP3  = $03;
  TEMP4  = $04;
  TEMP5  = $05;
  TEMP6  = $06;
  TEMP7  = $07;
  TEMP8  = $08;
  TEMP9  = $09;
  TEMP10 = $0A;

var
  SubTypeArray : array[1..10] of TRFXSubTypeRec =
    ((SubType : TEMP1;  SubTypeString : 'temp1'),
     (SubType : TEMP2;  SubTypeString : 'temp2'),
     (SubType : TEMP3;  SubTypeString : 'temp3'),
     (SubType : TEMP4;  SubTypeString : 'temp4'),
     (SubType : TEMP5;  SubTypeString : 'temp5'),
     (SubType : TEMP6;  SubTypeString : 'temp6'),
     (SubType : TEMP7;  SubTypeString : 'temp7'),
     (SubType : TEMP8;  SubTypeString : 'temp8'),
     (SubType : TEMP9;  SubTypeString : 'temp9'),
     (SubType : TEMP10; SubTypeString : 'temp10'));

procedure RFX2xPL(Buffer : BytesArray; xPLMessages : TxPLRFXMessages);
var
  DeviceID : String;
  SubType : String;
  Temperature : Extended;
  TemperatureSign : String;
  BatteryLevel : Integer;
  xPLMessage : TxPLMessage;
begin
  DeviceID := GetSubTypeString(Buffer[2],SubTypeArray)+IntToHex(Buffer[4],2)+IntToHex(Buffer[5],2);
  if Buffer[6] and $80 > 0 then
    TemperatureSign := '-';    // negative value
  Buffer[6] := Buffer[6] and $7F;  // zero out the temperature sign
  Temperature := ((Buffer[6] shl 8) + Buffer[7]) / 10;
  if (Buffer[8] and $0F) = 0 then  // zero out rssi
    BatteryLevel := 0
  else
    BatteryLevel := 100;
  // Create sensor.basic message for the temperature
  xPLMessage := TxPLMessage.Create(nil);
  xPLMessage.schema.RawxPL := 'sensor.basic';
  xPLMessage.MessageType := trig;
  xPLMessage.source.RawxPL := XPLSOURCE;
  xPLMessage.target.IsGeneric := True;
  xPLMessage.Body.AddKeyValue('device='+DeviceID);
  xPLMessage.Body.AddKeyValue('current='+TemperatureSign+FloatToStr(Temperature));
  xPLMessage.Body.AddKeyValue('units=c');
  xPLMessage.Body.AddKeyValue('type=temperature');
  xPLMessages.Add(xPLMessage.RawXPL);
  xPLMessage.Free;

  xPLMessage := TxPLMessage.Create(nil);
  xPLMessage.schema.RawxPL := 'sensor.basic';
  xPLMessage.MessageType := trig;
  xPLMessage.source.RawxPL := XPLSOURCE;
  xPLMessage.target.IsGeneric := True;
  xPLMessage.Body.AddKeyValue('device='+DeviceID);
  xPLMessage.Body.AddKeyValue('current='+IntToStr(BatteryLevel));
  xPLMessage.Body.AddKeyValue('type=battery');
  xPLMessages.Add(xPLMessage.RawXPL);
  xPLMessage.Free;

end;

end.
