package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ProgLetInNode implements Node {

	private ArrayList<Node> declist = new ArrayList<Node>();
	private ArrayList<Node> classlist = new ArrayList<Node>();
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
		for (Node decC:classlist){decC.typeCheck();}
		for (Node dec:declist){dec.typeCheck();}
		return exp.typeCheck();
	}

	public String codeGeneration() {
		String classCode="";
		String declCode="";

		for (Node decC:classlist) classCode+=decC.codeGeneration();
		for (Node dec:declist) declCode+=dec.codeGeneration();
		return  "push 0\n"+
		classCode+
		declCode+
		exp.codeGeneration()+
		"halt\n"+
		FOOLlib.getCode();
	}

}  