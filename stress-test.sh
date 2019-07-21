#!/bin/bash
set -e
# Authors:      Rodrigo Cuadra
#               with Collaboration of Jose Miguel Rivera
# Date:         14-Jul-2019
# Support:      rcuadra@aplitel.com
#
echo -e "\n"
echo -e "\e[39m"
echo -e "************************************************************"
echo -e "*         Welcome to the VitalPBX stress test              *"
echo -e "*              All options are mandatory                   *"
echo -e "************************************************************"
echo -e "*           Warning-Warning-Warning-Warning                *"
echo -e "*         Due to limitations in the audio used             *"
echo -e "*      the test can not be longer than 6 minutes           *"
echo -e "************************************************************"
filename="config.txt"
	if [ -f $filename ]; then
		echo -e "config file"
		n=1
		while read line; do
			case $n in
				1)
					ip_local=$line
  				;;
				2)
					ip_remote=$line
  				;;
				3)
					interface_name=$line
  				;;
				4)
					protocol=$line
  				;;
				5)
					codec=$line
  				;;
				6)
					recording=$line
  				;;
				7)
					maxcpuload=$line
  				;;
				8)
					call_step=$line
  				;;
				9)
					call_step_seconds=$line
  				;;
			esac
			n=$((n+1))
		done < $filename
		echo -e "IP Local....................................... >  $ip_local"	
		echo -e "IP Remote...................................... >  $ip_remote"
		echo -e "Network Interface name (ej: eth0).............. >  $interface_name"
		echo -e "Protocol (1.-SIP, 2.-IAX)...................... >  $protocol"
		echo -e "Codec (1.-None, 2.-G79, 3.- GSM)............... >  $codec"
		echo -e "Recording Calls (yes,no)....................... >  $recording"
		echo -e "Max CPU Load (Recommended 90%)................. >  $maxcpuload"
		echo -e "Calls Step (Recommended 5-20).................. >  $call_step"
		echo -e "Seconds between each step (Recommended 5-30)... >  $call_step_seconds"
	fi
	
	while [[ $ip_local == '' ]]
	do
    		read -p "IP Local....................................... > " ip_local 
	done 

	while [[ $ip_remote == '' ]]
	do
    		read -p "IP Remote...................................... > " ip_remote 
	done
	
	while [[ $interface_name == '' ]]
	do
    		read -p "Network Interface name (ej: eth0).............. > " interface_name 
	done

	while [[ $protocol == '' ]]
	do
    		read -p "Protocol (1.-SIP, 2.-IAX)...................... > " protocol 
	done

	while [[ $codec == '' ]]
	do
    		read -p "Codec (1.-None, 2.-G79, 3.- GSM)............... > " codec 
	done 

	while [[ $recording == '' ]]
	do
    		read -p "Recording Calls (yes,no)....................... > " recording 
	done 

	while [[ $maxcpuload == '' ]]
	do
    		read -p "Max CPU Load (Recommended 90%)................. > " maxcpuload 
	done 

	while [[ $call_step == '' ]]
	do
    		read -p "Calls Step (Recommended 5-20).................. > " call_step 
	done 

	while [[ $call_step_seconds == '' ]]
	do
    		read -p "Seconds between each step (Recommended 5-30)... > " call_step_seconds
	done 

