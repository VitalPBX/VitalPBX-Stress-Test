#!/bin/bash
set -e
# Authors:      Rodrigo Cuadra
#               with Collaboration of Jose Miguel Rivera
# Date:         30-May-2023
# Support:      rcuadra@vitalpbx.com
#
echo -e "\n"
echo -e "\e[39m"
echo -e "************************************************************"
echo -e "*       Welcome to the VitalPBX 3-4 stress test            *"
echo -e "*              All options are mandatory                   *"
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
					ssh_remote_port=$line
  				;;
				4)
					interface_name=$line
  				;;
				5)
					protocol=$line
  				;;
				6)
					codec=$line
  				;;
				7)
					recording=$line
  				;;
				8)
					maxcpuload=$line
  				;;
				9)
					call_step=$line
  				;;
				10)
					call_step_seconds=$line
  				;;
			esac
			n=$((n+1))
		done < $filename
		echo -e "IP Local....................................... >  $ip_local"	
		echo -e "IP Remote...................................... >  $ip_remote"
		echo -e "SSH Remote Port (Default is 22)................ >  $ssh_remote_port"
		echo -e "Network Interface name (ej: eth0).............. >  $interface_name"
		echo -e "Protocol (1.-SIP, 2.-IAX, 3.-PJSIP)............ >  $protocol"
		echo -e "Codec (1.-None, 2.-G79, 3.- GSM)............... >  $codec"
		echo -e "Recording Calls (yes,no)....................... >  $recording"
		echo -e "Max CPU Load (Recommended 75%)................. >  $maxcpuload"
		echo -e "Calls Step (Recommended 5-100)................. >  $call_step"
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

	while [[ $ssh_remote_port == '' ]]
	do
    		read -p "SSH Remote Port (Default is 22)................ > " ssh_remote_port 
	done

	while [[ $interface_name == '' ]]
	do
    		read -p "Network Interface name (ej: eth0).............. > " interface_name 
	done

	while [[ $protocol == '' ]]
	do
    		read -p "Protocol (1.-SIP, 2.-IAX, 3.-PJSIP)............ > " protocol 
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
    		read -p "Max CPU Load (Recommended 75%)................. > " maxcpuload 
	done 

	while [[ $call_step == '' ]]
	do
    		read -p "Calls Step (Recommended 5-100)................. > " call_step 
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

		while [[ $ssh_remote_port == '' ]]
		do
    			read -p "SSH Remote Port (Default is 22)................. > " ssh_remote_port 
		done

		while [[ $interface_name == '' ]]
		do
    			read -p "Network Interface name (ej: eth0).............. > " interface_name 
		done
		
		while [[ $protocol == '' ]]
		do
    			read -p "Protocol (1.-SIP, 2.-IAX, 3.-PJSIP............. > " protocol 
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
    			read -p "Max CPU Load (Recommended 75%).................. > " maxcpuload 
		done 

		while [[ $call_step == '' ]]
		do
    			read -p "Calls Step (Recommended 5-100)................. > " call_step 
		done 

		while [[ $call_step_seconds == '' ]]
		do
    			read -p "Seconds between each step (Recommended 5-30)... > " call_step_seconds
		done 
	fi

echo -e "$ip_local" 		> config.txt
echo -e "$ip_remote" 		>> config.txt
echo -e "$ssh_remote_port"	>> config.txt
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
ssh-copy-id -p $ssh_remote_port root@$ip_remote
echo -e "*** Done ***"

echo -e "************************************************************"
echo -e "*            Creating Asterisk config files                *"
echo -e "************************************************************"

wget -O /var/lib/asterisk/sounds/en/sarah.wav  https://github.com/VitalPBX/VitalPBX-Stress-Test/raw/refs/heads/master/sarah.wav

