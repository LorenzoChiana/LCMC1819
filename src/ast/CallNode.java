package ast;

import java.util.ArrayList;

import lib.FOOLlib;

public class CallNode implements Node {

	private String id;
	private int nestingLevel;
	private STentry entry;
	private ArrayList<Node> parlist = new ArrayList<Node>();

	public CallNode(String i, STentry st, ArrayList<Node> p, int nl) {
		id = i;
		nestingLevel = nl;
		entry = st;
		parlist = p;
	}

	public String toPrint(String s) {
		String parlstr = "";
		for (Node par : parlist) {
			parlstr += par.toPrint(s + "  ");
		}
		return s + "Call:" + id + " at nestinglevel " + nestingLevel + "\n" + entry.toPrint(s + "  ") + parlstr;
	}

	public Node typeCheck() {
		ArrowTypeNode t = null;
		if (entry.getType() instanceof ArrowTypeNode) {
			t = (ArrowTypeNode) entry.getType();
		} else {
			System.out.println("Invocation of a non-function " + id);
			System.exit(0);
		}
		ArrayList<Node> p = t.getParList();
		/* check sul numero di parametri */
		if (p.size() != parlist.size()) {
			System.out.println("Wrong number of parameters in the invocation of " + id);
			System.exit(0);
		}
		/* check sul tipo dei parametri */
		for (int i = 0; i < parlist.size(); i++)
			if (!(FOOLlib.isSubtype((parlist.get(i)).typeCheck(), p.get(i)))) {
				System.out.println("Wrong type for " + (i + 1) + "-th parameter in the invocation of " + id);
				System.exit(0);
			}

		return t.getRet();
	}

	public String codeGeneration() {
		String parCode = "";
		for (int i = parlist.size() - 1; i >= 0; i--)
			parCode += parlist.get(i).codeGeneration();
		String getAR = "";
		for (int i = 0; i < nestingLevel - entry.getNestinglevel(); i++)
			getAR += "lw\n";
		
		if(entry.isMethod()) {
			//METHOD CALL
			return  //CONTROL LINK
	    			"lfp\n" 
					  
					//ALLOCAZIONE PARAMETRI
	    			+ parCode  
	    			 
	    			//ACCESS LINK	 
	    			+ "lfp\n" 
	    			+ getAR		
	    			
	    			//JUMP AL METODO
	    			+ "push " + entry.getOffset() +"\n"			 
	    			+ "lfp\n" 
	    			+ getAR
	    			+ "lw\n"
	    			+ "add\n"
	    			+ "lw\n"
	    	        + "js\n";
			
		} else {
			//HIGHER ORDER
			return  //CONTROL LINK
	    			"lfp\n" 
					  
					//ALLOCAZIONE PARAMETRI
	    			+ parCode  
	    			 
	    			//ACCESS LINK
	    			+ "push " + entry.getOffset()+"\n"		 
	    			+ "lfp\n" + getAR			 
	    			+ "add\n"
	    			+ "lw \n"   
	    			
	    			//JUMP ALLA FUNZIONE
	    			//Se è un metodo uso l'offset normale, altrimenti vado ad offset-1 
	    			//(nell'higher order infatti le funzioni occupano 2 spazi e l'indirizzo della funzione è nel secondo)
	    			+ "push " + (entry.getOffset()-1)+"\n"			 
	    			+ "lfp\n" +getAR
	    			+ "add\n"
	    			+ "lw\n"
	    	        + "js\n";
			
		}

  }  
}  