getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }


BASE=`dirname $(readlink -f $0)`
LOG=app.xml


for YT in $(find $BASE/input -type f -name *apk); do
PACKAGE_NAME=`aapt2 dump permissions $YT | grep package | head -n1 | cut -d : -f 2 | sed 's/ //g'`
NUM=$(((NUM+1)))
echo
echo "${NUM}. Make $(basename $YT)"
OUT=$BASE/output/permissions/${PACKAGE_NAME}.xml
echo " out : $OUT"
rm -rf $OUT
mkdir -p $BASE/output/permissions
cat <<EOF > "$OUT"
<?xml version="1.0" encoding="utf-8"?>
<!--
  ~ Date : $(date)
  ~ 
  ~ Copyright (C) 2020 - 2024 The Litegapps Project
  ~
-->
<!--
This XML file declares which signature|privileged permissions should be granted to privileged
applications on GMS or Google-branded devices.
It allows additional grants on top of privapp-permissions-platform.xml
-->
<permissions>
  <privapp-permissions package="$PACKAGE_NAME">
EOF

for Y in $(aapt d permissions $YT); do
	
if [[ $Y == *name=* ]] && [[ $Y != $PACKAGE_NAME ]]; then
T=`echo "$Y" | head -n1 | cut -d = -f 2 | sed "s/'//g"`
T=`echo "$T" | sed "s/'//g"`
echo "    <permission name=\"$T\"/>" >> $OUT
elif [[ $Y != *name=* ]] && [[ $Y == *com.* ]] && [[ $Y != $PACKAGE_NAME ]]; then
T=`echo "$Y" | head -n1 | cut -d = -f 2 | sed "s/'//g"`
echo "    <permission name=\"$T\"/>" >> $OUT
		
fi
done

cat <<EOF >> "$OUT"
  </privapp-permissions>
</permissions>
EOF

sleep 1s
done
