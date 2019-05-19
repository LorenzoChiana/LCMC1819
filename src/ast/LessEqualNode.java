package ast;
import lib.FOOLlib;

public class LessEqualNode implements Node {
	private Node left;
	private Node right;

	public LessEqualNode (Node l, Node r) {
		this.left = l;
		this.right = r;
	}

	public String toPrint(String s) {
		return s + "LessEqual\n" + left.toPrint(s + "  ")   
		+ right.toPrint(s + "  ") ; 
	}

	public Node typeCheck() {
		Node l = left.typeCheck();  
		Node r = right.typeCheck();  
		if (!(FOOLlib.isSubtype(l, r) || FOOLlib.isSubtype(r, l))) {
			System.out.println("Incompatible types in less equal");
			System.exit(0);	
		}  
		return new BoolTypeNode();
	}

	/*
	 * Se è vero salto a l1 se è falso continuo
	 * */

	public String codeGeneration() {
		String l1 = FOOLlib.freshLabel();
		String l2 = FOOLlib.freshLabel();
		return left.codeGeneration() +
				right.codeGeneration() +
				"bleq " + l1 + "\n" +
				"push 0\n" +
				"b " + l2 + "\n" +
				l1 + ": \n" +
				"push 1\n" +
				l2 + ": \n";
	}



}
