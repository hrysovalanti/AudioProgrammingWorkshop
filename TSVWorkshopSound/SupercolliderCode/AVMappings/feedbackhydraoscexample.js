 // Type some code on a new line (such as "osc().out()"), and press CTRL+shift+enter\
 await loadScript("https://cdn.jsdelivr.net/gh/ojack/hydra-osc/lib/osc.min.js")
 _osc = new OSC() 
 _osc.open() 
 _osc.on("*", (m) => { console.log(m.address, m.args)}) 
 
mod= 0
 _osc.on("/freq", (m) => { mod=m.args[0]})
 hue=0
 _osc.on("/amp", (m) => { hue=m.args[0]})
 diff=0
 _osc.on("/noisefreq", (m) => { diff=m.args[0]})



 osc(0.8,()=>hue,()=>hue*10).modulateRotate(o0,()=>mod/10).colorama(()=>hue).out()
 osc(0.8,()=>hue,3).diff(o2,()=>hue).out(o1)
 src(o0,3).mult(o1,3).kaleid(()=>oof).out(o2)
 render(o0)
