package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class NewNode implements Node {
	private ArrayList<Node> arglist = new ArrayList<Node>();

	public NewNode (ArrayList<Node> array) {
		this.arglist = array;
	}

	public String toPrint(String s) {
		return s+"And\n";/* + left.toPrint(s+"  ")   
		+ right.toPrint(s+"  ") ; */
	}

	public Node typeCheck() {
		/*Node l= left.typeCheck();  
		Node r= right.typeCheck();  
		if ( !(FOOLlib.isSubtype(l, r) || FOOLlib.isSubtype(r, l)) ) {
			System.out.println("Incompatible types in and");
			System.exit(0);	
		}  */
		return new BoolTypeNode();
	}

	public String codeGeneration() {
		
		return "";
	}

}
