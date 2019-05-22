package lib;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import ast.ArrowTypeNode;
import ast.BoolTypeNode;
import ast.EmptyTypeNode;
import ast.IntTypeNode;
import ast.Node;
import ast.RefTypeNode;

public class FOOLlib {
	public final static int MEMSIZE = 10000; 

	//definisce la gerarchia dei tipi riferimento (costruita durante il parsing)
	private static Map<String, String> superType = new HashMap<>();
	private static ArrayList<ArrayList<String>> dispatchTables = new ArrayList<>();

	//valuta se il tipo "a" e' <= al tipo "b"
	public static boolean isSubtype (Node a, Node b) {
		//se entrambi sono ArrowTypeNode controllo i parametri e il tipo di ritorno
		if(a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) {
			ArrowTypeNode nodeA = (ArrowTypeNode)a;
			ArrowTypeNode nodeB = (ArrowTypeNode)b;
			//covarianza per i tipi di ritorno: A deve essere sottotipo di B
			if(nodeA.getParListLength() != nodeB.getParListLength() 
					|| !(isSubtype(nodeA.getRet(), nodeB.getRet()))) {
				return false;
			} else {
				//controvarianza per i parametri: i parametri di B devono essere sottotipo dei parametri di A
				int dimA = nodeA.getParListLength();
				for(int i = 0; i < dimA; i++) {
					if(!isSubtype(nodeB.getParList().get(i), nodeA.getParList().get(i))) {
						return false;
					}
				}
				return true;
			}
		} else 
			/*Controllo che in superType esista una coppia con chiave A (sottotipo)
			 * se esiste controllo che il super tipo di A sia uguale a A, se non lo e'
			 * chiamo ricorsivamente (ora il sotto tipo sara' il super tipo di A e il super tipo rimane B)
			 * itero finche' non trovo una corrispondenza nella hashmap, se non la trovo vuol dire che
			 * A non e' sottotipo di B
			 * */
			if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
				RefTypeNode refB = (RefTypeNode) b; // classe padre -> supertipo
				RefTypeNode refA = (RefTypeNode) a; // classe figlio -> sottotipo
				String superTypeA = superType.get(refA.getClassId());
				
				//se A e B sono la stessa classe torna true
				if(refB.getClassId().equals(refA.getClassId())) {
					return true;
				}
				
				/* Se A non ha un supertipo il typecheck non va a buon fine 
				 * poiche' A non e' sottoclasse di B */
				if(superTypeA == null){
					return false;
				}

				/* Chiamo ricorsivamente finchè non trovo una corrispondenza nella HashMap. 
				 * Se trovo la corrispondenza il typecheck è corretto e A e' sottotipo di B */
				if(!(refB.getClassId().equals(superTypeA))){
					return isSubtype(new RefTypeNode(superTypeA), refB);
				} else {
					return true;
				}
			
			//EmptyTypeNode e' sottotipo di tutti i tipi
			} else if(a instanceof EmptyTypeNode) { 
				return true;
			} else if(a.getClass().equals(b.getClass()) 
					|| ((a instanceof BoolTypeNode) && (b instanceof IntTypeNode))){
				return true;
			}
		return false;
	}

	//il più basso antenato comune di due nodi
	public static Node lowestCommonAncestor (Node a, Node b) {
		//per A e B tipi bool/int
		if (a instanceof BoolTypeNode && b instanceof BoolTypeNode) {
			return a;
		} else if (a instanceof IntTypeNode && b instanceof IntTypeNode) {
			return a;
		} else if (a instanceof IntTypeNode && b instanceof BoolTypeNode) {
			return a;
		} else if (a instanceof BoolTypeNode && b instanceof IntTypeNode) {
			return b;
		} 

		//per a e b tipi riferimento (o EmptyTypeNode)
		// se uno tra A e B e' EmptyTypeNode torna l'altro;
		if (a instanceof EmptyTypeNode && b instanceof RefTypeNode) {
			return b;
		} else if (b instanceof EmptyTypeNode && a instanceof RefTypeNode) {
			return a;
		}else if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
			/* all'inizio considera la classe di A e risale, poi, le sue superclassi controllando, ogni volta, se B 
			 * sia sottotipo della classe considerata:
			 * torna un RefTypeNode a tale classe qualora il controllo abbia, prima o poi, successo, null altrimenti*/

			RefTypeNode refB = (RefTypeNode) b; 
			RefTypeNode refA = (RefTypeNode) a; 

			String type = refA.getClassId();
			RefTypeNode c = new RefTypeNode(type);
			if(isSubtype(refB, c)) {//controllo che b sia sottotipo della classe considerata
				return c;
			} 

			while (superType.containsKey(type)) { //risalgo la catena di superclassi
				c = new RefTypeNode(superType.get(type));
				if(isSubtype(refB, c)) {//controllo che b sia sottotipo della classe considerata
					return c;
				} else{
					type = superType.get(type);
				}
			}
			return null;
		}

		/* Per A e B tipi funzionali con stesso numero di parametri
		 * Controlla se esiste lowest common ancestor dei tipi di ritorno di A e B (si chiama ricorsivamente) e se, 
		 * per ogni i, i tipi parametro i-esimi sono uno sottotipo dell'altro (metodo "isSubtype"):
		 * - torna null se il controllo non ha successo; altrimenti
		 * - torna un tipo funzionale che ha come tipo di ritorno il risultato della chiamata ricorsiva (covarianza) 
		 * 	 e come tipo di parametro i-esimo il tipo che e' sottotipo dell'altro (controvarianza)*/
		if (a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) { //Se sono tipi funzionali
			ArrowTypeNode nodeB = (ArrowTypeNode) b; 
			ArrowTypeNode nodeA = (ArrowTypeNode) a; 
			if (nodeA.getParListLength() == nodeB.getParListLength()) { //e hanno lo stesso numero di parametri
				ArrayList<Node> parA = nodeA.getParList();
				ArrayList<Node> parB = nodeB.getParList();
				ArrayList<Node> parlist = new ArrayList<>();

				for (int i = 0; i < parA.size(); i++) { //itero i parametri
					if ((isSubtype(parA.get(i), parB.get(i)))) { //Se non sono uno sottotipo dell'altro restituisco null
						parlist.add(parA.get(i));
					} else if (isSubtype(parB.get(i), parA.get(i))){
						parlist.add(parB.get(i));
					} else {
						return null;
					}
				}
				Node ret = lowestCommonAncestor (nodeA.getRet(),nodeB.getRet());
				if (ret != null) { //controlla lowest common ancestor dei tipi di ritorno
					return new ArrowTypeNode(parlist, ret); 
				}
			}

		}
		return null;
	}

	private static int labCount = 0; //nome etichette (univoche)
	private static int funlabCount = 0; 
	private static String funCode = ""; 

	public static void addDispatchTable(ArrayList<String> dt) {
		dispatchTables.add(dt);
	}

	public static void addSuperType(String sup, String sub) {
		superType.put(sub, sup);
	}
	public static ArrayList<String> getDispatchTable(int i){
		return dispatchTables.get(i);
	}

	public static void putCode(String c) { 
		funCode += "\n" + c; //aggiunge una linea vuota di separazione prima di funzione
	} 

	public static String getCode() { 
		return funCode;
	} 

	public static String freshLabel() { 
		return "label" + (labCount++);
	} 

	public static String freshFunLabel() { 
		return "function" + (funlabCount++);
	} 	
}