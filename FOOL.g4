grammar FOOL;
 
@header{
import java.util.*;
import lib.FOOLlib;
import ast.*;
}

@parser::members{
	private int classOffset = -2;
	private int nestingLevel = 0;
	private ArrayList<HashMap<String,STentry>> symTable = new ArrayList<>();
	//livello ambiente con dichiarazioni piu' esterno � 0 (prima posizione ArrayList) invece che 1 (slides)
	//il "fronte" della lista di tabelle � symTable.get(nestingLevel)
	
	private HashMap<String, HashMap<String,STentry>> classTable = new HashMap<>();
	// vuole il nome della classe e la virtual table
	
	
}

@lexer::members {
int lexicalErrors=0;
}
  
/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

prog  returns [Node ast]
	:{
		HashMap<String,STentry> hm = new HashMap<String,STentry> ();
        symTable.add(hm);
        boolean isOO=false;
	}
	( LET (c=cllist (d=declist)? 
		{isOO=true;}
        | d=declist
    ) IN e=exp
    {
    	if (isOO){
    		$ast = new ProgLetInNode($c.classList,$d.astlist,$e.ast);
    	}else{
    		$ast = new ProgLetInNode($d.astlist,$e.ast);
    	}
    }
        |e=exp
        {
        	$ast = new ProgNode($e.ast);
        	symTable.remove(nestingLevel);
        }
        
        ) SEMIC
      ;


