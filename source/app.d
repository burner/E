import std.stdio;

import std.conv : to;

import parser;
import lexer;
import ast;

void main() {
	string s = "hello[]";
	auto l = Lexer(s);
	auto p = new Parser(l);

	Expr e = p.parseExpr();
	assert(e.ruleSelection == ExprEnum.PostfixExpr);

	PostfixExpr ps = e.post;
	assert(ps !is null);
	assert(ps.ruleSelection == PostfixExprEnum.Array,
		to!string(ps.ruleSelection)
	);
}
