#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

ADDON = true;

GVAR(playerList) = [];

// CBA settings
[] call FUNC(initCBASettings);

if (isServer) then {
    [] call FUNC(initServerCBAEvents);

};