cllist returns [ArrayList<Node> classList]: {
			$classList = new ArrayList<Node>();
			boolean isExtends = false;
		}( CLASS classID=ID {
			HashSet <String> methodsUsedYet = new HashSet<>(); //rende possibile rilevare la ridefinizione di metodi con lo stesso nome
			HashSet <String> fieldsUsedYet = new HashSet<>(); //rende possibile rilevare la ridefinizione di campi con lo stesso nome
			
			int offsetVT = -1; //perche' i campi sono la prima cosa che vediamo, offset modificato in caso di estensione della classe
			
			HashMap<String,STentry> hm =symTable.get(nestingLevel); 
			HashMap<String,STentry> vt = new HashMap<String, STentry>();  //virtualTable tiene sia le cose ha la nostra classe sia quello che eredita
			STentry entry = new STentry(nestingLevel, classOffset); //STentry della classe aggiunta alla symbol table
			
         	if (hm.put($classID.text, entry)!= null) { //inserisco l'STentry della classe nella symbol table
         		System.out.println("Class id "+$classID.text+" at line "+$classID.line+" already declared");
  				System.exit(0);
          	} else {
          		classOffset--; //classOffset cresce verso il basso
          	}
          	
            ClassTypeNode classType = new ClassTypeNode(); 
           	ClassNode classNode = new ClassNode($classID.text); 
		}
		(EXTENDS id2 = ID {
			isExtends=true;
			hm = symTable.get(0); //nesting level 0 poiche' le classi sono dichiarate in ambiente globale
			
			//cerco la classe nella symbol table, se esiste mi faccio copia dei campi e metodi ereditati dalla classe padre
			if(hm.containsKey($id2.text)){
				classType.addAllFields(((ClassTypeNode) hm.get($id2.text).getType()).getFields());
				classType.addAllMethods(((ClassTypeNode) hm.get($id2.text).getType()).getMethods());
			} else {
				System.out.println("Class id "+$id2.text+" at line "+$id2.line+" doesn\'t exist");
  				System.exit(0);
			}
			//setto la classe padre nel classNode
			classNode.setSuperEntry(symTable.get(0).get($id2.text));
			//Metto nella virtual table una copia della vt della classe padre
			vt.putAll(new HashMap<String, STentry>(classTable.get($id2.text)));
			//offset dei campi parte da l'offset della classe padre e cresce verso il basso
			offsetVT = -classType.getFields().size()-1;
			//aggiungo la corrispondenza padre figlio nella mappa che mi servirà per il subtype
			FOOLlib.addSuperType($id2.text, $classID.text);
			
		})? 
		{
			//aggiungo la classe alla classList globale 
			$classList.add(classNode);
			
			//aggiungo entry classe-virtual table alla mappa 
          	if (classTable.put($classID.text, vt) != null) {
          		System.out.println("Class id "+$classID.text+" at line "+$classID.line+" already declared");
  				System.exit(0);
          	}
       		//aggiungo la virtual table alla symbol table e cambio nesting level per entrare nella classe
       		symTable.add(vt);
           	nestingLevel++;
		}
		LPAR (i =ID COLON t = type {
		   	//dichiarazione dei CAMPI 
		   	//Uso un array locale per memorizzare tutti i campi e alla fine li aggiungo al classNode
           	ArrayList<Node> fieldList = new ArrayList<Node>();
           
           	//OTTIMIZZAZIONE: controllo che non ci sia già un campo in questa classe già dichiarato con lo stesso nome
           	if (fieldsUsedYet.contains($i.text)){
           		System.out.println("Field id "+$i.text+" at line "+$i.line+" already declared in this class");
  				System.exit(0);
           	} else {
           		fieldsUsedYet.add($i.text);
          	} 
          	
          	//Se l'id e' gia' presente nella vt e se questo non e' un metodo faccio l'override
           	if (isExtends && classTable.get($id2.text).containsKey($i.text)){   
         		//OVERRIDING
         		if(!classTable.get($id2.text).get($i.text).getIsMethod()){
         			//creo un nodo campo
         			FieldNode field = new FieldNode($i.text, $t.ast, classTable.get($id2.text).get($i.text).getOffset());
         			//aggiungo il campo alla virtual table con offset del campo di cui faccio override
         			vt.put($i.text, new STentry(nestingLevel, $t.ast, classTable.get($id2.text).get($i.text).getOffset()));
         			//faccio override nel classType (che aveva già memorizzato il campo del padre)
         			classType.overrideField((-classTable.get($id2.text).get($i.text).getOffset())-1, field);
         			fieldList.add(field);
         		} else {
         			System.out.println("Override is not permitted");
  					System.exit(0);
         		}
			}else{
				//NO OVERRIDING
				FieldNode field = new FieldNode($i.text, $t.ast, offsetVT);
				fieldList.add(field);
				//aggiungo il campo alla virtual table continuando dall'offset a cui ero arrivato e decremento l'offset
				vt.put($i.text, new STentry(nestingLevel, $t.ast, offsetVT));
				//aggiungo il campo nel classType
			    classType.addField(-offsetVT-1, field);
			    offsetVT--;
			}
		}(COMMA i=ID COLON t=type {
			//Rifaccio la stessa cosa per i campi diversi dal primo
			
			if (fieldsUsedYet.contains($i.text)){
           		System.out.println("Field id "+$i.text+" at line "+$i.line+" already declared in this class");
  				System.exit(0);
           	}else{
           		fieldsUsedYet.add($i.text);
           	}
           	
           	if (isExtends && classTable.get($id2.text).containsKey($i.text)){   
         		//OVERRIDING
         		if(!classTable.get($id2.text).get($i.text).getIsMethod()){
         			FieldNode field = new FieldNode($i.text, $t.ast, classTable.get($id2.text).get($i.text).getOffset());
				    fieldList.add(field);
         			vt.put($i.text, new STentry(nestingLevel, $t.ast, classTable.get($id2.text).get($i.text).getOffset()));
         			classType.overrideField((-classTable.get($id2.text).get($i.text).getOffset())-1, field);
         		}else{
         			System.out.println("Override is not permitted");
  					System.exit(0);
         		}
			}else{
				//NO OVERRIDING
				FieldNode field = new FieldNode($i.text, $t.ast, offsetVT);
				fieldList.add(field);
				vt.put($i.text, new STentry(nestingLevel, $t.ast, offsetVT));
			    classType.addField(-offsetVT-1, field);
			    offsetVT--;
			}
		})* {
			//Finite le dichiarazione dei campi li aggiungo al classNode
			classNode.addField(fieldList);
		})? RPAR    
  		CLPAR{
  		//dichiarazione dei METODI
  	
  			//se la classe estende parto dall'offset in cui sono arrivato nella classe padre, offset dei metodi cresce verso l'alto
  			if (isExtends){
    			offsetVT = (classType.getMethods().size());
    		}else{
     			offsetVT = 0;
    		}
  		}(FUN i=ID COLON t=type {
  			MethodNode method = new MethodNode($i.text, $t.ast);
     	
    		//OTTIMIZZAZIONE: controllo che non ci sia già un metodo in questa classe già dichiarato con lo stesso nome
   			if (methodsUsedYet.contains($i.text)){
      			System.out.println("Method id "+$i.text+" at line "+$i.line+" already declared in this class");
 				System.exit(0);
   			}else{
       			methodsUsedYet.add($i.text);
    		}
        
    		//true perchè si tratta di un metodo
   			STentry mEntry = new STentry(nestingLevel, true);
        
    		//Se l'id e' gia' presente nella vt e se questo e' un metodo faccio l'override
    		if (isExtends && classTable.get($id2.text).containsKey($i.text)){ 
    			//OVERRIDING
    			if(classTable.get($id2.text).get($i.text).getIsMethod()){
    				//setto offset a offset del padre
        			method.setOffset(classTable.get($id2.text).get($i.text).getOffset());
        			//faccio override nel classType
					classType.overrideMethod(classTable.get($id2.text).get($i.text).getOffset(), method);
     				classNode.addMethod(method);
     				//setto l'offset nell'entry
     				mEntry.setOffset(classTable.get($id2.text).get($i.text).getOffset());
     				//aggiungo il metodo nella vt
       				vt.put($i.text, mEntry);
        		}else{
        			System.out.println("Override is not permitted");
  					System.exit(0);
       			}
			}else{
			//NO OVERRIDING
				//setto offset
				method.setOffset(offsetVT);
				//aggiungo il metodo al classType e al classNode
				classType.addMethod(offsetVT, method);
     			classNode.addMethod(method);
     			mEntry.setOffset(offsetVT);
				//Non è necessario il controllo poichè ho già controllato all'inizio che non esiste un metodo con lo stesso id
				vt.put($i.text, mEntry);
				//offset dei metodi nella virtual table cresce verso l'alto
				offsetVT++;
			}
			//incremento il nesting level poichè entro nella dichiarazione dei parametri dei metodi
        	nestingLevel++;
        	symTable.add(new HashMap<String,STentry>());
     	}
     	LPAR {
     		//dichiarazione PARAMETRI METODO
     		ArrayList<Node> parType = new ArrayList<Node>(); 
     		int paroffset = 0;
     	}(i=ID COLON ht=hotype { 
     		ParNode p = new ParNode($i.text, $ht.ast);
     		parType.add($ht.ast);
     		method.addPar(p);
     		
     		if(p.getSymType() instanceof ArrowTypeNode){
      			paroffset += 2;
      	  	} else{
      			paroffset++;
      	  	}
      	  	//aggiungo parametro alla virtual table se l'id è già presente lancio un errore
     		if (vt.put($i.text,new STentry(nestingLevel,$ht.ast,paroffset)) != null  ){ 
         		System.out.println("Parameter id "+$i.text+" at line "+$i.line+" already declared");
          	 	System.exit(0);
        	} 
     	}
     	(COMMA i=ID COLON ht=hotype{
     		//stessa cosa ma da secondo parametro  in poi
     		ParNode par = new ParNode($i.text, $ht.ast);
     		method.addPar(par);
     		parType.add($ht.ast);
     		if(p.getSymType() instanceof ArrowTypeNode){
      			paroffset += 2;
      	  	} else{
      			paroffset++;
      	  	}
     		if (vt.put($i.text,new STentry(nestingLevel,$ht.ast,paroffset)) != null){
          		System.out.println("Parameter id "+$i.text+" at line "+$i.line+" already declared");
           		System.exit(0);
        	}
     	}		
     	)* )? RPAR {
     		ArrowTypeNode atn = new ArrowTypeNode(parType, $t.ast);
     		method.setSymType(atn);
     		mEntry.addType(atn);
     	}
        (LET {
        	//dichiarazioni variabili della classe
        	ArrayList<Node> declist = new ArrayList<Node>();
        	int varoffset = -2; 
        }(VAR i=ID COLON t=type ASS e=exp SEMIC {
            Node v = new VarNode($i.text, $t.ast, $e.ast);
            HashMap<String,STentry> hmVar = symTable.get(nestingLevel);
 			if (hmVar.put($i.text, new STentry(nestingLevel, $t.ast,varoffset)) != null  ) {
 				System.out.println("Var id "+$i.text+" at line "+$i.line+" already declared");
  				System.exit(0);
  			} else {
  				if(((VarNode)v).getSymType() instanceof ArrowTypeNode){
  					varoffset -= 2;
  				} else{
  					varoffset--;
			}
		}
		method.setDeclist(declist);
        declist.add(v);
         })+ IN {
         	method.setDeclist(declist);
         })? ex = exp {  
            method.addBody($ex.ast);
            //esco dallo scope interno delle dichiarazioni
            symTable.remove(nestingLevel--);
         }
       	SEMIC )* {
     		classNode.setSymType(classType);
        	entry.addType(classType);
  			//rimuovere la hashmap corrente poiche' esco dallo scope               
        	symTable.remove(nestingLevel--);
  		}               
  		CRPAR)+; 

