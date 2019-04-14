package ast;

import java.util.ArrayList;

public class ClassTypeNode implements Node {
	ArrayList<Node> allFields;
	ArrayList<Node> allMethods;

	public ClassTypeNode () {
		allFields = new ArrayList<Node>();
		allMethods = new ArrayList<Node>();
	}
	
	public void addField(int offset, Node field) {
		allFields.add(offset, field);
	}
	
	public void addMethod(int offset, Node method) {
		allMethods.add(offset, method);
	}
	
	public ArrayList<Node> getFields() {
		return allFields;
	}
	
	public ArrayList<Node> getMethods() {
		return allMethods;
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
