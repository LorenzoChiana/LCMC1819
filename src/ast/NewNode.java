package ast;

import java.util.ArrayList;
import java.util.List;

import lib.FOOLlib;

public class NewNode implements Node {

	private STentry entry;
	private String id;
	private ArrayList<Node> argList = new ArrayList<>();

	public NewNode(String id, STentry entry, ArrayList<Node> args) {
		this.entry = entry;
		this.id = id;
		this.argList = args;
	}

	@Override
	public String toPrint(String s) {
		 String parlstr = ""; 
		for(Node p: argList) {
			parlstr+=p.toPrint(s + "  ");
		}
		return s + "NewNode: " + this.id + "\n" + parlstr;
	}

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
	
	@Override
	public String codeGeneration() {
		//String parCode="";
		String storeCode="";
		for(int i = argList.size()-1;i>=0;i--) {
			 storeCode+= 
					 //scrivo i campi sullo heap
					 argList.get(i).codeGeneration() 
					 + "lhp\n"
					 + "sw\n"
				     /*incremento valore di hp: da fare dopo aver caricato tutti i parametri*/
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
				
				/* scrivo object pointer sullo stack */
				+ "lhp \n"
				/*incremento valore di hp*/
				 + "lhp\n"
				 + "push 1 \n"
				 + "add\n"
				 + "shp\n";
				
	}

}
