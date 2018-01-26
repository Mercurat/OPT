/**
* Author: James
* initialize server mission EH
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_initServerMissionEH.sqf;
*
*/
#include "script_component.hpp"

GVAR(EH_PlayerConnected) = addMissionEventHandler ["PlayerConnected", {
    /*
    id: Number - unique DirectPlay ID (very large number). It is also the same id used for user placed markers (same as _id param)
    uid: String - getPlayerUID of the joining client. The same as Steam ID (same as _uid param)
    name: String - profileName of the joining client (same as _name param)
    jip: Boolean - didJIP of the joining client (same as _jip param)
    owner: Number - owner id of the joining client (same as _owner param)
    */
    params ["_id", "_uid", "_name", "_jip", "_owner"];
    //LOG_2("PlayerConnected - jip: %1 - owner: %2",_jip,_owner);
    
    if (OPT_PARAM_SHOW_INTRO and !OPT_PARAM_TRAINING and !(_jip)) then {
        [QGVAR(startIntro), [], playableUnits select {owner _x == _owner}] call CBA_fnc_targetEvent;    
    };

}];