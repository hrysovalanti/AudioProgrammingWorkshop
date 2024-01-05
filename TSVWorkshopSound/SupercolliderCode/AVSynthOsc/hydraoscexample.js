 
 // Type some code on a new line (such as "osc().out()"), and press CTRL+shift+enter
 await loadScript("https://cdn.jsdelivr.net/gh/ojack/hydra-osc/lib/osc.min.js")
 _osc = new OSC() 
 _osc.open() 
 _osc.on("*", (m) => { console.log(m.address, m.args)}) 
 
 lfo= 0
 _osc.on("/lfo", (m) => { lfo=m.args[0]})
hue=0
 _osc.on("/amp", (m) => { hue=m.args[0]})


 osc(()=>lfo,()=>hue*100,()=>hue*100).out()
//osc(0.20,()=>oof,()=>oof*100).modulateRotate(o0,()=>foo*10).colorama(()=>foo/2).out()
