module exception;

class ParseException : Exception {
	int line;
	int column;

	this(string msg) {
		super(msg);
	}

	this(string msg, int l, int c) {
		super(msg);
		this.line = l;
		this.column = c;
	}

	this(string msg, ParseException other) {
		super(msg, other);
	}

	this(string msg, ParseException other, int l, int c) {
		super(msg, other);
		this.line = l;
		this.column = c;
	}

}
