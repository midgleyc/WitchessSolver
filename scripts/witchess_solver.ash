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
	ws_puzzleTrueNum = ws_matcher_trueNum.group(1).to_int();
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
// Lookup table of known solutions
string ws_soln_path = "witchess_puzzle_solns.txt";

// Solution map
string[int] ws_solns;

// Loads the solution map into the current session
void ws_loadSolutions() {
	file_to_map(ws_soln_path , ws_solns);
}

// tests whether or not a given solution string is square.
boolean ws_is_square(string soln) {
	int x = 0;
	int y = 0;
	int maxX = 0;
	int maxY = 0;
	boolean sane = true;
	matcher matcher_soln_sanity = create_matcher("([rlud])", soln);
	while (matcher_soln_sanity.find()) {
		string dir = matcher_soln_sanity.group(1);
		switch (dir) {
			case "r":
				x += 1;
				break;
			case "l":
				x -= 1;
				break;
			case "u":
				y += 1;
				break;
			case "d":
				y -= 1;
				break;
			default:
				ws_throwErr("Unrecognized direction: \"" + dir + "\"");
				break;
		}
		sane = sane && !(x < 0 || y < 0);
		maxX = max(x, maxX);
		maxY = max(y, maxY);
	}
	sane = (x == y) && sane;
	sane = (x == maxX) && sane;
	sane = (x == maxY) && sane;
	if (!sane) {
		print("x: " + x);
		print("y: " + y);
	}
	return sane;
}

// Parses the current puzzle in ws_page. STUB
void ws_solve() {
	if (ws_solns contains ws_puzzleTrueNum) {
		string ws_soln_str = ws_solns[ws_puzzleTrueNum];
		print("Solution: " + ws_soln_str);
	} else {
		ws_throwErr("Solution for #"+ ws_puzzleTrueNum +" not found in lookup!");
	}
}

/*****************************************
                MAIN
        lights, camera, action!
*****************************************/

// Solves all the witchess puzzles
void main() {
	ws_loadSolutions();
	foreach key in ws_solns {
		if (!ws_is_square(ws_solns[key])) {
			ws_throwErr("Warning: non-square solution at key " + key);
		}
	}
	while (ws_puzzleHasNext()) {
		ws_loadNext();
		if (!ws_puzzleDone()) {
			ws_parse();
			ws_solve();
		}
		if (!ws_puzzleDone()) {
			ws_throwErr("Could not solve puzzle " + ws_puzzleNum + ". (#" + ws_puzzleTrueNum + ")");
		} else {
			print("Puzzle " + ws_puzzleNum + " complete. (#" + ws_puzzleTrueNum + ")", "green");
		}
	}
	print("Witchess puzzles finished.", "green");
}