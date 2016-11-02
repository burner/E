module lexer;

import tokenmodule;

struct Lexer {
	string input;

	int line;
	int column;

	@property bool empty() const {
		return true;
	}

	@property Token front() {
		return Token();
	}

	@property Token front() const {
		return Token();
	}

	void popFront() {

	}
}
