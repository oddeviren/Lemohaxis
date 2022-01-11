
/*
s.options.inDevice = "ASIO : Focusrite USB ASIO";
s.options.outDevice = "ASIO : Focusrite USB ASIO";
s.options.sampleRate_(44100);
*/

(

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////Bus Defs////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

~tpmbus = Bus.control(s,1);   //TrackedPitchMidiNo BUS
~tpfbus = Bus.control(s,1);   //TrackedPitchFreq BUS
~tpgbus = Bus.control(s,1);   //Tracked GATE BUS
~n0bus = Bus.control(s,1);
~n1bus = Bus.control(s,1);
~n2bus = Bus.control(s,1);
~n3bus = Bus.control(s,1);
~n4bus = Bus.control(s,1);
~n5bus = Bus.control(s,1);
~n6bus = Bus.control(s,1);
~n7bus = Bus.control(s,1);
~n8bus = Bus.control(s,1);
~pinchrbus = Bus.control(s,1); //Right Hand Pinch Bus
~pinchlbus = Bus.control(s,1); //Left Hand Pinch Bus
~grabrbus = Bus.control(s,1); //Right Hand Grab Bus
~grablbus = Bus.control(s,1); //Left Hand Grab Bus
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////OSC COMS//-and ranging data/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//NetAddr.langPort

b = NetAddr.new("127.0.0.1", 8080); //Processing Adress
m = NetAddr.new("127.0.0.1", 3131); //Max Adress

OSCdef(\listeningProcsagel, {arg msg;
	~sagelx = msg[2].linlin(-200,1400,0,1);
	~sagely = msg[4].linlin(-200,1100,0,1);
	~sag1parx = msg[6].linlin(-400,1450,0,1);
	~sag1pary = msg[8].linlin(-450,1200,0,1);
	~sag2parx = msg[10].linlin(-400,1450,0,1);
	~sag2pary = msg[12].linlin(-450,1200,0,1);
	~sag3parx = msg[14].linlin(-400,1450,0,1);
	~sag3pary = msg[16].linlin(-450,1200,0,1);
	~sag4parx = msg[18].linlin(-400,1450,0,1);
	~sag4pary = msg[20].linlin(-450,1200,0,1);
	~sag5parx = msg[22].linlin(-400,1450,0,1);
	~sag5pary = msg[24].linlin(-450,1200,0,1);
	~sagroll = msg[30].linlin(-179,179,-1,1);

	if (msg[26]==100)
	{
		~pinchrbus = 1; //Right Hand Pinch Bus
	}
	{
		~pinchrbus = 0; //Right Hand Pinch Bus
	};

	if (msg[28]==100)
	{
		~grabrbus = 1; //Right Hand Grab Bus
	}
	{
		~grabrbus = 0; //Right Hand Grab Bus
	};

}, "/proc/sagel");


OSCdef(\listeningProcsolel, {arg msg;
	~solelx = msg[2].linlin(-200,1400,0,1);
	~solely = msg[4].linlin(-200,1100,0,1);
	~sol1parx = msg[6].linlin(-400,1450,0,1);
	~sol1pary = msg[8].linlin(-450,1200,0,1);
	~sol2parx = msg[10].linlin(-400,1450,0,1);
	~sol2pary = msg[12].linlin(-450,1200,0,1);
	~sol3parx = msg[14].linlin(-400,1450,0,1);
	~sol3pary = msg[16].linlin(-450,1200,0,1);
	~sol4parx = msg[18].linlin(-400,1450,0,1);
	~sol4pary = msg[20].linlin(-450,1200,0,1);
	~sol5parx = msg[22].linlin(-400,1450,0,1);
	~sol5pary = msg[24].linlin(-450,1200,0,1);
	~solroll = msg[30].linlin(-179,179,0,1);

	if (msg[26]==100)
	{
		~pinchlbus = 1; //Left Hand Pinch Bus
	}
	{
		~pinchlbus = 0; //Left Hand Pinch Bus
	};

	if (msg[28]==100)
	{
		~grablbus = 1; //Left Hand Grab Bus
		~ctrl = 1; //->Controller
	}
	{
		~grablbus = 0; //Left Hand Grab Bus
	};

}, "/proc/solel");



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////New Note Cluster Tracker (for Routine) via OSC//////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////



OSCdef(\listeningProcNotes, {arg msg;
	msg.postln;
	~n0bus = msg[2];
	~n1bus = msg[4];
	~n2bus = msg[6];
	~n3bus = msg[8];
	~n4bus = msg[10];
	~n5bus = msg[12];
	~n6bus = msg[14];
	~n7bus = msg[16];
	~n8bus = msg[18];
	//~n0bus.value.postln;

	~noteclusterfull = [msg[2],55.midicps,msg[4],60.midicps,msg[6],62.midicps,msg[8],64.midicps,msg[10],65.midicps,msg[12],67.midicps,msg[14],69.midicps,msg[16],71.midicps,msg[18],72.midicps];

	~notecluster = Array.new(9);

	if (~noteclusterfull[0]==1)
	{
		~notecluster.add(55.midicps);
	};

	if (~noteclusterfull[2]==1)
	{
		~notecluster.add(60.midicps);
	};

	if (~noteclusterfull[4]==1)
	{
		~notecluster.add(62.midicps);
	};

	if (~noteclusterfull[6]==1)
	{
		~notecluster.add(64.midicps);
	};

	if (~noteclusterfull[8]==1)
	{
		~notecluster.add(65.midicps);
	};

	if (~noteclusterfull[10]==1)
	{
		~notecluster.add(67.midicps);
	};

	if (~noteclusterfull[12]==1)
	{
		~notecluster.add(69.midicps);
	};

	if (~noteclusterfull[14]==1)
	{
		~notecluster.add(71.midicps);
	};

	if (~noteclusterfull[16]==1)
	{
		~notecluster.add(72.midicps);
	};

	~scalesize = ~notecluster.size;

	~scalesize.do{
	arg item;
	~freqinterval = (1100/(item+1));};

	~maplist = Array.new(9);
	~maplist.add(0);
	~scalesize.do{
	arg item;
	~maplist.add((item+1)*~freqinterval);};

}, "/proc/newnotes");





/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Audio Input Pitch Tracker//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


SynthDef(\tracker, {
	var track, trackgate;
	# track, trackgate = Pitch.kr(SoundIn.ar(0, minFreq: 60, maxFreq: 4000, ampThreshold: 0.1, peakThreshold: 0.5));  //freq tanımı
	~trackedpitchfreq = track;
	~trackedpitchmidi = track.cpsmidi.round(1);
	Out.kr(~tpfbus, ~trackedpitchfreq);
	Out.kr(~tpmbus, ~trackedpitchmidi);
	Out.kr(~tpgbus, trackgate);
}).play;



//TRACKER VALUES FROM OUTPUT
/*

~tpmbus.getSynchronous;   //TrackedPitchMidiNo Value
~tpfbus.getSynchronous;   //TrackedPitchFreq
~tpgbus.getSynchronous;   //Tracked GATE

*/



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////SYNTHESIZER//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////




SynthDef.new(\blonp, {
	arg freq = 440, amp = 0.08;
	var signal, envelope;
	envelope = EnvGen.ar(Env.adsr(0.001, 2, 0.0, 0.04, curve: \lin));
	signal = SinOsc.ar(freq);
	signal = signal * amp * envelope;
	signal = Splay.ar(signal);
	DetectSilence.ar(signal, doneAction: 2);
	Out.ar(0, signal);
}).add;

SynthDef(\blonp2, { arg out, singSwitch = 0, freq = 2434, amp = 0.05, decayScale = 1, lag = 10, pan = 0;
	var snd, input, first, freqScale, mallet, sing;
	freqScale = freq / 2434;
	freqScale = Lag3.kr(freqScale, lag);
	decayScale = Lag3.kr(decayScale, lag);

	// mallet
	mallet = LPF.ar(
		in: Impulse.ar(0) ! 2 * amp,
		freq: 10000 * freqScale
	);

	// sing
	sing = LPF.ar(
		in: {PinkNoise.ar * Integrator.kr(singSwitch * 0.001, 0.999).linexp(0, 1, 0.01, 1) * amp} ! 2,
		freq: 2434 * freqScale
	);

	sing = sing + Dust.ar(0.1);
	sing = LPF.ar(sing, 10000 * freqScale);
	sing = sing * LFNoise1.kr(0.5).range(-45, -30).dbamp;

	// input = mallet + sing
	input = mallet + (singSwitch.clip(0, 1) * sing);

	// resonant filter bank
	snd = DynKlank.ar(
		specificationsArrayRef: `[
			// Array of filter frequencies
			[
				(first = LFNoise1.kr(0.5).range(2424, 2444)) + Line.kr(20, 0, 0.5),
				first + LFNoise1.kr(0.5).range(1,3),
				LFNoise1.kr(1.5).range(5435, 5440) - Line.kr(35, 0, 1),
				LFNoise1.kr(1.5).range(5480, 5485) - Line.kr(10, 0, 0.5),
				LFNoise1.kr(2).range(8435, 8445) + Line.kr(15, 0, 0.05),
				LFNoise1.kr(2).range(8665, 8670),
				LFNoise1.kr(2).range(8704, 8709),
				LFNoise1.kr(2).range(8807, 8817),
				LFNoise1.kr(2).range(9570, 9607),
				LFNoise1.kr(2).range(10567, 10572) - Line.kr(20, 0, 0.05),
				LFNoise1.kr(2).range(10627, 10636) + Line.kr(35, 0, 0.05),
				LFNoise1.kr(2).range(14689, 14697) - Line.kr(10, 0, 0.05)
			],
			// Array of filter amplitudes
			[
				LFNoise1.kr(1).range(-10, -5).dbamp,
				LFNoise1.kr(1).range(-20, -10).dbamp,
				LFNoise1.kr(1).range(-12, -6).dbamp,
				LFNoise1.kr(1).range(-12, -6).dbamp,
				-20.dbamp,
				-20.dbamp,
				-20.dbamp,
				-25.dbamp,
				-10.dbamp,
				-20.dbamp,
				-20.dbamp,
				-25.dbamp
			],
			// Array of filter decay times
			[
				20 * freqScale.pow(0.2),
				20 * freqScale.pow(0.2),
				5,
				5,
				0.6,
				0.5,
				0.3,
				0.25,
				0.4,
				0.5,
				0.4,
				0.6
			] * freqScale.reciprocal.pow(0.5)
		],
		input: input,
		freqscale: freqScale,
		freqoffset: 0,
		decayscale: decayScale
	);

	DetectSilence.ar(snd, doneAction: 2);

	Out.ar(out, Pan2.ar(Mix.ar(snd), pan));
},

).add;


(
SynthDef(\droneFM, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, freq=440, m1Ratio=1, m2Ratio=2, m3Ratio=3,
	amp=0.02, dur=10, ampM=0.84 , pan=0;
	var sig, car1, mod1, car2, mod2, car3, mod3, env, index;
	index = LFNoise1.kr(0.2).range(2, 12);
	env = EnvGen.kr(Env.new([0, 0.70, 0.70, 0], [dur*0.2, dur*0.1, dur*0.7]), doneAction:2);
	mod1 = SinOsc.ar([freq * m1Ratio, freq+0.7 * m1Ratio], mul:freq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(f1Freq + mod1);
	mod2 = SinOsc.ar([freq * m2Ratio, freq+1.4 * m2Ratio], mul:freq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);
	mod3 = SinOsc.ar([freq * m3Ratio, freq+0.35 * m3Ratio], mul:freq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.4;
	sig = car1 + car2 + car3 * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
)


)



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////SYNTHCONTROLS//////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
(
~controlsag = 1;
~controlsol = 1;
~controlchopsol = 1;
~controlchopsag = 1;
~controlgrabsol = 1;
~controlgrabsag = 1;




OSCdef(\listeningProcsagel2, {arg msg;
		if (msg[26]>40 && msg[4]>=700 && ~controlsag == 1 && msg[28]==0)      //Pinch ise, el aşağı hareket edip 700ün altına indiyse ve kontrol açıksa
		{
		~scalesize.do{
		arg item;
			if (msg[2]>~maplist[item] && msg[2] < ~maplist[(item+1)])
			{
				x = Synth.new(\blonp,[\freq, (~notecluster[item]*2), \amp, 0.1]);
				~controlsag = 0;
			}
		};
	};

	if (msg[4]<=650.0 && ~controlsag == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlsag = 1;
	};

}, "/proc/sagel");


OSCdef(\listeningProcsolel2, {arg msg;
	if (msg[26]>40 && msg[4]>=700 && ~controlsol == 1 && msg[28]==0)      //Pinch ise, el aşağı hareket edip 700ün altına indiyse ve kontrol açıksa
		{
		~scalesize.do{
		arg item;
			if (msg[2]>~maplist[item] && msg[2] < ~maplist[(item+1)])
			{
				x = Synth.new(\blonp,[\freq, ~notecluster[item]]);
				~controlsol = 0;
			}
		};
	};

	if (msg[4]<=650.0 && ~controlsol == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlsol = 1;
	};

}, "/proc/solel");


OSCdef(\listeningProcsolel3, {arg msg;
	msg.postln;
	if (msg[2]<=(-90) && msg[2]>=(-110) && ~controlchopsol == 1)
	{
		k = Synth(\blonp2,[\freq, ~notecluster[0]]);
		~controlchopsol = 0;
	};
	if (msg[2]<=(-170) && ~controlchopsol == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlchopsol = 1;
	};
};, "/proc/solelroll");

OSCdef(\listeningProcsagel3, {arg msg;
	msg.postln;
	if (msg[2]>=(90) && msg[2]<=(110) && ~controlchopsag == 1)
	{
		k = Synth(\blonp2,[\freq, ~notecluster.choose]);
		~controlchopsag = 0;
	};
	if (msg[2]>=(170) && ~controlchopsag == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlchopsag = 1;
	};
};, "/proc/sagelroll");

OSCdef(\listeningProcsolel4, {arg msg;
	msg.postln;
	if (msg[2]==(100)&& ~controlgrabsol == 1 && msg[4]>=(800) &&  msg[6]<=(40))
	{
		x = Synth.new(\droneFM,[\freq, (( ~notecluster.choose)/2)]);
		~controlgrabsol = 0;
	};
};, "/proc/solelgrab");

OSCdef(\listeningProcsagel4, {arg msg;
	msg.postln;
	if (msg[2]==(100)&& ~controlgrabsag == 1 && msg[4]>=(800) &&  msg[6]<=(40))
	{
		x = Synth.new(\droneFM,[\freq,  ~notecluster.choose]); //or .cpsmidi.round(1))]);
		~controlgrabsag = 0;
	};
};, "/proc/sagelgrab");

OSCdef(\listeningProcsolel5, {arg msg;
	msg.postln;
	if (msg[2]<=10.0 && ~controlgrabsol == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlgrabsol = 1;
	};
};, "/proc/solelgrab2");


OSCdef(\listeningProcsagel5, {arg msg;
	msg.postln;
	if (msg[2]<=10.0 && ~controlgrabsag == 0) //El geri kalktı ise, kontrolü aç
	{
		~controlgrabsag = 1;
	};
};, "/proc/sagelgrab2");


)











