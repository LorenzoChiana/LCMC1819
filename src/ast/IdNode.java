package ast;
/*
 * Classe utilizzata per cecare le dichiarazione di cose dichiarate in uno scope esterno
 * */
public class IdNode implements Node {

	private String id;
	private int nestingLevel;
	private STentry entry;

	public IdNode (String i, STentry st, int nl) {
		id=i;
		nestingLevel=nl;
		entry=st;
	}

	public String toPrint(String s) {
		return s+"Id:" + id + " at nestinglevel "+ nestingLevel + "\n" + 
				entry.toPrint(s+"  ") ;  
	}

	public Node typeCheck() {
		/*if (entry.getType() instanceof ArrowTypeNode) {
			System.out.println("Wrong usage of function identifier");
			System.exit(0);
		} */
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
		String getAR="";
		for (int i=0; i<nestingLevel-entry.getNestinglevel();i++) {
			getAR+="lw\n";
		}
		
		return "push "+offset+"\n"+			 
			"lfp\n"+getAR+ //risalgo la catena statica per ottenere l'indirizzo dell'AR 
			//in cui � dichiarata la variabile			 
			"add\n"+
			"lw\n"; //prende il valore all'indirizzo specificato e lo poppa sullo stack
	}

}  