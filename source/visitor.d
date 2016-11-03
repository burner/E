module visitor;

import ast;
import tokenmodule;

class Visitor {

	void accept(Expr obj) {
		final switch(obj.ruleSelection) {
			case ExprEnum.PostfixExpr:
				obj.post.visit(this);
				break;
		}
	}

	void accept(const(Expr) obj) {
		final switch(obj.ruleSelection) {
			case ExprEnum.PostfixExpr:
				obj.post.visit(this);
				break;
		}
	}

	void accept(PostfixExpr obj) {
		final switch(obj.ruleSelection) {
			case PostfixExprEnum.Ident:
				obj.ident.visit(this);
				break;
			case PostfixExprEnum.Array:
				obj.ident.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixExprEnum.Primary:
				obj.prim.visit(this);
				break;
		}
	}

	void accept(const(PostfixExpr) obj) {
		final switch(obj.ruleSelection) {
			case PostfixExprEnum.Ident:
				obj.ident.visit(this);
				break;
			case PostfixExprEnum.Array:
				obj.ident.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixExprEnum.Primary:
				obj.prim.visit(this);
				break;
		}
	}

	void accept(PostfixFollow obj) {
		final switch(obj.ruleSelection) {
			case PostfixFollowEnum.Dot:
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.Array:
				obj.array.visit(this);
				break;
			case PostfixFollowEnum.ArrayDot:
				obj.array.visit(this);
				obj.postfix.visit(this);
				break;
			case PostfixFollowEnum.ArrayFollow:
				obj.array.visit(this);
				obj.pffollow.visit(this);
				break;
			case PostfixFollowEnum.Call:
				obj.call.visit(this);
				break;
			case PostfixFollowEnum.CallDot:
				obj.call.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.CallFollow:
				obj.call.visit(this);
				obj.pffollow.visit(this);
				break;
		}
	}

	void accept(const(PostfixFollow) obj) {
		final switch(obj.ruleSelection) {
			case PostfixFollowEnum.Dot:
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.Array:
				obj.array.visit(this);
				break;
			case PostfixFollowEnum.ArrayDot:
				obj.array.visit(this);
				obj.postfix.visit(this);
				break;
			case PostfixFollowEnum.ArrayFollow:
				obj.array.visit(this);
				obj.pffollow.visit(this);
				break;
			case PostfixFollowEnum.Call:
				obj.call.visit(this);
				break;
			case PostfixFollowEnum.CallDot:
				obj.call.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.CallFollow:
				obj.call.visit(this);
				obj.pffollow.visit(this);
				break;
		}
	}

	void accept(Array obj) {
		final switch(obj.ruleSelection) {
			case ArrayEnum.Index:
				obj.expr.visit(this);
				break;
		}
	}

	void accept(const(Array) obj) {
		final switch(obj.ruleSelection) {
			case ArrayEnum.Index:
				obj.expr.visit(this);
				break;
		}
	}

	void accept(Call obj) {
		final switch(obj.ruleSelection) {
			case CallEnum.Empty:
				break;
		}
	}

	void accept(const(Call) obj) {
		final switch(obj.ruleSelection) {
			case CallEnum.Empty:
				break;
		}
	}

	void accept(PrimaryExpr obj) {
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Float:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Integer:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
	}

	void accept(const(PrimaryExpr) obj) {
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Float:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Integer:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
	}

	void accept(Identifier obj) {
		final switch(obj.ruleSelection) {
			case IdentifierEnum.Ident:
				obj.value.visit(this);
				break;
		}
	}

	void accept(const(Identifier) obj) {
		final switch(obj.ruleSelection) {
			case IdentifierEnum.Ident:
				obj.value.visit(this);
				break;
		}
	}
}
