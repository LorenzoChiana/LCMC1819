package ast;

public class FieldNode implements DecNode {

	private String id;
	private Node type;
	private int offset;
	

	public FieldNode (String i, Node type, int offset) {
		id=i;
		this.type = type;
		this.offset = offset;
	}
	
	public int getOffset() {
		return this.offset;
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
}  