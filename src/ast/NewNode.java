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
		for (Node arg:arglist) {
			list+=arg.toPrint(s+"  ");
		}
		return s+"New: "+id+"\n"+list;
	}
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Node typeCheck() {
		if (!(entry.getType() instanceof ClassTypeNode)) {
			System.out.println("Invocation of a non-class "+id);
			System.exit(0);
		}
		ArrayList<Node> fieldsList = ((ClassTypeNode) entry.getType()).getFields();
		if ( !(fieldsList.size() == arglist.size()) ) {
			System.out.println("Wrong number of parameters in the invocation of "+id);
			System.exit(0);
		} 
		//controlla che i parametri della chiamata siano sottotipo della funzione che chiami
		for (int i=0; i<arglist.size(); i++) {
//			System.out.print("SUB "+id+" -----> 1: "+ (arglist.get(i)).typeCheck()+" 2: "+((FieldNode)fieldsList.get(i)).getSymType());
//			System.out.println(" --- isSub? "+FOOLlib.isSubtype((arglist.get(i)).typeCheck(), ((FieldNode)fieldsList.get(i)).getSymType()));
			if ( !(FOOLlib.isSubtype((arglist.get(i)).typeCheck(), ((FieldNode)fieldsList.get(i)).getSymType()))) {
				System.out.println("Wrong type for "+(i+1)+"-th parameter in the invocation of "+id);
				System.exit(0);
			} 
		}
		return new RefTypeNode(id);
	}
	
	@Override
	public String codeGeneration() {
		String parCode="";
		for (int i=arglist.size()-1; i>=0; i--) {
			parCode+=arglist.get(i).codeGeneration();
		}

		String labelList = "";
		for(int i = 0; i<arglist.size(); i++) {
			labelList += "lhp \n"	//carico sullo stack l'indirizzo dello heap pointer				
					+ "sw \n" 		//salvo all'indirizzo di hp quello che c'� nel top dello stack
					+ "lhp \n" 		//incremento hp
					+ "push 1 \n" 
					+ "add \n"
					+ "shp \n";		//salva la nuova cima dello heap (il nuovo heap pointer)
		}

		return parCode 
				+"lhp \n"
				+ labelList
				+ (FOOLlib.MEMSIZE + entry.getOffset()) + "\n"	//recupera il dispatch pointer
				+ "lhp \n"						
				+ "sw \n"									//carica il dispatch pointer a indirizzo hp
				+ "lhp \n"			//quello che rimane sullo stack (object pointer da ritornare)
				+ "lhp \n" 									//incremento hp
				+ "push 1 \n" 
				+ "add \n"
				+ "shp \n";
	}
	/*@Override
	public String codeGeneration() {
		String storeCode="";
		for(int i = arglist.size()-1;i>=0;i--) {
			 storeCode+= 
					 arglist.get(i).codeGeneration() 
					 + "lhp\n"
					 + "sw\n"
				     + "lhp\n"
					 + "push 1 \n"
					 + "add\n"
					 +"shp\n";
		}
		return  storeCode 
				+ "push " + (FOOLlib.MEMSIZE + entry.getOffset()) + "\n"
				+ "lw\n" // carico su stack il dispatch pointer
				+ "lhp\n"
				+ "sw\n" // scrivo il dispatch pointer sullo heap
				
				+ "lhp \n"
				 + "lhp\n"
				 + "push 1 \n"
				 + "add\n"
				 + "shp\n";
				
	}*/

}

