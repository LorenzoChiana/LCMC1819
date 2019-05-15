package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ProgLetInNode implements Node {

	private ArrayList<Node> declist;
	private ArrayList<Node> classlist;
	private Node exp;

	public ProgLetInNode (ArrayList<Node> d, Node e) {
		declist=d;
		exp=e;
	}

	public ProgLetInNode (ArrayList<Node> c, ArrayList<Node> d, Node e) {
		classlist=c;
		declist=d;
		exp=e;
	}

	public String toPrint(String s) {
		//class List
		String cstr="";
		for (Node c:classlist){
			cstr+=c.toPrint(s+"  ");
		};
		//dec List
		String declstr="";
		for (Node dec:declist){
			declstr+=dec.toPrint(s+"  ");
		};
		return s+"ProgLetIn\n" + cstr + declstr + exp.toPrint(s+"  "); 
	}

	public Node typeCheck() {
		for (Node dec:declist){dec.typeCheck();};
		for (Node decC:classlist){decC.typeCheck();};
		return exp.typeCheck();
	}

	public String codeGeneration() {
		String declCode="";
		String declCCode="";
		for (Node dec:declist) declCode+=dec.codeGeneration();
		for (Node decC:declist) declCode+=decC.codeGeneration();
		return  "push 0\n"+
		declCCode+
		declCode+
		exp.codeGeneration()+
		"halt\n"+
		FOOLlib.getCode();
	}

}  