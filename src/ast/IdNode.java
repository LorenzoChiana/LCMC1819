package ast;
/*
 * Classe utilizzata per cecare le dichiarazione di cose dichiarate in uno scope esterno
 * */
public class IdNode implements Node {
	private String id;
	private int nestingLevel;
	private STentry entry;

	public IdNode (String i, STentry st, int nl) {
		this.id = i;
		this.nestingLevel = nl;
		this.entry = st;
	}

	public String toPrint(String s) {
		return s + "Id:" + id + " at nestinglevel " + nestingLevel + "\n" + 
				entry.toPrint(s + "  ");  
	}

	public Node typeCheck() {
		if ((entry.getType() instanceof ClassTypeNode) || (entry.getIsMethod())) {
			System.out.println("Wrong usage of function identifier");
			System.exit(0);
		} 
		return entry.getType();
	}

	public String codeGeneration() {
		if (entry.getType() instanceof ArrowTypeNode) {
			return getAddress(entry.getOffset()) + getAddress(entry.getOffset()-1); 
		} else {
			return getAddress(entry.getOffset()); 
		}
	}

	private String getAddress(int offset) {
		String getAR = "";
		for (int i = 0; i < nestingLevel-entry.getNestinglevel(); i++) {
			getAR += "lw\n";
		}

		return  "lfp\n"	//carico il frame pointer
		+ getAR //risalgo la catena statica 	
		+ "push " + offset + "\n" //sommo l'offset
		+ "add\n"
		+ "lw\n"; //prende il valore all'indirizzo specificato e lo poppa sullo stack
	}
}  