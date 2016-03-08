script "witchess_solver.ash";

/**********************************************
                 Developed by:
      the coding arm of ProfessorJellybean.
             (#2410942), (#2413598)

          GCLI Usage: witchess_solver

**********************************************/

// Whether or not we should look for the minimum path (by default, false). Set with "set solvewitchess_golf = true/false"
boolean ws_golf = false || get_property("solvewitchess_golf").to_boolean();

// Whether or not we should log solutions (by default, false). Set with "set solvewitchess_log_soln = true/false"
boolean ws_log_soln = false || get_property("solvewitchess_log_soln").to_boolean();

// Current witchess puzzle
int ws_puzzle_num = 1;

// Buffer that represents the current puzzle
buffer ws_page = visit_url("witchess.php?num=" + puzzle_num);

// Parses the next puzzle.
ws_parseNext()