echo -e "[call-test-ext]" 							> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e "exten => _200,1,NoOp(Outgoing Call)" 					>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n, Answer()" 						        >> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
	if [ "$cdrs" != yes ] ;then
		echo -e " same => n,NoCDR()" 					>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
	fi
	if [ "$recording" = yes ] ;then
		echo -e " same => n,MixMonitor(/tmp/$"{UNIQUEID}".wav,ab)" 	>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
	fi
echo -e " same => n(begin),Wait(1)"                                             >> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n,Playback(sarah)"                                            >> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n,Goto(begin)"                                                >> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n,Hangup()" 							>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " " 						                	>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e "[call-test-trk]" 							>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e "exten => 100,1,Answer()" 						>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n,Dial(PJSIP/100@call-test-trk,30,rtT)" 			>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf
echo -e " same => n,Hangup()" 							>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf

protocol_name=PJSIP
echo -e "[call-test-trk](p1)" 					> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "type=endpoint" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "dtmf_mode=rfc4733" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "context=call-test-ext" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
if [ "$codec" = 1 ] ;then
	codec_name=NONE
	echo -e "allow=!all,ulaw,alaw" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
fi		
if [ "$codec" = 2 ] ;then
	codec_name=g729
	echo -e "allow=!all,g729" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
fi
if [ "$codec" = 3 ] ;then
	codec_name=gsm
	echo -e "allow=!all,gsm" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
fi
echo -e "language=en" 						>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "aors=call-test-trk" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "trust_id_inbound=no" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "trust_id_outbound=no" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "" 							>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "[call-test-trk](p1-aor)" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "type=aor" 						>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "max_contacts=2" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "contact=sip:call-test-trk@$ip_remote:5060"		>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "qualify_frequency=30" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "qualify_timeout=3" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "" 							>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "[call-test-trk]" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "type=identify" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "endpoint=call-test-trk" 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf
echo -e "match=@$ip_remote" 					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf

ssh -p $ssh_remote_port root@$ip_remote "wget -O /var/lib/asterisk/sounds/en/jonathan.wav https://github.com/VitalPBX/VitalPBX-Stress-Test/raw/refs/heads/master/jonathan.wav"

ssh -p $ssh_remote_port root@$ip_remote "echo -e '[call-test-ext]' 					> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e 'exten => _100,1,Answer()' 				>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e ' same => n,NoCDR()' 					>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e ' same => n(begin),Wait(1)' 				>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e ' same => n,Playback(jonathan)'                 	>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e ' same => n,Goto(begin)' 				>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "echo -e ' same => n,Hangup()' 					>> /etc/asterisk/vitalpbx/extensions__60-call-test.conf"
	
ssh -p $ssh_remote_port root@$ip_remote "rm -rf /etc/asterisk/vitalpbx/sip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "rm -rf /etc/asterisk/vitalpbx/iax__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e '[call-test-trk](p1)'				> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'type=endpoint'					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'dtmf_mode=rfc4733' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'context=call-test-ext'				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
if [ "$codec" = 1 ] ;then
	codec_name=NONE
	ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'allow=!all,ulaw,alaw' 			>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
fi		
if [ "$codec" = 2 ] ;then
	codec_name=g729
	ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'allow=!all,g729' 			>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
fi
if [ "$codec" = 3 ] ;then
	codec_name=gsm
	ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'allow=!all,gsm' 			>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
fi
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'language=en'					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'aors=call-test-trk'				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'trust_id_inbound=no'				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'trust_id_outbound=no' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e ''						>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e '[call-test-trk](p1-aor)' 			>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'type=aor'					>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'max_contacts=2'				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'contact=sip:call-test-trk@$ip_local:5060'	>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'qualify_frequency=30' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'qualify_timeout=3' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e '' 						>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e '[call-test-trk]'				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'type=identify' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'endpoint=call-test-trk' 			>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"
ssh -p $ssh_remote_port root@$ip_remote "	echo -e 'match=$ip_local' 				>> /etc/asterisk/vitalpbx/pjsip__60-call-test.conf"

