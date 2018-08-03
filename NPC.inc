procedure NPC.Setvx(Value: real);
begin
     Fvx:=Value;
end;
procedure NPC.Setvy(Value: real);
begin
     Fvy:=Value;
end;
procedure NPC.Setx(Value: real);
begin
     Fx:=Value;
end;
procedure NPC.Sety(Value: real);
begin
     Fy:=Value;
end;
procedure NPC.Setv(Value: integer);
begin
     Fv:=Value;
end;
procedure NPC.Setenemy(Value: Tenemy);
begin
     Fenemy:=Value;
end;
procedure NPC.Sethealth(Value: integer);
begin
     Fhealth:=Value;
     if Fhealth>0 then Fded:=false;
end;
procedure NPC.incshoottimer;
var casevar:integer;
begin
     case Fenemy of
        mage:casevar:=19;
        sorcerer:casevar:=3;
        turret:casevar:=2;
        cannon:casevar:=14;
     end;
     if Fshoottimer>casevar then Fshoottimer:=0 else Fshoottimer+=1;
end;
procedure NPC.Setshoottimer(Value:integer);
begin
     Fshoottimer:=Value;
end;

procedure NPC.Setded(Value: boolean);
begin
     Fded:=Value;
end;
procedure NPC.Setmoving(Value: boolean);
begin
     Fmoving:=Value;
end;

procedure NPC.paint;
var bitmap:TBitmap;
begin
     case Fenemy of
        mage,sorcerer,turret,paralyzer,cannon:begin Height:=80; Width:=80; end;
        key:begin Height:=20; Width:=40; end;
     end;
     bitmap:=TBitmap.create;
     with bitmap do
     begin
     	bitmap.TransparentColor:=clblack;
     	bitmap.Transparent:=true;
     	bitmap.transparentmode:=tmFixed;
     end;
     bitmap.height:=Height;
     bitmap.width:=Width;
     case Fenemy of
        mage:
          begin
               Fv:=2;
               Fhitboxwidth:=35;
               Fhitboxheight:=35;
               if Fhealth>-1 then
               if vx<0 then bitmap.LoadFromFile('sprites\zomb12.bmp')
               else bitmap.LoadFromFile('sprites\zomb11.bmp')
               else
                   case Fhealth of
                      -11:       bitmap.LoadFromFile('sprites\bl1.bmp');
                      -12:       bitmap.LoadFromFile('sprites\bl2.bmp');
                      -13:       bitmap.LoadFromFile('sprites\bl1.bmp');
                   end;
          end;
        sorcerer:
          begin
               Fv:=2;
               Fhitboxwidth:=35;
               Fhitboxheight:=35;
               if Fhealth>-1 then
               if vx<0 then bitmap.LoadFromFile('sprites\zomb22.bmp')
               else bitmap.LoadFromFile('sprites\zomb21.bmp')
               else
                   case Fhealth of
                      -11:       bitmap.LoadFromFile('sprites\bl1.bmp');
                      -12:       bitmap.LoadFromFile('sprites\bl2.bmp');
                      -13:       bitmap.LoadFromFile('sprites\bl1.bmp');
                   end;
          end;
        turret:
          begin
               Fhitboxwidth:=35;
               Fhitboxheight:=35;
               if Fhealth>-1 then
               if vx<0 then bitmap.LoadFromFile('sprites\zomb30.bmp')
               else bitmap.LoadFromFile('sprites\zomb30.bmp')
               else
                   case Fhealth of
                      -11:       bitmap.LoadFromFile('sprites\explo1.bmp');
                      -12:       bitmap.LoadFromFile('sprites\explo2.bmp');
                      -13:       bitmap.LoadFromFile('sprites\explo3.bmp');
                   end;
          end;
        paralyzer:
          begin
               Fv:=4;
               Fhitboxwidth:=35;
               Fhitboxheight:=35;
               if Fhealth>-1 then
               if vx<0 then bitmap.LoadFromFile('sprites\zomb40.bmp')
               else bitmap.LoadFromFile('sprites\zomb40.bmp')
               else
                   case Fhealth of
                      -11:       bitmap.LoadFromFile('sprites\explo1.bmp');
                      -12:       bitmap.LoadFromFile('sprites\explo2.bmp');
                      -13:       bitmap.LoadFromFile('sprites\explo3.bmp');
                   end;
          end;
        cannon:
          begin
               Fv:=1;
               Fhitboxwidth:=35;
               Fhitboxheight:=35;
               if Fhealth>-1 then
               if vx<0 then bitmap.LoadFromFile('sprites\zomb52.bmp')
               else bitmap.LoadFromFile('sprites\zomb51.bmp')
               else
                   case Fhealth of
                      -11:       bitmap.LoadFromFile('sprites\explo1.bmp');
                      -12:       bitmap.LoadFromFile('sprites\explo2.bmp');
                      -13:       bitmap.LoadFromFile('sprites\explo3.bmp');
                   end;
          end;
        key:
          begin
               Fv:=0;
               Fhitboxwidth:=0;
               Fhitboxheight:=0;
               bitmap.LoadFromFile('sprites\key.bmp');
          end;
     end;
     self.canvas.draw(0,0,bitmap);
     bitmap.free;
end;
procedure NPC.moving;
begin
     Fx:=Fx+Fvx*Fv;
     Fy:=Fy+Fvy*Fv;
     left:=round(Fx)-width div 2;
     top:=round(Fy)-height div 2;
end;
