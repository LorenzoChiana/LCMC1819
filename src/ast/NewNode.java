package ast;

import java.util.ArrayList;
import java.util.List;

import lib.FOOLlib;

public class NewNode implements Node {
	private ArrayList<Node> argList = new ArrayList<Node>();
	private String id;
	private STentry entry;
	
	public NewNode (String id, STentry entry, ArrayList<Node> arglist) {
		this.argList = arglist;
		this.id = id;
		this.entry = entry;
	}

	public String toPrint(String s) {
		String list = "";
		for (Node arg:argList){list+=arg.toPrint(s+"  ");}
		return s+"New: "+id+"\n"
		+entry.toPrint(s+"  ")
		+list;
	}

	/*public Node typeCheck() {
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
	}*/
	
	@Override
	public Node typeCheck() {
		if (entry.getType() instanceof ClassTypeNode) {
			List<Node> fields = ((ClassTypeNode) entry.getType()).getFields();
			// Controllo numero di parametri
			if (argList.size() != fields.size()) {
				System.out.println("Wrong number of parameters in the invocation of " + id);
				System.exit(0);
			}
			// Controllo che siano sottotipi
			for (int i = 0; i < argList.size(); i++)
				if (!(FOOLlib.isSubtype((argList.get(i)).typeCheck(), ((FieldNode) fields.get(i)).getSymType()))) {
					System.out.println("Wrong type for " + (i + 1) + "-th parameter in the invocation of " + id);
					System.exit(0);
				}
		} else {
			System.out.println("Non class invocation error " + id);
			System.exit(0);
		}

		return new RefTypeNode(id);
	}

	public String codeGeneration() {
		String parCode="";
		for (int i=argList.size()-1; i>=0; i--) {
			parCode+=argList.get(i).codeGeneration();
		}
		
		String labelList = "";
		for(int i = 0; i<argList.size(); i++) {
			labelList += "lhp \n"	//carico sullo stack l'indirizzo dello heap pointer				
					+ "sw \n" 		//salvo all'indirizzo di hp quello che c'è nel top dello stack
					+ "lhp \n" 		//incremento hp
					+ "push 1 \n" 
					+ "add \n"
					+ "shp";		//salva la nuova cima dello heap (il nuovo heap pointer)
		}
		
		return parCode 
				+"lhp \n"
				+ labelList
				+ (FOOLlib.MEMSIZE + entry.getOffset()) 	//recupera il dispatch pointer
				+ "lhp \n"						
				+ "sw \n"									//carica il dispatch pointer a indirizzo hp
				+ "lhp \n"			//quello che rimane sullo stack (object pointer da ritornare)
				+ "lhp \n" 									//incremento hp
				+ "push 1 \n" 
				+ "add \n"
				+ "shp";
	}

}
