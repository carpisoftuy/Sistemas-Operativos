infoYad() {
#echo entre en infoYad
titulo="$1"
texto="$2"
  yad --title="${titulo}" \
    --image=gtk-info \
    --center \
    --width=340 \
    --height=80 \
    --text-align=center \
    --text="${texto}" \
    --button=Aceptar
}

ListG() {
yad --form \
  --title=" * Listado de grupos * " \
  --width=400 \
  --height=100 \
  --center \
  --field="Nombre de grupo : " "$grp"
# seguir con grilla YAD
}

ConsG() {
grp=grp
sal=$(yad --form \
  --title=" * Consulta de grupo * " \
  --width=400 \
  --height=100 \
  --center \
  --field="Nombre de grupo : " "$grp" )
if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz : vuelvo al invocante
grp=$(echo $sal | cut -f1 -d'|')
vgc='grep '$grp' '/etc/group
sal=$(echo $vgc | bash 2>&1)
res=$?
titulo=' * CONSULTA de GRUPO * '
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Consulta : </span> exitosa !\n$sal"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"red\">Consulta : </span> fallida !(grupo $grp NO EXISTE)"
  infoYad "$titulo" "$texto"
fi
}

ModifG() {
grp=grp
ngrp=ngrp
sal=$(yad --form \
  --title=" * Modificación de grupo * " \
  --width=400 \
  --height=200 \
  --center \
  --field="Nombre de grupo : " "$grp" \
  --field="Nuevo nombre de grupo : " "$ngrp" )
if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz : vuelvo al invocante
grp=$(echo $sal | cut -f1 -d'|')
ngrp=$(echo $sal | cut -f2 -d'|')
vgm='groupmod -n '$ngrp' '$grp
sal=$(echo $vgm | bash 2>&1)
res=$?
titulo=' * MODIFICACIÓN de GRUPO * '
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Modificación : </span> exitosa !"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"red\">Modificación : </span> fallida ! ($sal)"
  infoYad "$titulo" "$texto"
fi
}

BajaG() {
grp=grp
sal=$(yad --form \
  --title=" * Baja de grupo * " \
  --width=400 \
  --height=100 \
  --center \
  --field="Nombre de grupo : " "$grp" )
if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz : vuelvo al invocante
grp=$(echo $sal | cut -f1 -d'|')
vgd='sudo groupdel '$grp
sal=$(echo $vgd | bash 2>&1)
res=$?
titulo=' * BAJA de GRUPO * '
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Baja : </span> exitosa !"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"red\">Baja : </span> fallida ! ($sal)"
  infoYad "$titulo" "$texto"
fi
}

AltaU() {
# seguir
# abortar si no puedo crear user (no seguir con la passwd)
# ver si las passwords coinciden
# ver robustez de la password : mayuscula, minuscula, nuero, simblo, largo

usr=jperez
dir=/home/jperez
com='comentario con espacios'
pas=secreta
par=secreta
vcs=27/06/2023 # vencimiento contraseña
usuario=$(yad --form \
  --title="Alta de usuario" \
  --date-format="%-d/%m/%Y" \
  --width=400 \
  --height=300 \
  --center \
  --field="Nombre de usuario : " "$usr" \
  --field="Directorio de inicio : " "$dir" \
  --field="Comentario : " "$com" \
  --field="Contraseña : ":H "$pas" \
  --field="Repita contraseña : ":H "$par" \
  --field="Vencimiento contraseña:":DT "$vcs"  \
  --field="Interprete :":CB /bin/bash!/bin/sh!/sbin/nologin!/bin/false!/bin/sync!/sbin/halt!/sbin/shutdown )
  #--columns="3" \

# monitoreo de la variable total
echo $usuario

# salida de emergencia
#exit

# desmembrado de componentes : pisamos los valores anteriores
usr=$(echo $usuario | cut -f1 -d'|')
dir=$(echo $usuario | cut -f2 -d'|')
com=$(echo $usuario | cut -f3 -d'|')
pwd=$(echo $usuario | cut -f4 -d'|')
par=$(echo $usuario | cut -f5 -d'|')
vcs=$(echo $usuario | cut -f6 -d'|')
idc=$(echo $usuario | cut -f7 -d'|') # interprete de comandos

# monitoreo de variables extraidas
echo -e user : "\t\t\t" $usr
echo -e home : "\t\t\t" $dir
echo -e coments : "\t\t" $com
echo -e password : "\t\t" $pwd
echo -e password again : "\t" $par
echo -e password expired : "\t" $vcs
echo -e shell : "\t\t" $idc

# ensamblado de orden useradd
# vua : variable useradd
vua='useradd -d '$dir' -m -c "'$com'" -s '$idc' '$usr
vua='useradd -d '$dir' -m -c '\'$com\'' -s '$idc' '$usr
echo $vua # monitoreo
# intento de creacion efectiva del usuario (ejecuto la variable vua)
#$($vua)
#$vua
# cambio a pasar por tuberia el contenido de la variable, a bash
# (metodo anterior fallaba con los espacios)
#echo $vua | bash
#sudo echo $vua | bash
echo $vua | sudo bash
#echo $vua | sudo bash
res=$?
titulo=' * ALTA de USUARIO * '
#echo $titulo
#exit
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Alta : </span> exitosa !"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"green\">Alta : </span> fallida !"
  infoYad "$titulo" "$texto"
fi
echo $usr:$pwd | chpasswd
res=$?
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">asignación contraseña : </span> exitosa !"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"green\">asignación contraseña : </span> fallida !"
  infoYad "$titulo" "$texto"
fi

# userdel -r jperez
# /etc/sudoers :
# SIGTadmin ALL = NOPASSWD: /usr/sbin/useradd
#

# ANEXO
# consolidacion de los interpretes usados hasta ahora :
#[c7@localhost ~]$ cat /etc/passwd | cut -f7 -d: | sort | uniq -c
#      3 /bin/bash
#      1 /bin/false
#      1 /bin/sync
#      1 /sbin/halt
#     39 /sbin/nologin
#      1 /sbin/shutdown

}

