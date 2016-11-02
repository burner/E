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

	bool firstExpression() const {
		return this.firstPostfixExpression();
	}

	Expression parseExpression() {
		try {
			return this.parseExpressionImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a Expression an Exception was thrown.", e);
		}
	}

	Expression parseExpressionImpl() {
		if(this.firstPostfixExpression()) {
			PostfixExpression post = this.parsePostfixExpression();
			return new Expression(ExpressionEnum.Postfix, post);
		}
		throw new ParseException("Was expecting an PostfixExpression.", this.lex.line, this.lex.column);
	}

	bool firstPostfixExpression() const {
		return this.firstPrimaryExpression();
	}

	PostfixExpression parsePostfixExpression() {
		try {
			return this.parsePostfixExpressionImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a PostfixExpression an Exception was thrown.", e);
		}
	}

	PostfixExpression parsePostfixExpressionImpl() {
		if(this.firstPrimaryExpression()) {
			PrimaryExpression prim = this.parsePrimaryExpression();
			if(this.lex.front.type == TokenType.lbrack) {
				this.lex.popFront();
				if(this.firstExpression()) {
					Expression expr = this.parseExpression();
					if(this.lex.front.type == TokenType.rbrack) {
						this.lex.popFront();
						return new PostfixExpression(PostfixExpressionEnum.Array, prim, expr);
					}
					throw new ParseException("Was expecting an rbrack.", this.lex.line, this.lex.column);
				}
				throw new ParseException("Was expecting an Expression.", this.lex.line, this.lex.column);
			} else if(this.lex.front.type == TokenType.lparen) {
				this.lex.popFront();
				if(this.firstExpression()) {
					Expression expr = this.parseExpression();
					if(this.lex.front.type == TokenType.rparen) {
						this.lex.popFront();
						return new PostfixExpression(PostfixExpressionEnum.Call, prim, expr);
					}
					throw new ParseException("Was expecting an rparen.", this.lex.line, this.lex.column);
				}
				throw new ParseException("Was expecting an Expression.", this.lex.line, this.lex.column);
			}
			throw new ParseException("Was expecting an lbrack, or lparen.", this.lex.line, this.lex.column);
		}
		throw new ParseException("Was expecting an PrimaryExpression.", this.lex.line, this.lex.column);
	}

	bool firstPrimaryExpression() const {
		return this.lex.first.type == TokenType.identifier
			 || this.lex.first.type == TokenType.lparen;
	}

	PrimaryExpression parsePrimaryExpression() {
		try {
			return this.parsePrimaryExpressionImpl();
		} catch(ParseException e) {
			throw new ParseException("While parsing a PrimaryExpression an Exception was thrown.", e);
		}
	}

	PrimaryExpression parsePrimaryExpressionImpl() {
		Token ident = this.lex.front;
		if(ident.type == TokenType.identifier) {
			this.lex.popFront();
			return new PrimaryExpression(PrimaryExpressionEnum.Identifier, ident);
		} else if(this.lex.front.type == TokenType.lparen) {
			this.lex.popFront();
			if(this.firstExpression()) {
				Expression expr = this.parseExpression();
				if(this.lex.front.type == TokenType.rparen) {
					this.lex.popFront();
					return new PrimaryExpression(PrimaryExpressionEnum.Parenthesis, expr);
				}
				throw new ParseException("Was expecting an rparen.", this.lex.line, this.lex.column);
			}
			throw new ParseException("Was expecting an Expression.", this.lex.line, this.lex.column);
		}
		throw new ParseException("Was expecting an identifier, or lparen.", this.lex.line, this.lex.column);
	}

}
