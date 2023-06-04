s.reboot;
~sound= {rrand(SinOsc.ar(0.1), SinOsc.ar(0.42)) *0.1};
~sound.play;

~sound= {SinOsc.ar(\freq.kr(400)).postln};
~sound.stop;
~sound.xset(\freq,200);
//command line example, server-client

//make sound creating functions
x={SinOsc.ar}.play;
x.free;

//live code with set
(z= {
arg freq=440, amp=1;
var sig;
sig= SinOsc.ar(freq)*amp;
}.play;
)

z.set(\freq,200).;
z.free;
// modulate pulse width
{ Pulse.ar(200, Line.kr(0.01,0.99,8), 0.2) }.scope(1);

// two band limited square waves thru a resonant low pass filter
{ RLPF.ar(Pulse.ar([100,250],0.5,0.1), XLine.kr(8000,400,5), 0.05) }.scope(1);

//Generates random values at a rate given by the nearest integer division of the sample rate by the freq argument.
(w= {
	arg noiseHz=8;
	var freq, amp, sig;
	freq= LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp= LFNoise1.kr(12).exprange(0.02,1);
	sig= SinOsc.ar(freq) * amp;
}.play;
)

w.set(\noiseHz, 64);
w.set(\noiseHz,exprand(4,64));
w.release(3);

(r= {
	var sig;
	sig=
}.play;
)
s.scope;
(
Pbind(\note, Prand([ 0, 2, 4 ], inf),
    \dur, 0.2
).play;
)

s.options.outDevice="Built-in Output";
s.options.sampleRate=44100;

