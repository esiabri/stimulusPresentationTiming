% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% selecting the screen for the stimulus presentation: mirroring two
% identical screens show them with one number here.
screenNumber = max(screens);%1;%

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
grey = white / 2;

% Open an on screen window using PsychImaging and color it white. (or the
% default stimulus with white under the photo-diode area)
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% set the priority level of this thread as the highest
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% number of the stimuli and the duration of each stimulus in this test
numStim = 20;
stimFrames = 5;

% Initializaing the sessions for using the DAQ card (NI-6323 here) to tag
% the signal from the photo-diode

stimIDSession = daq.createSession('ni');
stimTagSession = daq.createSession('ni');
recStartStopSession = daq.createSession('ni');

%sessions with different number of digital channels don't work! why? So we
%define three sessions in three ports each with 8 channels: stimIDSession
%which delivers the stimulus ID to the Intan (port 2/line0:7). stimTagSession contanis two
%channels (port0/line0:1) that toggle before and after Scrren('Flip',...).
%recStartStopSession contains a channel (port1/line1) to send the start/stop recording
%trigger to the Intan. Port 0 is dedicated to the tag signals, since it is
%the only port which could be accompanied by an analog channel in a same
%session.
%Port 1/line 0 (PFI0) is not connected on the NI-card interface (silly!)
%stimIDSession lines go to the digital channels 0:7 on Intan, 
%stimTagSession lines go to the digital channels 8:9 on Intan,
%recStartStopSession line go to the digital channel 15 on Intan

stimTagSession.addDigitalChannel('Dev1','port0/line0:7','OutputOnly');
tagsDefaultValue = [1,1,0,0,0,0,0,0];
beforeStimOnFlip = [0,1,0,0,0,0,0,0];
afterStimOnFlip = [0,0,0,0,0,0,0,0];
afterStimOffFlip = [1,1,0,0,0,0,0,0];

stimTagSession.outputSingleScan(tagsDefaultValue);

recStartStopSession.addDigitalChannel('Dev1','port1/line0:7','OutputOnly');
recStartTrigger = [0,1,0,0,0,0,0,0];
recStopTrigger = [0,0,0,0,0,0,0,0];

recStartStopSession.outputSingleScan(recStopTrigger);


% toggeling the digital tag before recording since it behaves wieredly
% during the first toggles!
for loop=1:3
    stimTagSession.outputSingleScan(afterStimOffFlip);
    pause(1);
    stimTagSession.outputSingleScan(tagsDefaultValue);
end

%following variables save the times at differen points of each stimulus
%presentation

vblStimAll = zeros(numStim,1);
stimTime = zeros(numStim,1); %Stim time based on the corrected vbl (in case the vbl correction is available) and also corrected based on other parameters
BeamposStimAll = zeros(numStim,1);
MissedStimAll = zeros(numStim,1);
FlipTimestampStimAll = zeros(numStim,1);

timeBeforeDigitalTagBeforeStimFlipAll = zeros(numStim,1);
timeAfterDigitalTagBeforeStimFlipAll = zeros(numStim,1);

timeBeforeDigitalTagAfterStimFlipAll = zeros(numStim,1);
timeAfterDigitalTagAfterStimFlipAll = zeros(numStim,1);


vblStimEndAll = zeros(numStim,1);
stimEndTime = zeros(numStim,1);
BeamposStimEndAll = zeros(numStim,1);
MissedStimEndAll = zeros(numStim,1);
FlipTimestampStimEndAll = zeros(numStim,1);

timeBeforeDigitalTagAfterStimEndFlipAll = zeros(numStim,1);
timeAfterDigitalTagAfterStimEndFlipAll = zeros(numStim,1);



% White is the default value under the photodiode, Flip the default screen
% with White under the photo-diode
Screen('FillRect', window, white);
Screen('Flip', window);

pause(2); %Wait for the white screen before strating the recording 