echo -e "************************************************************"
echo -e "*                   Check Information                      *"
echo -e "*        Make sure that both server have communication     *"
echo -e "************************************************************"
	while [[ $veryfy_info != yes && $veryfy_info != no ]]
	do
    		read -p "Are you sure to continue with this settings? (yes,no) > " veryfy_info 
	done

	if [ "$veryfy_info" = yes ] ;then
		echo -e "************************************************************"
		echo -e "*                Starting to run the scripts               *"
		echo -e "************************************************************"
	else
		while [[ $ip_local == '' ]]
		do
    			read -p "IP Local....................................... > " ip_local 
		done 

		while [[ $ip_remote == '' ]]
		do
    			read -p "IP Remote...................................... > " ip_remote 
		done

		while [[ $interface_name == '' ]]
		do
    			read -p "Network Interface name (ej: eth0).............. > " interface_name 
		done
		
		while [[ $protocol == '' ]]
		do
    			read -p "Protocol (1.-SIP, 2.-IAX....................... > " protocol 
		done

		while [[ $codec == '' ]]
		do
    			read -p "Codec (1.-None, 2.-G79, 3.- GSM................ > " codec 
		done 

		while [[ $recording == '' ]]
		do
    			read -p "Recording Calls (yes,no)....................... > " recording 
		done 

		while [[ $maxcpuload == '' ]]
		do
    			read -p "Max CPU Load (Recommended 90%)................. > " maxcpuload 
		done 

		while [[ $call_step == '' ]]
		do
    			read -p "Calls Step (Recommended 5-20).................. > " call_step 
		done 

		while [[ $call_step_seconds == '' ]]
		do
    			read -p "Seconds between each step (Recommended 5-30)... > " call_step_seconds
		done 
	fi

echo -e "$ip_local" 		> config.txt
echo -e "$ip_remote" 		>> config.txt
echo -e "$interface_name" 	>> config.txt
echo -e "$protocol" 		>> config.txt
echo -e "$codec" 		>> config.txt
echo -e "$recording" 		>> config.txt
echo -e "$maxcpuload"     	>> config.txt
echo -e "$call_step" 		>> config.txt
echo -e "$call_step_seconds" 	>> config.txt
echo -e "************************************************************"
echo -e "*          Copy Authorization key to remote server         *"
echo -e "************************************************************"
sshKeyFile=/root/.ssh/id_rsa
	if [ ! -f $sshKeyFile ]; then
		ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' >/dev/null
	fi
ssh-copy-id root@$ip_remote
echo -e "*** Done ***"

echo -e "************************************************************"
echo -e "*            Creating Asterisk config files                *"
echo -e "************************************************************"

echo -e "[call-test-ext]" 							> /etc/asterisk/ombutel/extensions__60-call-test.conf
echo -e "exten => _200,1,NoOp(Outgoing Call)" 					>> /etc/asterisk/ombutel/extensions__60-call-test.conf
	if [ "$cdrs" != yes ] ;then
		echo -e " same => n,NoCDR()" 					>> /etc/asterisk/ombutel/extensions__60-call-test.conf
	fi
	if [ "$recording" = yes ] ;then
		echo -e " same => n,MixMonitor(/tmp/$"{UNIQUEID}".wav,ab)" 	>> /etc/asterisk/ombutel/extensions__60-call-test.conf
	fi
	if [ "$protocol" = 1 ] ;then
		echo -e " same => n,Dial(SIP/call-test-trk/100,30,rtT)" 	>> /etc/asterisk/ombutel/extensions__60-call-test.conf
	else
		echo -e " same => n,Dial(IAX2/call-test-trk/100,30,rtT)"		>> /etc/asterisk/ombutel/extensions__60-call-test.conf
	fi
echo -e " same => n,Hangup()" 							>> /etc/asterisk/ombutel/extensions__60-call-test.conf

	if [ "$protocol" = 1 ] ;then
		protocol_name=SIP
		rm -rf /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "[call-test-trk]" 					> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "context=call-test-ext" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "description=Call_Test" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "host=$ip_remote" 					>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "type=friend" 						>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "transport=udp" 					>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "qualify=yes" 						>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "outbound_registration=yes" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "auth_rejection_permanent=yes" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "max_retries=10" 					>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "expiration=3600" 					>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "retry_interval=60" 					>> /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "forbidden_retry_interval=10" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		codec_name=NONE
		if [ "$codec" = 2 ] ;then
			codec_name=g729
			echo -e "allow=!all,g729" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		fi
		if [ "$codec" = 3 ] ;then
			codec_name=gsm
			echo -e "allow=!all,gsm" 				>> /etc/asterisk/ombutel/sip__60-call-test.conf
		fi
	fi

	if [ "$protocol" = 2 ] ;then
		protocol_name=IAX
		rm -rf /etc/asterisk/ombutel/sip__60-call-test.conf
		echo -e "[call-test-trk]" 					> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "context=call-test-ext" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "description=Call_Test" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "host=$ip_remote" 					>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "type=friend" 						>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "transport=udp" 					>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "qualify=yes" 						>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "outbound_registration=yes" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "auth_rejection_permanent=yes" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "max_retries=10" 					>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "expiration=3600" 					>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "retry_interval=60" 					>> /etc/asterisk/ombutel/iax__60-call-test.conf
		echo -e "forbidden_retry_interval=10" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		codec_name=NONE
		if [ "$codec" = 2 ] ;then
			codec_name=g729
			echo -e "allow=!all,g729" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		fi
		if [ "$codec" = 3 ] ;then
			codec_name=gsm
			echo -e "allow=!all,gsm" 				>> /etc/asterisk/ombutel/iax__60-call-test.conf
		fi
	fi

