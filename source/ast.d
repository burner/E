module ast;

import tokenmodule;

import visitor;

enum ExpressionEnum {
	Postfix,
}

class Expression {
	ExpressionEnum ruleSelection;
	PostfixExpression post;

	this(ExpressionEnum ruleSelection, PostfixExpression post) {
		this.ruleSelection = ruleSelection;
		this.post = post;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PostfixExpressionEnum {
	Primary,
	Array,
	Call,
}

class PostfixExpression {
	PostfixExpressionEnum ruleSelection;
	PrimaryExpression prim;
	Expression expr;

	this(PostfixExpressionEnum ruleSelection, PrimaryExpression prim) {
		this.ruleSelection = ruleSelection;
		this.prim = prim;
	}

	this(PostfixExpressionEnum ruleSelection, PrimaryExpression prim, Expression expr) {
		this.ruleSelection = ruleSelection;
		this.prim = prim;
		this.expr = expr;
	}

	this(PostfixExpressionEnum ruleSelection, PrimaryExpression prim, Expression expr) {
		this.ruleSelection = ruleSelection;
		this.prim = prim;
		this.expr = expr;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PrimaryExpressionEnum {
	Identifier,
	Parenthesis,
}

class PrimaryExpression {
	PrimaryExpressionEnum ruleSelection;
	Token ident;
	Expression expr;

	this(PrimaryExpressionEnum ruleSelection, Token ident) {
		this.ruleSelection = ruleSelection;
		this.ident = ident;
	}

	this(PrimaryExpressionEnum ruleSelection, Expression expr) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

