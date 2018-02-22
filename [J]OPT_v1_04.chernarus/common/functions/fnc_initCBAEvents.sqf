/**
* Author: James
* initialize CBA Event Handlers
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call fnc_initCBAEvents.sqf;
*
*/
#include "script_component.hpp"

// fügt einen AddAction Eintrag hinzu
[QGVAR(addAction), {
	params ["_obj", "_parameter"];

	_obj addAction _parameter;

}] call CBA_fnc_addEventHandler;

// update budget
[QGVAR(updateBudget), {
	params ["_side", "_unitCost", "_sign"];

	private _cat = "Budget";
	private _message = "";
	private _budget_neu = 0;

	switch (_sign) do {
		case "-": {
				if (_side == west) then {
					_budget_neu = GVARMAIN(nato_budget) - _unitCost;
				} else {
					_budget_neu = GVARMAIN(csat_budget) - _unitCost;
				};

		};
		case "+":  {
				if (_side == west) then {
					_budget_neu = GVARMAIN(nato_budget) + _unitCost;
				} else {					
					_budget_neu = GVARMAIN(csat_budget) + _unitCost;
				};
                
		};
	};

	// server log sowie Aktualisierung via publicVarialbe
	if (_side == west) then {
		_message = format["NATO alt: %1 - neu: %2 - Differenz: %3%4", GVARMAIN(nato_budget), _budget_neu, _sign, _unitCost];
		GVARMAIN(nato_budget) = _budget_neu;
		publicVariable QGVARMAIN(nato_budget);

	} else {
		_message = format["CSAT alt: %1 - neu: %2 - Differenz: %3%4", GVARMAIN(csat_budget), _budget_neu, _sign, _unitCost];
		GVARMAIN(csat_budget) = _budget_neu;
		publicVariable QGVARMAIN(csat_budget);

	};
	
	[QEGVAR(log,write), [_cat, _message]] call CBA_fnc_localEvent;

}] call CBA_fnc_addEventHandler;

// Zeus neu vergeben
[QGVAR(renewCurator), {

	params ["_operator"];

	if (_operator in (allCurators apply {getAssignedCuratorUnit _x})) then {
        _id = (allCurators apply {getAssignedCuratorUnit _x}) find _operator;
        _module = allCurators select _id;
        unassignCurator _module;
        _operator assignCurator _module;	
    };
    
}] call CBA_fnc_addEventHandler;


[QGVAR(setVariable), {

    params ["_var", "_value"];

    call compile format["%1 = %2", _var, _value];

}] call CBA_fnc_addEventHandler;