VitalPBX Stress Test
=====
For a long time many people have asked us the following:<br>
What is the concurrent call capacity of VitalPBX or Asterisk?<br>
We took on the task of conducting an investigation of how to perform a test of concurrent calls and we realized that the information was very poor and did not meet our expectations. So we decided to make a script to test the capacity of concurrent calls in VitalPBX depending on the hardware..<br>

-----------------
## Prerequisites
To do this test it is necessary to have two VitalPBX installed, the location that is to which we will perform the tests and the remote that is to which we will connect. It should be noted that it is necessary that the remote VitalPBX server should have more capacity than the local one, because if it had less capacity it could not reach the maximum capacity of the local server.<br>

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

Note:<br>
The test can not last more than 6 minutes due to the duration of the test audio. If you want a longer duration, change the test audio or add more audios in the line of:<br>
asterisk -rx "channel originate Local / 200 @ call-test-ext application Playback <Test Audio>
