package ast;

import lib.*;

public class DivNode implements Node {
	private Node left;
	private Node right;

	public DivNode (Node l, Node r) {
		this.left = l;
		this.right = r;
	}

	public String toPrint(String s) {
		return s + "Div\n" + left.toPrint(s + "  ")  
		+ right.toPrint(s + "  "); 
	}

	public Node typeCheck() {
		if (!(FOOLlib.isSubtype(left.typeCheck(), new IntTypeNode()) 
				&& FOOLlib.isSubtype(right.typeCheck(), new IntTypeNode()))) {
			System.out.println("Non integers in div");
			System.exit(0);	
		}
		return new IntTypeNode();
	}

	public String codeGeneration() {
		return left.codeGeneration() + right.codeGeneration() + "div\n";
	}
}  