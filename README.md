# stimulusPresentationTiming
Codes for generating visual stimuli with accurate timing using PTB and checking the timing using the photodiode signal and digital tags sent through NI-card

Stimulus timing and duration design by PTB and Matlab (code included in the mFile)
Recorded test with 20 stimulus each 5 frame duration in 180Hz refresh rate (rhd file include the digital tags recorded with intan and the analog signal from the photodiode)
The results of the tests of the digital tags and photodiode signal and delays estimated in matlab were done by python (code and results included in the ipynb file)

Details of the connections: photodiode (the one borrowed from Luke), screens: 1 - Asus ROG PG248Q (used for stimulus presentation) 2 - Samsung S24E650, presentation computer: Dell 3420, one screen connected through the DP from the onboard Intel graphic card

Onboard graphic card: Intel HD Graphics 630
AMD graphic card: AMD FirePro W4100

The result of the same test in the following settings (recommended setup:9):

All as the above but two screens:

Connection to 2 display ports of the onboard Intel graphic card:
1 - (Worked) Asus as the primary screen with 180 Hz refresh rate, and the second screen was samsung with 60 Hz refresh rate, both connected to the DP of the Intel onboard graphic card. Both screens with 1920x1080 resolution! (highest resolution of both monitors)

2 - (Didn’t work) when the primary screen was set to Samsung, PTB raised the synch error!

3 - (Worked) changing the resolution of the second non-primary screen (samsung here) didn’t affect the perfectness of the results!

Connection to 2 display ports of the AMD graphic card:
4 - (Worked) Asus as the primary screen with 180 Hz refresh rate, and the second screen was samsung with 60 Hz refresh rate, both connected to the DP of the Intel onboard graphic card. Both screens with 1920x1080 resolution! (highest resolution of both monitors)

5 - (Worked but PTB doesn’t release the screen with sca: not recommended) The primary screen was set to Samsung

6 - (Worked) changing the resolution of the second non-primary screen (samsung here) didn’t affect the perfectness of the results!

ASUS connected to the AMD and Samsung to the Intel onboard:
7 - (Worked) Asus as the primary screen with 180 Hz refresh rate, and the second screen was samsung with 60 Hz refresh rate, both connected to the DP of the Intel onboard graphic card. Both screens with 1920x1080 resolution! (highest resolution of both monitors)

Samsung connected to the AMD and ASUS to the Intel onboard:
8 - (Worked) Asus as the primary screen with 180 Hz refresh rate, and the second screen was samsung with 60 Hz refresh rate, both connected to the DP of the Intel onboard graphic card. Both screens with 1920x1080 resolution! (highest resolution of both monitors)

Asus to the Intel onboard DP and the Samsung to the Intel Onboard HDMI
9 - (Worked) Asus as the primary screen with 180 Hz refresh rate, and the second screen was samsung with 60 Hz refresh rate. Both screens with 1920x1080 resolution! (highest resolution of both monitors). This is the recommended setup, since we need to add another asus to the second DP port on Intel to have a mirror screen of the task. 

Cables:
Works with 180Hz:
5.5 feet E326508 Amphenol (DP to DP, and with mini dp to DP adaptorE164571 for AMD) 
5 feet E246588 Horton (DP to DP, and with mini dp to DP adaptorE164571 for AMD)
6 feet 05VX0-AA10-813 (mini dp tp dp)

Up to 144 Hz (OS shows the connection without any problem)
15 feet Amazon basics (and it doesn’t have the lock!) ---> get better 15 feet cables with lock!

Tests refresh rates: 
144 Hz (Asus to AMD through adaptor - Just one screen): Worked
144 Hz (Asus to AMD through adaptor and the other screen also to AMD): Worked - Asus Primary
144 Hz (Asus to Intel and the other screen also to Intel): Worked - Asus Primary

(NOT WORKED) 144 Hz (to AMD through adaptor and another screen through Intel): timings are not good! (duration and the start point is unreliable)

Conclusion: 1- get another good 15 feet cable 2- always keep the presenting screen as the primary one 3- need three dp ports! (two presenting and one admin!): Intel has two dp and AMD is not always releasing the screens: (this should be figured out) 4- the most reliable two screens connections with one long cable: both to the Intel! (but ultimately we need three connections in which two be the stimulus presentation)
