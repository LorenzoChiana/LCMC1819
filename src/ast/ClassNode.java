package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ClassNode implements DecNode {

	private String id;
	private Node symType;
	private ArrayList<Node> fields = new ArrayList<Node>(); 
	private ArrayList<Node> methods = new ArrayList<Node>(); 
	private ArrayList<String> dispatchTable; 

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

	public String toPrint(String s) {
		return null;
	}

	public Node typeCheck() {
		for (Node dec:fields){
			dec.typeCheck();
		}

		return null;
	}

	public String codeGeneration() {
		ArrayList<String> dt = new ArrayList<String>();
		FOOLlib.addDispatchTable(dt);		//per ereditarietà copiare dispatch table della classe da cui si eredita (contenuto)

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