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

# al inicio ponerme en mi directorio de trabajo !
#cd /home/sosam/bin
cd /home/sosam/SI
#binpath=/home/sosam/bin
binpath=/home/sosam/SI

while true
do
  opcion=$(yad --list \
    --title=" * MENU principal CARPISOFT * " \
    --height=200 \
    --width=300 \
    --button=Aceptar:0 \
    --center \
    --text="Bienvenidos a Sistema Informatico de Gestion de paqueteria !" \
    --column="Opciones generales" \
    "Grupos y Usuarios" "Mantenimiento" "Salir (Esc)")
  ans=$?
  if [ $ans -eq 0 ]
then
    case $opcion in
    Grupos*)
      #./menuGU;;
      $binpath/menuGU;;
    Manten*)
      $binpath/Mantenimiento;;
    Salir*)
      exit;;
    esac
  else
    exit
  fi
done
