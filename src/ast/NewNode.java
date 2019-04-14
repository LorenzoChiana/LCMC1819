package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class NewNode implements Node {
	private ArrayList<Node> arglist = new ArrayList<Node>();
	private String id;
	private STentry entry;
	
	public NewNode (String id, STentry entry, ArrayList<Node> arglist) {
		this.arglist = arglist;
		this.id = id;
		this.entry = entry;
	}

	public String toPrint(String s) {
		String list = "";
		for (Node arg:arglist){list+=arg.toPrint(s+"  ");}
		return s+"New: "+id+"\n"
		+entry.toPrint(s+"  ")
		+list;
	}

	public Node typeCheck() {
		if (!(entry.getType() instanceof ClassTypeNode)) {
			System.out.println("Invocation of a non-class "+id);
			System.exit(0);
		}
		
		ArrayList<Node> p = ((ClassTypeNode) entry.getType()).getFields();
		
		if ( !(p.size() == arglist.size()) ) {
			System.out.println("Wrong number of parameters in the invocation of "+id);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo della funzione che chiami
		for (int i=0; i<arglist.size(); i++) {
			if ( !(FOOLlib.isSubtype( (arglist.get(i)).typeCheck(), p.get(i)) ) ) {
				System.out.println("Wrong type for "+(i+1)+"-th parameter in the invocation of "+id);
				System.exit(0);
			} 
		}
		return new RefTypeNode(id);
	}

	public String codeGeneration() {

		return "";
	}

}
