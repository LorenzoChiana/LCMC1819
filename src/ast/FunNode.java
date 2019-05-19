package ast;
import java.util.ArrayList;
import java.util.List;
import lib.FOOLlib;

public class FunNode implements DecNode {
	private String id;
	private Node type; 		//tipo di ritorno della funzione
	private Node symType;
	private List<Node> parlist = new ArrayList<Node>(); // campo "parlist" che è lista di Node
	private List<Node> declist = new ArrayList<Node>(); 
	private Node exp;

	public FunNode(String i, Node t) {
		this.id = i;
		this.type = t;
	}

	public void addDec(ArrayList<Node> d) {
		declist = d;
	}  

	public void addBody(Node b) {
		exp = b;
	}  

	public void addPar(ParNode p) { //metodo "addPar" che aggiunge un nodo a campo "parlist"
		parlist.add(p);  
	}  

	public String toPrint(String s) {

		String parlstr = "";
		for (Node par: parlist){
			parlstr += par.toPrint(s + "  ");
		}

		String declstr = "";
		for (Node dec:declist){
			declstr += dec.toPrint(s + "  ");
		}

		return s + "Fun:" + id + "\n"
		+ type.toPrint(s+"  ")
		+ parlstr
		+ declstr
		+ exp.toPrint(s + "  "); 
	}

	public Node typeCheck() {
		for (Node dec: declist){
			dec.typeCheck();
		}
		if (!FOOLlib.isSubtype(exp.typeCheck(), type)) {
			System.out.println("FunNode " + this.id + " error: Incompatible value for variable");
			System.exit(0);
		}
		return null;
	}

	public String codeGeneration() {
		String declCode = "";
		for (Node dec: declist) {
			declCode += dec.codeGeneration();
		}

		String popDecl = "";
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

		String funl = FOOLlib.freshFunLabel();

		FOOLlib.putCode(
				funl + ":\n" + 
						"cfp\n" + //setta $fp a $sp (fp = frame pointer; sp = stack pointer) 
						"lra\n" + //inserisce return address
						declCode + // inserisce le dichiarazioni locali
						exp.codeGeneration() + 
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

	@Override
	public Node getSymType() {
		return this.symType;
	}

	public void setSymType(Node symType) {
		this.symType = symType;
	}
}  