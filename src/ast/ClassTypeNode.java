package ast;

import java.util.ArrayList;

public class ClassTypeNode implements Node {
	ArrayList<Node> allFields;
	ArrayList<Node> allMethods;

	public ClassTypeNode () {
		allFields = new ArrayList<Node>();
		allMethods = new ArrayList<Node>();
	}
	
	public void addField(Node f, int offset) {
		this.allFields.add(offset, f);
	}
	
	public void replaceField(Node f, int offset) {
		this.allFields.set(offset, f);
	}
	
	public void addAllFields(ArrayList<Node> f) {
		allFields.addAll(f);
	}
	
	public void addAllMethods(ArrayList<Node> m) {
		allMethods.addAll(m);
	}
	
	public void addField(int offset, Node field) {
		allFields.add(offset, field);
	}
	
	public void addMethod(Node method, int offset) {
		allMethods.add(offset, method);
	}
	
	public void replaceMethod(Node m, int offset) {
		this.allMethods.set(offset, m);
	}
	
	public ArrayList<Node> getFields() {
		return new ArrayList<Node>(allFields);
	}
	
	public ArrayList<Node> getMethods() {
		return new ArrayList<Node>(allMethods);
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
