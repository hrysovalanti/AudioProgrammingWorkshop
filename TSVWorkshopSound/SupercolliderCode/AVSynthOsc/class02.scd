//From Previous Sound Example
/*(
f={ arg rate=2;
	var sig, freq;
	freq=LFNoise0.kr(rate).exprange(200,800);
	sig= SinOsc.ar(freq,0, SinOsc.kr(100))}.play;
)
f.free;
f.set(\rate, exprand(4, 8));

//fade out time in seconds
f.release(3);*/
s.boot;

//Create your synth with variables to be sent as osc
(SynthDef(\randomsine, {arg lforate=2, out=0, sinefreq=200, sineampcontrol=100;
	var trig,sig, amp, env;
	//Here is the rate for the osc messages(a random exponential value)
	trig=LFNoise2.kr(lforate);
	//amplitude modulation
	amp= 0.2*SinOsc.kr(sineampcontrol);
	//Here is your sound out
	sig= SinOsc.ar(sinefreq);
	//sound out with amp mod
	env =(sig *amp);
	//Here we specify which variables at the rate we defined earlier will be sent out as osc
	SendReply.kr(trig, '/oscout', [trig,amp]);
	//Creating a bus(speaker) for our synth
	Out.ar(out, env*trig!2);
}).add;
)
s.meter;


//To play our synth
~myfirstSineOsc=Synth.new(\randomsine);
~myfirstSineOsc.trace;
//To change our synth arguments live we use the set method.
//Repeat in a new line, set method to live code
~myfirstSineOsc.set(\lforate,2,\sinefreq,exprand(200,1000), \sineampcontrol, 1);

//To stop our Synth from playing we are freeing it from the server.
~myfirstSineOsc.free;

//To USE the OSC protocol first we need to create a network address with "IP" and, port number(for osc hydra port is 41234)
~defaultoscsc= NetAddr("localhost",41234);

//Our First message is our synth's lfo, an OSCDef class is used to send the message and can be modified live
(
//name of OSCdef,
OSCdef(\lfosend, { |msg|
	//specifying the msg from
	var datalfo = msg[3]*100;
	datalfo.postln;
	~defaultoscsc.sendMsg("/lfo", datalfo);
}, '/oscout');
)

(
OSCdef(\ampsend, { |msg|
	var datamp = msg[4];
	datamp.postln;
	~defaultoscsc.sendMsg("/amp", datamp);
}, '/oscout');
)