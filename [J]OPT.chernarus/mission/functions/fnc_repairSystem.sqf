﻿/**
* Author: James
* add addAction entries to vehicle that activated the triggerActivated
* repair and rearm vehicle. If vehicle is leaving the trigger zone
* actions are removed.
*
* Arguments:
* 0: <BOOL> true: add action menu entries, false: remove
*
* Return Value:
* None
*
* Example:
* [thistrigger, true] call fnc_repairSystem.sqf;
*
*/
#include "script_component.hpp"
// arguments
private _state = param [0, false, [true]]; // Bereich aktiv oder inaktiv

// Skriptteil für aktiven Bereich
// Aktioneinträge zuweisen
if (_state) then {

    // detect nearest vehicle
    private _vecs = nearestObjects [position player, ["LandVehicle", "Air"], 25];

    if (count _vecs == 0) exitWith {
        [QEGVAR(gui,message), ["Reparatursystem", "Kein Fahrzeug im Umkreis von 25m.", "red"]] call CBA_fnc_localEvent;
    };
    private _vec = _vecs select 0;

	// binde Fahrzeug an Spieler
	player setVariable [QGVAR(repairSystem_vec), _vec];

	// Aktionseinträge müssen dem Fahrzeug gegeben werden, da im Fahrzeug nicht mehr nutzbar
	// nur für den auslösenden Spieler sichtbar, da addAction immer LOCAL!
	private _action1 = _vec addAction ["<t size=""1.2"">Fahrzeug auftanken</t>", {

		params ["_vec"];

		// als erstes Fahrzeug anhalten
		_vec setFuel 0;

        [
            10,
            [_vec],
            {
                (_this select 0) params ["_vec"];
                _vec setFuel 1;
                [QEGVAR(gui,message), ["Reparatursystem", "Fahrzeug fertig betankt", "green"]] call CBA_fnc_localEvent;                
            },
            {
                [QEGVAR(gui,message), ["Reparatursystem", "Vorgang abgebrochen", "red"]] call CBA_fnc_localEvent;
            },
            "Fahrzeug wird betankt...",
            {true},
            ["isnotinside"]
        ] call ace_common_fnc_progressBar;

	}, [], 100, false, true, '', "not (isEngineOn _target)"];

	private _action2 = _vec addAction ["<t size=""1.2"">Fahrzeug reparieren</t>", {
		
		params ["_vec"];

		// als erstes Fahrzeug anhalten
        private _fuel = fuel _vec;

        _vec setFuel 0;
        
        [
            ([_vec] call EFUNC(fieldrepair,getPartsRepairTime)) min 10,
            [_vec, _fuel],
            {
                (_this select 0) params ["_vec", "_fuel"];
                _vec setFuel _fuel;
                _vec setDamage 0;
                [QEGVAR(gui,message), ["Reparatursystem", "Fahrzeug vollständig repariert", "green"]] call CBA_fnc_localEvent;                
            },
            {
                [QEGVAR(gui,message), ["Reparatursystem", "Vorgang abgebrochen", "red"]] call CBA_fnc_localEvent;
            },
            "Fahrzeug wird repariert...",
            {true},
            ["isnotinside"]
        ] call ace_common_fnc_progressBar;

	}, [], 100, false, true, '', "not (isEngineOn _target)"];

	_vec setVariable [QGVAR(repairSystem_actions), [_action1, _action2]];

} // Skriptteil für deaktivierten Bereich
else {

	_vec = player getVariable [QGVAR(repairSystem_vec), objNull];
	// entferne vorherige Aktioneinträge
	{
		_vec removeAction _x;
	} foreach (_vec getVariable [QGVAR(repairSystem_actions), []]);

	player setVariable [QGVAR(repairSystem_vec), objNull];
	
};




