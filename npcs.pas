unit NPCs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, LCLType, ExtCtrls;
type Tstrela = (playstrela, playstrela2, enemstrela1, enemstrela2, enemstrela3, mina);


    strela = class(TGraphicControl)
  private
    Fshape: Tstrela;
    Fvx, Fvy, Fx, Fy, Fv:real;
    Fidle: boolean;
    Fhitboxwidth,Fhitboxheight,Fdamage:integer;
    procedure SetShap(Value: Tstrela);
    procedure Setidle(Value: boolean);
    procedure Setvx(Value: real);
    procedure Setvy(Value: real);
    procedure Setx(Value: real);
    procedure Sety(Value: real);
    procedure Setv(Value: real);
    procedure Setdamage(Value: integer);
  public
    procedure paint; override;
    procedure moving;
    property shape: Tstrela read Fshape write SetShap default playstrela;
    property idle: boolean read Fidle write Setidle;
    property vx: real read Fvx write Setvx;
    property vy: real read Fvy write Setvy;
    property x: real read Fx write Setx;
    property y: real read Fy write Sety;
    property v: real read Fv write Setv;
    property hitboxwidth: integer read Fhitboxwidth;
    property hitboxheight: integer read Fhitboxheight;
    property damage: integer read Fdamage write Setdamage;
  end;

    Tenemy = (mage,sorcerer,turret,paralyzer,cannon,boss1,key);

     NPC = class(TGraphicControl)
       private
         Fhealth,Fv,Fhitboxwidth,Fhitboxheight, Fshoottimer: integer;
         Fenemy: Tenemy;
         Fded,Fmoving:boolean;
         Fx,Fy,Fvx,Fvy:real;
         procedure Setvx(Value: real);
    	 procedure Setvy(Value: real);
    	 procedure Setx(Value: real);
	 procedure Sety(Value: real);
    	 procedure Setv(Value: integer);
         procedure Setenemy(Value: Tenemy);
         procedure Sethealth(Value: integer);
         procedure Setded(Value: boolean);
         procedure Setmoving(Value: boolean);
       public
         procedure paint; override;
         procedure incshoottimer;
         procedure Setshoottimer(Value: integer);
         procedure moving;
         property movable: boolean read Fmoving write Setmoving default False;
         property ded: boolean read Fded write Setded;
         property x: real read Fx write Setx;
         property y: real read Fy write Sety;
         property vx: real read Fvx write Setvx;
         property vy: real read Fvy write Setvy;
         property v: integer read Fv write Setv;
         property hitboxwidth: integer read Fhitboxwidth;
    	 property hitboxheight: integer read Fhitboxheight;
         property shoottimer: integer read Fshoottimer;
         property enemytype: Tenemy read Fenemy write Setenemy default mage;
         property health: integer read Fhealth write Sethealth;
     end;

  TPLAYER = class(TShape)
    private
      Faimx,Faimy:real;
      procedure Setaimx(Value:real);
      procedure Setaimy(Value:real);
    public
      procedure paint; override;
      property aimx: real read Faimx write Setaimx;
      property aimy: real read Faimy write Setaimy;
     end;

  TPlayerHealthbar = class(TGraphicControl)
    public
      procedure paint(value, maxvalue: integer);
  end;

implementation
procedure TPlayerHealthbar.paint(value, maxvalue: integer);
var bitmap:TBitmap;
begin
     bitmap:=TBitmap.create;
     width:=300;
     height:=20;
     bitmap.width:=width;
     bitmap.height:=height;
     with bitmap.canvas do
     	  begin
     	       brush.color:=clgreen;
     	       FillRect(0,0,round(300*value/maxvalue),20);
	       brush.color:=clgray;
	       fillrect(round(300*value/maxvalue),0,300,20);
               brush.style:=bsclear;
               font.color:=clwhite;
               font.Bold:=true;
               textout(5,3,inttostr(value));
               textout(295-bitmap.canvas.TextWidth(inttostr(maxvalue)),3,inttostr(maxvalue));
	  end;
     canvas.draw(0,0,bitmap);
     bitmap.Free;
end;

procedure TPLAYER.Setaimx(Value:real);
begin
     Faimx:=Value;
end;
procedure TPLAYER.Setaimy(Value:real);
begin
     Faimy:=Value;
end;

procedure TPLAYER.paint;
var bitmap:TBitmap;
begin
     bitmap:=Tbitmap.Create;
     bitmap.Height:=50;
     bitmap.Width:=50;
     bitmap.TransparentColor:=clblack;
     bitmap.TransparentMode:=tmfixed;
     bitmap.Transparent:=true;
     if (-Faimx<Faimy) and (Faimx<Faimy) then bitmap.LoadFromFile('sprites\playerskinfr.bmp');
     if (-Faimx>Faimy) and (Faimx<Faimy) then bitmap.LoadFromFile('sprites\playerskinle.bmp');
     if (-Faimx<Faimy) and (Faimx>Faimy) then bitmap.LoadFromFile('sprites\playerskinri.bmp');
     if (-Faimx>Faimy) and (Faimx>Faimy) then bitmap.LoadFromFile('sprites\playerskin.bmp');
     canvas.Draw(0,0,bitmap);
end;


{$I strela.inc}
{$I NPC.inc}


end.

