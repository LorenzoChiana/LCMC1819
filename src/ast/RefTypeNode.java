package ast;

public class RefTypeNode implements Node {
	String classId;

	public RefTypeNode (String id) {
		this.classId = id;
	}
	public String getClassId() {
		return classId;
	}
	public String toPrint(String s) {
		return s + "RefType " + classId + "\n";
	}

	//non utilizzato
	public Node typeCheck() {return null;}

	//non utilizzato
	public String codeGeneration() {return "";}

}