ListU(){


# Obtener la lista de todos los usuarios
  usuarios=$(cut -d: -f1 /etc/passwd | ls /home)

  # Mostrar la lista de usuarios
  yad --form \
      --title=" * Listado de Usuarios * " \
      --width=400 \
      --height=100 \
      --center \
      --field="Nombre de usuario : " "$usuarios" \
      --button=Aceptar

}
BajaU(){

# SIGT Sistema Informatico de Gestion de Torneos
# SIGTadmin : usuario administrador que ejecuta estos shellscripts
# solo tiene permiso sudooer sobre SIGT*

usr=jperez
dir=/home/jperez
com=comentario
pas=secreta
par=secreta
vcs=27/06/2023 # vencimiento contraseña
usuario=$(yad --form \
  --title="Baja de usuario" \
  --width=400 \
  --height=300 \
  --center \
  --field="Nombre de usuario : " "$usr" )
  #--columns="3" \

# monitoreo de la variable total
echo $usuario

# salida de emergencia
#exit
# de aca en mas no corre

# desmembrado de componentes : pisamos los valores anteriores
usr=$(echo $usuario | cut -f1 -d'|')

# monitoreo de variables extraidas
echo -e user : "\t\t\t" $usr

# ensamblado de orden userdel
# vud : variable userdel
vud='sudo rm -r '/home/$usr
echo $vud # monitoreo
# intento de eliminacion efectiva del usuario (ejecuto la variable vud)
#$($vud)
$vud

if [ $? -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Baja : </span> exitosa !"
  yad --title=" * BAJA de USUARIO * " \
--image=gtk-info \
    --center \
    --width=340 \
    --height=80 \
    --text-align=center \
    --text="${texto}" \
    --button=Aceptar
else
  texto="<span weight=\"bold\" foreground=\"green\">Baja : </span> fallida !"
  yad --title=" * BAJA de USUARIO * " \
    --image=gtk-info \
    --center \
    --width=340 \
    --height=80 \
    --text-align=center \
    --text="${texto}" \
    --button=Aceptar
fi

# ANEXO
# consolidacion de los interpretes usados hasta ahora :
#[c7@localhost ~]$ cat /etc/passwd | cut -f7 -d: | sort | uniq -c
#      3 /bin/bash
#      1 /bin/false
#      1 /bin/sync
#      1 /sbin/halt
#     39 /sbin/nologin
#      1 /sbin/shutdown


}

AltaG() {
grp=grp
sal=$(yad --form \
  --title=" * Alta de grupo * " \
  --width=400 \
  --height=100 \
  --center \
  --field="Nombre de grupo : " "$grp" )
if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz : vuelvo al invocante
grp=$(echo $sal | cut -f1 -d'|')
vga='sudo groupadd '$grp
sal=$(echo $vga | bash 2>&1)
res=$?
titulo=' * ALTA de GRUPO * '
if [ $res -eq 0 ]
then
  texto="<span weight=\"bold\" foreground=\"green\">Alta : </span> exitosa !"
  infoYad "$titulo" "$texto"
else
  texto="<span weight=\"bold\" foreground=\"red\">Alta : </span> fallida ! ($sal)"
  infoYad "$titulo" "$texto"
fi
}

ModifU() {
  usr=usr
  dir=dir
  com=com
  pas=pas
  par=par
  vcs=vcs
  idc=idc

  # Diálogo para obtener la información actual del usuario
  usuario=$(yad --form \
    --title="Modificación de usuario" \
    --date-format="%-d/%m/%Y" \
    --width=400 \
    --height=300 \
    --center \
    --field="Nombre de usuario : " "$usr" \
    --field="Directorio de inicio : " "$dir" \
    --field="Comentario : " "$com" \
    --field="Contraseña : ":H "$pas" \
    --field="Repita contraseña : ":H "$par" \
    --field="Vencimiento contraseña:":DT "$vcs"  \
    --field="Interprete :":CB /bin/bash!/bin/sh!/sbin/nologin!/bin/false!/bin/sync!/sbin/halt!/sbin/shutdown )

  if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz: vuelvo al invocante

  # Desmembrar la información actual
  usr=$(echo $usuario | cut -f1 -d'|')
  dir=$(echo $usuario | cut -f2 -d'|')
  com=$(echo $usuario | cut -f3 -d'|')
  pwd=$(echo $usuario | cut -f4 -d'|')
  par=$(echo $usuario | cut -f5 -d'|')
  vcs=$(echo $usuario | cut -f6 -d'|')
idc=$(echo $usuario | cut -f7 -d'|')

  # Diálogo para obtener la nueva información del usuario
  usuario_modificado=$(yad --form \
    --title="Modificación de usuario" \
    --date-format="%-d/%m/%Y" \
    --width=400 \
    --height=300 \
    --center \
    --field="Nombre de usuario : " "$usr" \
    --field="Directorio de inicio : " "$dir" \
    --field="Comentario : " "$com" \
    --field="Contraseña : ":H "$pwd" \
    --field="Repita contraseña : ":H "$par" \
    --field="Vencimiento contraseña:":DT "$vcs"  \
    --field="Interprete :":CB /bin/bash!/bin/sh!/sbin/nologin!/bin/false!/bin/sync!/sbin/halt!/sbin/shutdown )

  if [ $? -ne 0 ]; then return; fi # Escape, Cancelar, cruz: vuelvo al invocante

  # Desmembrar la nueva información
  usr_modificado=$(echo $usuario_modificado | cut -f1 -d'|')
  dir_modificado=$(echo $usuario_modificado | cut -f2 -d'|')
  com_modificado=$(echo $usuario_modificado | cut -f3 -d'|')
  pwd_modificado=$(echo $usuario_modificado | cut -f4 -d'|')
  par_modificado=$(echo $usuario_modificado | cut -f5 -d'|')
  vcs_modificado=$(echo $usuario_modificado | cut -f6 -d'|')
  idc_modificado=$(echo $usuario_modificado | cut -f7 -d'|')

  # Ejecutar el comando de modificación de usuario
  vum="sudo usermod -d $dir_modificado -c '$com_modificado' -s $idc_modificado $usr_modificado"
  sal=$(echo $vum | bash 2>&1)
  res=$?
  titulo=' * MODIFICACIÓN de USUARIO * '

  if [ $res -eq 0 ]; then
    texto="<span weight=\"bold\" foreground=\"green\">Modificación : </span> exitosa !"
    infoYad "$titulo" "$texto"
  else
    texto="<span weight=\"bold\" foreground=\"red\">Modificación : </span> fallida ! ($sal)"
    infoYad "$titulo" "$texto"
  fi
}


Usuarios() {
while true
do
  opcion=$(yad --list \
    --title=" * SUB MENU usuarios * " \
    --height=300 \
    --width=300 \
    --button=Aceptar:0 \
    --center \
    --text="Selecciona A B M C L : " \
    --column="ABMCL Usuarios" \
    "Alta" "Baja" "Modificacion" "Consulta" "Listado" "Salir (Esc)")
  ans=$?
  if [ $ans -eq 0 ]
  then
    case $opcion in
    Alta*)
      AltaU;;
    Baja*)
      BajaU;;
    Modif*)
      ModifU;;
    Consulta*)
      ConsU;;
    Listado*)
      ListU;;
    Salir*)
      return;;
    esac
  else
    return
  fi
