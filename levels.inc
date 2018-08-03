procedure changelevel;
var i,c,g:integer; f:text;
begin
     for i:=0 to length(enemy)-1 do
              if enemy[i]<>nil then
                 Freeandnil(enemy[i]);
     for i:=0 to length(enem_bullets)-1 do
              begin
                   enem_bullets[i].Top:=-50;
                   enem_bullets[i].left:=-50;
                   enem_bullets[i].idle:=true;
              end;
     for i:=0 to length(play_bullets)-1 do
              begin
                   play_bullets[i].top:=-50;
                   play_bullets[i].left:=-50;
                   play_bullets[i].idle:=true;
              end;
     with form1.image1.canvas do
     begin
           brush.color:=$1E1E1E;
           fillrect(form1.clientrect);
           brush.color:=clgray;
           fillrect(100,100,width-100,height-100);
     end;
     assignfile(f,'levels.txt');
     reset(f);
     for i:=1 to level-1 do
              readln(f);
     read(f,c);
     with form1.image1.canvas do
     begin
           if not levelcleared[level] then brush.color:=clolive;
           if c mod 2=1 then
              fillrect(width-100,height div 2-70,width,height div 2+70);
           c:=c div 2;
           if c mod 2=1 then
              fillrect(width div 2-70,height-100,width div 2+70, height);
           c:=c div 2;
           if c mod 2=1 then
              fillrect(0,height div 2-70,100,height div 2+70);
           c:=c div 2;
           if c mod 2=1 then
              fillrect(width div 2-70,0,width div 2+70,100);
     end;
     if not gotkey then
        with form1.image1.canvas do
        begin
             brush.color:=$010101;
             c:=c div 2;
             if c mod 2=1 then
                fillrect(width-100,height div 2-70,width,height div 2+70);
             c:=c div 2;
             if c mod 2=1 then
                fillrect(width div 2-70,height-100,width div 2+70, height);
             c:=c div 2;
             if c mod 2=1 then
                fillrect(0,height div 2-70,100,height div 2+70);
             c:=c div 2;
             if c mod 2=1 then
                fillrect(width div 2-70,0,width div 2+70,100);
        end;
     read(f,c);
     if not levelcleared[level] then
     begin
           if c=0 then
            begin
                 levelcleared[level]:=true;
                 changelevel;
            end;
           enemies:=c;
           killcount:=0;
           Setlength(enemy,c);
           for i:=0 to c-1 do
                    begin
                         enemy[i]:=NPC.Create(nil);
                         with enemy[i] do
                              begin
                                   read(f,g);
                                   case g of
                                        1:enemytype:=mage;
                                        2:enemytype:=sorcerer;
                                        3:enemytype:=turret;
                                        4:enemytype:=paralyzer;
                                        5:enemytype:=cannon;
                                        6:enemytype:=boss1;
                                        7:enemytype:=key;
                                   end;
                                   parent:=Form1;
                                   read(f,g);
                                   x:=g;
                                   read(f,g);
                                   y:=g;
                                   read(f,g);
                                   health:=g;
                                   if enemytype in [paralyzer,sorcerer,key] then
                                      movable:=true;
                                   paint;
                                   left:=round(x)-width div 2;
                                   top:=round(y)-height div 2;
                                   Setshoottimer(random(19));
                              end;
                    end;
     end;
     closefile(f);
end;
