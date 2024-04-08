
% get_possibs returns a list of valid words (can be empty).
get_possibs("astr", ["astral", "astronaut"]). 
get_possibs("ty", ["tyre", "type", "tycoon", "tyke"]).
get_possibs("a", ["a", "animal", "astral", "astronaut"]).
get_possibs("bleeboba", []).

% get_definition can have one, or multiple definitions
get_definition("astral", "of, relating to, or coming from the stars").
get_definition("astronaut", "a person whose profession is to travel beyond the earth's atmosphere").
get_definition("tyre", " a rubber cushion that fits around a wheel (as of an automobile) and usually contains compressed air").
get_definition("type", "a particular kind, class, or group").
get_definition("tycoon", "a businessperson of exceptional wealth, power, and influence").
get_definition("tyke", "a small child").
get_definition("a", "the 1st letter of the English alphabet").
get_definition("a", "used as a function word before singular nouns when the referent is unspecified and before number collectives and some numbers").
get_definition("animal", "any of a kingdom (Animalia) of living things including many-celled organisms and often many of the single-celled ones (such as protozoans) that typically differ from plants in having cells without cellulose walls, in lacking chlorophyll and the capacity for photosynthesis, in requiring more complex food materials (such as proteins), in being organized to a greater degree of complexity, and in having the capacity for spontaneous movement and rapid motor responses to stimulation").
