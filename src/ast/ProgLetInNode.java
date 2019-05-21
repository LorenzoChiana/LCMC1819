package ast;
import java.util.ArrayList;
import java.util.List;

import lib.FOOLlib;

public class ProgLetInNode implements Node {

	private List<Node> declist = new ArrayList<Node>();
	private List<Node> classlist = new ArrayList<Node>();
	private Node exp;

	public ProgLetInNode (ArrayList<Node> d, Node e) {
		this.declist = d;
		this.exp = e;
	}

	public ProgLetInNode (ArrayList<Node> c, ArrayList<Node> d, Node e) {
		this.classlist = c;
		this.declist = d;
		this.exp = e;
	}

	public String toPrint(String s) {
		//class List
		String cstr = "";
		for (Node c: classlist){
			cstr += c.toPrint(s + "  ");
		}

		//dec List
		String declstr = "";
		for (Node dec: declist){
			declstr += dec.toPrint(s + "  ");
		}

		return s + "ProgLetIn\n" + cstr + declstr + exp.toPrint(s + "  ");

	}

	public Node typeCheck() {
		for (Node c: classlist){
			c.typeCheck();
		}

		for (Node d: declist){
			d.typeCheck();
		}
		return exp.typeCheck();
	}

	public String codeGeneration() {
		String classCode = "";
		String declCode = "";

		for (Node c: classlist) {
			classCode += c.codeGeneration();
		}

		for (Node d: declist) {
			declCode += d.codeGeneration();
		}

		return  "push 0\n"
			+ classCode
			+ declCode
			+ exp.codeGeneration()
			+ "halt\n"
			+ FOOLlib.getCode();
	}

}  