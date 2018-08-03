unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, Grids, Windows, math , NPCs;

type
  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Player: TPLAYER;
    Shape2: TShape;
    Timer1: TTimer;
    killanimation_timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word);
    procedure FormKeyUp(Sender: TObject; var Key: Word);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure killtimer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
var upp,downp,leftp,rightp:boolean;
  shoot:boolean;                                      //player controls
  paralyzed:boolean;
  paralyzetimer: 0..5;
  enemy:array of NPC;
  play_bullets: array [0..15] of strela;
  enem_bullets:array [0..100] of strela;
  play_health: TPlayerHealthbar;
  cooldown:integer = 0;                                       //player shoot cooldown
  healthpoints, maxhealthpoints:integer;
  bullplay,bullenem:integer; //počíta, kam dať ďalší náboj
  level: 1..25;
  levelcleared:array [1..25] of boolean;
  gotkey:boolean;
  killcount,enemies:integer;
  timer:integer;
  //animation_timer_delay:boolean;      //niečo ako delay()

{$R *.lfm}

{$I levels.inc}


procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
     randomize;
     level:=1;
     timer:=0;
     for i:=1 to 25 do
         levelcleared[i]:=false;
     paralyzed:=false;
     gotkey:=false;
     bullplay:=0;
     bullenem:=16;
     healthpoints:=400;
     maxhealthpoints:=400;
     play_health:=TPlayerHealthbar.create(nil);
     with play_health do
        begin
     	     Parent:=Form1;
             left:=300;
             top:=640;
     	     paint(healthpoints,maxhealthpoints);
	end;
     for i:=0 to length(play_bullets)-1 do
         begin
              play_bullets[i]:=strela.create(nil);
              with play_bullets[i] do
	           begin
                        parent:=Form1;
                        shape:=playstrela2;
                        top:=-50;
                        left:=-50;
                        idle:=true;
                        paint;
                   end;
         end;
     for i:=0 to length(enem_bullets)-1 do
         begin
              enem_bullets[i]:=strela.Create(nil);
              with enem_bullets[i] do
                   begin
                        parent:=Form1;
                        top:=-50;
                        left:=-50;
                        idle:=true;
                        paint;
		   end;
         end;
     Player:=TPLAYER.Create(Form1);
     Player.Width:=50;
     Player.Height:=50;
     Player.top:=350;
     Player.left:=700;
     Player.Parent:=Form1;
     Player.paint;
    changelevel;
end;


procedure proshoot;
begin
     if bullplay>length(play_bullets)-2 then
        bullplay:=0
     else
     	bullplay:=bullplay+1;
     with play_bullets[bullplay] do
	begin
           vx:=Form1.Player.aimx;
           vy:=Form1.Player.aimy;
           x:=Form1.Player.left+Form1.Player.width div 2+round(Form1.Player.aimx*15)-4;
           y:=Form1.Player.top+Form1.Player.height div 2+round(Form1.Player.aimy*15)-4;
           top:=round(y)-height div 2;
           left:=round(x)-width div 2;
           idle:=false;
        end;
end;
function fuhol(x,y:real;var tempc:real):real;
var tempa,tempb:integer;
begin
     tempa:=Form1.Player.left+Form1.Player.width div 2-round(x);
     tempb:=Form1.Player.top+Form1.Player.height div 2-round(y);
     tempc:=sqrt(sqr(tempa)+sqr(tempb));
     if tempc<>0 then
        fuhol:=arcsin(tempa/tempc);
     if tempb<0 then fuhol:=pi()-fuhol;
end;

