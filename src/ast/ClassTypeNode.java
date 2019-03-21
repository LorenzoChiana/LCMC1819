package ast;

import java.util.ArrayList;

public class ClassTypeNode implements Node {
	ArrayList<Node> allFields;
	ArrayList<Node> allMethods;

	public ClassTypeNode () {
		allFields = new ArrayList<Node>();
		allMethods = new ArrayList<Node>();
	}
	
	public void addField(Node field) {
		allFields.add(field);
	}
	
	public void addMethod(Node method) {
		allMethods.add(method);
	}

	public String toPrint(String s) {
		String fieldList = "";
		String methodList = "";
		for (Node field:allFields){fieldList+=field.toPrint(s+"  ");}
		for (Node method:allMethods){methodList+=method.toPrint(s+"  ");}
		
		return s+"ClassTypeNode\n" + fieldList + methodList; 
	}

	//non utilizzato
	public Node typeCheck() {return null;}

	//non utilizzato
	public String codeGeneration() {return "";}

}
