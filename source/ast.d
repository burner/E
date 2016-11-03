module ast;

import tokenmodule;

import visitor;

enum ExprEnum {
	PostfixExpr,
}

class Expr {
	ExprEnum ruleSelection;
	PostfixExpr post;

	this(ExprEnum ruleSelection, PostfixExpr post) {
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

enum PostfixExprEnum {
	Ident,
	Array,
	Primary,
}

class PostfixExpr {
	PostfixExprEnum ruleSelection;
	Identifier ident;
	PrimaryExpr prim;
	PostfixFollow follow;

	this(PostfixExprEnum ruleSelection, Identifier ident) {
		this.ruleSelection = ruleSelection;
		this.ident = ident;
	}

	this(PostfixExprEnum ruleSelection, Identifier ident, PostfixFollow follow) {
		this.ruleSelection = ruleSelection;
		this.ident = ident;
		this.follow = follow;
	}

	this(PostfixExprEnum ruleSelection, PrimaryExpr prim) {
		this.ruleSelection = ruleSelection;
		this.prim = prim;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PostfixFollowEnum {
	Dot,
	Array,
	ArrayDot,
	ArrayFollow,
	Call,
	CallDot,
	CallFollow,
}

class PostfixFollow {
	PostfixFollowEnum ruleSelection;
	Call call;
	PostfixExpr postfix;
	Array array;
	PostfixExpr follow;
	PostfixFollow pffollow;

	this(PostfixFollowEnum ruleSelection, PostfixExpr follow) {
		this.ruleSelection = ruleSelection;
		this.follow = follow;
	}

	this(PostfixFollowEnum ruleSelection, Array array) {
		this.ruleSelection = ruleSelection;
		this.array = array;
	}

	this(PostfixFollowEnum ruleSelection, Array array, PostfixExpr postfix) {
		this.ruleSelection = ruleSelection;
		this.array = array;
		this.postfix = postfix;
	}

	this(PostfixFollowEnum ruleSelection, Array array, PostfixFollow pffollow) {
		this.ruleSelection = ruleSelection;
		this.array = array;
		this.pffollow = pffollow;
	}

	this(PostfixFollowEnum ruleSelection, Call call) {
		this.ruleSelection = ruleSelection;
		this.call = call;
	}

	this(PostfixFollowEnum ruleSelection, Call call, PostfixExpr follow) {
		this.ruleSelection = ruleSelection;
		this.call = call;
		this.follow = follow;
	}

	this(PostfixFollowEnum ruleSelection, Call call, PostfixFollow pffollow) {
		this.ruleSelection = ruleSelection;
		this.call = call;
		this.pffollow = pffollow;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum ArrayEnum {
	Slice,
	Index,
}

class Array {
	ArrayEnum ruleSelection;
	Expr expr;

	this(ArrayEnum ruleSelection) {
		this.ruleSelection = ruleSelection;
	}

	this(ArrayEnum ruleSelection, Expr expr) {
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

enum CallEnum {
	Empty,
}

class Call {
	CallEnum ruleSelection;

	this(CallEnum ruleSelection) {
		this.ruleSelection = ruleSelection;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PrimaryExprEnum {
	Float,
	Integer,
	Parenthesis,
}

class PrimaryExpr {
	PrimaryExprEnum ruleSelection;
	Token value;
	Expr expr;

	this(PrimaryExprEnum ruleSelection, Token value) {
		this.ruleSelection = ruleSelection;
		this.value = value;
	}

	this(PrimaryExprEnum ruleSelection, Expr expr) {
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

enum IdentifierEnum {
	Ident,
}

class Identifier {
	IdentifierEnum ruleSelection;
	Token value;

	this(IdentifierEnum ruleSelection, Token value) {
		this.ruleSelection = ruleSelection;
		this.value = value;
	}

	final void visit(Visitor vis) {
		vis.accept(this);
	}

	final void visit(Visitor vis) const {
		vis.accept(this);
	}
}