procedure enemshoot(iter:NPC);
var i:integer; uhol,tempc:real;
begin
     if bullenem>length(enem_bullets)-6 then
        bullenem:=0;
       if iter<>nil then
        begin
             bullenem:=bullenem+1;
              uhol:=fuhol(iter.x,iter.y,tempc);
              case iter.enemytype of
                 mage:
                    with enem_bullets[bullenem] do
                        begin
                             uhol:=uhol+random(1000)/5000-0.1;
                             shape:=enemstrela2;
                             vx:=sin(uhol);
                             vy:=cos(uhol);
                             iter.vx:=sin(uhol);
                             iter.vy:=cos(uhol);
                             iter.Top:=iter.top+60;
                             iter.Top:=iter.top-60;
                             x:=iter.left+iter.width div 2;
                             y:=iter.top+iter.height div 2;
                             top:=round(y)-4;
                             left:=round(x)-4;
                             idle:=false;
		        end;
                 sorcerer:
                    for i:=1 to 3 do
                      begin
                           with enem_bullets[bullenem] do
                               begin
                                    shape:=enemstrela3;
                                    vx:=sin(uhol-i*0.2+0.4);
                                    vy:=cos(uhol-i*0.2+0.4);
                                    iter.vx:=sin(uhol);
                                    iter.vy:=cos(uhol);
                                    x:=iter.left+iter.width div 2;
                                    y:=iter.top+iter.height div 2;
                                    top:=round(y)-4;
                                    left:=round(x)-4;
                                    idle:=false;
                               end;
                           bullenem+=1;
                           iter.Top:=iter.top+60;
                           iter.Top:=iter.top-60;
                      end;
                 turret:
                    begin
                         if iter.shoottimer mod 4=1 then
                                   uhol+=pi/4;
                         for i:=1 to 4 do
                           begin
                                with enem_bullets[bullenem] do
                                    begin
                                         shape:=enemstrela1;
                                         vx:=sin(uhol+i*pi/2);
                                          vy:=cos(uhol+i*pi/2);
                                          x:=iter.left+iter.width div 2;
                                          y:=iter.top+iter.height div 2;
                                          top:=round(y)-4;
                                          left:=round(x)-4;
                                          idle:=false;
                                    end;
                                bullenem+=1;
                                iter.Top:=iter.top+60;
                                iter.Top:=iter.top-60;
                     end;
                    end;
                 cannon:
                   begin
                        with enem_bullets[bullenem] do
                        begin
                             shape:=mina;
                             vx:=sin(uhol);
                             vy:=cos(uhol);
                             iter.vx:=sin(uhol);
                             iter.vy:=cos(uhol);
                             iter.Top:=iter.top+60;
                             iter.Top:=iter.top-60;
                             x:=iter.left+iter.width div 2;
                             y:=iter.top+iter.height div 2;
                             top:=round(y)-4;
                             left:=round(x)-4;
                             idle:=false;
		        end;
                   end;
              end;
	end;
end;
procedure TForm1.killtimer(Sender: TObject);
var  i:integer;
begin
     for i:=0 to length(enemy)-1 do
       if enemy[i]<>nil then
            if enemy[i].ded then
               with enemy[i] do
                  begin
                       top:=top+60;
                       top:=top-60;      //kvôli paint funkcií
                       health:=health-1;
                       if health=-14 then
                          begin
                               form1.killanimation_timer.Enabled:=false;
                               Freeandnil(enemy[i]);
                               killcount+=1;
                               if killcount=enemies then
                                 begin
                                      levelcleared[level]:=true;
                                      changelevel;
                                 end;
                               Freeandnil(killanimation_timer);
                          end;
                  end;
end;

procedure Do_killanimation(iter:NPC);
begin
            if iter.health<1 then
               with iter do
                  begin
                       ded:=True;
                       health:=-10;         //podľa hodnoty robí animáciu
                  end;
     form1.killanimation_timer:=TTimer.Create(Form1);
     with form1.killanimation_timer do             //timer
          begin
               interval:=60;
               OnTimer:=@form1.killtimer;
               enabled:=true;
          end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word);
begin
     case Key of
         VK_W:upp:=true;
         VK_S:downp:=true;
         VK_A:leftp:=true;
         VK_D:rightp:=true;
         VK_SPACE:shoot:=true;
     end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word);
