unit archivos_turnos;

interface
         uses crt, archivos_usuarios, archivos_autos;

         type
             st20=string[20];
             st30=string[30];
             st100=string[100];

             r_turno=record
                     dia_hora:st20;
                     codigo_turno:integer;
                     dni_usuario:longint;
                     //anio:integer;
                     //descr:st100;
                     //material:st20;
                     //estilo:st20;
                     motivo:st20;
                     //altura:real;
                     //peso:real;
                     //completo:st2;
                     //can_partes:integer;
                     patente:st20;
                     estado_turno:boolean;
                     end;
         t_turnos = file of r_turno;

         procedure abrir_archivo_turno(var arch:t_turnos; nom_arch:string);
         procedure leer_turno(var arch:t_turnos; nom_arch:string; var pos:integer; var dato_leido:r_turno);
         procedure guardar_turno(var arch:t_turnos ; nom_arch:string ; var escribir_dato:r_turno);
         procedure modificar_turno(var arch:t_turnos; var arch_u:t_usuarios ; var arch_a:t_autos ;nom_arch:string; nom_arch_u:string; nom_arch_a:string ;pos:integer);
         procedure busqueda_turno(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
        // procedure busqueda_motivo_turno(var arch:t_turnos; nom_arch:string; buscado:st20; var pos:integer);
        // procedure busqueda_codigo_turno(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
         procedure alta_turno(var arch:t_turnos; var arch_u:t_usuarios; var arch_a:t_autos; nom_arch_a:string ;nom_arch_u:string; nom_arch:string; var reg:r_turno);
         procedure baja_turno(var arch:t_turnos; nom_arch:string; var pos:integer);
         procedure alta_estado_turno(var arch:t_turnos; nom_arch:string; var pos:integer);
         procedure busqueda_patente(var arch:t_autos; nom_arch_a:string; buscado:st20; var pos:integer);
        // procedure busqueda_dni_usuario(var arch:t_turnos; nom_arch:string; buscado:st8; var pos:integer);
         //procedure estadistica_museo(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
         procedure eliminar_archivo_turno(var arch:t_turnos);

implementation
              procedure abrir_archivo_turno(var arch:t_turnos;  nom_arch:string); //Abre archivo de motivo texto en modo escritura que borra el contenido y escribe
              begin
                   assign(arch, nom_arch);
                   {$I-}                           //{$I-} directiva para deshabilitar mensajes de error de el sistema operativo.
                        reset(arch);
                   {$I-}
                   if ioresult<>0 then
                      rewrite(arch); //Si la directiva {$I-} devuelve un valor distinto de cero quiere decir que no existe el fichero o hay un problema.                   close(arch);
                   //close(arch);
              end;
              procedure leer_turno(var arch:t_turnos; nom_arch:string; var pos:integer; var dato_leido:r_turno); //Lee archivo de motivo texto
              begin
                   abrir_archivo_turno(arch, nom_arch);
                   seek(arch, pos);                  //seek posiciona el puntero en la posicion que indica el segundo parametro
                   read(arch, dato_leido);        //recorre el archivo y lee secuencialmente
                   close(arch);
              end;

              procedure guardar_turno(var arch:t_turnos ; nom_arch:string ; var escribir_dato:r_turno); //Escribe en archivo de motivo texto
              var
                 reg_control:r_turno;
                 pos:integer;
              begin
                   pos:=0;
                   leer_turno(arch,nom_arch, pos, reg_control);
                   abrir_archivo_turno(arch, nom_arch);
                   seek(arch, filesize(arch));
                   if filepos(arch)=1 then
                      begin
                           if reg_control.codigo_turno=0 then         //
                              begin                                 // Debido a la inicializacion la posicion 0 ya esta ocupada
                                   seek(arch, 0);                   // Cuando filepos(Que indica la posicion el puntero en el archivo) sea 1
                                   write(arch, escribir_dato);      // los datos que hay que guardar hay que guardarlas en la posicion 0
                              end                                   //
                                 else
                                     begin
                                          seek(arch, filesize(arch));
                                          write(arch, escribir_dato);
                                     end;
                      end
                         else
                             begin
                                   seek(arch, filesize(arch));
                                   write(arch, escribir_dato);         //Escribe en el archivo lo que hay en escribir dato
                             end;         //Escribe en el archivo lo que hay en escribir dato
                   close(arch);
              end;

              procedure modificar_turno(var arch:t_turnos; var arch_u:t_usuarios ; var arch_a:t_autos ;nom_arch:string; nom_arch_u:string; nom_arch_a:string ;pos:integer);
              var
                 reg:r_turno;
                 control:char;
                 validacion,x,y,i:integer;
                 posi:integer;
                 reg_u:registro_usuario;
                 reg_a:r_auto;
              begin
                   clrscr;
                   leer_turno(arch, nom_arch, pos, reg);
                   if reg.estado_turno then
                   begin
                   clrscr;
                 textcolor (blue);
                 x:=20;
                 y:=2;
                 For i:=1 to 14 do
                 Begin
                      Gotoxy (x,y);
                      Writeln('|');
                      inc (y);
                 End;
                 x:=60;
                 y:=2;
                 For i:=1 to 14 do
                 Begin
                      Gotoxy (x,y);
                      Writeln('|');
                      inc (y);
                 End;
                 x:=21;
                 y:=15;
                 For i:=1 to 41 do
                 Begin
                      Gotoxy (x,y);
                      Writeln ('_');
                      x:=x+2
                 End;
                 x:=102;
                 y:=2;
                 For i:=1 to 14 do
                 Begin
                      Gotoxy (x,y);
                      Writeln('|');
                      inc (y);
                 End;
                 x:=21;
                 y:=1;
                 For i:=1 to 41 do
                 Begin
                      Gotoxy (x,y);
                      Writeln ('_');
                      x:=x+2
                 End;
                   textcolor (white);
                   gotoxy(21,4);
                   writeln('Fecha del turno: ', reg.dia_hora);
                   gotoxy(21,5);
                   writeln('DNI del usuario: ', reg.dni_usuario);
                   gotoxy(21,6);
                   writeln('motivo: ', reg.motivo);
                   gotoxy(21,7);
                   writeln('Patente auto: ', reg.patente);
                   gotoxy(61,2);
                   writeln('Elegir la opcion para modificar ');
                   gotoxy(61,3);
                   writeln();
                   gotoxy(61,4);
                   writeln('1: Fecha del turno: ');
                   gotoxy(61,5);
                   writeln('2: DNI del Usuario: ');
                   gotoxy(61,6);
                   writeln('3: motivo: ');
                   gotoxy(61,7);
                   writeln('4: Patente auto: ');
                   gotoxy(61,13);
                   writeln('ESC: Salir');
                   repeat
                         gotoxy(21,16);
                         writeln('                                                                                   ');
                         gotoxy(21,13);
                         control:=readkey;
                         keypressed;
                         case control of
                         '1':begin
                                  gotoxy(81,4);
                                   writeln('                   ');
                                   gotoxy(81,4);
                                  readln(reg.dia_hora);
                                  gotoxy(38,4);
                                  writeln('                ');
                                  gotoxy(40,4);
                                  writeln(reg.dia_hora);
                                  abrir_archivo_turno(arch, nom_arch);
                                  seek(arch, pos);
                                  write(arch, reg);
                                  close(arch);
                             end;
                         '2':begin
                                  gotoxy(81,5);
                                  writeln('                  ');
                                  gotoxy(81,5);
                                  {$I-}
                                       readln(reg.dni_usuario);
                                  {$I+}
                                  validacion:=ioresult();
                                  if validacion=0 then
                                     begin
                                          busqueda_dni_usuario(arch_u, nom_arch_u, reg.dni_usuario, posi);
                                          if posi>-1 then
                                             begin
                                                  leer_usuario(arch_u, nom_arch_u, posi, reg_u);
                                                  if reg_u.estado_usuario then
                                                     begin
                                                          gotoxy(38,5);
                                                          writeln('                     ');
                                                          gotoxy(40,5);
                                                          writeln(reg.dni_usuario);
                                                          abrir_archivo_turno(arch, nom_arch);
                                                          seek(arch, pos);
                                                          write(arch, reg);
                                                          close(arch);
                                                     end
                                                        else
                                                            begin
                                                                 gotoxy(21,16);
                                                                 writeln('                                                                   ');
                                                                 gotoxy(21,16);
                                                                 Textcolor(red);
                                                                 writeln('El usuario esta dado de baja. Debe darlo de alta primero');
                                                                 Textcolor(white);
                                                                 readkey;
                                                            end;
                                             end
                                                else
                                                    begin
                                                         gotoxy(21,16);
                                                         writeln('                                                                   ');
                                                         textcolor(red);
                                                         gotoxy(21,16);
                                                         writeln('El usuario no esta registrado. Debe registrar el usuario primero');
                                                         textcolor(white);
                                                         readkey;
                                                    end;
                                     end
                                        else
                                            begin
                                                 gotoxy(21,16);
                                                 writeln('                                                                   ');
                                                 textcolor(red);
                                                 gotoxy(21,16);
                                                 writeln('Debe ingresar solo numeros. Presione enter para intentar de nuevo');
                                                 textcolor(white);
                                                 readkey;
                                            end;
                             end;
                         '3':begin
                                  gotoxy(72,8);
                                  writeln('                    ');
                                  textcolor(yellow);
                                  gotoxy(21,16);
                                  writeln('Presione "s":Service ; "m":Motor; "f":Frenos');
                                  textcolor(white);
                                  gotoxy(81,6);
                                  writeln('                       ');
                                  gotoxy(81,6);
                                  reg.motivo:=readkey;
                                  keypressed;
                                  if (reg.motivo='s') or (reg.motivo='m') or (reg.motivo='f') then
                                     begin
                                          if reg.motivo='s' then
                                             begin
                                                  reg.motivo:='Service';
                                                  gotoxy(81,6);
                                                  writeln(reg.motivo);
                                                  gotoxy(21,11);
                                                  writeln('                       ');
                                                  gotoxy(21,12);
                                                  writeln('                       ');
                                                  gotoxy(61,11);
                                                  writeln('                      ');
                                                  gotoxy(61,12);
                                                  writeln('                      ');
                                                  abrir_archivo_turno(arch, nom_arch);
                                                  seek(arch, pos);
                                                  write(arch, reg);
                                                  close(arch);
                                             end
                                             else
                                                 if reg.motivo='m' then
                                                    begin
                                                         reg.motivo:='Motor';
                                                         gotoxy(81,6);
                                                         writeln(reg.motivo);
                                                         abrir_archivo_turno(arch, nom_arch);
                                                         seek(arch, pos);
                                                         write(arch, reg);
                                                         close(arch);
                                                    end
                                                    else
                                                        begin
                                                             reg.motivo:='Frenos';
                                                             gotoxy(81,6);
                                                             writeln(reg.motivo);
                                                             abrir_archivo_turno(arch, nom_arch);
                                                             seek(arch, pos);
                                                             write(arch, reg);
                                                             close(arch);
                                                        end;
                                          gotoxy(29,6);
                                          writeln('                       ');
                                          gotoxy(40,6);
                                          writeln(reg.motivo);
                                       end
                                          else
                                              begin
                                                   gotoxy(21,16);
                                                   writeln('                                      ');
                                                   gotoxy(21,16);
                                                   textcolor(red);
                                                   writeln('Letra erronea');
                                                   textcolor(white);
                                                   readkey;
                                              end;

                             end;
                         '4':begin
                                  gotoxy(81,7);
                                  writeln('                    ');
                                  gotoxy(81,7);
                                  {$I-}
                                       readln(reg.patente);
                                  {$I+}
                                  validacion:=ioresult();
                                  if validacion=0 then
                                     begin
                                          busqueda_patente(arch_a, nom_arch_a, reg.patente, posi);
                                          if posi>-1 then
                                             begin
                                                  leer_auto(arch_a, nom_arch_a, posi, reg_a);
                                                  if reg_a.estado_auto then
                                                     begin
                                                          gotoxy(34,7);
                                                          writeln('                     ');
                                                          gotoxy(40,7);
                                                          writeln(reg.patente);
                                                          abrir_archivo_turno(arch, nom_arch);
                                                          seek(arch, pos);
                                                          write(arch, reg);
                                                          close(arch);
                                                     end
                                                        else
                                                            begin
                                                                 gotoxy(21,16);
                                                                 writeln('                                                                   ');
                                                                 gotoxy(21,16);
                                                                 Textcolor(red);
                                                                 writeln('La patente esta dada de baja. Debe darlo de alta primero');
                                                                 Textcolor(white);
                                                                 readkey;
                                                            end;
                                             end
                                                else
                                                    begin
                                                         gotoxy(21,16);
                                                         writeln('                                                                   ');
                                                         gotoxy(21,16);
                                                         Textcolor(red);
                                                         writeln('La patente no esta registrada. Debe registrar el auto primero');
                                                         Textcolor(white);
                                                         readkey;
                                                    end;
                                     end
                                        else
                                            begin
                                                 gotoxy(21,16);
                                                 writeln('                                                                   ');
                                                 gotoxy(21,16);
                                                 Textcolor(red);
                                                 writeln('Debe ingresar solo numeros. Presione enter para intentar de nuevo');
                                                 Textcolor(white);
                                                 readkey;
                                            end;
                             end;
                         end;
                   until control=#27;
                   end
                      else
                          begin
                               textcolor(red);
                               writeln('El turno esta dado de baja');
                               textcolor(white);
                               readkey;
                          end;
              end;

              procedure busqueda_turno(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
              var
                 reg_aux:r_turno;
                 i:integer;
              begin
                   i:=0;
                   pos := -1;
                   abrir_archivo_turno(arch, nom_arch);
                   while not eof(arch) do
                   begin
                        read(arch, reg_aux);
                        if reg_aux.codigo_turno = buscado then
                           begin
                                pos:=i;
                           end;
                        i:=i+1;
                        seek(arch, i);
                   end;
                   close(arch);
              end;

            //   procedure busqueda_motivo_turno(var arch:t_turnos; nom_arch:string; buscado:st20; var pos:integer);
            //   var
            //      reg_aux:r_turno;
            //      i:integer;
            //   begin
            //        i:=0;
            //        pos := -1;
            //        abrir_archivo_turno(arch, nom_arch);
            //        while not eof(arch) do
            //        begin
            //             read(arch, reg_aux);
            //             if reg_aux.motivo = buscado then
            //                begin
            //                     pos:=i;
            //                end;
            //             i:=i+1;
            //             seek(arch, i);
            //        end;
            //        close(arch);
            //   end;

            //   procedure busqueda_dni_usuario(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
            //   var
            //      reg_aux:r_turno;
            //      i,y,z,x:integer;
            //   begin
            //        y:=4;
            //        i:=0;
            //        pos := -1;
            //        gotoxy (61,4);
            //        writeln('Obras: ');
            //        abrir_archivo_turno(arch, nom_arch);
            //        while not eof(arch) do
            //        begin
            //             read(arch, reg_aux);
            //             if reg_aux.dni_usuario = buscado then
            //                begin
            //                     pos:=1;
            //                     if reg_aux.estado_turno then
            //                        begin
            //                             gotoxy (69,y);
            //                             writeln('* ', reg_aux.dia_hora);
            //                             y:=y+1;
            //                        end;
            //                end;
            //             i:=i+1;
            //             seek(arch, i);
            //        end;
            //        textcolor (blue);
            //        x:=51;
            //        z:=2;
            //        For i:=1 to y+2 do
            //            Begin
            //                 Gotoxy (x,z);
            //                 Writeln('|');
            //                 inc (z);
            //            End;
            //        x:=52;
            //        z:=y+3;
            //        For i:=1 to 23 do
            //            Begin
            //                 Gotoxy (x,z);
            //                 Writeln ('_');
            //                 x:=x+2
            //            End;
            //        x:=97;
            //        z:=2;
            //        For i:=1 to y+2 do
            //            Begin
            //                 Gotoxy (x,z);
            //                 Writeln('|');
            //                 inc (z);
            //            End;
            //        x:=52;
            //        z:=1;
            //        For i:=1 to 23 do
            //            Begin
            //                 Gotoxy (x,z);
            //                 Writeln ('_');
            //                 x:=x+2
            //            End;
            //        textcolor (white);
            //        close(arch);
            //        textcolor(yellow);
            //        gotoxy(51, y+4);
            //        writeln('Presione enter para salir.');
            //        textcolor(white);
            //   end;

          //    procedure busqueda_codigo_turno(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
          //     var
          //        reg_aux:r_turno;
          //        i:integer;
          //     begin
          //          i:=0;
          //          pos :=-1;
          //          abrir_archivo_turno(arch, nom_arch);
          //          while not eof(arch) do
          //          begin
          //               read(arch, reg_aux);
          //               if reg_aux.codigo_turno = buscado then
          //                  begin
          //                       pos:=i;
          //                  end;
          //               i:=i+1;
          //               seek(arch, i);
          //          end;
          //          close(arch);
          //     end;

          procedure busqueda_patente(var arch:t_autos; nom_arch_a:string; buscado:st20; var pos:integer);
              var
                 reg_aux:r_auto;
                 i:integer;
              begin
                   i:=0;
                   pos:=-1;
                   abrir_archivo_auto(arch, nom_arch_a);
                   while not eof(arch) do
                   begin
                        read(arch, reg_aux);
                        if reg_aux.patente = buscado then
                           begin
                                pos:=i;
                           end;
                        i:=i+1;
                        seek(arch, i);
                   end;
                   close(arch);
              end;


          //     procedure busqueda_patente(var arch:t_turnos; nom_arch:string; buscado:st20; var pos:integer);
          //     var
          //        reg_aux:r_turno;
          //        i,y,x,z:integer;
          //     begin
          //      //     y:=6;
          //      //     i:=0;
          //          pos := -1;
          //          abrir_archivo_turno(arch, nom_arch);
          //      //     gotoxy (61,6);
          //      //     writeln('Patente: ');
          //          while not eof(arch) do
          //          begin
          //               read(arch, reg_aux);
          //               if reg_aux.patente = buscado then
          //                  begin
          //                       if reg_aux.estado_turno then
          //                       begin
          //                            gotoxy (68,y);
          //                            writeln('*', reg_aux.dia_hora);
          //                            pos:=1;
          //                          //   y:=y+1;
          //                       end;
          //                  end;
          //          i:=i+1;
          //          seek(arch, i);
          //          end;
          //          textcolor (blue);
          //          x:=51;
          //          z:=2;
          //          For i:=1 to y+2 do
          //              Begin
          //                   Gotoxy (x,z);
          //                   Writeln('|');
          //                   inc (z);
          //              End;
          //          x:=52;
          //          z:=y+3;
          //          For i:=1 to 23 do
          //              Begin
          //                   Gotoxy (x,z);
          //                   Writeln ('_');
          //                   x:=x+2
          //              End;
          //          x:=97;
          //          z:=2;
          //          For i:=1 to y+2 do
          //              Begin
          //                   Gotoxy (x,z);
          //                   Writeln('|');
          //                   inc (z);
          //              End;
          //          x:=52;
          //          z:=1;
          //          For i:=1 to 23 do
          //              Begin
          //                   Gotoxy (x,z);
          //                   Writeln ('_');
          //                   x:=x+2
          //              End;
          //          textcolor (white);
          //          close(arch);
          //          gotoxy(51,y+4);
          //          textcolor(yellow);
          //          writeln('Presione enter para salir.');
          //          textcolor(white);
          //          readkey;
          //     end;

            //   procedure estadistica_museo(var arch:t_turnos; nom_arch:string; buscado:integer; var pos:integer);
            //   var
            //      reg_aux:r_turno;
            //      i:integer;
            //      x,y,co:integer;
            //      cp:integer;
            //      ce:integer;
            //      cf:integer;
            //      pp:real;
            //      pe:real;
            //      pf:real;
            //   begin
            //        i:=0;
            //        cp:=0;
            //        ce:=0;
            //        cf:=0;
            //        co:=0;
            //        pos := -1;
            //        abrir_archivo_turno(arch, nom_arch);
            //        while not eof(arch) do
            //        begin
            //             read(arch, reg_aux);
            //             if reg_aux.patente = buscado then
            //                begin
            //                     if reg_aux.estado_turno then
            //                     begin
            //                          pos:=1;
            //                          co:=co+1;
            //                          if (reg_aux.motivo='Pintura') then
            //                             cp:=cp+1
            //                             else
            //                             if (reg_aux.motivo='Estatua') then
            //                                ce:=ce+1
            //                                else
            //                                    cf:=cf+1;
            //                 end;
            //                end;
            //             i:=i+1;
            //             seek(arch, i);
            //        end;
            //        if pos=1 then
            //           begin
            //                textcolor (blue);
            //                x:=49;
            //                y:=2;
            //                For i:=1 to 8 do
            //                    Begin
            //                         Gotoxy (x,y);
            //                         Writeln('|');
            //                         inc (y);
            //                    End;
            //                x:=50;
            //                y:=9;
            //                For i:=1 to 20 do
            //                    Begin
            //                         Gotoxy (x,y);
            //                         Writeln ('_');
            //                         x:=x+2
            //                    End;
            //                x:=89;
            //                y:=2;
            //                For i:=1 to 8 do
            //                    Begin
            //                         Gotoxy (x,y);
            //                         Writeln('|');
            //                         inc (y);
            //                    End;
            //                    x:=50;
            //                    y:=1;
            //                For i:=1 to 20 do
            //                Begin
            //                     Gotoxy (x,y);
            //                     Writeln ('_');
            //                     x:=x+2
            //                End;
            //                textcolor (white);
            //                pp:=(100*cp)div co;
            //                pe:=(100*ce)div co;
            //                pf:=(100*cf)div co;
            //                gotoxy(52,5);
            //                writeln('Obras:');
            //                gotoxy(61,4);
            //                writeln(pp :2:0,'% son pinturas');
            //                gotoxy(61,5);
            //                writeln(pe :2:0,'% son estatuas');
            //                gotoxy(61,6);
            //                writeln(pf :2:0,'% son fosiles');
            //           end
            //              else
            //                  writeln('Este museo no tiene registrada ninguna obra ');
            //        close(arch);
            //   end;

              procedure baja_turno(var arch:t_turnos; nom_arch:string; var pos:integer);
              var
                 reg:r_turno;
              begin
                   leer_turno(arch, nom_arch, pos, reg);
                   reg.estado_turno:=false;
                   abrir_archivo_turno(arch, nom_arch);
                   seek(arch, pos);
                   write(arch, reg);
                   close(arch);
              end;

              procedure alta_estado_turno(var arch:t_turnos; nom_arch:string; var pos:integer);
              var
                 reg:r_turno;
              begin
                   leer_turno(arch, nom_arch, pos, reg);
                   reg.estado_turno:=true;
                   abrir_archivo_turno(arch, nom_arch);
                   seek(arch, pos);
                   write(arch, reg);
                   close(arch);
              end;

     procedure alta_turno(var arch:t_turnos; var arch_u:t_usuarios; var arch_a:t_autos; nom_arch_a:string ;nom_arch_u:string; nom_arch:string; var reg:r_turno);
     var
          posi,x,y,i:integer;
          control:char;
          asd:integer;
          aux_hora:st20;
          validacion:integer;
          //reg_u:registro_usuario;//modifique esta linea
          reg_a:r_auto;
          reg_aux_t:r_turno;
          ultima_posicion:integer;
     begin
          abrir_archivo_turno(arch,nom_arch); //
          if filesize(arch)=0 then           //
               begin                           //
                    reg.codigo_turno:=0;        //  Inicializacion del archivo
                    write(arch, reg)          //
               end;                           //
          close(arch);                     //
          clrscr;
          textcolor (white);
          x:=44;
          y:=2;
          For i:=1 to 20 do
          Begin
               Gotoxy (x,y);
               Writeln('|');
               inc (y);
          End;
          x:=45;
          y:=21;
          For i:=1 to 29 do
          Begin
               Gotoxy (x,y);
               Writeln ('_');
               x:=x+2
          End;
          x:=102;
          y:=2;
          For i:=1 to 20 do
          Begin
               Gotoxy (x,y);
               Writeln('|');
               inc (y);
          End;
          x:=45;
          y:=1;
          For i:=1 to 29 do
          Begin
               Gotoxy (x,y);
               Writeln ('_');
               x:=x+2
          End;
          textcolor (white);
          posi:=-1;
          gotoxy(66,2);
          writeln('Alta de Turno');
          gotoxy(45,4);
          writeln('Fecha del turno: ');
          gotoxy(45,5);
          writeln('DNI del usuario: ');
          gotoxy(45,6);
          writeln('Patente auto: ');
          //    gotoxy(45,7);
          //    writeln('Estilo: ');
          //    gotoxy(45,8);
          //    writeln('Material: ');
          //    gotoxy(45,9);
          //    writeln('Descripcion: ');
          //    gotoxy(45,10);
          //    writeln('Año: ');
          gotoxy(45,11);
          writeln('motivo: ');
          gotoxy(45,15);
          writeln('Codigo: ');
          gotoxy(63,4);
          readln(aux_hora);
          abrir_archivo_turno(arch, nom_arch); //
          ultima_posicion:=filesize(arch)-1;  // lectura de la posicion del ultimo registro
          close(arch);                        //
          leer_turno(arch, nom_arch, ultima_posicion, reg_aux_t); //
          reg.codigo_turno:=reg_aux_t.codigo_turno+1;                // generar codigo de obra automaticamente
          gotoxy(53,15);
          writeln(reg.codigo_turno);
          //busqueda_turno(arch, nom_arch, reg.codigo_turno, posi);
          if posi = -1 then
               begin
                    reg.dia_hora:=aux_hora;
                    // reg.codigo_turno:=asd;
                    repeat
                         gotoxy(63,5);
                         writeln('                                      ');
                         gotoxy(63,5);
                         {$I-}
                              readln(reg.dni_usuario);
                         {$I+}
                         validacion:=ioresult();
                         if validacion<>0 then
                              begin
                                   gotoxy(45,16);
                                   Textcolor (red);
                                   writeln('Debe ingresar solo numeros');
                                   Textcolor (white);
                              end;
                    until validacion=0;
                    gotoxy(45,16);
                    writeln('                                           ');//desde aca
                  busqueda_dni_usuario(arch_u, nom_arch_u, reg.dni_usuario, posi);  
                  if posi>-1 then
                    begin
                     leer_auto(arch_a, nom_arch_a, posi, reg_a);   // REVISAR ESTE BLOQUE PRIMERO PREGUNTA POR EL DNI Y DESPUES LEE EL AUTO
                     if reg_a.estado_auto then
                        begin
                             repeat
                                   gotoxy(63,6);
                                   writeln('                                     ');
                                   gotoxy(63,6);
                                   {$I-}
                                        readln(reg.patente);
                                   {$I-}
                                   validacion:=ioresult();
                                   if validacion<>0 then
                                      begin
                                           gotoxy(45,16);
                                           Textcolor (red);
                                           writeln('Debe ingresar solo numeros');
                                           Textcolor (white);
                                      end;
                             until validacion = 0;
                             gotoxy(45,16);
                             writeln('                                           ');
                              busqueda_patente(arch_a, nom_arch_a, reg.patente, posi);//hasta aca
                              if posi>-1 then
                                   begin
                                        leer_auto(arch_a, nom_arch_a, posi, reg_a);
                                        if reg_a.estado_auto then
                                        begin
                                        //  gotoxy(53,7);
                                        //  readln(reg.marca);
                                        //    repeat
                                        //          gotoxy(50,10);
                                        //          writeln('                                     ');
                                        //          gotoxy(50,10);
                                        //          {$I-}
                                        //               readln(reg.anio);
                                        //          {$I+}
                                        //          validacion:=ioresult();
                                        //          if validacion<>0 then
                                        //             begin
                                        //                  gotoxy(45,16);
                                        //                  Textcolor (red);
                                        //                  writeln('Debe ingresar solo numeros...');
                                        //                  Textcolor (white);
                                        //             end;
                                        //    until validacion=0;
                                             gotoxy(45,16);//hasta aca
                                             writeln('                                                         ');
                                             repeat
                                                  gotoxy(45,16);
                                                  writeln('Presione "s":Service ; "m":Motor; "f":Freno');
                                                  gotoxy(55,11);
                                                  writeln('                             ');
                                                  gotoxy(55,11);
                                                  control:=readkey;
                                                  keypressed;
                                                  case control of
                                                       's':begin
                                                                 reg.motivo:='Service';
                                                                 gotoxy(55,11);
                                                                 writeln(reg.motivo);
                                                            end;
                                                       'm':begin
                                                                 reg.motivo:='Motor';
                                                                 gotoxy(55,11);
                                                                 writeln(reg.motivo);
                                                            end;
                                                       'f':begin
                                                                 reg.motivo:='Freno';
                                                                 gotoxy(55,11);
                                                                 writeln(reg.motivo);
                                                            end;
                                                       else
                                                            begin
                                                                 gotoxy(45,16);
                                                                 Textcolor (red);
                                                                 writeln('La letra ingresada es erronea:...');
                                                                 Textcolor (white);
                                                            end;
                                                  end;
                                             until (reg.motivo = 'Service') or (reg.motivo = 'Motor') or (reg.motivo = 'Freno');
                                          gotoxy(45,16);
                                          writeln('                                                         ');
                                        //    if reg.motivo='Estatua' then
                                        //       begin
                                        //            gotoxy(45,12);
                                        //            writeln('Altura: ');
                                        //            gotoxy(45,13);
                                        //            writeln('Peso: ');
                                        //            repeat
                                        //                  gotoxy(53,12);
                                        //                  writeln('                    ');
                                        //                  gotoxy(53,12);
                                        //                  {$I-}
                                        //                       readln(reg.altura);
                                        //                  {$I+}
                                        //                  validacion:=ioresult();
                                        //                  if validacion<>0 then
                                        //                     begin
                                        //                          gotoxy(45,16);
                                        //                          Textcolor (red);
                                        //                          writeln('Debe ingresar solo numeros.');
                                        //                          Textcolor (white);
                                        //                     end;
                                        //            until validacion=0;
                                        //            gotoxy(45,16);
                                        //            writeln('                               ');
                                        //            repeat
                                        //                  gotoxy(51,13);
                                        //                  writeln('                                 ');
                                        //                  gotoxy(51,13);
                                        //                  {$I-}
                                        //                       readln(reg.peso);
                                        //                  {$I+}
                                        //                  validacion:=ioresult();
                                        //                  if validacion<>0 then
                                        //                     begin
                                        //                          gotoxy(45,16);
                                        //                          Textcolor (red);
                                        //                          writeln('Debe ingresar solo numeros.');
                                        //                          Textcolor (white);
                                        //                     end;
                                        //            until validacion=0;
                                        //            gotoxy(45,16);
                                        //            writeln('                                                         ');
                                        //       end
                                        //          else
                                        //              if reg.motivo='Fosil' then
                                        //                 begin
                                        //                      gotoxy(45,12);
                                        //                      writeln(#168'El fosil esta completo?: ');
                                        //                      gotoxy(45,13);
                                        //                      writeln('Cantidad de partes: ');
                                        //                      repeat
                                        //                            gotoxy(45,16);
                                        //                            writeln('Pulse "s": si esta completo ; "n": si no esta completo.');
                                        //                            gotoxy(71,12);
                                        //                            writeln('            ');
                                        //                            gotoxy(71,12);
                                        //                            control:=readkey;
                                        //                            keypressed;
                                        //                            case control of
                                        //                                 's':begin
                                        //                                          reg.completo:='Si';
                                        //                                          gotoxy(71,12);
                                        //                                          writeln(reg.completo);
                                        //                                     end;
                                        //                                 'n':begin
                                        //                                          reg.completo:='No';
                                        //                                          gotoxy(71,12);
                                        //                                          writeln(reg.completo);
                                        //                                     end;
                                        //                                 else
                                        //                                     begin
                                        //                                          gotoxy(45,16);
                                        //                                          Textcolor (red);
                                        //                                          writeln('La letra ingresada es erronea: ');
                                        //                                          Textcolor (white);
                                        //                                     end;
                                        //                            end;
                                        //                      until (reg.completo = 'Si') or (reg.completo = 'No');
                                        //                      gotoxy(45,16);
                                        //                      writeln('                                                         ');
                                        //                      repeat

                                        //                            gotoxy(65,13);
                                        //                            writeln('                        ');
                                        //                            gotoxy(65,13);
                                        //                            {$I-}
                                        //                                 readln(reg.can_partes);
                                        //                            {$I+}
                                        //                            validacion:=ioresult();
                                        //                            if validacion<>0 then
                                        //                               begin
                                        //                                    gotoxy(45,16);
                                        //                                    Textcolor (red);
                                        //                                    writeln('Debe ingresar solo numeros.');
                                        //                                    Textcolor (white);
                                        //                               end; 
                                        //                   until validacion=0; //Este until y validacion son de until (reg.motivo = 'Service') or (reg.motivo = 'Motor') or (reg.motivo = 'Freno'); (si no es cambiar)
                                        //                   gotoxy(45,16);
                                        //                   writeln('                               ');
                                        //              end;
                                             reg.estado_turno:=true;
                                             guardar_turno(arch, nom_arch, reg);
                                             gotoxy(45,16);
                                             Textcolor (green);
                                             writeln('Turno creado correctamente!');
                                             Textcolor (white);
                                             gotoxy(45,18);
                                             writeln('tocar cualquier tecla para volver al menu');
                                             textcolor(white);
                                             readkey;
                                        end;
                                        
                                             // begin
                                             //      gotoxy(45,16);
                                             //      Textcolor (red);
                                             //      writeln('El auto esta dado de baja.');
                                             //      Gotoxy (45,17);
                                             //      Writeln('Dar de alta para continuar');
                                             //      Textcolor (white);
                                             //      readkey;
                                             // end;
                                   end
                                   else
                                        begin
                                             gotoxy(45,16);
                                             Textcolor (red);
                                             writeln('el auto no esta registrado.');
                                             gotoxy(45,17);
                                             writeln('Registre primero el auto para continuar');
                                             Textcolor (white);
                                             readkey;
                                        end;
                         end
                              else
                              begin
                                   gotoxy(45,16);
                                   Textcolor (red);
                                   writeln('El usuario esta dado de baja.');
                                   Gotoxy (45,17);
                                   writeln ('Dar de alta para continuar');
                                   Textcolor (white);
                                   readkey;
                              end;
                    end
                         else
                              begin
                                   gotoxy(45,16);
                                   Textcolor (red);
                                   writeln('El usuario no esta registrado.');
                                   Gotoxy(46,17);
                                   Writeln ('Registre primero el usuario para continuar');
                                   Textcolor (white);
                                   readkey;
                              end;
               end
               else
                    begin
                         leer_turno(arch, nom_arch, posi, reg);
                         if (reg.estado_turno) then
                              begin
                                   repeat
                                        gotoxy(45,16);
                                        writeln('Este turno ya esta registrada.' ,#168,'Que desea hacer?');
                                        gotoxy(45,17);
                                        writeln('1: Modificar');
                                        gotoxy(45,18);
                                        writeln('2: Dar baja');
                                        gotoxy(45,19);
                                        writeln('ESC: Volver');
                                        control:=readkey;
                                        keypressed;
                                        if (control = '1') then
                                             modificar_turno(arch, arch_u ,arch_a,nom_arch, nom_arch_u, nom_arch_a,posi)
                                             else
                                                  if (control='2') then
                                                       begin
                                                            gotoxy(45,16);
                                                            writeln('                                                         ');
                                                            gotoxy(45,17);
                                                            writeln('                ');
                                                            gotoxy(45,18);
                                                            writeln('                     ');
                                                            gotoxy(45,19);
                                                            writeln('              ');
                                                            baja_turno (arch,nom_arch, posi);
                                                            gotoxy(45,16);
                                                            writeln('Listo!');
                                                            readkey;
                                                       end
                                                       else
                                                       if (control=#27) then
                                                            clrscr
                                                                 else
                                                                 begin
                                                                      gotoxy(45,16);
                                                                      writeln('                                                         ');
                                                                      gotoxy(45,17);
                                                                      writeln('                ');
                                                                      gotoxy(45,18);
                                                                      writeln('                     ');
                                                                      gotoxy(45,19);
                                                                      writeln('              ');
                                                                      gotoxy(45,16);
                                                                      Textcolor (red);
                                                                      writeln('La tecla ingresada es erronea...');
                                                                      Textcolor (white);
                                                                      readkey;
                                                                 end;
                                   until (control = '1') or (control='2') or (control = #27);
                              end
                              else
                              begin
                                   repeat
                                        gotoxy(45,16);
                                        writeln('Este turno esta registrado pero esta dado de baja.');
                                        gotoxy(45,17);
                                        writeln('1: Dar de alta');
                                        gotoxy(45,18);
                                        writeln('ESC: Volver');
                                        control:=readkey;
                                        keypressed;
                                        if (control = '1') then
                                             begin
                                                  gotoxy(45,16);
                                                  writeln('                                                         ');
                                                  gotoxy(45,17);
                                                  writeln('               ');
                                                  gotoxy(45,18);
                                                  writeln('            ');
                                                  alta_estado_turno(arch, nom_arch, posi);
                                                  gotoxy(45,16);
                                                  Textcolor (green);
                                                  writeln('Listo!');
                                                  Textcolor (white);
                                                  readkey;
                                             end
                                                  else
                                                  if (control=#27) then
                                                       clrscr
                                                            else
                                                            begin
                                                                 gotoxy(45,16);
                                                                 writeln('                                                         ');
                                                                 gotoxy(45,17);
                                                                 writeln('               ');
                                                                 gotoxy(45,18);
                                                                 writeln('            ');
                                                                 gotoxy(45,16);
                                                                 Textcolor (red);
                                                                 writeln('La letra ingresada es erronea...');
                                                                 Textcolor (white);
                                                                 readkey;
                                                            end;
                                   until (control = '1') or (control = #27);
                              end;
                    end;   //si no funciona fijarme puede faltar un end; en el inicio de el comentario *
     end;

              procedure eliminar_archivo_turno(var arch:t_turnos);
              begin
                   erase(arch);
              end;

begin

end.