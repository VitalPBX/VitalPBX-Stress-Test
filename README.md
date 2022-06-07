VitalPBX-Asterisk Stress Test
=====
In this tutorial, we will show you how to perform a test to know the capacity of simultaneous calls in VitalPBX and Asterisk PBX depending on the hardware.

For a long time many people have asked us the following:<br>
“What is the concurrent call capacity of VitalPBX or Asterisk?… What is the bandwidth consumption for calls in VitalPBX or Asterisk?”

We took on the task of conducting an investigation of how to perform a test of concurrent calls and we realized that the information was very poor and did not meet our expectations. So we decided to make a script to test the capacity of concurrent calls in VitalPBX depending on the hardware it has been installed on and bandwidth consumption..<br>

-----------------
## Prerequisites
To do this test it is necessary to have two VitalPBX servers installed, the server on which we will perform the tests and the remote server to which we will connect. It should be noted, that it is necessary that the remote VitalPBX server should have more capacity than the local one. Because if it had less capacity, it will not stress test the maximum capacity of the local server.<br>

## Script VitalPBX V3 and V4
Next, copy and run the following script on the server you wish to stress test<br>
<pre>
[root@vitalpbx1 ~]#  cd /
[root@vitalpbx1 ~]#  wget https://raw.githubusercontent.com/VitalPBX/VitalPBX-Stress-Test/master/stress-test.sh
[root@vitalpbx1 ~]#  chmod +x stress-test.sh
[root@vitalpbx1 ~]#  ./stress-test.sh
</pre>
Set up the following information (In your case the values can change):
<pre>
IP Local....................................... >  <strong>192.168.30.10</strong>	
IP Remote...................................... >  <strong>192.168.30.20</strong>
SSH Remote Port (Default is 22)................ >  <strong>22</strong>
Network Interface name (ej: eth0).............. >  <strong>eth0</strong>
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
The test cannot last more than 10 minutes due to the duration of the audio. If you want a longer duration, change the audio or add more time to the "demo-instruct" audio on this line on the stress-test.sh script:<br>
asterisk -rx "channel originate Local / 200 @ call-test-ext application Playback demo-instruct&demo-instruct......

## Test results
Hardware Info<br>
<pre>
Motherboard----> Raspberry Pi 4 Model B
CPU Model------> Broadcom BCM2711, Quad core Cortex-A72 (ARM v8) 64-bit SoC @ 1.5GHz
CPU Cores------> 4
MEMORY RAM-----> 4 GB
</pre>

![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_RaspberryPI4.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_REC_RaspberryPI4.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_RaspberryPI4.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_REC_RaspberryPI4.png)


Hardware Info<br>
<pre>
Motherboard----> YANYU STX-R19F
CPU Model------> Intel(R) Celeron(R) CPU J1900 @ 1.99GHz
CPU Cores------> 4
MEMORY RAM-----> 4 GB
</pre>

![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_Celeron_J1900.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_REC_Celeron_J1900.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_Celeron_J1900.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_REC_Celeron_J1900.png)


Hardware Info<br>
<pre>
Motherboard----> YANYU STX-N92_VER:1.0
CPU Model------> Intel(R) Core(TM) i5-4210Y CPU @ 1.50GHz
CPU Cores------> 4
MEMORY RAM-----> 4 GB
</pre>

![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_Intel_I5.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_REC_Intel_I5.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_Intel_I5.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_REC_Intel_I5.png)


Hardware Info<br>
<pre>
Motherboard----> Virtual
CPU Model------> 4 threads, 4GB RAM, M1 Max - ARM CPU
CPU Cores------> 4
MEMORY RAM-----> 4 GB
</pre>

![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_M1.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_REC_M1.png)
![VitalPBX-Stress-Test](https://github.com/VitalPBX/VitalPBX-Stress-Test/blob/master/images/VitalPBX_StressTest_SIP_G729_REC_M1.png)

## Conclusions
In the tests done to the Raspberry PI 3+ without using any type of codec and without recording of calls a total of up to 80 concurrent calls was achieved using 94% of CPU Processing and only 27% of memory, which we conclude Asterisk requires mostly processor resources when making a call. When we add call recording, the reduction in call capacity is 25%, that is 80 to 60 simultaneous calls. The most marked difference is when we use codec g729, there is a decrease in capacity of 50% and it increases to 60% less when we add call recording with the codec g729. In conclusion, the use of codecs affects the performance of our PBX by quite a lot, however, the benefit we have is the reduction of consumption bandwidth from 85K to 30k per call, approximately. We believe it is advisable not to use codecs since in this day and age, since the bandwidth that the ISPs offer us are much better than past decades, where compression was really needed.

We could see the same behavior when the tests were performed on an Intel Celeron J1900 processor and a 4th generation Intel Core i5 with 4GB of RAM.

Another conclusion we cam to with these tests, is that the memory is not very important with respect to concurrent calls in Asterisk, however, in some cases it is necessary since not only the Asterisk application is executed on a server with VitalPBX. We recommend not to commit the error of believing that increasing the memory will increase the processing capacity of concurrent calls from our server.

## Recommendations

1.-Always size the server with a test of 50% (maximum) of occupation, that is to say, when performing the test take as the maximum when the occupation of the CPU reaches 50%. This is because you have to take into account that we may have other applications running on the same server at any given time.<br>
2.- Do not make the mistake of over-sizing the server. in many cases, with 4GB of RAM is more than enough.<br>
3.- Use solid state drives, since this increases the speed of execution for any process.<br>
4.- Never do this test on a server that is in production. Perform this test before deploying any server with VitalPBX.<br>
5.- All of your comments are welcome.<br>

