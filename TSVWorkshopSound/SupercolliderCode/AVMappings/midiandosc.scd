//To Capture all Midi Devices in Supercollider, you can use the MIDIIn class
//Connect MIDI before activating this line.
//s.waitForBoot{
  //Code here
MIDIIn.connectAll;
//MIDIClient to see the information that gets posted(a list of sources and destinations)
MIDIClient.init;

//MIDI Func(difference is that wants a global variable) and MIDI Def(syntax exactly the same as sythndef)

//Debugging tool
MIDIFunc.trace(true);// all the data for every single message that comes in.
MIDIFunc.trace(false);

(
SynthDef.new(\tone,{
	arg freq=440, amp=0.2, gate=0, out=0;
	var sig, env;
	sig=SinOsc.ar(freq,0,amp!2);
		env= EnvGen.kr(Env.adsr,gate,doneAction:2);
		sig= sig * env;
	SendReply.kr(env,'/oscout', [freq,amp]);
	//SendReply.kr(env,'/oscoutsec', amp);
	Out.ar(out,sig);
	}).add;
)

~defaultoscsc=NetAddr("localhost", 41234);
(
OSCdef(\sinesend, { |msg|
	var datafreq ;
	datafreq = msg[3];
	//dataamp= msg[4];
    datafreq.postln;
	//dataamp.postln;
	~defaultoscsc.sendMsg("/freq", datafreq);
	//~defaultoscsc.sendMsg("/amp", datafreq);
}, '/oscout');
)

(
OSCdef(\sinesendamp, { |msg|
	var dataamp ;
	//datafreq = msg[3];
	dataamp= msg[4];
   // datafreq.postln;
	dataamp.postln;
	~defaultoscsc.sendMsg("/amp",dataamp);
}, '/oscout');
)

~notes= Array.fill(128,{nil});

(
MIDIdef.noteOn(\on,{
	arg val, num, chan, src;
	[val,num,chan,src].postln;
	~notes[num]=Synth.new(\tone, [\freq,num.midicps,
		\amp, val.linexp(1,127,0.02,0.5),
		\gate,1,
		\out,0
	]);

});//To kill it manually

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val,num,chan,src].postln;
	~notes[num].set(\gate,0);
	~notes[num]=nil;
})//To kill it manually
)


//to stop it manually
//MIDIdef(\on).free;
(
SynthDef(\noisewater,{
	arg noisefreq=1, res=0.08, noisetrig=0.5,hfreq=1900, pulsetrig=1, pwm=0.05, out=0, atk=0.1, rel=0.3, rate=10, chan=0.1;
	var sig, env, trig, pulse;
	//pulse= LFNoise2.kr(pulsetrig,pwm);
	trig=Impulse.kr(rate);
	chan= LFTri.kr(0.1);
	sig= Pan2.ar(RLPF.ar(BrownNoise.ar(noisefreq),hfreq,res),LFNoise2.kr(chan),1);
	SendReply.kr(trig, '/noisea',noisefreq );
	Out.ar(out,sig);
}).add;
)
~noisemiddlelowsec=Synth(\noisewater, [\freq,0.005,\hfreq,120, \res, 0.02,\chan,0.5]);
(
OSCdef(\noisesend, { |msg|
	var dataamp ;
	dataamp= msg[3];
   // datafreq.postln;
	dataamp.postln;
	~defaultoscsc.sendMsg("/chan",dataamp);
}, '/noisea');
)

(
MIDIdef.cc(\control,{
	arg val, num, chan, src;
	[val,num,chan,src].postln;
	~noisemiddlelowsec.set(\freq, val.linlin(0,127,0,0.008))
}, 3)
)

/*//MIDIdef.freeAll;
s.boot;
}*/