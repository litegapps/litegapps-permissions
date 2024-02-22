getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }


BASE=`dirname $(readlink -f $0)`
LOG=app.xml


for YT in $(find $BASE/input -type f -name *apk); do
PACKAGE_NAME=`aapt d permissions $YT | grep package | head -n1 | cut -d : -f 2 | sed 's/ //g'`

OUT=$BASE/output/permissions/${PACKAGE_NAME}.xml
echo " out : $OUT"
rm -rf $BASE/output/permissions
mkdir -p $BASE/output/permissions
echo '<permissions>' > $OUT
echo "  <privapp-permissions package='$PACKAGE_NAME'>" >> $OUT
for Y in $(aapt d permissions $YT); do
	
	if [[ $Y == *name=* ]]; then
		T=`echo "$Y" | head -n1 | cut -d = -f 2`
		echo "    <permission name=${T} />" >> $OUT
	elif [[ $Y != *name=* ]] && [[ $Y == *com.* ]]; then
		T=`echo "$Y" | head -n1 | cut -d = -f 2`
		echo "    <permission name='${T}' />" >> $OUT
	fi
done

echo "   </privapp-permissions>" >> $OUT
echo "</permissions>" >> $OUT

sed -i 's/"'"/'"'/g' $OUT
done
