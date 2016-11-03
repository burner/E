module parser;

import ast;
import tokenmodule;

import lexer;

import exception;

class Parser {
	Lexer lex;

	this(Lexer lex) {
		this.lex = lex;
	}

	bool firstExpr() const {
		return this.firstPostfixExpr();
	}

	Expr parseExpr() {
		try {
			return this.parseExprImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a Expr an Exception was thrown.", e);
		}
	}

	Expr parseExprImpl() {
		if(this.firstPostfixExpr()) {
			PostfixExpr post = this.parsePostfixExpr();

			return new Expr(ExprEnum.PostfixExpr, post);
		}
		throw new ParseException("Was expecting an PostfixExpr.", this.lex.line, this.lex.column);
	}

	bool firstPostfixExpr() const {
		return this.firstIdentifier()
			 || this.firstPrimaryExpr();
	}

	PostfixExpr parsePostfixExpr() {
		try {
			return this.parsePostfixExprImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a PostfixExpr an Exception was thrown.", e);
		}
	}

	PostfixExpr parsePostfixExprImpl() {
		if(this.firstIdentifier()) {
			Identifier ident = this.parseIdentifier();
			if(this.firstPostfixFollow()) {
				PostfixFollow follow = this.parsePostfixFollow();

				return new PostfixExpr(PostfixExprEnum.Array, ident, follow);
			}
			return new PostfixExpr(PostfixExprEnum.Ident, ident);
		} else if(this.firstPrimaryExpr()) {
			PrimaryExpr prim = this.parsePrimaryExpr();

			return new PostfixExpr(PostfixExprEnum.Primary, prim);
		}
		throw new ParseException("Was expecting an Identifier, or PrimaryExpr.", this.lex.line, this.lex.column);
	}

	bool firstPostfixFollow() const {
		return this.lex.front.type == TokenType.dot
			 || this.firstArray()
			 || this.firstCall();
	}

	PostfixFollow parsePostfixFollow() {
		try {
			return this.parsePostfixFollowImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a PostfixFollow an Exception was thrown.", e);
		}
	}

	PostfixFollow parsePostfixFollowImpl() {
		if(this.lex.front.type == TokenType.dot) {
			this.lex.popFront();
			if(this.firstPostfixExpr()) {
				PostfixExpr follow = this.parsePostfixExpr();

				return new PostfixFollow(PostfixFollowEnum.Dot, follow);
			}
			throw new ParseException("Was expecting an PostfixExpr.", this.lex.line, this.lex.column);
		} else if(this.firstArray()) {
			Array array = this.parseArray();
			if(this.lex.front.type == TokenType.dot) {
				this.lex.popFront();
				if(this.firstPostfixExpr()) {
					PostfixExpr postfix = this.parsePostfixExpr();

					return new PostfixFollow(PostfixFollowEnum.ArrayDot, array, postfix);
				}
				throw new ParseException("Was expecting an PostfixExpr.", this.lex.line, this.lex.column);
			} else if(this.firstPostfixFollow()) {
				PostfixFollow pffollow = this.parsePostfixFollow();

				return new PostfixFollow(PostfixFollowEnum.ArrayFollow, array, pffollow);
			}
			return new PostfixFollow(PostfixFollowEnum.Array, array);
		} else if(this.firstCall()) {
			Call call = this.parseCall();
			if(this.lex.front.type == TokenType.dot) {
				this.lex.popFront();
				if(this.firstPostfixExpr()) {
					PostfixExpr follow = this.parsePostfixExpr();

					return new PostfixFollow(PostfixFollowEnum.CallDot, call, follow);
				}
				throw new ParseException("Was expecting an PostfixExpr.", this.lex.line, this.lex.column);
			} else if(this.firstPostfixFollow()) {
				PostfixFollow pffollow = this.parsePostfixFollow();

				return new PostfixFollow(PostfixFollowEnum.CallFollow, call, pffollow);
			}
			return new PostfixFollow(PostfixFollowEnum.Call, call);
		}
		throw new ParseException("Was expecting an dot, Array, or Call.", this.lex.line, this.lex.column);
	}

