/**
* Author: James
* initialize FAR Revive script
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_postInit.sqf;
*
*/
#include "script_component.hpp"

/* PLAYER VAR */
FAR_isDragging = false;
FAR_Debugging = false;
FAR_deathMassageIsShown = false;

if (isDedicated) exitWith {};

// Player Initialization
[] spawn FUNC(playerInit);
player addEventHandler ["Respawn", {
    [] spawn FUNC(playerInit);
}];

[] spawn {
	waitUntil {!isNull (findDisplay 46)};
	(findDisplay 46) displayAddEventHandler ["KeyDown", {_this call FUNC(keyUnbind)}];
};

// Drag & Carry animation fix
GVAR(eh_EachFrame) = addMissionEventHandler ["EachFrame", {
    if (animationState player in ["acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon", "helper_switchtocarryrfl", "AcinPknlMstpSrasWrflDnon"]) then {
        if (FAR_isDragging) then {
            player switchMove "AcinPknlMstpSrasWrflDnon";
        } else {
            player switchMove "amovpknlmstpsraswrfldnon";
        };
    };
}];


// 3D Marker
[] spawn {
	if (FAR_REVIVE_3D_ICONS) then {
		_icons = addMissionEventHandler ["Draw3D", {
			{
				if (
                    (_x distance player) < 30 and
                    _x getVariable ["FAR_isUnconscious", 0] == 1 and
                    _x != player and
                    UNIT_SIDE(_x) == PLAYER_SIDE
                ) then {
                    private _name = UNIT_NAME(_x);
					drawIcon3D ["\a3\ui_f\data\map\MapControl\hospital_ca.paa", [0.6,0.15,0,0.8], _x, 0.5, 0.5, 0, format["%1 (%2m)", _name, ceil (player distance _x)], 0, 0.02];

				};
			} forEach playableUnits;
		}];
	};
};


////////////////////////////////////////////////
// [Debugging] Add revive to playable AI units
////////////////////////////////////////////////
if (!FAR_Debugging || isMultiplayer) exitWith {};

{
	if (!isPlayer _x) then 
	{
		_x addEventHandler ["HandleDamage", FUNC(handleDamage)];
		_x setVariable ["FAR_isUnconscious", 0, true];
		_x setVariable ["FAR_isStabilized", 0, true];
		_x setVariable ["FAR_isDragged", 0, true];
	};
} forEach switchableUnits;