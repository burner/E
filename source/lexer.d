module lexer;

import tokenmodule;

import std.experimental.logger;

struct Lexer {
	string input;
	long stringPos;

	int line;
	int column;

	Token cur;

	this(string input) {
		this.input = input;
		this.stringPos = 0;
		this.line = 1;
		this.column = 1;
		this.buildToken();
	}

	private bool isTokenStop() const {
		return this.stringPos >= this.input.length 
			|| this.isTokenStop(this.input[this.stringPos]);
	}

	private bool isTokenStop(const(char) c) const {
		return 
			c == ' ' || c == '\t' || c == '\n' || c == ';' || c == '(' 
			|| c == ')' || c == '{' || c == '}' || c == '&' || c == '!'
			|| c == '=' || c == '|' || c == '.' || c == '*' || c == '/'
			|| c == '%';
	}

	private void eatWhitespace() {
		import std.ascii : isWhite;
		while(this.stringPos < this.input.length) {
			if(this.input[this.stringPos] == ' ') {
				++this.column;
			} else if(this.input[this.stringPos] == '\t') {
				++this.column;
			} else if(this.input[this.stringPos] == '\n') {
				this.column = 1;
				++this.line;
			} else {
				break;
			}
			++this.stringPos;
		}
	}

	private void buildToken() {
		this.eatWhitespace();

		if(this.stringPos >= this.input.length) {
			this.cur = Token(TokenType.undefined);
			return;
		}

		if(this.input[this.stringPos] == ')') {
			this.cur = Token(TokenType.rparen);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '(') {
			this.cur = Token(TokenType.lparen);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == ']') {
			this.cur = Token(TokenType.rbrack);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '[') {
			this.cur = Token(TokenType.lbrack);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '}') {
			this.cur = Token(TokenType.rcurly);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '{') {
			this.cur = Token(TokenType.lcurly);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == ';') {
			this.cur = Token(TokenType.semicolon);
			++this.column;
			++this.stringPos;
		} else {
			ulong b = this.stringPos;	
			ulong e = this.stringPos;
			switch(this.input[this.stringPos]) {
				case 'f':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('u', e)) {
						if(this.testCharAndInc('n', e)) {
							if(this.testCharAndInc('c', e)) {
								if(this.isTokenStop()) {
									this.cur = Token(TokenType.func);
									return;
								}
							}
						}
						goto default;
					} else if(this.testCharAndInc('o', e)) {
						if(this.testCharAndInc('r', e)) {
							if(this.isTokenStop()) {
								this.cur = Token(TokenType.forkeyword);
								return;
							}
						}
					}
					goto default;
				case '0': .. case '9':
					do {
						++this.stringPos;
						++this.column;
						++e;
					} while(this.stringPos < this.input.length 
							&& this.input[this.stringPos] >= '0'
							&& this.input[this.stringPos] <= '9');
					
					if(this.stringPos >= this.input.length
							|| this.input[this.stringPos] != '.') 
					{
						this.cur = Token(TokenType.integer, this.input[b .. e]);
						return;
					} else if(this.stringPos < this.input.length
							&& this.input[this.stringPos] == '.')
					{
						do {
							++this.stringPos;
							++this.column;
							++e;
						} while(this.stringPos < this.input.length 
								&& this.input[this.stringPos] >= '0'
								&& this.input[this.stringPos] <= '9');

						this.cur = Token(TokenType.float64, this.input[b ..  e]);
						return;
					}
					goto default;
				default:
					do {
						++this.stringPos;
						++this.column;
						++e;
					} while(!this.isTokenStop());
					this.cur = Token(TokenType.identifier, this.input[b .. e]);
					break;
			}
		}
	}

	bool testCharAndInc(const(char) c, ref ulong e) {
		if(this.stringPos < this.input.length 
				&& this.input[this.stringPos] == c)
		{
			++this.column;
			++this.stringPos;
			++e;
			return true;
		} else {
			return false;
		}
	}

	unittest {
		import std.conv : to;

		string testS = "(){}iden;func(for)formost;1337;13.37";
		auto l = Lexer(testS);
		assert(!l.empty);
		assert(l.front.type == TokenType.lparen);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.rparen);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.lcurly);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.rcurly);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.identifier);
		assert(l.front.value == "iden");
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.semicolon);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.func, to!string(l.front.type));
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.lparen);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.forkeyword);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.rparen);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.identifier);
		assert(l.front.value == "formost");
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.semicolon);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.integer);
		assert(l.front.value == "1337");
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.semicolon);
		l.popFront();
		assert(!l.empty);
		assert(l.front.type == TokenType.float64);
		assert(l.front.value == "13.37");
		l.popFront();
		assert(l.empty);
	}

	@property bool empty() const {
		return this.stringPos >= this.input.length
			&& this.cur.type == TokenType.undefined;
	}

	@property ref Token front() {
		return this.cur;
	}

	@property Token front() const {
		return this.cur;
	}

	void popFront() {
		this.buildToken();		
	}
}
