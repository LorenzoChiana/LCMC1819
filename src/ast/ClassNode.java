package ast;
import java.util.ArrayList;

import lib.FOOLlib;

public class ClassNode implements DecNode {

	private String id;
	private Node symType;
	private ArrayList<Node> field = new ArrayList<Node>(); 
	private ArrayList<Node> method = new ArrayList<Node>(); 

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
		field=f;
	}  


	public void addMethod (Node p) { 
		method.add(p);  
	}  

	public String toPrint(String s) {
		return null;
	}

	public Node typeCheck() {
		for (Node dec:field){dec.typeCheck();};
		
		return null;
	}

	public String codeGeneration() {
		String declCode = "";
		for (Node dec:field) {
			declCode += dec.codeGeneration();
		}

		String popDecl="";
		for (Node dec:field) {
			if(((DecNode)dec).getSymType() instanceof ArrowTypeNode) {
				popDecl += "pop\n";
				popDecl += "pop\n";
			} else {
				popDecl += "pop\n";
			}
		}

		String popParl = "";
		for (Node par: method) {
			if(((DecNode)par).getSymType() instanceof ArrowTypeNode) {
				popParl += "pop\n";
				popParl += "pop\n";
			} else {
				popParl += "pop\n";
			}
		}

		String funl = FOOLlib.freshFunLabel();

		FOOLlib.putCode(
				funl + ":\n" + 
						"cfp\n" + //setta $fp a $sp (fp = frame pointer; sp = stack pointer) 
						"lra\n" + //inserisce return address
						declCode + // inserisce le dichiarazioni locali 
						"srv\n" + //pop del return value
						popDecl + //pop delle dichiarazioni
						"sra\n" + //pop del return address
						"pop\n" + //pop di AL
						popParl + //pop dei parametri
						"sfp\n" + //setto $fp al valore del CL
						"lrv\n" + //risultato della funione sullo stack
						"lra\n" + "js\n" //salta a $ra
				);

		return "lfp\n push " + funl + "\n";
	}

	

}  