#!/usr/bin/sh
#litegapps-permissions
#by wahyu6070
getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }
SED(){
	local INPUT=$1
	local OUTPUT=$2
	local FILE=$3
	sed -i 's/'"${INPUT}"'/'"${OUTPUT}"'/g' $FILE
	}

BASE=`dirname $(readlink -f $0)`
NAME="privapp-permissions-LiteGapps.xml"
TMP=$BASE/tmp

MK=$TMP/$NAME
rm -rf $TMP
mkdir -p $TMP
touch $MK

#update metadata
AUTHOR=`getp author $BASE/config`
C_AUTHOR=`getp author $BASE/layout/head.xml`
SED "$C_AUTHOR" $AUTHOR $BASE/layout/head.xml
SED "$(getp date $BASE/layout/head.xml)" "$(date +%d-%m-%Y)" $BASE/layout/head.xml
#Coment
cat $BASE/layout/head.xml >> $MK


echo "     LiteGapps Permissions Builder"
echo
cd $BASE/list
for I in $(find * -name *.xml -type f); do
	BASEDIR=`dirname $BASE/$I`
	echo "- Including <$I>"
	cat $BASE/list/$I >> $MK



done
cat $BASE/layout/end.xml >> $MK

#copy to system
cp -pf $MK $BASE/system/etc/permissions/
rm -rf $TMP
echo "- Done"
