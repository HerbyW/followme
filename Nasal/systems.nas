####    Follow Me   ####

# -new light function for MP-Modus
# -Killer grass elimination
# - mouse control
# by Herbert Wagner 05/2015



var sbc1 = aircraft.light.new( "/sim/model/lights/sbc1", [0.5, 0.3] );
sbc1.interval = 0.1;
sbc1.switch( 1 );

var sbc2 = aircraft.light.new( "/sim/model/lights/sbc2", [0.2, 0.3], "/sim/model/lights/sbc1/state" );
sbc2.interval = 0;
sbc2.switch( 1 );

setlistener( "/sim/model/lights/sbc2/state", func(n) {
  var bsbc1 = sbc1.stateN.getValue();
  var bsbc2 = n.getBoolValue();
  var b = 0;
  if( bsbc1 and bsbc2 and getprop( "/controls/lighting/beacon") ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/beacon/enabled", b );

  if( bsbc1 and !bsbc2 and getprop( "/controls/lighting/indicators" ) ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/indicators/enabled", b );
});

var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0.5, 0.5] );
beacon.interval = 0;

var indicators = aircraft.light.new( "/sim/model/lights/indicators", [0.7, 0.7] );
indicators.interval = 0;


###########################################################################
# Killer grass and other surfaces get now killed themselfs :)
# by HerbyW 07-2015
#

var min_carrier_alt = 2;

# Do terrain modelling ourselves.
setprop("/sim/fdm/surface/override-level", 1);

terrain_survol = func {

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var info = geodinfo(lat, lon);




 if (info != nil) {
    if (info[0] != nil){
       setprop("/fdm/jsbsim/environment/terrain-hight",info[0]);

#var terrain_hight = info[0];
#print("TERRAIN ",terrain_hight);

      
    }
    if (info[1] != nil){
      if (info[1].solid !=nil){
        setprop("/fdm/jsbsim/environment/terrain-undefined",0);
        setprop("/fdm/jsbsim/environment/terrain-solid",info[1].solid);

#var solid = info[1].solid;
#print("SOLID ",solid);

    }
      if (info[1].light_coverage !=nil)
       setprop("/fdm/jsbsim/environment/terrain-light-coverage",info[1].light_coverage);
      if (info[1].load_resistance !=nil)
       setprop("/fdm/jsbsim/environment/terrain-load-resistance",info[1].load_resistance);
      if (info[1].friction_factor !=nil)
       setprop("/fdm/jsbsim/environment/terrain-friction-factor",info[1].friction_factor);
      if (info[1].bumpiness !=nil)
       setprop("/fdm/jsbsim/environment/terrain-bumpiness",info[1].bumpiness);
      if (info[1].rolling_friction !=nil)
       setprop("/fdm/jsbsim/environment/terrain-rolling-friction",info[1].rolling_friction);
      if (info[1].names !=nil)
       setprop("/fdm/jsbsim/environment/terrain-names",info[1].names[0]);

#unfortunately when on carrier the info[1]  is nil,  only info[0] is valid
#var terrain_name = info[1].names[0];
#print("NAME ",terrain_name);
      #if (terrain_name == "Ocean" and terrain_hight >  min_carrier_alt)
        #setprop("fdm/jsbsim/environment/terrain-oncarrier",1);
    }else{
setprop("/fdm/jsbsim/environment/terrain-undefined",1);
}
	      #debug.dump(geodinfo(lat, lon));


  }else {
    setprop("/fdm/jsbsim/environment/terrain-hight",0);
    setprop("/fdm/jsbsim/environment/terrain-solid",1);
    setprop("/fdm/jsbsim/environment/terrain-oncarrier",0);
    setprop("/fdm/jsbsim/environment/terrain-light-coverage",1);
    setprop("/fdm/jsbsim/environment/terrain-load-resistance",1e+30);
    setprop("/fdm/jsbsim/environment/terrain-friction-factor",1);
    setprop("/fdm/jsbsim/environment/terrain-bumpiness",0);
    setprop("/fdm/jsbsim/environment/terrain-rolling-friction",0.02);
    setprop("/fdm/jsbsim/environment/terrain-names","unknown");
    }

settimer (terrain_survol, 0.5);
}


terrain_survol();



setlistener("/fdm/jsbsim/environment/terrain-friction-factor", func { 
  
  if (getprop("/fdm/jsbsim/environment/terrain-friction-factor") > 0.7)
  {
          setprop("/fdm/jsbsim/environment/terrain-friction-factor", 0.8)
  }  
}
);

setlistener("/fdm/jsbsim/environment/terrain-rolling-friction", func { 
  
  if (getprop("/fdm/jsbsim/environment/terrain-rolling-friction") > 0.5)
  {
          
	  setprop("/fdm/jsbsim/environment/terrain-rolling-friction", 0.25)
  }  
}
);

##############################################################################
setlistener("/controls/flight/elevator", func (position){
    var position = position.getValue();
    # helper for braking
    var ms = getprop("/devices/status/mice/mouse/mode") or 0;
    if (ms == 1 and position < 0) {
        setprop("/controls/gear/brake-left", 1);
        setprop("/controls/gear/brake-right", 1);
    }
    var ms = getprop("/devices/status/mice/mouse/mode") or 0;
    if (ms == 1 and position > 0) {
        setprop("/controls/gear/brake-left", 0);
        setprop("/controls/gear/brake-right", 0);
    }
    
    # helper for throtte on throttle axis or elevator
    var se = getprop("/controls/engines/engine/throttle") or 0;
    if (ms == 1 and position >= 0) setprop("/controls/engines/engine/throttle", position*1);
},0,1);
###############################################################################
    # Flash High Beam
var beam_call = func {
     setprop("/controls/lighting/headlight", 1);
};
var beam_stop = func {
     setprop("/controls/lighting/headlight", 0);
};

setlistener("/controls/lighting/headlight", func {
 if (getprop("/controls/lighting/headlight2") == 0)
 {     setprop("/controls/lighting/headlight", 0); }
});

setlistener("/controls/lighting/headlight2", func {
 if (getprop("/controls/lighting/headlight") == 1)
 {     setprop("/controls/lighting/headlight2", 1); }
});