declist returns [ArrayList<Node> astlist]: {
		$astlist= new ArrayList<Node>();
		int offset = -2;
		/*a nesting level 0 offset di funzioni/variabili si calcolano decrementando a partire dall’offset raggiunto dalle classi
		 * poiche' dichiarazioni di funzioni/variabili appaiono in seguito nell’ambiente globale*/
		if(nestingLevel==0){
			offset = classOffset;
		}
		}(( VAR i=ID COLON ht=hotype ASS e=exp {
			//dichiarazioni di variabili globali
        	VarNode v = new VarNode($i.text,$ht.ast,$e.ast);  
            $astlist.add(v);                                 
            HashMap<String,STentry> hm = symTable.get(nestingLevel);
            
            if (hm.put($i.text, new STentry(nestingLevel, $ht.ast,offset)) != null  ) {
             	System.out.println("Var id "+$i.text+" at line "+$i.line+" already declared");
              	System.exit(0);
			} else {
            	if(v.getSymType() instanceof ArrowTypeNode){
              		offset -= 2;
              	} else{
              		offset--;
              	}
            }
            
        }| FUN i=ID COLON t=type {//inserimento di ID nella symtable
        	//dichiarazione di funzioni
	    	FunNode f = new FunNode($i.text,$t.ast);      
	        $astlist.add(f);                              
	        HashMap<String,STentry> hm = symTable.get(nestingLevel);
	        STentry entry=new STentry(nestingLevel, offset);
	       	offset-=2;
	       	
	        if ( hm.put($i.text,entry) != null  ) {
	        	System.out.println("Fun id "+$i.text+" at line "+$i.line+" already declared");
	            System.exit(0);
	        }
	        //creare una nuova hashmap per la symTable
	      	nestingLevel++;
	      	HashMap<String,STentry> hmn = new HashMap<String,STentry> ();
	        symTable.add(hmn);
	    }LPAR {
	    	//dichiarazione parametri funzione
            ArrayList<Node> parTypes = new ArrayList<Node>();
            //offset parametri cresce verso l'alto
            int paroffset=0; 
        } (fid=ID COLON fht=hotype {
           	parTypes.add($fht.ast);
            ParNode fpar = new ParNode($fid.text,$fht.ast); //creo nodo ParNode
            f.addPar(fpar);      
                                       
            if(fpar.getSymType() instanceof ArrowTypeNode){
            	paroffset += 2;
            } else {
            	paroffset++;
            }
            
            if (hmn.put($fid.text,new STentry(nestingLevel,$fht.ast,paroffset)) != null){ //aggiungo dich a hmn
            	System.out.println("Parameter id "+$fid.text+" at line "+$fid.line+" already declared");
              	System.exit(0);
            }
        } (COMMA id=ID COLON hty=hotype{
        	//dichiarazione secondo parametro in poi
            parTypes.add($hty.ast);
           	ParNode par = new ParNode($id.text,$hty.ast);
            f.addPar(par);
                    
            if(par.getSymType() instanceof ArrowTypeNode){
            	paroffset += 2;
	        } else{
	           	paroffset++;
	        }
	        
            if (hmn.put($id.text,new STentry(nestingLevel,$hty.ast,paroffset)) != null){
            	System.out.println("Parameter id "+$id.text+" at line "+$id.line+" already declared");
               	System.exit(0);
            }
       	})* )? RPAR {
            ArrowTypeNode atn = new ArrowTypeNode(parTypes, $t.ast);
            f.setSymType(atn);
            entry.addType(atn);
        }(LET d=declist IN{
        	f.addDec($d.astlist);
        })? e=exp {
        	f.addBody($e.ast);
	        //rimuovere la hashmap corrente poich� esco dallo scope               
	        symTable.remove(nestingLevel--);    
	    }) SEMIC)+;