recStartStopSession.outputSingleScan(recStartTrigger); %Start the recording

for stim = 1:numStim

        
    pause(rand); %random pause (0-1 sec) between two successive stimuli
    
    timeBeforeDigitalTagBeforeStimFlip = GetSecs;
    stimTagSession.outputSingleScan(beforeStimOnFlip); %before Stimulus Flip Tag
    timeAfterDigitalTagBeforeStimFlip = GetSecs; %This time is used to estimate the delay between the tag and stim start
    
    Screen('FillRect', window, black); %Loading the Stimulus (black screen here)
    %Stimulus Onset which could happen anytime, (no reference point here)
    %in case of timing needed it should be added as a parameter to the
    %Screen like the next Screen command used
    [vblStim StimulusOnsetTime FlipTimestampStim MissedStim BeamposStim] = Screen('Flip', window); 

    timeBeforeDigitalTagAfterStimFlip = GetSecs;
    stimTagSession.outputSingleScan(afterStimOnFlip); %after Stimulus Flip Tag
    timeAfterDigitalTagAfterStimFlip = GetSecs;

    Screen('FillRect', window, white); 
    %Stimulus End by loading the default background (white under the
    %photodiode), this ensures the duration of the stimulus since it is
    %started at [vblStim + (stimFrames - 0.5) * ifi] 
    [vblStimEnd PostStimulusOnsetTime FlipTimestampStimEnd MissedStimEnd BeamposStimEnd] = Screen('Flip', window, vblStim + (stimFrames - 0.5) * ifi); 
    
    timeBeforeDigitalTagAfterStimEndFlip = GetSecs;
    stimTagSession.outputSingleScan(afterStimOffFlip); %after Post Stimulus Flip Tag
    timeAfterDigitalTagAfterStimEndFlip = GetSecs;
        
    
    vblStimAll(stim) = vblStim;
    stimTime(stim) = StimulusOnsetTime;
    BeamposStimAll(stim) = BeamposStim;
    MissedStimAll(stim) = MissedStim;
    FlipTimestampStimAll(stim) = FlipTimestampStim;
    
    timeBeforeDigitalTagBeforeStimFlipAll(stim) = timeBeforeDigitalTagBeforeStimFlip;
    timeAfterDigitalTagBeforeStimFlipAll(stim) = timeAfterDigitalTagBeforeStimFlip;
    
    timeBeforeDigitalTagAfterStimFlipAll(stim) = timeBeforeDigitalTagAfterStimFlip;
    timeAfterDigitalTagAfterStimFlipAll(stim) = timeAfterDigitalTagAfterStimFlip;
    
    
    vblStimEndAll(stim) = vblStimEnd;
    stimEndTime(stim) = PostStimulusOnsetTime;
    BeamposStimEndAll(stim) = BeamposStimEnd;
    MissedStimEndAll(stim) = MissedStimEnd;
    FlipTimestampStimEndAll(stim) = FlipTimestampStimEnd;
    
    timeBeforeDigitalTagAfterStimEndFlipAll(stim) = timeBeforeDigitalTagAfterStimEndFlip;
    timeAfterDigitalTagAfterStimEndFlipAll(stim) = timeAfterDigitalTagAfterStimEndFlip;
    

end

recStartStopSession.outputSingleScan(recStopTrigger); % Stop the recording

WaitSecs(2);
sca;

% Estimated delay of the stimulus start time relative to the "before Stimulus Flip Tag":
estimatedTagDelayStimStart = stimTime - timeAfterDigitalTagBeforeStimFlipAll;
% It turns out that the real time of the stimulus onset on the screen
% (based on the photo-diode signal) is exactly one frame (1/refRate) after
% this calculated delay relative to the "before Stimulus Flip Tag"
% in other words: Stimulu_Start_Time = before_Stimulus_Flip_Tag + ifi
% This has been tested for different refresh rates up to 180 Hz