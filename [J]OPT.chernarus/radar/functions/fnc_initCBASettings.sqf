/**
* Author: James
* initialize CBA settings
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_initCBASettings.sqf;
*
*/
#include "script_component.hpp"

[
    "OPT_PARAM_RADAR", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "LIST", // setting type
    "Radar Container verfügbar", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "OPT Radar", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [[0, 1], ["aus", "an"], 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(maxDammage), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    "Schadenswert (in %), bei dem Radar unbrauchbar", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "OPT Radar", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0, 1, 0.85, 2], // data for this setting: [min, max, default, number of shown trailing decimals]
    1, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;