exp	returns [Node ast]: 
	f=term {
		$ast= $f.ast;
	} ( 
		PLUS l=term {
			$ast= new PlusNode ($ast,$l.ast);
		}
        | MINUS l=term {
			$ast= new MinusNode ($ast,$l.ast);
		}
        | OR l=term {
			$ast= new OrNode ($ast,$l.ast);
		} 
       )* 
    ;  

term returns [Node ast]: 
	f=factor {
		$ast= $f.ast;
	} ( 
		TIMES l=factor {
			$ast= new MultNode ($ast, $l.ast);
		}
  	    | DIV l=factor {
  	    	$ast= new DivNode($ast,	$l.ast);
  	    }
  	    | AND l=factor {
  	    	$ast= new AndNode ($ast, $l.ast);
  	    }
  	   )*
  	 ;
  	
    
factor	returns [Node ast]:
	f=value {
		$ast= $f.ast;
	} (
		(EQ eq=value {
			$ast= new EqualNode ($ast,$eq.ast);
		})
	    | (GE ge=value {
	     	$ast= new GreaterEqualNode ($ast,$ge.ast);
	    })
	    | (LE le=value {
	     	$ast= new LessEqualNode ($ast,$le.ast);
	     }) 
	   )*
 	;	 	
   	
  	
