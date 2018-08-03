procedure strela.SetShap(Value: Tstrela);
begin
     Fshape:=Value;
     case Value of
        playstrela:
          begin
               Fv:=9;
               Fdamage:=10;
               Fhitboxwidth:=4;
               Fhitboxheight:=4;
          end;
        playstrela2:
          begin
               Fv:=10;
               Fdamage:=15;
               Fhitboxwidth:=6;
               Fhitboxheight:=6;
          end;
        enemstrela1:
          begin
               Fdamage:=30;
               Fv:=4;
               Fhitboxwidth:=4;
               Fhitboxheight:=4;
          end;
        enemstrela2:
          begin
               Fv:=15;
               Fdamage:=10;
               Fhitboxwidth:=5;
               Fhitboxheight:=5;
          end;
        enemstrela3:
          begin
               Fv:=4;
               Fdamage:=40;
               Fhitboxwidth:=14;
               Fhitboxheight:=14;
          end;
        mina:
          begin
               Fv:=10;
               Fdamage:=0;
          end;
     end;
     case Fshape of
        playstrela,enemstrela1:begin Height:=10; Width:=10; end;
        playstrela2:begin Height:=32; Width:=32; end;
        enemstrela2,enemstrela3,mina:begin Height:=32; Width:=32; end;
     end;
end;
procedure strela.Setidle(Value: boolean);
begin
     Fidle:=Value;
end;

procedure strela.Setvx(Value: real);
begin
     Fvx:=Value;
end;
procedure strela.Setvy(Value: real);
begin
     Fvy:=Value;
end;
procedure strela.Setx(Value: real);
begin
     Fx:=Value;
end;
procedure strela.Sety(Value: real);
begin
     Fy:=Value;
end;
procedure strela.Setv(Value: real);
begin
     Fv:=Value;
end;
procedure strela.Setdamage(Value: integer);
begin
     Fdamage:=Value;
end;

procedure strela.paint;
var bitmap:TBitmap;
  p:array [1..4] of TPoint;
begin
     bitmap:=TBitmap.create;
     with bitmap do
     begin
     	bitmap.TransparentColor:=clblack;
     	bitmap.Transparent:=true;
     	bitmap.transparentmode:=tmFixed;
     end;
     bitmap.height:=Height;
     bitmap.width:=Width;
     case Fshape of
        playstrela:
          begin
          	with bitmap.canvas do
                        begin
                             pen.color:=$000001;
                             brush.color:=clgray;
                             ellipse(0,0,bitmap.width,bitmap.height);
                        end;
          end;
        playstrela2:
          begin
               with bitmap.canvas do
                       begin
                            pen.color:=$FF00AA;
                            brush.color:=$AA00FF;
                            pen.width:=3;
                            p[1].x:=round(Fvx*16+16);
                            p[1].y:=round(Fvy*16+16);
                            p[2].x:=round(-Fvy*8+16);
                            p[2].y:=round(Fvx*8+16);
                            p[3].x:=round(Fvy*8+16);
                            p[3].y:=round(-Fvx*8+16);
                            p[4]:=p[1];
                            polygon(p);
                       end;
          end;
        enemstrela1:
          begin
               with bitmap.canvas do
                       	begin
                             pen.color:=$E63CC8;
                             brush.color:=clred;
                             ellipse(0,0,bitmap.width,bitmap.height);
			end;
	  end;
        enemstrela2:
          begin
               with bitmap.canvas do
                        begin
                             pen.color:=$0024AE;
                             pen.Width:=8;
                             p[1].x:=bitmap.width div 2-round(Fvx*15);
                             p[1].y:=bitmap.height div 2-round(Fvy*15);
                             p[2].x:=bitmap.width div 2+round(Fvx*15);
                             p[2].y:=bitmap.height div 2+round(Fvy*15);
                             line(p[1],p[2]);
                             pen.color:=clred;
                             pen.width:=3;
                             line(p[1],p[2]);
			end;
	  end;
        enemstrela3:
          begin
               with bitmap.canvas do
                        begin
                             pen.color:=$005400;
                             pen.Width:=8;
                             p[1].x:=bitmap.width div 2-round(Fvx*15);
                             p[1].y:=bitmap.height div 2-round(Fvy*15);
                             p[2].x:=bitmap.width div 2+round(Fvx*15);
                             p[2].y:=bitmap.height div 2+round(Fvy*15);
                             p[3].x:=bitmap.width div 2-round(-Fvy*15);
                             p[3].y:=bitmap.height div 2-round(Fvx*15);
                             p[4].x:=bitmap.width div 2+round(-Fvy*15);
                             p[4].y:=bitmap.height div 2+round(Fvx*15);
                             line(p[1],p[2]);
                             line(p[3],p[4]);
                             pen.color:=$64B864;
                             pen.width:=3;
                             line(p[1],p[2]);
                             line(p[3],p[4]);
			end;
	  end;
        mina:
          begin
               if Fdamage>-1 then bitmap.LoadFromFile('sprites\bomba.bmp')
                  else
                    begin
                        height:=80; width:=80;
                        left:=round(Fx)-width div 2;
                        top:=round(Fy)-height div 2;
                        bitmap.Width:=width;
                        bitmap.height:=height;
                        case Fdamage of
                            -5..-1:
                             bitmap.LoadFromFile('sprites\explo1.bmp');
                            -10..-6:
                             bitmap.LoadFromFile('sprites\explo2.bmp');
                            -15..-11:
                             bitmap.LoadFromFile('sprites\explo3.bmp');
                        end;
                    end;
          end;
          end;
     canvas.draw(0,0,bitmap);
     bitmap.Free;
end;
procedure strela.moving;
begin
     Fx:=Fx+Fvx*Fv;
     Fy:=Fy+Fvy*Fv;
     if Fshape=mina then
        begin
            Fv:=abs(Fv-0.27);
            if Fv<0.28 then
               begin
                    Fdamage-=1;
                    top:=top-60;
                    top:=top+60;
               end;
        end;
     left:=round(Fx)-width div 2;
     top:=round(Fy)-height div 2;
end;