systemctl restart asterisk
ssh -p $ssh_remote_port root@$ip_remote "systemctl restart asterisk"
echo -e "*** Done ***"
echo -e " **************************************************************************************"
echo -e " *                      Restarting Asterisk in both Server                            *"
echo -e " **************************************************************************************"
sleep 10
numcores=`nproc --all`
exitcalls=false
i=0
step=0
clear
echo -e " ************************************************************************************************"
echo -e "     Actual Test State (Step: "$call_step_seconds"s, Core: "$numcores", Protocol: "$protocol_name", Codec: "$codec_name", Recording: "$recording")     "
echo -e " ************************************************************************************************"
echo -e " ------------------------------------------------------------------------------------------------"
printf "%2s %7s %10s %19s %10s %10s %10s %12s %12s\n" "|" " Step |" "Calls |" "Asterisk Channels |" "CPU Load |" "Load |" "Memory |" "BW TX kb/s |" "BW RX kb/s |"
R1=`cat /sys/class/net/"$interface_name"/statistics/rx_bytes`
T1=`cat /sys/class/net/"$interface_name"/statistics/tx_bytes`
date1=$(date +"%s")
slepcall=$(printf %.2f "$((1000000000 * call_step_seconds / call_step))e-9")
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
		load=`cat /proc/loadavg | awk '{print $0}' | cut -d " " -f 1`
		cpu=`top -n 1 | awk 'FNR > 7 {s+=$10} END {print s}'`
		cpuint=${cpu%.*}
		cpu="$((cpuint/numcores))"
		memory=`free | awk '/Mem/{printf("%.2f%"), $3/$2*100} /buffers\/cache/{printf(", buffers: %.2f%"), $4/($3+$4)*100}'`
		if [ "$cpu" -le 34 ] ;then
			echo -e "\e[92m ------------------------------------------------------------------------------------------------"
		fi
		if [ "$cpu" -ge 35 ] && [ "$cpu" -lt 65 ] ;then
			echo -e "\e[93m ------------------------------------------------------------------------------------------------"
		fi
		if [ "$cpu" -ge 65 ] ;then
			echo -e "\e[91m ------------------------------------------------------------------------------------------------"
		fi
		printf "%2s %7s %10s %19s %10s %10s %10s %12s %12s\n" "|" " "$step" |" ""$i" |" ""$activecalls" |" ""$cpu"% |" ""$load" |" ""$memory" |" ""$bwtx" |" ""$bwrx" |"
		echo -e "$i, $activecalls, $cpu, $load, $memory, $bwtx, $bwrx, $seconds" 	>> data.csv
		exitstep=false
		x=1
		while [ $exitstep = 'false' ]  
        	do
			let x=x+1
			if [ "$call_step" -lt $x ] ;then
				exitstep=true
			fi
                        asterisk -rx"channel originate Local/200@call-test-ext extension 100@call-test-trk"
			sleep "$slepcall"
		done
		let step=step+1
		let i=i+"$call_step"
		if [ "$cpu" -gt "$maxcpuload" ] ;then
			exitcalls=true
		fi
		R1=`cat /sys/class/net/"$interface_name"/statistics/rx_bytes`
		T1=`cat /sys/class/net/"$interface_name"/statistics/tx_bytes`
		date1=$(date +"%s")
#		sleep "$call_step_seconds"
		sleep 1
	done
echo -e "\e[39m ------------------------------------------------------------------------------------------------"
echo -e " ************************************************************************************************"
echo -e " *                                    Restarting Asterisk                                       *"
echo -e " ************************************************************************************************"
rm -rf /etc/asterisk/vitalpbx/asterisk__60-max-load.conf
systemctl restart asterisk
ssh -p $ssh_remote_port root@$ip_remote "systemctl restart asterisk"
rm -rf /tmp/*.wav
echo -e " ************************************************************************************************"
echo -e " *                                      Test Complete                                           *"
echo -e " *                                 Result in data.csv file                                      *"
echo -e " ************************************************************************************************"
echo -e "\e[39m"
