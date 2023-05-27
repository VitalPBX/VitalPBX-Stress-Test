#!/bin/bash
set -e
# Authors:      Rodrigo Cuadra
#               with Collaboration of Jose Miguel Rivera
#		Stress Test with one Server
# Date:         27-May-2023
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
					protocol=$line
  				;;
				2)
					codec=$line
  				;;
				3)
					recording=$line
  				;;
				5)
					maxcpuload=$line
  				;;
				5)
					call_step=$line
  				;;
				6)
					call_step_seconds=$line
  				;;
			esac
			n=$((n+1))
		done < $filename
		echo -e "Protocol (1.-SIP, 2.-IAX, 3.-PJSIP)............ >  $protocol"
		echo -e "Codec (1.-None, 2.-G79, 3.- GSM)............... >  $codec"
		echo -e "Recording Calls (yes,no)....................... >  $recording"
		echo -e "Max CPU Load (Recommended 90%)................. >  $maxcpuload"
		echo -e "Calls Step (Recommended 5-20).................. >  $call_step"
		echo -e "Seconds between each step (Recommended 5-30)... >  $call_step_seconds"
	fi

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

echo -e "$protocol" 		>> config.txt
echo -e "$codec" 		>> config.txt
echo -e "$recording" 		>> config.txt
echo -e "$maxcpuload"     	>> config.txt
echo -e "$call_step" 		>> config.txt
echo -e "$call_step_seconds" 	>> config.txt

echo -e "************************************************************"
echo -e "*            Creating Asterisk config files                *"
echo -e "************************************************************"

echo -e "[999](p1)" 						> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "type=endpoint" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "auth=auth999" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "identify_by=username,auth_username" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "outbound_auth=auth999" 				>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "aors=999" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "deny=9" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "permit=9" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "dtmf_mode=rfc4733" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "message_context=messages" 				>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "set_var=DEVICENAME=999" 				>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "tone_zone=us" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "set_var=CHANNEL(parkinglot)=parking-1" 		>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
	if [ "$codec" = 1 ] ;then
		codec_name=ulaw,alaw
		echo -e "allow=!all,ulaw,alaw" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
	fi
	if [ "$codec" = 2 ] ;then
		codec_name=g729
		echo -e "allow=!all,g729" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
	fi
	if [ "$codec" = 3 ] ;then
		codec_name=gsm
		echo -e "allow=!all,gsm" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
	fi
echo -e "language=en" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "moh_suggest=default" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "context=cos-all" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "mailboxes=999@vitalpbx-voicemail" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "device_state_busy_at=0" 				>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "callerid="Stress Test" <999>" 				>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "" 							>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "[auth999]" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "type=auth" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "auth_type=userpass" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "username=999" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "password=4R3u92nYDm2b7zaN48ZNvwgAx" 			>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "" 							>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "[999](p1-aor)" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "type=aor" 						>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf
echo -e "max_contacts=5" 					>> /etc/asterisk/vitalpbx/pjsip__61-call-test.conf




echo -e "[call-test-ext]" 							> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
echo -e "exten => _200,1,NoOp(Outgoing Call)" 					>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	if [ "$cdrs" != yes ] ;then
		echo -e " same => n,NoCDR()" 					>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	fi
	if [ "$recording" = yes ] ;then
		echo -e " same => n,MixMonitor(/tmp/$"{UNIQUEID}".wav,ab)" 	>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	fi
	if [ "$protocol" = 1 ] ;then
		echo -e " same => n,Dial(SIP/call-test-trk/100,30,rtT)" 	>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	fi
	if [ "$protocol" = 2 ] ;then
		echo -e " same => n,Dial(IAX2/call-test-trk/100,30,rtT)"	>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	fi
	if [ "$protocol" = 3 ] ;then
		echo -e " same => n,Dial(PJSIP/call-test-trk/100)"		>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf
	fi
echo -e " same => n,Hangup()" 							>> /etc/asterisk/vitalpbx/extensions__61-call-test.conf

asterisk -rx"core restart now"
echo -e "*** Done ***"
echo -e " *************************************************************************************"
echo -e " *                            Restarting Asterisk                                    *"
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
printf "%2s %7s %10s %16s %10s %10s %12s %12s\n" "|" " Step |" "Calls |" "Asterisk Calls |" "CPU Load |" "Memory |"
sleep 1
echo -e "calls, active calls, cpu load (%), memory (%), bwtx (kb/s), bwrx(kb/s), interval(seg)" 	> data.csv
	while [ $exitcalls = 'false' ]        
        do
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
		printf "%2s %7s %10s %16s %10s %10s %12s %12s\n" "|" " "$step" |" ""$i" |" ""$activecalls" |" ""$cpu"% |" ""$memory" |"
		echo -e "$i, $activecalls, $cpu, $memory, $seconds" 	>> data.csv
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
		sleep "$call_step_seconds"
        done
echo -e "\e[39m -------------------------------------------------------------------------------------"
echo -e " *************************************************************************************"
echo -e " *                               Restarting Asterisk                                 *"
echo -e " *************************************************************************************"
asterisk -rx"core restart now"
rm -rf /tmp/*.wav
rm -rf /etc/asterisk/vitalpbx/extensions__61-call-test.conf

echo -e " *************************************************************************************"
echo -e " *                                 Test Complete                                     *"
echo -e " *                            Result in data.csv file                                *"
echo -e " *************************************************************************************"
echo -e "\e[39m"
