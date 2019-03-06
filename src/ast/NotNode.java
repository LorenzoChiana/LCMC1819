package ast;

import lib.FOOLlib;

public class NotNode implements Node {
	private Node val;

	public NotNode (Node v) {
		val=v;
	}

	public String toPrint(String s) {
		return s+"Not\n" + val.toPrint(s+"  "); 
	}

	public Node typeCheck() {   
		return val.typeCheck();
	}

	public String codeGeneration() {
		String l1= FOOLlib.freshLabel();
		String l2= FOOLlib.freshLabel();
		return 
				val.codeGeneration() + 
				"push 1\n"+ 
				"beq "+l1+"\n"+
				"push 1\n"+ 
				"b "+l2+"\n"+
				l1+": \n"+
				"push 0\n"+
				l2+": \n";
	}

}