begin
     case Key of
         VK_W:upp:=false;
         VK_S:downp:=false;
         VK_A:leftp:=false;
         VK_D:rightp:=false;
         VK_SPACE:shoot:=false;
     end;
end;


procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var tempc:real; tempx,tempy:integer;
begin
     tempx:=X-form1.left;
     tempy:=Y-form1.Top;
     tempc:=sqrt(sqr(tempx-Player.Left-Player.width div 2)+sqr(tempy-Player.top-Player.height div 2));
     Player.aimx:=(tempx-Player.Left-Player.width div 2)/tempc;
     Player.aimy:=(tempy-Player.top-Player.height div 2)/tempc;
end;

procedure timer2;
var i:integer;	  			     	      	   //enemy timer
begin
     if paralyzed then
        paralyzetimer+=1;
     if paralyzetimer=5 then
        paralyzed:=false;
     for i:=0 to length(enemy)-1 do
       if enemy[i]<>nil then
       begin
            enemy[i].incshoottimer;
            case enemy[i].enemytype of
                mage:
                  if enemy[i].shoottimer<10 then
                     begin
                          enemshoot(enemy[i]);
                          enemy[i].movable:=false;
                     end
                     else
                        enemy[i].movable:=true;
                sorcerer:
                  if enemy[i].shoottimer=1 then
                     enemshoot(enemy[i]);
                turret:
                  if enemy[i].shoottimer=1 then
                      enemshoot(enemy[i]);
                cannon:
                  if enemy[i].shoottimer=1 then
                     begin
                         enemshoot(enemy[i]);
                         enemy[i].movable:=false;
                     end
                     else
                         if enemy[i].shoottimer=7 then
                            enemy[i].movable:=true;
            end;

            if (enemy[i].health<1) and (not enemy[i].ded) then
               begin
                    Do_killanimation(enemy[i]);
               end;
       end;
     play_health.paint(healthpoints, maxhealthpoints);
