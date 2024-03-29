package ast;
public class ParNode implements DecNode {

	private String id;
	private Node type;

	public ParNode (String i, Node t) {
		this.id = i;
		this.type = t;
	}

	public String toPrint(String s) {
		return s + "Par:" + id + "\n"
				+ type.toPrint(s + "  ") ; 
	}

	//non utilizzato
	public Node typeCheck() {
		return null;
	}

	public String codeGeneration() {
		return "";
	}

	@Override
	public Node getSymType() {
		return this.type;
	}

	public String getId() {
		return this.id;
	}

}  