	bool firstArray() const {
		return this.lex.front.type == TokenType.lbrack;
	}

	Array parseArray() {
		try {
			return this.parseArrayImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a Array an Exception was thrown.", e);
		}
	}

	Array parseArrayImpl() {
		if(this.lex.front.type == TokenType.lbrack) {
			this.lex.popFront();
			if(this.lex.front.type == TokenType.rbrack) {
				this.lex.popFront();
				return new Array(ArrayEnum.Slice);
			} else if(this.firstExpr()) {
				Expr expr = this.parseExpr();
				if(this.lex.front.type == TokenType.rbrack) {
					this.lex.popFront();
					return new Array(ArrayEnum.Index, expr);
				}
				throw new ParseException("Was expecting an rbrack.", this.lex.line, this.lex.column);
			}
			throw new ParseException("Was expecting an rbrack, or Expr.", this.lex.line, this.lex.column);
		}
		throw new ParseException("Was expecting an lbrack.", this.lex.line, this.lex.column);
	}

	bool firstCall() const {
		return this.lex.front.type == TokenType.lparen;
	}

	Call parseCall() {
		try {
			return this.parseCallImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a Call an Exception was thrown.", e);
		}
	}

	Call parseCallImpl() {
		if(this.lex.front.type == TokenType.lparen) {
			this.lex.popFront();
			if(this.lex.front.type == TokenType.rparen) {
				this.lex.popFront();
				return new Call(CallEnum.Empty);
			}
			throw new ParseException("Was expecting an rparen.", this.lex.line, this.lex.column);
		}
		throw new ParseException("Was expecting an lparen.", this.lex.line, this.lex.column);
	}

	bool firstPrimaryExpr() const {
		return this.lex.front.type == TokenType.float64
			 || this.lex.front.type == TokenType.integer
			 || this.lex.front.type == TokenType.lparen;
	}

	PrimaryExpr parsePrimaryExpr() {
		try {
			return this.parsePrimaryExprImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a PrimaryExpr an Exception was thrown.", e);
		}
	}

	PrimaryExpr parsePrimaryExprImpl() {
		if(this.lex.front.type == TokenType.float64) {
			Token value = this.lex.front;
			this.lex.popFront();
			return new PrimaryExpr(PrimaryExprEnum.Float, value);
		} else if(this.lex.front.type == TokenType.integer) {
			Token value = this.lex.front;
			this.lex.popFront();
			return new PrimaryExpr(PrimaryExprEnum.Integer, value);
		} else if(this.lex.front.type == TokenType.lparen) {
			this.lex.popFront();
			if(this.firstExpr()) {
				Expr expr = this.parseExpr();
				if(this.lex.front.type == TokenType.rparen) {
					this.lex.popFront();
					return new PrimaryExpr(PrimaryExprEnum.Parenthesis, expr);
				}
				throw new ParseException("Was expecting an rparen.", this.lex.line, this.lex.column);
			}
			throw new ParseException("Was expecting an Expr.", this.lex.line, this.lex.column);
		}
		throw new ParseException("Was expecting an float64, integer, or lparen.", this.lex.line, this.lex.column);
	}

	bool firstIdentifier() const {
		return this.lex.front.type == TokenType.identifier;
	}

	Identifier parseIdentifier() {
		try {
			return this.parseIdentifierImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a Identifier an Exception was thrown.", e);
		}
	}

	Identifier parseIdentifierImpl() {
		if(this.lex.front.type == TokenType.identifier) {
			Token value = this.lex.front;
			this.lex.popFront();
			return new Identifier(IdentifierEnum.Ident, value);
		}
		throw new ParseException("Was expecting an identifier.", this.lex.line, this.lex.column);
	}

}
