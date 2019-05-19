package ast;

import java.util.ArrayList;
import java.util.List;
import lib.FOOLlib;

public class CallNode implements Node {
	private String id;
	private int nestingLevel;
	private STentry entry;		//classe che stai richiamando
	private List<Node> parlist = new ArrayList<Node>(); 

	public CallNode (String i, STentry st, ArrayList<Node> p, int nl) {
		this.id = i;
		this.nestingLevel = nl;
		this.entry = st;
		this.parlist = p;
	}

	public String toPrint(String s) {
		String parlstr = "";
		for (Node par: parlist){
			parlstr += par.toPrint(s + "  ");
		}
		return s + "Call:" + id + " at nestinglevel " + nestingLevel + "\n" +
		entry.toPrint(s + "  ") +  
		parlstr;
	}

	public Node typeCheck() {	 
		if (!(entry.getType() instanceof ArrowTypeNode)) {
			System.out.println("Invocation of a non-function " + id);
			System.exit(0);
		}

		ArrowTypeNode t = (ArrowTypeNode) entry.getType(); 
		List<Node> p = t.getParList();

		if (!(p.size() == parlist.size())) {
			System.out.println("Wrong number of parameters in the invocation of " + id);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo dei parametri della funzione che chiami
		for (int i = 0; i < parlist.size(); i++) {
			if (!(FOOLlib.isSubtype( (parlist.get(i)).typeCheck(), p.get(i)))) {
				System.out.println("Wrong type for " + (i+1) + "-th parameter in the invocation of " + id);
				System.exit(0);
			} 
		}
		return t.getRet();
	}

	public String codeGeneration() {
		String result; 
		String parCode = "";

		//carichiamo i parametri sullo stack 
		for (int i = parlist.size()-1; i >= 0; i--) {
			parCode += parlist.get(i).codeGeneration();
		}

		String getAR = "";

		

		if (entry.getIsMethod()) {
			//Object Oriented
			
			for (int i = 0; i < nestingLevel-entry.getNestinglevel()+1; i++) {
				getAR += "lw\n";     
			}
			result = "lfp\n" + 			//Control Link - salvo il frame pointer precedente (della funzione che mi ha chiamato) che ci serve poi per tornare al punto in cui eravamo 
					parCode + 			//allocazione valori parametri	

					"lfp\n" + getAR + 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)			
					"push " + (entry.getOffset()) + "\n" +
					"add\n" +			//otteniamo l'indirizzo del metodo nella dispatch table
					"lw\n" + 			//carica sullo stack l'etichetta del metodo trovato nella dispatch table
					"js\n"; 			//effettua il salto
		} else {
			//Higher order
			//risaliamo la catena statica fino ad arrivare al nesting level che vogliamo
			for (int i = 0; i < nestingLevel-entry.getNestinglevel(); i++) {
				getAR += "lw\n";      
			}
			
			result = "lfp\n" + 			//Control Link
					parCode + 			//allocazione valori parametri	

					/*
					 * nel caso di higher order 
					 * nella prima parte dell'offset c'� la dichiarazione della funzione 
					 * e nella seconda c'� l'indirizzo
					 */

					//usato per settare un nuovo access link
					"lfp\n" + getAR + 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)	
					"push " + entry.getOffset() + "\n" +		 				 
					"add\n" +
					"lw\n" + 			//carica sullo stack l'indirizzo della funzione

					//usato per saltare al codice della funzione
					"lfp\n" + getAR + 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)	
					"push " + (entry.getOffset()-1) + "\n" +			 				 
					"add\n" +

					"lw\n" + 			//carica sullo stack l'indirizzo della funzione
					"js\n"; 			//effettua il salto
		}
		return result;
	}  
}  