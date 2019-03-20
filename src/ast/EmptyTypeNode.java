package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class EmptyTypeNode implements Node {
	private ArrayList<Node> parlist;
	private Node ret;

	public EmptyTypeNode (ArrayList<Node> p, Node r) {
		parlist=p;
		ret=r;
	}

	public Node getRet () { 
		return ret;
	}

	public ArrayList<Node> getParList () { 
		return parlist;
	}
	
	public int getParListLength() {
		return parlist.size();
	}
	public String toPrint(String s) {
		String parlstr="";
		for (Node par:parlist){parlstr+=par.toPrint(s+"  ");};
		return s+"ArrowTypeNode\n" + parlstr + ret.toPrint(s+"  ->") ; 
	}

	//non utilizzato
	public Node typeCheck() {return null;}

	//non utilizzato
	public String codeGeneration() {return "";}
}