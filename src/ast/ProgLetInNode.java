package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ProgLetInNode implements Node {

	private ArrayList<Node> declist;
	private ArrayList<Node> classlist;
	private Node exp;
	private boolean isOO=false;

	public ProgLetInNode (ArrayList<Node> d, Node e) {
		declist=d;
		exp=e;
		isOO=false;
	}

	public ProgLetInNode (ArrayList<Node> c, ArrayList<Node> d, Node e) {
		classlist=c;
		declist=d;
		exp=e;
		isOO=true;
	}

	public String toPrint(String s) {
		if (isOO) {
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
		}else {
			//dec List
			String declstr="";
			for (Node dec:declist){
				declstr+=dec.toPrint(s+"  ");
			};
			return s+"ProgLetIn\n" + declstr + exp.toPrint(s+"  "); 
		}
	}

	public Node typeCheck() {
		if (isOO) {
			for (Node dec:declist){dec.typeCheck();};
			for (Node decC:classlist){decC.typeCheck();};
			return exp.typeCheck();
		}else {
			for (Node dec:declist){dec.typeCheck();};
			return exp.typeCheck();
		}
	}

	public String codeGeneration() {
			String declCode="";
			for (Node decC:classlist) declCode+=decC.codeGeneration();
			for (Node dec:declist) declCode+=dec.codeGeneration();
			return  "push 0\n"+
			declCode+
			exp.codeGeneration()+
			"halt\n"+
			FOOLlib.getCode();
	}

}  