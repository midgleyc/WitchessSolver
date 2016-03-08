script "witchess_solver.ash";

/**********************************************
                 Developed by:
      the coding arm of ProfessorJellybean.
             (#2410942), (#2413598)

          GCLI Usage: witchess_solver

**********************************************/

// Whether or not we should look for the minimum path (by default, false). Set with "set solvewitchess_golf = true/false"
boolean golf = false || get_property("solvewitchess_golf").to_boolean();

// Whether or not we should log solutions (by default, false). Set with "set solvewitchess_log_soln = true/false"
boolean log_soln = false || get_property("solvewitchess_log_soln").to_boolean();
