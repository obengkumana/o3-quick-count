#!/bin/bash
smstart=0
while [ "$smstart" -eq "0" ]
	do
	DIR="/www/adit99"
	CK=`ls $DIR/sms/keluar/sender1 | wc -w`	
	if [ "$CK" != "0" ]
	then
		STATUS1=`cat $DIR/sms/keluar/status/send1`
		STATUS2=`cat $DIR/sms/keluar/status/send2`
		IMS1=`grep "sender1" $DIR/modem/script/imei | awk '{print $2}'`
		PS1=`grep "$IMS1" /tmp/hasil | awk '{print $1}' | tail -1`
		ls $DIR/sms/keluar/sender1 > /tmp/sender1 2>/dev/null
		STR=`cat /tmp/sender1`
		STR_ARRAY=(`echo $STR`)
		for x in "${STR_ARRAY[@]}"
		do
			echo $x > /tmp/$x 2>/dev/null
			TGL=`sed 's/\./ /g' /tmp/$x | awk '{print $1}'`
			D1D=`echo "$TGL" | cut -c1-2`
			M1M=`echo "$TGL" | cut -c3-4`
			Y1Y=`echo "$TGL" | cut -c5-8`
			T1GL="$D1D-$M1M-$Y1Y"
			JAM=`sed 's/\./ /g' /tmp/$x | awk '{print $2}'`
			h1h=`echo "$JAM" | cut -c1-2`
			m1m=`echo "$JAM" | cut -c3-4`
			s1s=`echo "$JAM" | cut -c5-6`
			J1AM="$h1h:$m1m:$s1s"
			NHCK=`sed 's/\./ /g' /tmp/$x | awk '{print $3}'`
			MH=`cat $DIR/sms/keluar/sender1/$x | tr "\n" "=" | cut -c1-159 | tr "=" "\n"`
			if [ "$STATUS1" == "1" ]
			then
				echo "$MH" | gnokii --config $DIR/modem/config/"$PS1" --sendsms "$NHCK" 2>/dev/null
				R=$?
				if [ "$R" -eq "0" ]
				then
					echo "$T1GL" > $DIR/web/tanggal/$T1GL
					echo "<TR><TD>"$T1GL"</TD><TD>"$J1AM"</TD><TD>"$NHCK"</TD><TD>"Sender 1"</TD><TD>"$MH"</TD></TR>" >> $DIR/web/sms/out 2>/dev/null					
					mv $DIR/sms/keluar/sender1/$x $DIR/sms/keluar/sukses 2>/dev/null
				else
					mv $DIR/sms/keluar/sender1/$x $DIR/sms/keluar/process 2>/dev/null 
				fi
			elif [ "$STATUS2" == "1" ]
			then
				mv $DIR/sms/keluar/sender1/$x $DIR/sms/keluar/sender1 2>/dev/null
			else
				mv $DIR/sms/keluar/sender1/$x $DIR/sms/keluar/process 2>/dev/null
			fi
			rm /tmp/$x 2>/dev/null
		done
	else
		sleep 1 2>/dev/null		
	fi					
done
exit 0    