value returns [Node ast]: 
	n=INTEGER {
		$ast= new IntNode(Integer.parseInt($n.text));
	} 
	| TRUE {
		$ast= new BoolNode(true);
	}   
	| FALSE {
		$ast= new BoolNode(false);
	} 
	| NULL {
		$ast= new EmptyNode();
	}  
	| NEW id=ID {
		//Se non esiste la classe id lancio errore
		if(!classTable.containsKey($id.text)) {
	    	System.out.println("Id "+$id.text+" at line "+$id.line+" is not a class");
            System.exit(0);
	    }
	    //le classi sono a nestingLevel 0 della symbol table
	    STentry entry = symTable.get(0).get($id.text);
		} LPAR {
	   		ArrayList<Node> arglist = new ArrayList<Node>();
	   	}
	   	 (a=exp {
	   	 	arglist.add($a.ast);
	   	 }
	   	 (COMMA a1=exp {
	   	 	arglist.add($a1.ast);
	   	 }
	   	 )* )? RPAR {
	   	 	//creo il new node
	   	 	$ast = new NewNode($id.text,entry,arglist);
	   	 }        
	    | IF x=exp THEN CLPAR y=exp CRPAR ELSE CLPAR z=exp CRPAR {
	    	$ast= new IfNode($x.ast,$y.ast,$z.ast);
	    }    
	    | NOT LPAR x=exp RPAR {$ast= new NotNode($x.ast);}
	    | PRINT LPAR e=exp RPAR {$ast= new PrintNode($e.ast);}   
        | LPAR exp RPAR {$ast= $exp.ast;} 
	    | id1=ID {
           int j=nestingLevel;
           STentry entry=null; 
           while (j>=0 && entry==null){
             entry=(symTable.get(j)).get($id1.text);
             j--;
           	}
           if (entry==null){
           		System.out.println("Id "+$id1.text+" at line "+$id1.line+" not declared");
            	System.exit(0);
            }  
	   		$ast=  new IdNode($id1.text,entry,nestingLevel);  
	   		
	   	} 
	   ( LPAR {
	   		ArrayList<Node> arglist = new ArrayList<Node>();
	   }
	   	 (a=exp {
	   	 	arglist.add($a.ast);
	   	 }
	   	 	(COMMA a=exp {
	   	 		arglist.add($a.ast);
	   	 	} )*
	   	 )? RPAR {
	   	 	//id() è una chiamata a una funzione o a un metodo dentro una classe
	   	 	$ast= new CallNode($id1.text,entry,arglist,nestingLevel);
	   	 }
	         | DOT id2=ID {
	         	//richiamo metodo da fuori la classe -> idClasse.idMetodo();
	         	//Controllo che sia un classNode
	         	if(!(entry.getType() instanceof RefTypeNode)){
	         		System.out.println("Id "+$id1.text+" at line "+$id1.line+" is not a class");
	         		System.exit(0);
	         	}
	         	//Controllo che la classe è stata dichiarata cercandola nella classTable
	         	if(!classTable.containsKey(((RefTypeNode)entry.getType()).getClassId())){
	         		System.out.println("Class "+$id1.text+" at line "+$id1.line+" not declared");
	         		System.exit(0);
	         	}
	         	//Recupero la virtual table della classe
	         	HashMap<String,STentry> virtualTable = classTable.get(((RefTypeNode)entry.getType()).getClassId());
	         	
	         	//controllo che nella virtual table sia dichiarato il metodo
	         	if(!virtualTable.containsKey($id2.text)){
	         		System.out.println("Method "+$id2.text+" at line "+$id2.line+" not declared");
	         		System.exit(0);
	         	}
	         	
	         	STentry methodEntry=virtualTable.get($id2.text); 
	         	//Recupero gli argomenti del metodo, il controllo sui parametri si fa nel ClassCallNode
	         	ArrayList<Node> arglistMethod = new ArrayList<Node>();
	         } 
	         
	         LPAR (a=exp {arglistMethod.add($a.ast);}
	         (COMMA a1=exp{arglistMethod.add($a1.ast);})* )? RPAR {
	         	//Creo il ClassCallNode 
	         	$ast= new ClassCallNode ($id1.text, $id2.text, methodEntry, entry, arglistMethod, nestingLevel); 
	         }
	         )?
	         	   
        ; 
               
