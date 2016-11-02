module visitor;

import ast;
import tokenmodule;

class Visitor {

	void accept(Expression obj) {
		final switch(obj.ruleSelection) {
			case ExpressionEnum.Postfix:
				obj.post.visit(this);
				break;
		}
	}

	void accept(const(Expression) obj) {
		final switch(obj.ruleSelection) {
			case ExpressionEnum.Postfix:
				obj.post.visit(this);
				break;
		}
	}

	void accept(PostfixExpression obj) {
		final switch(obj.ruleSelection) {
			case PostfixExpressionEnum.Primary:
				obj.prim.visit(this);
				break;
			case PostfixExpressionEnum.Array:
				obj.prim.visit(this);
				obj.expr.visit(this);
				break;
			case PostfixExpressionEnum.Call:
				obj.prim.visit(this);
				obj.expr.visit(this);
				break;
		}
	}

	void accept(const(PostfixExpression) obj) {
		final switch(obj.ruleSelection) {
			case PostfixExpressionEnum.Primary:
				obj.prim.visit(this);
				break;
			case PostfixExpressionEnum.Array:
				obj.prim.visit(this);
				obj.expr.visit(this);
				break;
			case PostfixExpressionEnum.Call:
				obj.prim.visit(this);
				obj.expr.visit(this);
				break;
		}
	}

	void accept(PrimaryExpression obj) {
		final switch(obj.ruleSelection) {
			case PrimaryExpressionEnum.Identifier:
				obj.ident.visit(this);
				break;
			case PrimaryExpressionEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
	}

	void accept(const(PrimaryExpression) obj) {
		final switch(obj.ruleSelection) {
			case PrimaryExpressionEnum.Identifier:
				obj.ident.visit(this);
				break;
			case PrimaryExpressionEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
	}
}
