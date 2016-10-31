####    Follow Me   Autostart ####
####    Herbert Wagner 05/2016      ####

var autostart = func {
setprop("/controls/engines/engine/direction", 0);
setprop("/controls/gear/brake-parking", 1);
setprop("/controls/engines/engine/starter", 1);
setprop("/controls/engines/engine/ignition", 1);
setprop("/controls/engines/engine/direction", 0);
setprop("/controls/gear/brake-parking", 0);
setprop("/controls/engines/engine/direction", 1);
    gui.popupTip("Engine started, Brakes are loose, lets go!");
 }
