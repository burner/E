module tokenmodule;

enum TokenType {
	undefined,
	plus,
	minus,
	div,
	mod,
	assign,
	lbrack,
	rbrack,
	lparen,
	rparen,
	lcurly,
	rcurly,
	identifier,
	semicolon,
	i64,
	f64,
	i64value,
	f64value,
	forkeyword,
	dot,
	comma,
	var,
	fun,
}

struct Token {
	import visitor;

	//int line;
	//int column;
	string value;

	TokenType type;

	this(TokenType type) {
		this.type = type;
	}

	this(TokenType type, string value) {
		this(type);
		this.value = value;
	}

	void visit(Visitor v) {

	}
	
	void visit(Visitor v) const {

	}
}

