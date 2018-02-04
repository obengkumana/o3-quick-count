#!/bin/bash
DIR="/var/www/qc"
db="/var/www/qc/db/QCdata.db"
dbtmp="/tmp/sqc2.tmp"
sql="sqlite3 $dbtmp"
sql2="sqlite3 $db"
d="/var/www/qc/tmp/sms"
dir1="$d/out"
dir2="$d/out2"
dir3="$d/done"
smstart=0
while [ "$smstart" -eq "0" ];do
	cp $db $dbtmp
	line=$($sql "select keterangan from pengaturan where nama_pengaturan='PortModem2'")
	# Check Status
	CC2=$(cat $DIR/config/modem/status/c2)
	if [ "$CC2" != "0" ];then
		# Check Modem
		_val=$(dmesg | grep "$line" | tail -3 | awk '{print $NF}' | head -1)
		if [ "$_val" == "detected" ] || [ "$(echo "$_val" | grep -c "ttyUSB")" != "0" ];then
			# Check Respon Modem
			C2=$(dmesg | grep "$line" | grep "ttyUSB" | tail -3 | awk '{print $NF}' | head -1)
			#_test=$(comgt -d /dev/$C2 -s $DIR/config/modem/testmdm | grep -c "K")
			_test=1				
			if [ "$_test" == "1" ];then
				# CHECK INBOX
				for ((x=0; x < 20; x++));do					
					gnokii --config $DIR/config/modem/port/"$C2" --getsms SM $x > /tmp/c2$x 2>/dev/null	
					if [ -s /tmp/c2$x ];then
						NH=`grep "Sender" /tmp/c2$x | sed 's/Sender://; s/Msg Center.*//g; s/ //g ; s/\+62/0/'`
						TGL=`grep "Date/time:" /tmp/c2$x | awk '{print $2}' | sed 's/\//-/g'`						
						JAM=`grep "Date/time:" /tmp/c2$x | awk '{print $3}'`
						IDSMS=` grep "Inbox Message" /tmp/c2$x | sed 's/. Inbox Message.*//g'`
						ISI=`head -5 /tmp/c2$x | tail -1 `
						echo "$ISI" > $DIR/tmp/sms/in/$TGL.$JAM.$NH 2>/dev/null
						gnokii --config $DIR/config/modem/port/"$C2" --deletesms SM $IDSMS 2>/dev/null
						rm /tmp/c2$x 2>/dev/null
					fi				
				done
				#CHECK OUTBOX AND SEND SMS
				CS2=$(cat $DIR/config/modem/status/c2)
				if [ "$CS2" != "0" ];then
				ls $dir2 > /tmp/out2
				if [ "x$(cat /tmp/out2)" !=  "x" ];then
					aout=(`cat /tmp/out2`)
					for x in ${aout[@]};do
						ax=(`echo $x | sed 's/\./ /g'`)
						# CHECK PREFIX
						prefix=$($sql "select nama_pengaturan from pengaturan where keterangan like '%${ax[2]:0:4}%'")
						if [ "$prefix" == "PrefixModem2" ];then
							cat $dir2/$x | gnokii --config $DIR/config/modem/port/"$C2" --sendsms ${ax[2]} 2>/dev/null 
							if [ "$?" -eq "0" ];then
								if [ "${ax[3]}" != "broadcast" ];then
									mv  $dir2/$x $dir3 2>/dev/null
								else
									rm -f  $dir2/$x 2>/dev/null
								fi
								sleep 2 2>/dev/null
							else
								rm -f  $dir2/$x 2>/dev/null
							fi
						else
							mv  $dir2/$x $dir3 2>/dev/null
						fi
					done
				fi
				fi
			else
				echo "MODEM2 TIDAK MERESPON" #2>/dev/null
				sleep 1 2>/dev/null
			fi
		elif [ "$_val" == "disconnected" ];then
			echo "MODEM2 TERPUTUS" #2>/dev/null
			sleep 1 2>/dev/null
		else
			echo "MODEM2 TIDAK DITEMUKAN" #2>/dev/null
			sleep 1 2>/dev/null
		fi
	else
		sleep 1 2>/dev/null
	fi		
done
exit 0    
