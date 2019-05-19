package ast;

import java.util.ArrayList;

public class ClassTypeNode implements Node {
	ArrayList<Node> allFields;
	ArrayList<Node> allMethods;

	public ClassTypeNode () {
		this.allFields = new ArrayList<Node>();
		this.allMethods = new ArrayList<Node>();
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

	public void addMethod(int offset, Node method) {
		allMethods.add(offset, method);
	}

	public void overrideMethod(int offset, Node method) {
		allMethods.set(offset, method);
	}

	public void overrideField(int offset, Node method) {
		allFields.set(offset, method);
	}

	public ArrayList<Node> getFields() {
		return new ArrayList<>(allFields);
	}

	public ArrayList<Node> getMethods() {
		return new ArrayList<>(allMethods);
	}

	public String toPrint(String s) {
		String fieldList = "";
		String methodList = "";
		for (Node field: allFields){
			fieldList += field.toPrint(s + "  ");
		}
		for (Node method: allMethods){
			methodList += method.toPrint(s + "  ");
		}
		return s + "ClassTypeNode\n" + fieldList + methodList; 
	}

	//non utilizzato
	public Node typeCheck() {
		return null;
	}

	//non utilizzato
	public String codeGeneration() {
		return "";
	}
}
