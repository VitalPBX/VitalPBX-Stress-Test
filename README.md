# VitalPBX-Stress-Test
VitalPBX Stress Test


## Script
Now copy and run the following script<br>
<pre>
[root@vitalpbx1 ~]#  cd /
[root@vitalpbx1 ~]#  wget https://raw.githubusercontent.com/VitalPBX/VitalPBX-Stress-Test/master/stress-test.sh
[root@vitalpbx1 ~]#  chmod +x stress-test.sh
[root@vitalpbx1 ~]#  ./stress-test.sh
</pre>
Set these values:
<pre>
IP Local....................................... >  <strong>192.168.30.10</strong>	
IP Remote...................................... >  <strong>192.168.30.20</strong>
Protocol (1.-SIP, 2.-IAX)...................... >  <strong>1</strong>
Codec (1.-None, 2.-G79, 3.- GSM)............... >  <strong>1</strong>
Recording Calls (yes,no)....................... >  <strong>no</strong>
Max CPU Load (Recommended 90%)................. >  <strong>90</strong>
Calls Step (Recommended 5-20).................. >  <strong>10</strong>
Seconds between each step (Recommended 5-30)... >  <strong>10</strong>

Are you sure to continue with these settings? (yes,no) > <strong>yes</strong>

Are you sure you want to continue connecting (yes/no)? <strong>yes</strong>

root@192.168.30.20's password: <strong>The root password from Remote Server</strong>
</pre>


