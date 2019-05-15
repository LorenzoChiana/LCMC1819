package lib;

import java.util.ArrayList;
import java.util.HashMap;

import ast.*;

public class FOOLlib {
	private static int labCount = 0;
	private static int functCount = 0;
	private static int methodLabCount = 0;
	private static HashMap<String, String> superType = new HashMap<>();
	private static String funCode = ""; // codice delle dichiarazioni di funzioni

	private static ArrayList<ArrayList<String>> dispatchTables = new ArrayList<>();

	public static final int MEMSIZE = 10000;
	
	// valuta se il tipo "a" è <= al tipo "b",
	public static boolean isSubtype(Node a, Node b) {
		// NULL è sottotipo di tutte le classi
		if (a instanceof EmptyTypeNode && b instanceof RefTypeNode) {
			return true;
		}

		else if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
			// Classe figlia
			RefTypeNode refA = (RefTypeNode) a;
			// Classe padre
			RefTypeNode refB = (RefTypeNode) b;

			if (refA.getClassId().equals(refB.getClassId())) {
				return true;
			}
			
			String entry = superType.get(refA.getClassId());
			if (entry == null) {
				return false;
			}
			if (entry.equals(refB.getClassId())) {
				return true;
			} else {
				return isSubtype(new RefTypeNode(entry), refB);
			}
		}
		/*
		 * i nodi sono tipi funzionali
		 */
		else if (a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) {
			ArrowTypeNode arrA = (ArrowTypeNode) a;
			ArrowTypeNode arrB = (ArrowTypeNode) b;
			/*
			 * lista dei parametri da entrambi i tipi funzionali
			 */
			ArrayList<Node> parA = arrA.getParList();
			ArrayList<Node> parB = arrB.getParList();

			/*
			 * controllo la covarianza sui tipi di ritorno; controllo della controvarianza
			 * sui parametri
			 */
			if ((parA.size() != parB.size()) || !(isSubtype(arrA.getRet(), arrB.getRet())))
				return false;
			else {
				int i, dimA = parA.size();
				for (i = 0; i < dimA; i++) {
					if (!isSubtype(parB.get(i), parA.get(i))) {
						return false;
					}
				}
				return true;
			}
		} else if (a.getClass().equals(b.getClass()) || ((a instanceof BoolTypeNode) && (b instanceof IntTypeNode))) {
			return true;
		}

		return false;
	}

	public static Node lowestCommonAncestor(Node a, Node b) {
		// per a e b tipi bool/int
		// torna int se almeno uno è int, bool altrimenti
		if (isSubtype(a, new IntTypeNode()) && isSubtype(b, new IntTypeNode())) {
			if (a instanceof IntTypeNode || b instanceof IntTypeNode) {
				return new IntTypeNode();
			} else {
				return new BoolTypeNode();
			}
		}

		// se uno tra "a" e "b" è EmptyTypeNode torna l'altro
		else if (a instanceof EmptyTypeNode) {
			return b;
		} else if (b instanceof EmptyTypeNode) {
			return a;
		} else if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
			// cerca super classe in comune
			RefTypeNode classA = (RefTypeNode) a;
			String s = superType.get(classA.getClassId());
			while (s != null) {				
				if (isSubtype(b, new RefTypeNode(s))) {
					return new RefTypeNode(s);
				}
				s = superType.get(s);
			}
			
		} else if (a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) {
			//lowest common ancestor per tipi funzionali
			ArrowTypeNode arrA = (ArrowTypeNode) a;
			ArrowTypeNode arrB = (ArrowTypeNode) b;
			if (arrA.getParList().size() == arrB.getParList().size()) {
				Node lca = lowestCommonAncestor(arrA.getRet(), arrB.getRet());
				if (lca != null) {
					ArrayList<Node> parList = new ArrayList<>();
					for (int i = 0; i < arrA.getParList().size(); i++) {
						Node parA = arrA.getParList().get(i);
						Node parB = arrB.getParList().get(i);
						if (isSubtype(parA, parB)) {
							parList.add(parA);
						} else if (isSubtype(parB, parA)) {
							parList.add(parB);
						} else {
							return null;
						}
					}
					return new ArrowTypeNode(parList, lca);
				}
			}
		}

		return null;

	}

	public static String freshLabel() {
		return "label" + (labCount++);
	}

	public static String freshFunLabel() {
		return "function" + (functCount++);
	}

	public static String freshMethodLabel() {
		return "method" + (methodLabCount++);
	}

	/**
	 * usato tutte le volte che incotriamo una dichiarazione di funzione
	 * 
	 * @param c
	 */
	public static void putCode(String c) {
		funCode += "\n" + c;
	}

	/**
	 * legge in maniera incrementale il codice delle funzioni dichiarate(?)
	 * 
	 * @return
	 */
	public static String getCode() {
		return funCode;
	}

	public static ArrayList<ArrayList<String>> getDispatchTables() {
		return dispatchTables;
	}

	public static void addDispatchTable(ArrayList<String> dispatchTable) {
		FOOLlib.dispatchTables.add(dispatchTable);
	}

	// aggiunta nella hashMap con coppia: chiave = classe che estende, valore = classe base
	public static void addSuperType(final String superClass, final String extendClass) {
		superType.put(extendClass, superClass);
	}
}