hotype returns [Node ast]: 
		t=type {
			$ast = $t.ast;
		}
        | a=arrow {
        	$ast = $a.ast;
        }
        ;

type returns [Node ast]: 
		INT {
			$ast=new IntTypeNode();
		}   		      
        | BOOL {
        	$ast=new BoolTypeNode();
        }		      	
 	    | id=ID{
 	    	$ast = new RefTypeNode($id.text);
 	    }               
 	    ;  
 	  
arrow returns [Node ast]: {
		ArrayList<Node> parTypes = new ArrayList<Node>();
	}
	LPAR (ht=hotype {
		parTypes.add($ht.ast);
	}  (COMMA ht=hotype {
		parTypes.add($ht.ast);
	})* )? RPAR ARROW t=type {
		$ast = new ArrowTypeNode(parTypes, $t.ast);
	};          
		  
/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/

PLUS  	: '+' ;
MINUS   : '-' ;
TIMES   : '*' ;
DIV 	: '/' ;
LPAR	: '(' ;
RPAR	: ')' ;
CLPAR	: '{' ;
CRPAR	: '}' ;
SEMIC 	: ';' ;
COLON   : ':' ; 
COMMA	: ',' ;
DOT	    : '.' ;
OR	    : '||';
AND	    : '&&';
NOT	    : '!' ;
GE	    : '>=' ;
LE	    : '<=' ;
EQ	    : '==' ;	
ASS	    : '=' ;
TRUE	: 'true' ;
FALSE	: 'false' ;
IF	    : 'if' ;
THEN	: 'then';
ELSE	: 'else' ;
PRINT	: 'print' ;
LET     : 'let' ;	
IN      : 'in' ;	
VAR     : 'var' ;
FUN	    : 'fun' ; 
CLASS	: 'class' ; 
EXTENDS : 'extends' ;	
NEW 	: 'new' ;	
NULL    : 'null' ;	  
INT	    : 'int' ;
BOOL	: 'bool' ;
ARROW   : '->' ; 	
INTEGER : '0' | ('-')?(('1'..'9')('0'..'9')*) ; 

ID  	: ('a'..'z'|'A'..'Z')('a'..'z' | 'A'..'Z' | '0'..'9')* ;


WHITESP  : ( '\t' | ' ' | '\r' | '\n' )+    -> channel(HIDDEN) ;

COMMENT : '/*' (.)*? '*/' -> channel(HIDDEN) ;
 
ERR   	 : . { System.out.println("Invalid char: "+ getText()); lexicalErrors++; } -> channel(HIDDEN);