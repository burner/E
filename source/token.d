module tokenmodule;

enum TokenType {
	lbrack,
	rbrack,
	lparen,
	rparen,
	identifier,
}

struct Token {
	import visitor;

	int line;
	int column;

	TokenType type;

	void visit(Visitor v) {

	}
	
	void visit(Visitor v) const {

	}
}

