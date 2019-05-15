package ast;

public class FieldNode implements DecNode {

	private String id;
	private Node type;
	

	public FieldNode (String i, Node type) {
		id=i;
		this.type = type;
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