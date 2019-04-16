package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class ClassCallNode implements Node {
	
	private String id1;	//classe
	private String id2;	//metodo
	private int nestingLevel;
	private STentry methodEntry;
	private STentry entry;
	private ArrayList<Node> parlist = new ArrayList<Node>(); 

	public ClassCallNode (String id1, String id2, STentry st, STentry entry, ArrayList<Node> p, int nl) {
		this.id1=id1;
		this.id2 = id2;
		nestingLevel=nl;
		methodEntry=st;
		parlist=p;
		this.entry = entry;
	}

	public String toPrint(String s) {
		String parlstr="";
		for (Node par:parlist){parlstr+=par.toPrint(s+"  ");};
		return s+"Call:" + id2 + " at nestinglevel " + nestingLevel +"\n" +
		entry.toPrint(s+"  ") +  
		parlstr;
	}

	public Node typeCheck() {	 
		ArrowTypeNode t=null;
		
		if (methodEntry.getType() instanceof ArrowTypeNode) {
			t=(ArrowTypeNode) methodEntry.getType(); 
		} else {
			System.out.println("Invocation of a non-function "+id2);
			System.exit(0);
		}
		ArrayList<Node> p = t.getParList();
		if ( !(p.size() == parlist.size()) ) {
			System.out.println("Wrong number of parameters in the invocation of "+id2);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo della funzione che chiami
		for (int i=0; i<parlist.size(); i++) {
			if ( !(FOOLlib.isSubtype( (parlist.get(i)).typeCheck(), p.get(i)) ) ) {
				System.out.println("Wrong type for "+(i+1)+"-th parameter in the invocation of "+id2);
				System.exit(0);
			} 
		}
		return t.getRet();
	}
	
	private String getAddress(int offset) {
		String getAR="";
		for (int i=0; i<nestingLevel-entry.getNestinglevel();i++) {
			getAR+="lw\n";
		}
		return "push "+offset+"\n"+			 
		"lfp\n"+getAR+ 		//risalgo la catena statica per ottenere l'indirizzo dell'AR in cui è dichiarata la variabile
		"add\n"+
		"lw\n"; 			//prende il valore all'indirizzo specificato e lo poppa sullo stack
	}

	public String codeGeneration() {
		String objectPointer = getAddress(entry.getOffset());
		
		String parCode="";
		for (int i=parlist.size()-1; i>=0; i--) {
			parCode+=parlist.get(i).codeGeneration();
		}
		
		return "lfp \n"						//salva il control link
				+ parCode					//dobbiamo settare l'AL a objectPointer
				+ objectPointer 			//salvare il valore dell'access link
				+ objectPointer				//salvare l'indirizzo del metodo
				+ "push " + methodEntry.getOffset() + "\n"
				+ "add \n"					//stiamo puntando al metodo chiamato
				+ "lw \n"
				+ "js \n";
	}  

}