ssh root@$ip_remote "echo -e '[call-test-ext]' 					> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e 'exten => _100,1,Answer()' 			>> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e ' same => n,NoCDR()' 				>> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e ' same => n(begin),Wait(1)' 			>> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e ' same => n,Playback(demo-instruct&silence/10)'    >> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e ' same => n,Goto(begin)' 				>> /etc/asterisk/ombutel/extensions__60-call-test.conf"
ssh root@$ip_remote "echo -e ' same => n,Hangup()' 				>> /etc/asterisk/ombutel/extensions__60-call-test.conf"

	if [ "$protocol" = 1 ] ;then
		ssh root@$ip_remote "rm -rf /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e '[call-test-trk]' 			> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'context=call-test-ext' 		>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'description=Call_Test' 		>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'host=$ip_local' 			>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'type=friend' 				>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'transport=udp' 			>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'qualify=yes' 				>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'outbound_registration=yes' 		>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'auth_rejection_permanent=yes'		>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'max_retries=10' 			>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'expiration=3600' 			>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'retry_interval=60' 			>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'forbidden_retry_interval=10' 		>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		if [ "$codec" = 2 ] ;then
			ssh root@$ip_remote "		echo -e 'allow=!all,g729' 	>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		fi
		if [ "$codec" = 3 ] ;then
			ssh root@$ip_remote "		echo -e 'allow=!all,gsm' 	>> /etc/asterisk/ombutel/sip__60-call-test.conf"
		fi
	fi

	if [ "$protocol" = 2 ] ;then
		ssh root@$ip_remote "rm -rf /etc/asterisk/ombutel/sip__60-call-test.conf"
		ssh root@$ip_remote "	echo -e '[call-test-trk]' 			> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'context=call-test-ext' 		>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'description=Call_Test' 		>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'host=$ip_local' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'type=friend' 				>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'transport=udp' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'qualify=yes' 				>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'outbound_registration=yes' 		>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'auth_rejection_permanent=yes'		>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'max_retries=10' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'expiration=3600' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'retry_interval=60' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		ssh root@$ip_remote "	echo -e 'forbidden_retry_interval=10' 		>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		if [ "$codec" = 2 ] ;then
			ssh root@$ip_remote "		echo -e 'allow=!all,g729' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		fi
		if [ "$codec" = 3 ] ;then
			ssh root@$ip_remote "		echo -e 'allow=!all,gsm' 			>> /etc/asterisk/ombutel/iax__60-call-test.conf"
		fi
	fi

asterisk -rx"core restart now"
ssh root@$ip_remote "asterisk -rx'core restart now'"
echo -e "*** Done ***"
echo -e " *************************************************************************************"
echo -e " *                      Restarting Asterisk in both Server                           *"
echo -e " *************************************************************************************"
sleep 10
numcores=`nproc --all`
exitcalls=false
i=0
step=0
clear
echo -e " *************************************************************************************"
	if [ "$codec" = 3 ] ;then
		echo -e " *           Actual Test State (Protocol: "$protocol_name", Codec: "$codec_name", Recording: "$recording")           *"
	else
		echo -e " *           Actual Test State (Protocol: "$protocol_name", Codec: "$codec_name", Recording: "$recording")          *"
	fi
