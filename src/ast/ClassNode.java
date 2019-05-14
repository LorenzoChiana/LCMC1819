package ast;

import java.util.ArrayList;
import java.util.List;

import lib.FOOLlib;

public class ClassNode implements DecNode {

	private Node symType;
	private String id;
	private ArrayList<FieldNode> fields = new ArrayList<>();
	private ArrayList<MethodNode> methods = new ArrayList<>();
	private STentry superEntry;

	private ArrayList<String> dispatchTable = new ArrayList<>();

	public ClassNode(String id) {
		this.id = id;
	}

	public void setSuperEntry(STentry entry) {
		this.superEntry = entry;
	}

	public STentry getSuperEntry() {
		return this.superEntry;
	}

	public void addField(FieldNode f) {
		this.fields.add(f);
	}

	public void addMethod(MethodNode m) {
		this.methods.add(m);
	}

	@Override
	public String toPrint(String s) {
		String fieldList = "";
		for (Node f : fields) {
			fieldList += f.toPrint(s + "  ");
		}
		String methodStr = "";
		for (Node m : methods) {
			methodStr += m.toPrint(s + "  ");
		}
		return s + "Class:" + id + "\n" + /* type.toPrint(s + "  ") + */ fieldList + methodStr;
	}

	public void setSymType(Node t) {
		this.symType = t;
	}
	

	@Override
	public Node typeCheck() {
		methods.forEach(Node::typeCheck);

		if (this.superEntry != null) {
			

			ClassTypeNode superType = (ClassTypeNode) this.superEntry.getType();
			ClassTypeNode actualType = (ClassTypeNode) this.getSymType();

			List<Node> superFields = superType.getFields();
			List<Node> superMethods = superType.getMethods();
			
			/*
			 * controllo sui campi
			 */
			int superFieldsSize = superFields.size();
			actualType.getFields().forEach(f -> {
				FieldNode fieldNode = (FieldNode) f;
				int idx = (-fieldNode.getOffset() - 1); //indice nell'array allFields
				if (idx < superFieldsSize) {//controllo solamente se c'è override
					FieldNode fieldParent = (FieldNode) superFields.get(idx);
					if (!FOOLlib.isSubtype(fieldNode, fieldParent)) {
						System.out.println("Incompatible value in overriding field");
						System.exit(0);
					}
				}
			});

			
			/*
			 * controllo sui metodi
			 */
			int superMethodsSize = superMethods.size();
			actualType.getMethods().forEach(m -> {
				MethodNode methodNode = (MethodNode) m;
				int idx = methodNode.getOffset(); //indice nell'array allMethods
				if (idx < superMethodsSize) {//controllo solamente se c'è override
					MethodNode methodParent = (MethodNode) superMethods.get(idx);
					if (!FOOLlib.isSubtype(methodNode, methodParent)) {
						System.out.println("Incompatible value in overriding method");
						System.exit(0);
					}
				}
			});

		}
		
		return null;
	}

	@Override
	public String codeGeneration() {
		if (this.superEntry != null)
			this.dispatchTable = new ArrayList<>(FOOLlib.getDispatchTables().get(-this.superEntry.getOffset() - 2));
		int i = 0;
		int dimMethods = methods.size();

		for (i = 0; i < dimMethods; i++) {
			MethodNode mtN = (MethodNode) methods.get(i);
			mtN.codeGeneration();

			final String labelMethod = mtN.getLabel();
			final int offsetMethod = mtN.getOffset();

			if (dispatchTable.size() > offsetMethod) { // l'offset del metodo è compreso nella dispatch table madre
				dispatchTable.set(offsetMethod, labelMethod); // rimpiazzo in caso di override dei metodi
			} else {
				dispatchTable.add(offsetMethod, labelMethod);
			}

		}

		FOOLlib.addDispatchTable(dispatchTable);

		String retCode = "lhp\n";

		for (String lbl : dispatchTable) {
			/* memorizzo la label ad indirizzo puntato da hp */
			retCode += "push " + lbl + "\n"
			+ "lhp\n"
			+ "sw\n"
			/* incremento valore di hp */
			+ "lhp\n"
			+ "push 1 \n"
			+ "add\n"
			+ "shp\n";
		}
		return retCode;
	}

	@Override
	public Node getSymType() {
		return this.symType;
	}

}
