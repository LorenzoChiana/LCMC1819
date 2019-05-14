grammar FOOL;

@header{
import java.util.ArrayList;
import java.util.HashMap;
import ast.*;
import lib.FOOLlib;
import java.util.HashSet;
}

@parser::members{
	private int classOffset = -2;
	private int nestingLevel = 0;
	private ArrayList<HashMap<String,STentry>> symTable = new ArrayList<>();
	//livello ambiente con dichiarazioni piu' esterno è 0 (prima posizione ArrayList) invece che 1 (slides)
	//il "fronte" della lista di tabelle è symTable.get(nestingLevel)
	
	private HashMap<String, HashMap<String,STentry>> classTable = new HashMap<>();
	

}

@lexer::members {
int lexicalErrors=0;
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

prog returns [Node ast]
	: {
		HashMap<String,STentry> hm = new HashMap<String,STentry> ();
       symTable.add(hm);
       boolean classes = false;
       }          
	  ( e=exp 	
        {
        	$ast = new ProgNode($e.ast);
        } 
      | LET (c=cllist {classes = true;} (d=declist)? | d=declist) 
        IN e=exp  
        {
        	if(!classes)
        		$ast = new ProgLetInNode($d.astlist, $e.ast);
        	else {
				$ast = new ProgLetInNode($c.classList, $d.astlist, $e.ast);
        	}
        }      
	  ) 
	  {symTable.remove(nestingLevel);} /* quando sono qui sono sicuro che il nesting level è 0 */
      SEMIC 
      ;
      
cllist  returns [ArrayList<Node> classList]
: {
	$classList = new ArrayList<Node>();
	boolean extend = false;
}
( CLASS classId=ID {extend = false;} (EXTENDS extended=ID {extend = true;})? 
					{
						
						ClassNode classNode = new ClassNode($classId.text);							
						ClassTypeNode classType = new ClassTypeNode();
						HashSet<String> innerFieldsAndMethod = new HashSet<>();
						
						/*se estendo, inizializzo classType con la copia di quello della classe padre */
						if(extend) {
							STentry superEntry = symTable.get(0).get($extended.text);
							
							if(superEntry!=null){
								classType=((ClassTypeNode) superEntry.getType()).copy();
								classNode.setSuperEntry(superEntry);
								
								FOOLlib.addSuperType($extended.text, $classId.text);
							} else {
								System.out.println("Class id "+$extended.text+" at line "+$extended.line+" does not exist");
								System.exit(0);
							}
						}
						$classList.add(classNode);
						STentry classEntry = new STentry(nestingLevel, classOffset--);
			            if (symTable.get(nestingLevel).put($classId.text, classEntry) != null)
			            {System.out.println("Class id "+$classId.text+" at line "+$classId.line+" already declared");
			            System.exit(0);}
			            
			            HashMap<String,STentry> virtualTable = new HashMap<String,STentry>();
			            if(extend){
			            	virtualTable = new HashMap<String,STentry>(classTable.get($extended.text));
			            }
			            classTable.put($classId.text, virtualTable);
			            symTable.add(virtualTable);
			            
			            /*Entro nei campi della funzione*/
			            nestingLevel++;
					}  
					
					LPAR {
						/*se estendo parto dall'offset dell'ultimo campo della classe padre */
						int fieldOffset = extend ? -classType.getFields().size() -1  : -1;
						
						
					} (fieldId=ID COLON fieldType=type 
						{
						    /*controllo che il campo non è già dichiarato nella classe corrente */
							if(!innerFieldsAndMethod.add($fieldId.text)){
								System.out.println("Field id "+$fieldId.text+" at line "+$fieldId.line+" already declared in this class");
					            System.exit(0);
							}
						
							if(!extend || !classTable.get($extended.text).containsKey($fieldId.text)){
								/*NO OVERRIDE */
								/*Primo campo della classe */
								FieldNode firstField = new FieldNode($fieldId.text, $fieldType.ast, fieldOffset);
								classNode.addField(firstField);
								classType.addField(firstField, -fieldOffset-1);									
									
								STentry stEntry = new STentry(nestingLevel, $fieldType.ast, fieldOffset--);
									
								/* Aggiungo il campo in virtual table */
								if ( virtualTable.put($fieldId.text, stEntry) != null ){
						            System.out.println("Field id "+$fieldId.text+" at line "+$fieldId.line+" already declared");
						            System.exit(0);
						        }
								
							} else {
								/*OVERRIDE */

								/*prendo la entry del campo della classe da cui estendo */
								STentry parentEntry = classTable.get($extended.text).get($fieldId.text);
								if(parentEntry.getType() instanceof ArrowTypeNode){
									System.out.println("Cant override a method with field");
									System.exit(0);
								}
								
								FieldNode field = new FieldNode($fieldId.text, $fieldType.ast, parentEntry.getOffset() );
								//classNode.addField(field);
								classType.replaceField(field, -parentEntry.getOffset()-1); 
								
								/*creo una nuova stentry con lo stesso offset */
								STentry stEntry = new STentry(nestingLevel, $fieldType.ast, parentEntry.getOffset());
								/* Aggiungo il campo in virtual table */
								virtualTable.put($fieldId.text, stEntry);	 		
							}
							
		
						} 
						(COMMA fieldId=ID COLON fieldType=type
						{
						
						   /*controllo che il campo non è già dichiarato nella classe corrente */
							if(!innerFieldsAndMethod.add($fieldId.text)){
								System.out.println("Field id "+$fieldId.text+" at line "+$fieldId.line+" already declared in this class");
					            System.exit(0);
							} 
						
							if(!extend || !classTable.get($extended.text).containsKey($fieldId.text)){
								/*NO OVERRIDE */
								FieldNode field = new FieldNode($fieldId.text, $fieldType.ast,fieldOffset);
								classNode.addField(field);
								classType.addField(field, -fieldOffset-1);									
								STentry stEntry = new STentry(nestingLevel,$fieldType.ast, fieldOffset--);
								
								/* Aggiungo il campo in virtual table */
								if ( virtualTable.put($fieldId.text, stEntry) != null   ){
									System.out.println("Field id "+$fieldId.text+" at line "+$fieldId.line+" already declared");
						            System.exit(0);
						        }			
							} else {
								/*OVERRIDE */

								/*prendo la entry del campo della classe da cui estendo */
								STentry parentEntry = classTable.get($extended.text).get($fieldId.text);
								if(parentEntry.getType() instanceof ArrowTypeNode){
									System.out.println("Cant override a method with field");
						            System.exit(0);
								}
								
								FieldNode field = new FieldNode($fieldId.text, $fieldType.ast, parentEntry.getOffset());
								//classNode.addField(field);
								classType.replaceField(field, -parentEntry.getOffset()-1); 
								
								/*creo una nuova stentry con lo stesso offset */
								STentry stEntry = new STentry(nestingLevel, $fieldType.ast, parentEntry.getOffset());
										
								/* Aggiungo il campo in virtual table */
								virtualTable.put($fieldId.text, stEntry);	 
									
							}				
						} 
						)*
					)? RPAR    
              CLPAR {/* Set up dichiarazione metodi */
						int methodOffset = extend ? classType.getMethods().size() : 0;
					}
                 (FUN methodId=ID COLON methodType=type 
                 	{
                 	    int parOffset = 0;
                 		MethodNode methodNode = new MethodNode($methodId.text,$methodType.ast);                		
                 		STentry methodEntry;

                 		/* controllo che il metodo non sia già stato dichiarato nella classe corrente */
						if(!innerFieldsAndMethod.add($methodId.text)){
							System.out.println("Method id "+$methodId.text+" at line "+$methodId.line+" already declared in this class");
					        System.exit(0);
						}
                 		if(!extend || !classTable.get($extended.text).containsKey($methodId.text)){
                 			/* Nuovo metodo */
                 			methodNode.setOffset(methodOffset);
                 			classNode.addMethod(methodNode);
                 			classType.addMethod(methodNode, methodOffset);
                 			/* La definiamo qui per settargli in seguito il tipo ArrowType */
                 			methodEntry = new STentry(nestingLevel, methodOffset++, true);
                 			if(virtualTable.put($methodId.text, methodEntry) != null ){ 
                 				System.out.println("Method id "+$methodId.text+" at line "+$methodId.line+" already declared");
                 				System.exit(0);
                 			}
                 	    } else {
                 	    	/*OVERRIDE */
                 	    	/*prendo la entry del metodo della classe da cui estendo */
                 	    	STentry parentEntry = classTable.get($extended.text).get($methodId.text);

                 	    	if(!(parentEntry.getType() instanceof ArrowTypeNode)){
                 	    		System.out.println("Cant override a field with method");
                 	    		System.exit(0);
                 	    	}
                 	    	methodNode.setOffset(parentEntry.getOffset());
                 	    	classType.replaceMethod(methodNode,parentEntry.getOffset());
                 	    	classNode.addMethod(methodNode);
                 	    	
                 	    	/*creao una nuova stentry con lo stesso offset */
                 	    	methodEntry = new STentry(nestingLevel, parentEntry.getOffset(), true);
                 	    	virtualTable.put($methodId.text, methodEntry); 
                 	    }
	                   
	                   
	                   /*Entro nello scope parametri del metodo*/
	                   nestingLevel++;
	                   symTable.add(new HashMap<String,STentry>());
				            
                 	}

                 	/*Dichiarazione Parametri metodo*/

                 	LPAR {
                 		ArrayList<Node> parTypes = new ArrayList<Node>();
                 	} (parId=ID COLON parType=hotype
                 		{
                 			ParNode fpar = new ParNode($parId.text,$parType.ast);
                 			parTypes.add($parType.ast);
                 		 	methodNode.addPar(fpar);
                 		 	if($parType.ast instanceof ArrowTypeNode) parOffset+=2;
              	    		else parOffset++;
                 		 	if ( virtualTable.put($parId.text,new STentry(nestingLevel, $parType.ast, parOffset)) != null  ) //aggiungo dich a hmn
                  			{System.out.println("Parameter id "+$parId.text+" at line "+$parId.line+" already declared");
                   			System.exit(0);}
                 		 }
                 		(COMMA parId=ID COLON parType=hotype
                 			{
                 				ParNode par = new ParNode($parId.text,$parType.ast);
                 				methodNode.addPar(par);
                 				parTypes.add($parType.ast);
                 				if($parType.ast instanceof ArrowTypeNode) parOffset+=2;
              	    			else parOffset++;
              	    			if ( virtualTable.put($parId.text,new STentry(nestingLevel, $parType.ast, parOffset)) != null  ) //aggiungo dich a hmn
                  				{System.out.println("Parameter id "+$parId.text+" at line "+$parId.line+" already declared");
                   				System.exit(0);}
                   				
                 			}
                 		)*
                 	)? {
                 		ArrowTypeNode type = new ArrowTypeNode(parTypes,$methodType.ast);
                 		methodNode.setSymType(type);
                 		methodEntry.addType(type);                 		
                 	}
                 	RPAR /* Dichiarazione variabili dentro metodo */
	                     (LET {
	                     	ArrayList<Node> declist = new ArrayList();
	                     	int varoffset = -2;
	                     }
	                     	(VAR varId=ID COLON varType=type ASS e=exp SEMIC 
	                     	{
	                     		VarNode v = new VarNode($varId.text,$varType.ast,$e.ast);
	                         	declist.add(v);
	                         	HashMap<String,STentry> varHm = symTable.get(nestingLevel);
	                         	if ( varHm.put($varId.text,new STentry(nestingLevel,$varType.ast,varoffset--)) != null  ) //aggiungo dich a hmn
                  				{System.out.println("Var id "+$varId.text+" at line "+$varId.line+" already declared");
                   				System.exit(0);}
                   				
	                         }
	                     {	methodNode.addDec(declist); })+ IN)? 
	                     e=exp {  
	                      	methodNode.addBody($e.ast);	                 	
	                      	symTable.remove(nestingLevel--);	                      	
	                      }
        	       SEMIC
        	     )*                
              CRPAR
              {
              	classNode.setSymType(classType);
              	classEntry.addType(classType);
              	symTable.remove(nestingLevel--);
              }
          )+
        ; 

declist	returns [ArrayList<Node> astlist]        
	: {$astlist= new ArrayList<Node>() ;
	   /* Se sono a nesting level 0 devo continuare ad usare il classoffset, altrimenti riparto da -2 */
	   int offset = nestingLevel==0 ? classOffset : -2;
	   }      
	  ( (	/* Dichiarazione variabile */
            VAR i=ID COLON h=hotype ASS e=exp
            {VarNode v = new VarNode($i.text,$h.ast,$e.ast);  
             $astlist.add(v);                                 
             HashMap<String,STentry> hm = symTable.get(nestingLevel);
             if (hm.put($i.text,new STentry(nestingLevel,$h.ast, offset)) != null)	{
             		System.out.println("Var id "+$i.text+" at line "+$i.line+" already declared");
              		System.exit(0);
              	}
              if(v.getSymType() instanceof ArrowTypeNode) offset-=2;
              else offset--;  
            }  
      |   /* Dichiarazione funzione */
            FUN i=ID COLON t=type
              {/*inserimento di ID nella symtable*/
               FunNode f = new FunNode($i.text,$t.ast);      
               $astlist.add(f);                              
               HashMap<String,STentry> hm = symTable.get(nestingLevel);
               STentry entry = new STentry(nestingLevel, offset);
               if (hm.put($i.text,entry) != null) {
               	System.out.println("Fun id "+$i.text+" at line "+$i.line+" already declared");
                System.exit(0);
                }
                offset-=2;
                /*crea una nuova hashmap per la symTable*/
                nestingLevel++;
                HashMap<String,STentry> hmn = new HashMap<String,STentry> ();
                symTable.add(hmn);
                }
              LPAR {/* Setup parametri funzione */
              		ArrayList<Node> parTypes = new ArrayList<Node>();
              	    int paroffset=0;
                   }
                (fid=ID COLON fty=hotype
                  { 
                  parTypes.add($fty.ast);
                  ParNode fpar = new ParNode($fid.text,$fty.ast); /*creo nodo ParNode
                  												    lo attacco al FunNode con addPar*/
                  f.addPar(fpar);       
                  /* Se il parametro è di tipo ArrowType deve avere offset 2 */                         
                  if($fty.ast instanceof ArrowTypeNode) paroffset+=2;
              	  else paroffset++;
                  
                  /*aggiungo dichiarazione a hmn*/
                  if (hmn.put($fid.text,new STentry(nestingLevel,$fty.ast,paroffset)) != null) {
                  	System.out.println("Parameter id "+$fid.text+" at line "+$fid.line+" already declared");
                   	System.exit(0);
                   }
              	  }
                  (COMMA id=ID COLON ty=hotype
                    {
                    parTypes.add($ty.ast);
                    ParNode par = new ParNode($id.text,$ty.ast);
                    f.addPar(par);

                    /* Se il parametro è di tipo ArrowType deve avere offset 2 */   
                    if($ty.ast instanceof ArrowTypeNode) paroffset+=2;
              	    else paroffset++;
                    if (hmn.put($id.text,new STentry(nestingLevel,$ty.ast,paroffset)) != null){
                    	System.out.println("Parameter id "+$id.text+" at line "+$id.line+" already declared");
                     	System.exit(0);
                     }
                    }
                  )*
                )? 
              RPAR {
              
                /* Creo il tipo ArrowType della funzione e lo metto nella STentry e nel FunNode */
              	ArrowTypeNode type = new ArrowTypeNode(parTypes,$t.ast);
              	f.setSymType(type);
              	entry.addType(type);
              }
              (LET d=declist IN {f.addDec($d.astlist);})? e=exp
              {f.addBody($e.ast);
               /*rimuovere la hashmap corrente poiché esco dallo scope*/               
               symTable.remove(nestingLevel--);    
              }
      ) SEMIC
    )+          
	;
	
type	returns [Node ast]
  : INT  {$ast=new IntTypeNode();}
  | BOOL {$ast=new BoolTypeNode();} 
  | i=ID {$ast = new RefTypeNode($i.text);}
	;	

exp	returns [Node ast]
 	: f=term {$ast= $f.ast;}
 	    ((PLUS l=term {$ast= new PlusNode ($ast,$l.ast);})
 	    |(MINUS l=term {$ast= new MinusNode($ast,$l.ast);}) 
 	    | (OR l=term {$ast= new OrNode($ast,$l.ast);}) 
 	    )*
 	;
 	
term	returns [Node ast]
	: f=factor {$ast= $f.ast;}
	    ((TIMES l=factor {$ast= new MultNode ($ast,	$l.ast);})
	    |(DIV l=factor {$ast= new DivNode($ast,	$l.ast);})
	    |(AND	l=factor {$ast= new AndNode ($ast, $l.ast);})
	    )*
	;
	
 	
factor returns [Node ast]
	: f=value {$ast= $f.ast;} 
		((EQ  l=value {$ast= new EqualNode ($ast,$l.ast);})
		| (LE  lLq=value {$ast= new LessEqualNode ($ast, $lLq.ast);})
		| (GE  lMq=value {$ast= new GreaterEqualNode ($ast, $lMq.ast);}))*
;

value	returns [Node ast]
	: n=INTEGER   
	  {$ast= new IntNode(Integer.parseInt($n.text));}  
	| TRUE 
	  {$ast= new BoolNode(true);}  
	| FALSE
	  {$ast= new BoolNode(false);}  
	  
	| NULL
	  {$ast= new EmptyNode();}  

	 | NEW classId=ID {
	 	/*Controllo che la classe sia in class table*/
	 	if(!classTable.containsKey($classId.text)){
	 		System.out.println("Class "+$classId.text+" at line "+$classId.line+" not declared");
            System.exit(0);
	 	}
	 }
	 LPAR{
	 	/* Salvo i parametri del costruttore in una lista */
	 	ArrayList<Node> argList = new ArrayList();
	 } ( arg=exp {argList.add($arg.ast);} (COMMA arg=exp {argList.add($arg.ast);} )* )? 
	 {
	 	/* Creo il new node passando come STentry quella della classe in sym table */
	 	$ast = new NewNode($classId.text,  symTable.get(0).get($classId.text), argList);
	 }
	 RPAR    
	  
	| LPAR e=exp RPAR
	  {$ast= $e.ast;}  
	| IF x=exp THEN CLPAR y=exp CRPAR 
		   ELSE CLPAR z=exp CRPAR 
	  {$ast= new IfNode($x.ast,$y.ast,$z.ast);}	 
	| NOT LPAR e=exp RPAR 
		{$ast= new NotNode($e.ast);}
	| PRINT LPAR e=exp RPAR	
	  {$ast= new PrintNode($e.ast);}
	| i=ID 
	  {//cercare la dichiarazione
           int j=nestingLevel;
           STentry entry=null; 
           while (j>=0 && entry==null)
             entry=(symTable.get(j--)).get($i.text);
           if (entry==null) {
           	System.out.println("Id "+$i.text+" at line "+$i.line+" not declared");
            System.exit(0);
           }               
	   $ast= new IdNode($i.text,entry,nestingLevel);} 
	   ( LPAR
	   	 {ArrayList<Node> arglist = new ArrayList<Node>();} 
	   	 ( a=exp {arglist.add($a.ast);} 
	   	 	(COMMA a=exp {arglist.add($a.ast);} )*
	   	 )? 
	   	 RPAR
	   	 {
	   	 	$ast= new CallNode($i.text,entry,arglist,nestingLevel);
	   	 } 
	   	 
	   	 | DOT id2=ID 
	   	 
	   	 LPAR {/* Salvo i parametri del metodo una lista */
	   	 	ArrayList<Node> arglist = new ArrayList<Node>();
	   	 }  (par1=exp {arglist.add($par1.ast);} (COMMA otherPars=exp {arglist.add($otherPars.ast);})* )? 
	   	 {
   	 		/*ID1 deve essere l'id di un oggetto' */
   	 		if(!(entry.getType() instanceof RefTypeNode)){
   	 			System.out.println("Method invocation of a non-class id at line " + $i.line);
	            System.exit(0);
   	 		}
   	 		/* Cerco la definizione del metodo tramite la class table */
   	 		String classId = ((RefTypeNode)entry.getType()).getClassId();
   	 		STentry methodEntry = classTable.get(classId).get($id2.text);
   	 		if (methodEntry==null) {
   	 		    System.out.println("Method "+$id2.text+" at line "+$id2.line+" not declared");
	            System.exit(0);
	        } 
  		 
	  	 } 
	   	 RPAR {
	   	 	$ast= new ClassCallNode($i.text, $id2.text, entry,  methodEntry, arglist, nestingLevel);
	   	 }
	   	 )?
 	; 


hotype returns [Node ast] 
		: t=type {$ast = $t.ast;}
		| a=arrow {$ast = $a.ast;}
        ;
 	  
arrow 	returns [Node ast] 
		: 
		{ArrayList<Node> parTypes = new ArrayList<Node>();}
		LPAR (p=hotype {parTypes.add($p.ast);} 
			(COMMA p=hotype {{parTypes.add($p.ast);} })*
		)? RPAR 
		ARROW ret=type {$ast = new ArrowTypeNode(parTypes, $ret.ast);};   
  		

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

