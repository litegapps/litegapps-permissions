getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }


BASE=`dirname $(readlink -f $0)`
LOG=app.xml

echo '<permissions>' > $LOG
echo "  <privapp-permissions package='com.google.android.gms'>" >> $LOG
for Y in $(aapt d permissions *.apk); do
	
	if [[ $Y == *name=* ]]; then
		T=`echo "$Y" | head -n1 | cut -d = -f 2`
		echo "    <permission name=${T} />" | tee -a $LOG
	elif [[ $Y != *name=* ]] && [[ $Y == *com.* ]]; then
		T=`echo "$Y" | head -n1 | cut -d = -f 2`
		echo "    <permission name='${T}' />" | tee -a $LOG
	fi
done

echo "   </privapp-permissions>" >> $LOG
echo "</permissions>" >> $LOG

sed -i 's/"'"/'"'/g' $LOG