echo -e " *************************************************************************************"
echo -e " -------------------------------------------------------------------------------------"
printf "%2s %7s %10s %16s %10s %10s %12s %12s\n" "|" " Step |" "Calls |" "Asterisk Calls |" "CPU Load |" "Memory |" "BW TX kb/s |" "BW RX kb/s |"
R1=`cat /sys/class/net/"$interface_name"/statistics/rx_bytes`
T1=`cat /sys/class/net/"$interface_name"/statistics/tx_bytes`
date1=$(date +"%s")
sleep 1
echo -e "calls, active calls, cpu load (%), memory (%), bwtx (kb/s), bwrx(kb/s), interval(seg)" 	> data.csv
	while [ $exitcalls = 'false' ]        
        do
       		R2=`cat /sys/class/net/"$interface_name"/statistics/rx_bytes`
       		T2=`cat /sys/class/net/"$interface_name"/statistics/tx_bytes`
		date2=$(date +"%s")
		diff=$(($date2-$date1))
		seconds="$(($diff % 60))"
		T2=`expr $T2 + 128`
		R2=`expr $R2 + 128`
        	TBPS=`expr $T2 - $T1`
        	RBPS=`expr $R2 - $R1`
        	TKBPS=`expr $TBPS / 128`
        	RKBPS=`expr $RBPS / 128`
		bwtx="$((TKBPS/seconds))"
		bwrx="$((RKBPS/seconds))"
		activecalls=`asterisk -rx "core show calls" | grep "active" | cut -d' ' -f1`
		cpu=`top -n 1 | awk 'FNR > 7 {s+=$10} END {print s}'`
		cpuint=${cpu%.*}
		cpu="$((cpuint/numcores))"
		memory=`free | awk '/Mem/{printf("%.2f%"), $3/$2*100} /buffers\/cache/{printf(", buffers: %.2f%"), $4/($3+$4)*100}'`
		if [ "$cpu" -le 34 ] ;then
			echo -e "\e[92m -------------------------------------------------------------------------------------"
		fi
		if [ "$cpu" -ge 35 ] && [ "$cpu" -lt 65 ] ;then
			echo -e "\e[93m -------------------------------------------------------------------------------------"
		fi
		if [ "$cpu" -ge 65 ] ;then
			echo -e "\e[91m -------------------------------------------------------------------------------------"
		fi
		printf "%2s %7s %10s %16s %10s %10s %12s %12s\n" "|" " "$step" |" ""$i" |" ""$activecalls" |" ""$cpu"% |" ""$memory" |" ""$bwtx" |" ""$bwrx" |"
		echo -e "$i, $activecalls, $cpu, $memory, $bwtx, $bwrx, $seconds" 	>> data.csv
		exitstep=false
		x=1
		while [ $exitstep = 'false' ]  
        	do
			let x=x+1
			if [ "$call_step" -lt $x ] ;then
				exitstep=true
			fi
			asterisk -rx"channel originate Local/200@call-test-ext application Playback demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct&demo-instruct"
		done
		let step=step+1
		let i=i+"$call_step"
		if [ "$cpu" -gt "$maxcpuload" ] ;then
			exitcalls=true
		fi
		R1=`cat /sys/class/net/"$interface_name"/statistics/rx_bytes`
		T1=`cat /sys/class/net/"$interface_name"/statistics/tx_bytes`
		date1=$(date +"%s")
		sleep "$call_step_seconds"
        done
echo -e "\e[39m -------------------------------------------------------------------------------------"
echo -e " *************************************************************************************"
echo -e " *                               Restarting Asterisk                                 *"
echo -e " *************************************************************************************"
asterisk -rx"core restart now"
rm -rf /tmp/*.wav
echo -e " *************************************************************************************"
echo -e " *                                 Test Complete                                     *"
echo -e " *                            Result in data.csv file                                *"
echo -e " *************************************************************************************"
echo -e "\e[39m"
