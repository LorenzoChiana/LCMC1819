package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class RefTypeNode implements Node {
	String classId;

	public RefTypeNode (String id) {
		classId = id;
	}

	public String toPrint(String s) {
		return "";
	}

	//non utilizzato
	public Node typeCheck() {return null;}

	//non utilizzato
	public String codeGeneration() {return "";}

}