done
}

Grupos() {
while true
do
  opcion=$(yad --list \
    --title=" * SUB MENU grupos * " \
    --height=300 \
    --width=300 \
    --button=Aceptar:0 \
    --center \
    --text="Selecciona A B M C L : " \
    --column="ABMCL Grupos" \
"Alta" "Baja" "Modificacion" "Consulta" "Listado" "Salir (Esc)")
  ans=$?
  if [ $ans -eq 0 ]
  then
    case $opcion in
    Alta*)
      AltaG;;
    Baja*)
      BajaG;;
    Modif*)
      ModifG;;
    Consulta*)
      ConsG;;
    Listado*)
      ListG;;
    Salir*)
      return;;
    esac
  else
    return
  fi
done
}

# programa principal
while true
do
  opcion=$(yad --list \
    --title=" * MENU grupos y usuarios * " \
    --height=200 \
    --width=300 \
    --button=Aceptar:0 \
    --center \
    --text="Selecciona grupos o usuarios : " \
    --column="ABM G / U" \
    "Grupos" "Usuarios" "Salir (Esc)")
  ans=$?
  if [ $ans -eq 0 ]
  then
    case $opcion in
    Grupos*)
      Grupos;;
    Usuarios*)
      Usuarios;;
    Salir*)
      exit;;
esac
  else
    exit
  fi
done
