package ast;

public class FieldNode implements DecNode {

	private String id;
	private Node type;
	private int offset;

	public FieldNode (String i, Node type, int offset) {
		this.id = i;
		this.type = type;
		this.offset = offset;
	}

	public FieldNode (String i, Node type) {
		this.id = i;
		this.type = type;
	}

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public String toPrint(String s) {
		return s+"Field:" + id +"\n"
				+type.toPrint(s+"  ") ; 
	}

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
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}

}  