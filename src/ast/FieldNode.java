package ast;

public class FieldNode implements DecNode {

	private String id;
	private Node type;
	private int offset;

	public FieldNode(String id, Node type, int offset) {
		this.id = id;
		this.type = type;
		this.offset = offset;
	}

	
	public int getOffset() {
		return this.offset;
	}

	@Override
	public String toPrint(String indent) {
		return indent + "Field: " + id + "\n" + type.toPrint(indent + "  ");
	}

	/*
	 * non usato come ParNode
	 */
	@Override
	public Node typeCheck() {
		return null;
	}
	

	/*
	 * non usato come ParNode
	 */
	@Override
	public String codeGeneration() {
		return "";
	}

	@Override
	public Node getSymType() {
		return this.type;
	}
	
	@Override
	public String toString() {
		return this.id;
	}

}
