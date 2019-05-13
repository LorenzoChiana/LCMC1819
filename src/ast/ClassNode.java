package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ClassNode implements DecNode {

	private String id;
	private Node symType;
	private ArrayList<Node> fields = new ArrayList<Node>(); 
	private ArrayList<Node> methods = new ArrayList<Node>(); 
	private STentry superEntry;

	public ClassNode (String i) {
		id=i;
	}

	@Override
	public Node getSymType() {
		return this.symType;
	}

	public void setSymType(Node symType) {
		this.symType = symType;
	}

	public void addField (ArrayList<Node> f) {
		fields=f;
	}  

	public void addMethod (MethodNode p) { 
		methods.add(p); 
	} 
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String toPrint(String s) {
		return null;
	}

	public Node typeCheck() {
		for (Node dec:fields){
			dec.typeCheck();
		}
		ArrayList<Node> superTypeFields =((ClassTypeNode)superEntry.getType()).getFields();
		for(int i = 0; i<superTypeFields.size(); i++) {
			if (!FOOLlib.isSubtype (fields.get(i), superTypeFields.get(i))) {
				System.out.println("Incompatible value for field");
				System.exit(0);
			}
		}
		
		ArrayList<Node> superTypeMethods =((ClassTypeNode)superEntry.getType()).getMethods();
		for(int i = 0; i<superTypeMethods.size(); i++) {
			if (!FOOLlib.isSubtype (methods.get(i), superTypeMethods.get(i))) {
				System.out.println("Incompatible value for methods");
				System.exit(0);
			}
		}
		return null;
	}
	
	public STentry getSuperEntry() {
		return superEntry;
	}

	public void setSuperEntry(STentry superEntry) {
		this.superEntry = superEntry;
	}
	
	public String codeGeneration() {
		ArrayList<String> dt;
		if (superEntry!=null) {
			dt = new ArrayList<String>(FOOLlib.getDispatchTable(-(superEntry.getOffset())-2)); //dispatchTable della classe da cui eredito(posizionen -offset-2)
		}else {
			dt = new ArrayList<String>();
		}
		
		FOOLlib.addDispatchTable(dt);		//per ereditariet� copiare dispatch table della classe da cui si eredita (contenuto)

		for(Node m: methods) {
			m.codeGeneration();
			dt.add(((MethodNode) m).getOffset(), ((MethodNode) m).getLabel());
		}

		String labelList = "";
		for(String s: dt) {
			labelList += "push " + s + "\n" 	//carico le label sullo heap
					+ "lhp \n"					
					+ "sw \n" 
					+ "lhp \n" 					//incremento hp
					+ "push 1 \n" 
					+ "add \n"
					+ "shp";					//salva la nuova cima dello heap
		}

		return "lhp \n" +
		labelList;
	}



}  