/**
* Author: James
* calculate signal loss due to terrain
*
* Arguments:
* 0: <BOOL> true - inform player about signal loss value, false - no message
*
* Return Value:
* 0: <NUMBER> signal loss
*
* Example:
* [container] call fnc_calcSignalLoss.sqf;
*
*/
#include "script_component.hpp"

params ["_informPlayer"];

// calculate signal loss
private _container = [] call FUNC(getRadar);
private _objekte = nearestTerrainObjects [getpos _container, ["Tree","BUILDING"], 100];
private _signalLoss = RADAR_DAMPING(_objekte) * 100;

if (_informPlayer) then {
	private _message = format["%1: %2", STR_RADAR_HINT_TEXT, _signalLoss]; 
	[QEGVAR(gui,message), [STR_RADAR_HINT_HEADER, _message, "blue"]] call CBA_fnc_localEvent;
};

_signalLoss;