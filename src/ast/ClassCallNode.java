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
		this.id1 = id1;
		this.id2 = id2;
		this.nestingLevel = nl;
		this.methodEntry = st;
		this.parlist = p;
		this.entry = entry;
	}

	public String getId1() {
		return id1;
	}

	public void setId1(String id1) {
		this.id1 = id1;
	}

	public String toPrint(String s) {
		String parlstr = "";
		for (Node par: parlist){
			parlstr += par.toPrint(s + "  ");
		}
		return s + "Call:" + id2 + " at nestinglevel " + nestingLevel + "\n" +
		entry.toPrint(s + "  ") +  
		parlstr;
	}

	public Node typeCheck() {		
		if (!(methodEntry.getType() instanceof ArrowTypeNode)) {
			System.out.println("Invocation of a non-function " + id2);
			System.exit(0);	 
		}

		ArrowTypeNode t = (ArrowTypeNode) methodEntry.getType();
		ArrayList<Node> p = t.getParList();

		if (!(p.size() == parlist.size())) {
			System.out.println("Wrong number of parameters in the invocation of " + id2);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo della funzione che chiami
		for (int i = 0; i < parlist.size(); i++) {
			if (!(FOOLlib.isSubtype((parlist.get(i)).typeCheck(), p.get(i)))) {
				System.out.println("Wrong type for " + (i+1) + "-th parameter in the invocation of " + id2);
				System.exit(0);
			} 
		}
		return t.getRet();
	}

	private String getAddress(int offset) {
		String getAR = "";
		for (int i = 0; i < nestingLevel-entry.getNestinglevel(); i++) {
			getAR += "lw\n";
		}
		return "push " + offset + "\n"			 
		+ "lfp\n" + getAR		//risalgo la catena statica 
		+ "add\n"
		+ "lw\n"; 			//prende il valore all'indirizzo specificato e lo poppa sullo stack
	}

	public String codeGeneration() {
		//chiamata ID1.ID2()
		String objectPointer = getAddress(entry.getOffset());
		String parCode = "";

		for (int i = parlist.size()-1; i >= 0; i--) {
			parCode += parlist.get(i).codeGeneration();
		}

		return "lfp \n"						//salva il control link
				+ parCode					//Carico i parametri sullo stack
				+ objectPointer 			//recupero l'Id1 per salvare il valore dell'access link
				+ objectPointer				//riuso Id1 per recuperare la dispatch table
				+ "lw \n"					
				+ "push " + methodEntry.getOffset() + "\n" //sommando l'offset cerco la label del metodo nella dispatch table
				+ "add \n"					
				+ "lw \n"
				+ "js \n";					//Effettuo il salto al metodo
	}
}
