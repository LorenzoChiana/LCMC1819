package lib;

import java.util.ArrayList;
import java.util.HashMap;

import ast.ArrowTypeNode;
import ast.BoolTypeNode;
import ast.EmptyTypeNode;
import ast.IntTypeNode;
import ast.Node;
import ast.RefTypeNode;

public class FOOLlib {
	public final static int MEMSIZE = 10000; 

	//definisce la gerarchia dei tipi riferimento (costruita durante il parsing)
	private static HashMap<String, String> superType = new HashMap<>();
	private static ArrayList<ArrayList<String>> dispatchTables = new ArrayList<>();

	//valuta se il tipo "a" è <= al tipo "b"
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
			}
			return true;
			/*}else if ((a instanceof EmptyTypeNode && !(b instanceof RefTypeNode || b instanceof EmptyTypeNode))) {	
			return false;*/
		}else 
			/*Controllo che in superType esista una coppia con chiave a (sottotipo)
			 * se esiste controllo che il super tipo di a sia uguale a b, se non lo è
			 * chiamo ricorsivamente (ora il sotto tipo sarà il super tipo di a e il super tipo rimane b
			 * itero finchè non trovo una corrispondenza nella hashmap, se non la trovo vuol dire che
			 * a non è sottotipo di b
			 * */
			if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
				if(!superType.containsKey(superType.get(((RefTypeNode) a).getClassId()))){
					return false;
				}

				if(!((RefTypeNode)b).getClassId().equals(superType.get(((RefTypeNode) a).getClassId()))){
					isSubtype(new RefTypeNode(superType.get(((RefTypeNode) a).getClassId())), b);
				}
			}else if(a instanceof RefTypeNode && b instanceof EmptyTypeNode) {
				return true;
			}else {
				return a.getClass().equals(b.getClass()) ||
						((a instanceof BoolTypeNode) && (b instanceof IntTypeNode));
			}
		return false;
	}

	private static int labCount=0; //nome etichette (univoche)
	private static int funlabCount=0; 

	private static String funCode="" ; 

	public static void addDispatchTable(ArrayList<String> dt) {
		dispatchTables.add(dt);
	}

	public static void addSuperType(String sup, String sub) {
		superType.put(sub,sup);
	}
	public static ArrayList<String> getDispatchTable(int i){
		return dispatchTables.get(i);
	}

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