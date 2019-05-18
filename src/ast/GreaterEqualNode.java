package ast;

import lib.FOOLlib;

public class GreaterEqualNode implements Node {

	private Node left;
	private Node right;

	public GreaterEqualNode(Node l, Node r) {
		this.left = l;
		this.right = r;
	}

	public String toPrint(String s) {
		return s + "GreaterEqual \n" + left.toPrint(s + "  ") + right.toPrint(s + "  ");
	}

	public Node typeCheck() {
		Node l = left.typeCheck();
		Node r = right.typeCheck();
		if (!(FOOLlib.isSubtype(l, r) || FOOLlib.isSubtype(r, l))) {
			System.out.println("Incompatible types in greater equal");
			System.exit(0);
		}
		return new BoolTypeNode();
	}

	/*
	 * Se è vero salto a l1 se è falso continuo
	 */
	public String codeGeneration() {
		String l1 = FOOLlib.freshLabel();
		String l2 = FOOLlib.freshLabel();

		return right.codeGeneration() 
				+ left.codeGeneration() 
				+ "bleq " + l1 + "\n" 
				+ "push 0\n" 
				+ "b " + l2 + "\n" 
				+ l1 + ": \n" 
				+ "push 1\n" 
				+ l2 + ": \n";
	}

}