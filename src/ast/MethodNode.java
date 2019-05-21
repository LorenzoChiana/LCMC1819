package ast;
import java.util.ArrayList;
import lib.FOOLlib;

public class MethodNode implements DecNode {
	private String id;
	private Node type; 		//tipo di ritorno del metodo
	private Node symType;
	private ArrayList<Node> parlist = new ArrayList<Node>(); // campo "parlist" che e' lista di Node
	private ArrayList<Node> declist = new ArrayList<Node>(); 
	private Node exp;
	private String label;
	private int offset;

	public MethodNode (String i, Node type) {
		this.id = i;
		this.type = type;
	}

	public void setSymType(Node type) {
		this.symType = type;
	}

	@Override
	public Node getSymType() {
		return symType;
	} 

	public int getOffset() {
		return offset;
	}

	//mettiamo l'offset della virtual table
	public void setOffset(int offset) {
		this.offset = offset;
	}

	public String getId() {
		return id;
	} 

	public void addPar(ParNode p) {
		parlist.add(p);
	}

	public void addBody(Node e) {
		exp = e;
	}

	public ArrayList<Node> getDeclist() {
		return declist;
	}

	public void setDeclist(ArrayList<Node> declist) {
		this.declist = declist;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String toPrint(String s) {
		String parlstr = "";
		for (Node par:parlist){
			parlstr += par.toPrint(s+"  ");
		}

		String declstr = "";
		for (Node dec:declist){
			declstr += dec.toPrint(s+"  ");
		}

		return s+"MethodNode:" + id +"\n"
		+symType.toPrint(s+"  ")
		+ "offset: "+offset
		+parlstr
		+declstr
		+exp.toPrint(s+"  ") ; 
	}

	public Node typeCheck() {	 
		for (Node dec:declist){
			dec.typeCheck();
		}

		if (!FOOLlib.isSubtype(exp.typeCheck(),type)) {
			System.out.println("MethodNode " + this.id + " error: Incompatible value for variable");
			System.exit(0);
		}
		return null;
	}

	public String codeGeneration() {
		label = FOOLlib.freshFunLabel();

		String declCode = "";
		for (Node dec:declist) {
			declCode += dec.codeGeneration();
		}

		String popDecl="";
		for (Node dec: declist) {
			if(((DecNode)dec).getSymType() instanceof ArrowTypeNode) {
				popDecl += "pop\n";
				popDecl += "pop\n";
			} else {
				popDecl += "pop\n";
			}
		}

		String popParl = "";
		for (Node par: parlist) {
			if(((DecNode)par).getSymType() instanceof ArrowTypeNode) {
				popParl += "pop\n";
				popParl += "pop\n";
			} else {
				popParl += "pop\n";
			}
		}

		FOOLlib.putCode(
				label + ":\n" + 	//nuova label che corrisponderà alla label del metodo nella dispatch table
						"cfp\n" + //setta $fp a $sp (fp = frame pointer; sp = stack pointer) 
						"lra\n" + //inserisce return address
						declCode + //carica sullo stack le dichiarazioni locali al metodo
						exp.codeGeneration() + 
						"srv\n" + //pop, salva la cima dello stack in rv(return value)
						popDecl + //pop delle dichiarazioni
						"sra\n" + //pop del return address
						"pop\n" + //pop di Access Link
						popParl + //pop dei parametri
						"sfp\n" + //setto $fp al valore del Control Link
						"lrv\n" + //salva risultato della funione sullo stack
						"lra\n" + "js\n" //salta a $ra
				);

		return "";
	}




}  