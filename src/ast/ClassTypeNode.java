package ast;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ClassTypeNode implements Node {

	private ArrayList<Node> allFields = new ArrayList<>();
	private ArrayList<Node> allMethods = new ArrayList<>();
	
	public ClassTypeNode() {}
	
	public ClassTypeNode(ArrayList<Node> fields, ArrayList<Node> methods) {
		this.allFields = fields;
		this.allMethods = methods;
	}

	public void addField(Node f, int offset) {
		this.allFields.add(offset, f);
	}
	
	public void replaceField(Node f, int offset) {
		this.allFields.set(offset, f);
	}

	public void addMethod(Node m, int offset) {
		this.allMethods.add(offset, m);
	}
	
	public void replaceMethod(Node m, int offset) {
		this.allMethods.set(offset, m);
	}

	public List<Node> getFields() {
		return Collections.unmodifiableList(this.allFields);
	}
	
	public List<Node> getMethods() {
		return Collections.unmodifiableList(this.allMethods);
	}

	@Override
	public String toPrint(String indent) {

		String fieldList = "";
		for (Node n : allFields)
			fieldList += n.toPrint(indent + "  ");

		String methodList = "";
		for (Node n : allMethods)
			methodList += n.toPrint(indent + "  ");

		return indent + "ClassType\n" + fieldList + methodList;
	}

	// non utilizzato
	@Override
	public Node typeCheck() {
		return null;
	}

	// non utilizzato
	@Override
	public String codeGeneration() {
		return "";
	}
	
	public ClassTypeNode copy() {
		return new ClassTypeNode(new ArrayList<>(allFields), new ArrayList<>(allMethods));
	}

}
