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

	//valuta se il tipo "a" e' <= al tipo "b"
	public static boolean isSubtype (Node a, Node b) {
		if(a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) {
			ArrowTypeNode nodeA = (ArrowTypeNode)a;
			ArrowTypeNode nodeB = (ArrowTypeNode)b;
			if(nodeA.getParListLength() != nodeB.getParListLength() ||
					!(isSubtype(nodeA.getRet(), nodeB.getRet()))) {
				return false;
			} else {
				//i tipi di ritorno devono essere sottotipi rispetto ai parametri
				int dimA = nodeA.getParListLength();
				for(int i = 0; i< dimA; i++) {
					if(!isSubtype(nodeB.getParList().get(i), nodeA.getParList().get(i))) {
						return false;
					}
				}
				return true;
			}
			//return true;
			/*}else if ((a instanceof EmptyTypeNode && !(b instanceof RefTypeNode || b instanceof EmptyTypeNode))) {	
			return false;*/
		}else 
			/*Controllo che in superType esista una coppia con chiave a (sottotipo)
			 * se esiste controllo che il super tipo di a sia uguale a b, se non lo e'
			 * chiamo ricorsivamente (ora il sotto tipo sara'� il super tipo di a e il super tipo rimane b
			 * itero finche' non trovo una corrispondenza nella hashmap, se non la trovo vuol dire che
			 * a non e' sottotipo di b
			 * */
			if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
				RefTypeNode refB = (RefTypeNode) b; // classe padre -> supertipo
				RefTypeNode refA = (RefTypeNode) a; // classe figlio -> sottotipo
				String superTypeA = superType.get(refA.getClassId());

				if(refB.getClassId().equals(refA.getClassId())) {
					return true;
				}

				if(superTypeA == null){
					return false;
				}

				if(!(refB.getClassId().equals(superTypeA))){
					return isSubtype(new RefTypeNode(superTypeA), refB);
				} else {
					return true;
				}
			} else if(a instanceof EmptyTypeNode) { //EmptyTypeNode è sottotipo di tutti i tipi
				return true;
			} else if
			(a.getClass().equals(b.getClass()) ||
					((a instanceof BoolTypeNode) && (b instanceof IntTypeNode))){
				return true;
			}
		return false;
	}

	public Node lowestCommonAncestor (Node a, Node b) {
		//per a e b tipi bool/int
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
		// se uno tra "a" e "b" è EmptyTypeNode torna l'altro;
		if (a instanceof EmptyTypeNode && b instanceof RefTypeNode) {
			return b;
		}else if (b instanceof EmptyTypeNode && a instanceof RefTypeNode) {
			return a;
		}else if (a instanceof RefTypeNode && b instanceof RefTypeNode) {
			/* all'inizio considera la classe di "a" e risale, poi, le sue superclassi controllando, ogni volta, se "b" 
			 * sia sottotipo della classe considerata:
			 * torna un RefTypeNode a tale classe qualora il controllo abbia, prima o poi, successo, null altrimenti*/

			RefTypeNode refB = (RefTypeNode) b; 
			RefTypeNode refA = (RefTypeNode) a; 

			String type = refA.getClassId();
			if(isSubtype(refB,new RefTypeNode(type))) {//controllo che b sia sottotipo della classe considerata
				return refB;
			} 

			while (superType.containsKey(type)) { //risalgo la catena di superclassi
				RefTypeNode c = new RefTypeNode(superType.get(type));
				if(isSubtype(refB,c)) {//controllo che b sia sottotipo della classe considerata
					return c;
				} else{
					type= superType.get(type);
				}
			}
			return null;
		}

		//per a e b tipi funzionali con stesso numero di parametri
		/*controlla se esiste lowest common ancestor dei tipi di ritorno di a e b (si chiama ricorsivamente) e se, 
		 * per ogni i, i tipi parametro i-esimi sono uno sottotipo dell'altro (metodo "isSubtype"):
		 * • torna null se il controllo non ha successo; altrimenti
		 * • torna un tipo funzionale che ha come tipo di ritorno il risultato della chiamata ricorsiva (covarianza) 
		 * 	 e come tipo di parametro i-esimo il tipo che è sottotipo dell'altro (controvarianza)*/
		if (a instanceof ArrowTypeNode && b instanceof ArrowTypeNode) { //Se sono tipi funzionali
			ArrowTypeNode nodeB = (ArrowTypeNode) b; 
			ArrowTypeNode nodeA = (ArrowTypeNode) a; 
			if (nodeA.getParListLength() == nodeB.getParListLength()) { //e hanno lo stesso numero di parametri
				ArrayList<Node> parA = nodeA.getParList();
				ArrayList<Node> parB = nodeB.getParList();
				ArrayList<Node> parlist = new ArrayList<>();
				
				for (int i=0; i<parA.size(); i++) { //itero i parametri
					if ((isSubtype(parA.get(i),parB.get(i)))) { //Se non sono uno sottotipo dell'altro restituisco null
						parlist.add(parA.get(i));
					}else if(isSubtype(parB.get(i),parA.get(i))){
						parlist.add(parB.get(i));
					}else {
						return null;
					}
				}
				Node ret =lowestCommonAncestor (nodeA.getRet(),nodeB.getRet());
				if (ret!=null) { //controlla lowest common ancestor dei tipi di ritorno
					return new ArrowTypeNode(parlist, ret); 
				}
			}

		}
		return null;
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