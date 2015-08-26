#!/bin/sh

ARQUITECTURA=i386,amd64
METODO=http
RAMA=wheezy
RAMAS=wheezy
HOST=ftp.us.debian.org
HOST_SEGURIDAD=security.debian.org
HOST_MULTIMEDIA=ftp.debian-multimedia.org
DIR_MIRROR=/var/data/repo/debian
DIR_SEGURIDAD=/var/data/repo/updates
SECCION=main
SECCIONES=main,contrib,non-free
lock=/tmp/mirror.lock

if test -f $lock ; then
    printf '%b\n' '\033[31mmirror.sh is running!!!\033[39m'
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi


echo "==================================================================="
echo "Actualizando los repositorios PRINCIPALES; main, contrib, non-free"
echo "==================================================================="
echo ""

debmirror -a ${ARQUITECTURA} \
-s ${SECCIONES} \
-h ${HOST}/debian \
-d ${RAMA} -r / --progress \
-e ${METODO} --ignore-release-gpg --nosource \
${DIR_MIRROR}

echo "====================================================================="
echo "Actualizando los repositorios de SEGURIDAD; main, contrib, non-free"
echo "====================================================================="
echo ""

debmirror -a ${ARQUITECTURA} \
-s ${SECCIONES} \
-h ${HOST_SEGURIDAD} \
-d ${RAMA}/updates -r /debian-security --progress \
-e ${METODO} --ignore-release-gpg --nosource \
${DIR_SEGURIDAD}

#echo "==================================================================="
#echo "Actualizando los repositorios MULTIMEDIA; main"
#echo "==================================================================="
#echo ""

#debmirror -a ${ARQUITECTURA} \
#-s ${SECCION} \
#-h ${HOST_MULTIMEDIA} \
#-d ${RAMAS} -r / --progress \
#-e ${METODO} --ignore-release-gpg --nosource \
#${DIR_MULTIMEDIA}

rm -rf $lock
