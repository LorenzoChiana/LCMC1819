package lib;

import ast.*;

public class FOOLlib {
	public final static int MEMSIZE = 10000; 
	
	//valuta se il tipo "a" è <= al tipo "b", dove "a" e "b" sono tipi di base: int o bool
	public static boolean isSubtype (Node a, Node b) {
		if(a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) {
			ArrowTypeNode nodeA = (ArrowTypeNode)a;
			ArrowTypeNode nodeB = (ArrowTypeNode)b;
			if(nodeA.getParListLength() == nodeB.getParListLength() &&
					isSubtype(nodeA.getRet(), nodeB.getRet())){
				//i tipi di ritorno devono essere sottotipi rispetto ai parametri
				for(int i = 0; i< nodeA.getParListLength(); i++) {
					if(!isSubtype(nodeB.getParList().get(i), nodeA.getParList().get(i))) {
						return false;
					}
				}
			} else {
				return false;
			}
			return true;
		} else {
			return a.getClass().equals(b.getClass()) ||
					((a instanceof BoolTypeNode) && (b instanceof IntTypeNode));
		}
	}

	private static int labCount=0; //nome etichette (univoche)
	private static int funlabCount=0; 

	private static String funCode="" ; 

	public static void putCode(String c) { 
		funCode+="\n"+c; //aggiunge una linea vuota di separazione prima di funzione
	} 

	public static String getCode() { 
		return funCode;
	} 
	
	public static String freshLabel() { 
		return "label"+(labCount++);
	} 

	public static String freshFunLabel() { 
		return "function"+(funlabCount++);
	} 	
}