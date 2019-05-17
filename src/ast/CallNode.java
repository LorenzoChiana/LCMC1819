package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class CallNode implements Node {

	private String id;
	private int nestingLevel;
	private STentry entry;		//classe che stai richiamando
	private ArrayList<Node> parlist = new ArrayList<Node>(); 

	public CallNode (String i, STentry st, ArrayList<Node> p, int nl) {
		id=i;
		nestingLevel=nl;
		entry=st;
		parlist=p;
	}

	public String toPrint(String s) {
		String parlstr="";
		for (Node par:parlist){parlstr+=par.toPrint(s+"  ");};
		return s+"Call:" + id + " at nestinglevel " + nestingLevel +"\n" +
		entry.toPrint(s+"  ") +  
		parlstr;
	}

	public Node typeCheck() {	 
		ArrowTypeNode t=null;
		if (entry.getType() instanceof ArrowTypeNode) {
			t=(ArrowTypeNode) entry.getType(); 
		} else {
			System.out.println("Invocation of a non-function "+id);
			System.exit(0);
		}
		ArrayList<Node> p = t.getParList();


		System.out.println("---------->" + p.size() + " parlist " + parlist.size());


		if ( !(p.size() == parlist.size()) ) {
			System.out.println("Wrong number of parameters in the invocation of "+id);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo della funzione che chiami
		for (int i=0; i<parlist.size(); i++) {
			if ( !(FOOLlib.isSubtype( (parlist.get(i)).typeCheck(), p.get(i)) ) ) {
				System.out.println("Wrong type for "+(i+1)+"-th parameter in the invocation of "+id);
				System.exit(0);
			} 
		}
		return t.getRet();
	}

	public String codeGeneration() {
		String result; 
		String parCode="";
		for (int i=parlist.size()-1; i>=0; i--) {
			parCode+=parlist.get(i).codeGeneration();
		}

		String getAR="";
		for (int i=0; i<nestingLevel-entry.getNestinglevel();i++) {
			getAR+="lw\n";      
		}

		if (entry.getIsMethod()) {
			//Object Oriented
			result = "lfp\n"+ 			//Control Link - salvo il frame pointer precedente (della funzione che mi ha chiamato) che ci serve poi per tornare al punto in cui eravamo 
					parCode+ 			//allocazione valori parametri	

					"lfp\n"+getAR+ 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)					 
					"lfp\n"+ 			//carica il frame pointer
					getAR+ 				//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)			
					"lw \n"+			//aggiungo 1 alla differenza di nesting level in modo da raggiungere la dispatch table
					"push "+(entry.getOffset())+"\n"+
					"add\n"+			//otteniamo l'indirizzo del metodo nella dispatch table
					"lw\n"+ 			//carica sullo stack l'etichetta del metodo trovato nella dispatch table
					"js\n"; 			//effettua il salto
		} else {
			//Higher order
			result = "lfp\n"+ 			//Control Link
					parCode+ 			//allocazione valori parametri	

					/*
					 * nel caso di higher order 
					 * nella prima parte dell'offset c'� la dichiarazione della funzione 
					 * e nella seconda c'� l'indirizzo
					 */

					//usato per settare un nuovo access link
					"lfp\n"+getAR+ 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)	
					"push "+entry.getOffset()+"\n"+		 				 
					"add\n"+
					"lw\n"+ 			//carica sullo stack l'indirizzo della funzione

					//usato per saltare al codice della funzione
					"lfp\n"+getAR+ 		//risalgo la catena statica per ottenere l'indirizzo dell'AR 
					//in cui � dichiarata la funzione (Access Link)	
					"push "+(entry.getOffset()-1)+"\n"+			 				 
					"add\n"+

					"lw\n"+ 			//carica sullo stack l'indirizzo della funzione
					"js\n"; 			//effettua il salto
		}

		return result;
	}  
}  