end;
procedure TForm1.Timer1Timer(Sender: TObject);
var i,j:integer; uhol,tempc:real;
begin
     form1.Canvas.Changing;
     if healthpoints < 0 then                           //smrť
        begin
             timer1.enabled:=false;
     	     ShowMessage('GAMEOVER');
	end;
     if GetAsynckeystate(MK_LBUTTON)<>0 then
        shoot:=true
     else
        shoot:=false;
     image1mousemove(nil,[],mouse.CursorPos.X,mouse.CursorPos.Y);
     if cooldown<50 then
     	cooldown:=cooldown+1;
     if upp and (image1.Canvas.Pixels[Player.left,Player.top-4]=clgray) and not paralyzed then Player.top:=Player.top-4;
     if downp and (image1.Canvas.Pixels[Player.left,Player.top+Player.height+4]=clgray) and not paralyzed then Player.top:=Player.top+4;
     if leftp and (image1.Canvas.Pixels[Player.left-4,Player.top]=clgray) and not paralyzed then Player.left:=Player.left-4;
     if rightp and (image1.Canvas.Pixels[Player.left+Player.width+4,Player.top]=clgray) and not paralyzed then Player.left:=Player.left+4;
     Player.Top:=player.top+60;
     Player.Top:=player.top-60;
     if shoot and (cooldown>20) then                                 //fire rate
        begin
              proshoot;
              cooldown:=0;
        end;
     if Player.left<5 then                                       //prechod do levelov
          begin
               level+=1;
               Player.left:=form1.width-Player.width-100;
               changelevel;
          end;
     if Player.top<5 then
        begin
             level+=5;
             Player.top:=form1.height-Player.Height-100;
             changelevel;
        end;
     if Player.left>995-Player.width then                                       //prechod do levelov
          begin
               level-=1;
               Player.left:=100;
               changelevel;
          end;
     if Player.top>695-Player.height then
        begin
             level-=5;
             Player.top:=100;
             changelevel;
        end;
     for i:=0 to length(play_bullets)-1 do                       //pohyb hráčových nábojov
        begin
        if not play_bullets[i].idle then
        with play_bullets[i] do
     	   begin
              moving;
              if (x+width div 2>image1.Width-100) or
              	(x+width div 2<100) or
                (y+height div 2>image1.height-100) or
                (y+height div 2<100) then
                          begin
                               x:=0;
                               y:=0;
                               vx:=0;
                               vy:=0;
                               top:=-50;
                               left:=-50;
                               idle:=true;
                          end
                else
                   for j:=0 to length(enemy)-1 do
                    if (enemy[j]<>nil) and (enemy[j].enemytype<>key) then
                      if (x+hitboxwidth>enemy[j].x-enemy[j].hitboxwidth) and
                   (x-hitboxwidth<enemy[j].x+enemy[j].hitboxwidth) and
                   (y+hitboxheight>enemy[j].y-enemy[j].hitboxheight) and
                   (y-hitboxheight<enemy[j].y+enemy[j].hitboxheight) then
                   	begin
                             begin
                                  x:=0;
                                  y:=0;
                                  vx:=0;
                                  vy:=0;
                                  top:=-50;
                                  left:=-50;
                                  idle:=true;
                             end;
                             if enemy[j].health>1 then
                                enemy[j].health:=enemy[j].health-damage;
			end;
	   end;
        end;
     for i:=0 to length(enem_bullets)-1 do                    //pohyb ostatných nábojov
        if not enem_bullets[i].idle then
        with enem_bullets[i] do
     	   begin
              moving;
              if (shape=mina) then
              begin
                 if damage=-2 then
                 begin
                      fuhol(x,y,tempc);
                      if tempc<96 then
                         healthpoints-=90;
                 end;
                 if damage=-16 then
                 begin
                      x:=0;
                      y:=0;
                      vx:=0;
                      vy:=0;
                      top:=-50;
                      left:=-50;
                      damage:=0;
                      idle:=true;
                 end;
              end;
              if (x+width div 2>image1.Width-100) or
              	(x-width div 2<100) or
                (y+height div 2>image1.height-100) or
                (y-height div 2<100) then
                    if enem_bullets[i].shape=mina then
                       enem_bullets[i].v:=0
                       else
                        begin
                             x:=0;
                             y:=0;
                             vx:=0;
                             vy:=0;
                             top:=-50;
                             left:=-50;
                             idle:=true;
                          end
                else
                  if (x+hitboxwidth>Player.left) and
                   (x-hitboxwidth<Player.left+Player.width) and
                   (y+hitboxheight>Player.top) and
                   (y-hitboxheight<Player.top+Player.height) and (enem_bullets[i].shape<>mina) then
                   begin
                        healthpoints-=enem_bullets[i].damage;
                        play_health.paint(healthpoints,maxhealthpoints);
                        begin
                             x:=0;
                             y:=0;
                             vx:=0;
                             vy:=0;
                             top:=-50;
                             left:=-50;
                             idle:=true;
                        end;
		   end;
	   end;
     for i:=0 to length(enemy)-1 do
         if (enemy[i]<>nil) and enemy[i].movable then
            begin
                 uhol:=fuhol(enemy[i].x,enemy[i].y,tempc);
                 if (enemy[i].enemytype=paralyzer) and (tempc<40) then
                    begin
                         paralyzed:=true;
                         paralyzetimer:=0;
                    end;
                 if (enemy[i].enemytype=key) and (tempc<20) and (enemy[i].health>0) then
                    begin
                         gotkey:=true;
                         enemy[i].health:=-2;
                         Do_killanimation(enemy[i]);
                         continue;
                    end;
                 enemy[i].vx:=sin(uhol);
                 enemy[i].vy:=cos(uhol);
                 enemy[i].moving;
            end;
     timer+=1;
     if timer=14 then
        begin
             timer2;
             timer:=0;
        end;
     form1.canvas.Changed;
end;


end.

