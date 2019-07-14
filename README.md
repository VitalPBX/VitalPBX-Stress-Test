# VitalPBX-Stress-Test
VitalPBX Stress Test


## Script
Now copy and run the following script<br>
<pre>
[root@vitalpbx1 ~]#  cd /
[root@vitalpbx1 ~]#  wget https://raw.githubusercontent.com/VitalPBX/vitalpbx_/master/vital_ha.sh
[root@vitalpbx1 ~]#  chmod +x vital_ha.sh
[root@vitalpbx1 ~]#  ./vital_ha.sh
</pre>
Set these values, remember the Floating IP Mask must be 2 digit format (SIDR) and the Disk is that you created in the step “Create Disk”:
<pre>
IP Master.......... > <strong>192.168.30.10</strong>
IP Slave........... > <strong>192.168.30.20</strong>
Floating IP........ > <strong>192.168.30.30</strong>
Floating IP Mask... > <strong>21</strong>
Disk (sdax)........ > <strong>sda4</strong>
hacluster password. > <strong>mypassword</strong>

Are you sure to continue with these settings? (yes,no) > <strong>yes</strong>

Are you sure you want to continue connecting (yes/no)? <strong>yes</strong>

root@192.168.30.20's password: <strong>The root password from Slave Server</strong>
</pre>

At the end of the installation you have to see the following message

<pre>
