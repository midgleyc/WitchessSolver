script "witchess_solver.ash";

/**********************************************
                 Developed by:
      the coding arm of ProfessorJellybean.
             (#2410942), (#2413598)

          GCLI Usage: witchess_solver
      mgithub & docs: https://goo.gl/v14FCu

**********************************************/

/*****************************************
                 FIELDS
      things to remember as we go
*****************************************/

// Whether or not we should look for the minimum path (by default, false).
// Activate with "set solvewitchess_golf = true"
boolean ws_golf = false || get_property("ws_golf").to_boolean();

// Whether or not we should log solutions (by default, false).
// Activate with "set solvewitchess_log_soln = true"
boolean ws_log_soln = false || get_property("ws_log_soln").to_boolean();

// Current witchess puzzle in scope
int ws_puzzleNum = 0;

// Current witchess puzzle's true number
int ws_puzzleTrueNum = 0;

// Your password hash, for POST requests.
string ws_pwhash = "&pwd=" + my_hash();

/*****************************************
                 UTILS
         little tools to help us
*****************************************/

// Color of error messages.
string ws_errcolor = "Red";

// Prints an error.
void ws_throwErr(string errmsg) {
	print(errmsg, ws_errcolor);
}

/*****************************************
                LOADING
        asking for the problem
*****************************************/

// Buffer that represents the current puzzle
buffer ws_page;

// Regex matcher for detecting whether or not the current puzzle is solved
string ws_matcher_done_regex = "Solved Today";
matcher ws_matcher_done = create_matcher(ws_matcher_done_regex, ws_page);

// Regex matcher for detecting whether or not the current puzzle has a next.
string ws_matcher_hasNext_regex = "next";
matcher ws_matcher_hasNext = create_matcher(ws_matcher_hasNext_regex, ws_page);

// Regex matcher for detecting the current puzzle's true number.
string ws_matcher_trueNum_regex = "Witchess Puzzle #(\\d+)";
matcher ws_matcher_trueNum = create_matcher(ws_matcher_trueNum_regex, ws_page);

// Whether or not the current puzzle is solved.
boolean ws_puzzleDone() {
	string prop_name = "_ws_finished_" + ws_puzzleNum;
	if (ws_puzzleNum == 0) {
		return true;
	} else if (get_property(prop_name).to_boolean()) {
		return true;
	} else {
		reset(ws_matcher_done, ws_page);
		if (ws_matcher_done.find()) {
			set_property(prop_name, true);
			return true;
		} else {
			return false;
		}
	}
}


// Whether or not the current puzzle has a next.
boolean ws_puzzleHasNext() {
	if (ws_puzzleNum == 0) {
		return true;
	} else {
		reset(ws_matcher_hasNext, ws_page);
		if (ws_matcher_hasNext.find()) {
			return true;
		} else {
			return false;
		}
	}
}

// Gets the true number of the puzzle.
void ws_setPuzzleTrueNum() {
	ws_matcher_trueNum.reset(ws_page);
	ws_matcher_trueNum.find();
	ws_puzzleTrueNum = group(ws_matcher_trueNum, 1).to_int();
}

// Gets the next puzzle.
void ws_loadNext() {
	ws_puzzleNum += 1;
	ws_page = visit_url("witchess.php?num=" + ws_puzzleNum);
	ws_setPuzzleTrueNum();
}

/*****************************************
                PARSING
        understanding the problem
*****************************************/

// Parses the current puzzle in ws_page. STUB
void ws_parse() {
	//print(ws_page);
}

/*****************************************
                SOLVING
          solving the problem
*****************************************/

// Parses the current puzzle in ws_page. STUB
void ws_solve() {
	print(ws_page);
}

/*****************************************
                MAIN
        lights, camera, action!
*****************************************/

// Solves all the witchess puzzles
void main() {
	while (ws_puzzleHasNext()) {
		ws_loadNext();
		if (!ws_puzzleDone()) {
			ws_parse();
			ws_solve();
			if (!ws_puzzleDone()) {
				ws_throwErr("Could not solve puzzle " + ws_puzzleNum + ". (#" + ws_puzzleTrueNum + ")");
			}
		}
		print("Puzzle " + ws_puzzleNum + " complete. (#" + ws_puzzleTrueNum + ")", "green");
	}
	print("Witchess puzzles finished.", "green");
}