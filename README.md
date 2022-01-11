# Lemohaxis
Interactive Music System for a Handpan, Leap Motion Controller and Xbox Controller.
It is designed to create meditative improvisational music.


Video Excerpt: https://vimeo.com/663140358 or https://vimeo.com/664955903
Audio Excerpt: https://tinyurl.com/2p952yrm


A leap motion tracker, a dynamic microphone, an Xbox 360 wireless controller and a reciever, and preferably an audio interface are required for running the system. 

-SETUP-
1- Connect microphone to the audio interface and check levels. 
2- Turn on the controller.
3- Run Processing file. Visual feedback must be visible to the handpan performer. 
4- Turn on controller and open the Max patch. Dont forget to run digital signal processing.
5- Open the Supercollider file. After setting the server options, boot the server.
6- Run the first chunk (Definitions).
7- Run the second chunk (Controls).
8- Ready to go.

General:
A dynamic microphone must be used for Handpan, for best results and not to disturb performer, it should be placed inside the handpan. Gain level must be adjusted depending on the microphone. 


Processing:
Guda.jpg must be in a folder named "data" in the same folder where the processing code running.
Also Leap Motion library must be installed inside the processing before running.

Max:
Controller must be turned on "before" openning the patch. (There is a problem on HCI object that it doesnt recognize the controller if it is turned on after opening the patch)
Fiddle pitch tracking object is used, so it must be installed depending on the users operating system.
***Be carefull about sound levels before testing. Strongly recommended to start with low volume as each interface-monitor has different output level.

Supercollider:
Dont forget to define your audio interface in server options.
Run first chunk, then run the second chunk.

Possible issues:
-In case of OSC communication problems, check ports used in the code, and rematch them. Current ports are unused in my system, but there is no guarantee that they are also unused in other systems.
-Xbox 360 wireless controllers are becoming problematic with each update and it gets harder to find suitable drivers. In that case, you can use other controller and remap in Max, inside the Xbox controls sub-patch.
-Some objects and libraries may stop working again due to OS updates.
-Check Sample if rates are matching between software and audio interface if you having a sound related problem.
-In case of extreme use of numerous sound generating units simultanously, it might cause latency. But you will be fine as long as you have a strong computer.
-For input problems check Max Audio setting and supercolliders Pitch.kr parameter.

Will be updated...
