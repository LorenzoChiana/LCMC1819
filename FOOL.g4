grammar FOOL;

@header{
import java.util.ArrayList;
import java.util.HashMap;
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
 
prog returns [Node ast]
	: {HashMap<String,STentry> hm = new HashMap<String,STentry> ();
       symTable.add(hm);}          
	  ( e=exp 	
        {$ast = new ProgNode($e.ast);} 
      | LET d=declist IN e=exp  
        {$ast = new ProgLetInNode($d.astlist,$e.ast);}      
	  ) 
	  {symTable.remove(nestingLevel);}
      SEMIC ;

cllist  returns [ArrayList<Node> classList]: {
						boolean isExtends = false;
						$classList = new ArrayList<Node>();
						int offsetVT = -1; //perch� i campi sono la prima cosa che vediamo
					}( CLASS classID=ID {
						ClassTypeNode classType = new ClassTypeNode();
						HashMap<String,STentry> hm = symTable.get(nestingLevel);
						HashMap<String,STentry> vt = new HashMap<String, STentry>();  //virtualTable tiene sia le cose ha la nostra classe sia quello che eredita
		             	if (hm.put($classID.text, new STentry(nestingLevel, classType, classOffset)) != null  ) {
		             		System.out.println("Class id "+$i.text+" at line "+$i.line+" already declared");
              				System.exit(0);
		              	} else {
		              		classOffset--;
		              	}
		              	symTable.add(vt);
		              	if (classTable.put($classID.text, vt) != null) {
		              		System.out.println("Class id "+$i.text+" at line "+$i.line+" already declared");
              				System.exit(0);
		              	}
						ClassNode classNode = new ClassNode($classID.text);  
	               		$classList.add(classNode);
		               	nestingLevel++;
		               	symTable.add(vt);
					}
					(EXTENDS id2 = ID {
						if(hm.containsKey($id2.text)){
							if (hm.get($id2.text).getType() instanceof ClassTypeNode){
								classType.addAllFields(((ClassTypeNode) hm.get($id2.text).getType()).getFields());
								classType.addAllMethods(((ClassTypeNode) hm.get($id2.text).getType()).getMethods());
							} else {
								System.out.println("Id "+$id2.text+" at line "+$id2.line+" is not a class");
              					System.exit(0);	
							}
						} else {
							System.out.println("Class id "+$id2.text+" at line "+$id2.line+" doesn\'t exist");
              				System.exit(0);
						}
						
						classNode.setSuperEntry(symTable.get(0).get($classID.text));
						vt.putAll(new HashMap<String, STentry>(classTable.get($id2.text)));
						offsetVT = -(classType.getFields().size())-1;
						isExtends=true;
						FOOLlib.addSuperType($id2.text, $classID.text);
						
					})? LPAR (i =ID COLON t = type {     
		               ArrayList<Node> fieldList = new ArrayList<Node>();
		               FieldNode field = new FieldNode($i.text, $t.ast);
		               fieldList.add(field);
		               
		               	if (vt.containsKey($i.text)){   //Se l'id è già presente nella vt e se questo non è un metodo faccio l'override
		             		//Overriding
		             		if(!vt.get($i.text).getIsMethod()){
		             			vt.replace($i.text, new STentry(nestingLevel, $t.ast, vt.get($i.text).getOffset()));
		             			classType.addField(-(vt.get($i.text).getOffset())-1, field.getSymType());
		             		}
						}else{
							vt.put($i.text, new STentry(nestingLevel, $t.ast, offsetVT));
							offsetVT--;
						    classType.addField(-offsetVT-1, field.getSymType());
						}
					}(COMMA i=ID COLON t=type {
						field = new FieldNode($i.text, $t.ast);
						fieldList.add(field);
						if (vt.containsKey($i.text)){   //Se l'id è già presente nella vt e se questo non è un metodo faccio l'override
		             		//Overriding
		             		if(!vt.get($i.text).getIsMethod()){
		             			vt.replace($i.text, new STentry(nestingLevel, $t.ast, vt.get($i.text).getOffset()));
		             			classType.addField(-(vt.get($i.text).getOffset())-1, field.getSymType());
		             		}
						}else{
							vt.put($i.text, new STentry(nestingLevel, $t.ast, offsetVT));
							offsetVT--;
						    classType.addField(-offsetVT-1, field.getSymType());
						}
					})* {
						classNode.addField(fieldList);
					} )? RPAR    
              CLPAR
                 ( FUN i=ID COLON t=type {
                 	MethodNode method = new MethodNode($i.text, $t.ast);
                 	if (isExtends){
                 		offsetVT = (classType.getMethods().size());
                 	}else{
                 		offsetVT = 0;
                 	}
                 	if (vt.containsKey($i.text)){   //Se l'id è già presente nella vt e se questo non è un metodo faccio l'override
		             		//Overriding
		            	if(vt.get($i.text).getIsMethod()){
		             		vt.replace($i.text, new STentry(nestingLevel, $t.ast, vt.get($i.text).getOffset()));
		             	}
					}else{
						vt.put($i.text, new STentry(nestingLevel, $t.ast, offsetVT));
						offsetVT++;
						
					}
	                nestingLevel++;
                 }
                 LPAR {
                 	ArrayList<Node> parType = new ArrayList<Node>(); 
                 	int paroffset = 1;
                 }(i=ID COLON ht=hotype { 
                 	ParNode p = new ParNode($i.text, $ht.ast);
                 	parType.add($ht.ast);
                 	method.addPar(p);
                 	if ( vt.put($i.text,new STentry(nestingLevel,$ht.ast,paroffset)) != null  ){ //aggiungo dich a hmn
	                  	System.out.println("Parameter id "+$i.text+" at line "+$i.line+" already declared");
	                   	System.exit(0);
	                } else {
	                  	if(p.getSymType() instanceof ArrowTypeNode){
	              			paroffset += 2;
	              	  	} else{
	              			paroffset++;
	              	  	}
	                }
                 }
                 	(COMMA i=ID COLON ht=hotype{
                 	ParNode par = new ParNode($i.text, $ht.ast);
                 	method.addPar(par);
                 	parType.add($ht.ast);
                 	if ( vt.put($i.text,new STentry(nestingLevel,$ht.ast,paroffset)) != null  ){ //aggiungo dich a hmn
	                  	System.out.println("Parameter id "+$i.text+" at line "+$i.line+" already declared");
	                   	System.exit(0);
	                } else {
	                  	if(p.getSymType() instanceof ArrowTypeNode){
	              			paroffset += 2;
	              	  	} else{
	              			paroffset++;
	              	  	}
	                }
                 }		
                 	)* )? RPAR {
                 		ArrowTypeNode atn = new ArrowTypeNode(parType, $t.ast); // A Giada non convince 
                 		classType.addMethod(offsetVT, atn);
                 		method.setSymType(atn);
                 		////forse ci va la entry.addType(atn);
                 		method.setOffset(offsetVT);					
                 		classNode.addMethod(method);
                 	}
	                     (LET {
	                     	ArrayList<Node> declist = new ArrayList<Node>();
	                     }(VAR i=ID COLON t=type ASS e=exp SEMIC {
	                     	Node v = new VarNode($i.text, $t.ast, $e.ast);
	                     	declist.add(v);
	                     })+ IN)? e = exp 
	                     {
	                     	method.addBody($e.ast);
	                     }
        	       SEMIC
        	     )* {
              		vt.get($classID.text).addType(classType);
              		//rimuovere la hashmap corrente poich� esco dallo scope               
	                symTable.remove(nestingLevel--);
              }               
              CRPAR 
          )+
        ; 

declist returns [ArrayList<Node> astlist]: {
		$astlist= new ArrayList<Node>();
		int offset = -2;
		if(nestingLevel==0){
			offset = classOffset;
		}
	} (
            ( VAR i=ID COLON ht=hotype ASS e=exp {
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
            }
            | FUN i=ID COLON t=type {//inserimento di ID nella symtable
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
	            }
                LPAR {
                	ArrayList<Node> parTypes = new ArrayList<Node>();
              	    int paroffset=1;
                } (fid=ID COLON fht=hotype {
                	parTypes.add($fht.ast);
                  ParNode fpar = new ParNode($fid.text,$fht.ast); //creo nodo ParNode
                  f.addPar(fpar);                                 //lo attacco al FunNode con addPar
                  
                  if ( hmn.put($fid.text,new STentry(nestingLevel,$fht.ast,paroffset)) != null  ){ //aggiungo dich a hmn
                  	System.out.println("Parameter id "+$fid.text+" at line "+$fid.line+" already declared");
                   	System.exit(0);
                  } else {
                  	if(fpar.getSymType() instanceof ArrowTypeNode){
              			paroffset += 2;
              	  	} else{
              			paroffset++;
              	  	}
                  }
                } (COMMA id=ID COLON hty=hotype
                	{
                    parTypes.add($hty.ast);
                    ParNode par = new ParNode($id.text,$hty.ast);
                    f.addPar(par);
                    if ( hmn.put($id.text,new STentry(nestingLevel,$hty.ast,paroffset)) != null){
                    	System.out.println("Parameter id "+$id.text+" at line "+$id.line+" already declared");
                     	System.exit(0);
                    } else {
                    	if(par.getSymType() instanceof ArrowTypeNode){
              				paroffset += 2;
	              		} else{
	              			paroffset++;
	              		}
                    }
                  }
                )* )? RPAR {
                	ArrowTypeNode atn = new ArrowTypeNode(parTypes, $t.ast);
                	f.setSymType(atn);
                	entry.addType(atn);
                }
                  (LET d=declist IN{f.addDec($d.astlist);})? e=exp 
                  {
                  	f.addBody($e.ast);
	                //rimuovere la hashmap corrente poich� esco dallo scope               
	                symTable.remove(nestingLevel--);    
	              }
            ) SEMIC 
          )+
        ;

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
		EQ eq=value {
			$ast= new EqualNode ($ast,$eq.ast);
		}
	    | GE ge=value {
	     	$ast= new GreaterEqualNode ($ast,$ge.ast);
	    }
	    | LE le=value {
	     	$ast= new LessEqualNode ($ast,$le.ast);
	     } 
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
		if(!classTable.containsKey($id.text)) {
	    	System.out.println("Id "+$id.text+" at line "+$id.line+" is not a class");
            System.exit(0);
	    }
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
	   	 	$ast = new NewNode($id.text,entry,arglist);
	   	 }        
	    | IF x=exp THEN CLPAR y=exp CRPAR ELSE CLPAR z=exp CRPAR {$ast= new IfNode($x.ast,$y.ast,$z.ast);}    
	    | NOT LPAR x=exp RPAR {$ast= new NotNode($x.ast);}
	    | PRINT LPAR e=exp RPAR {$ast= new PrintNode($e.ast);}   
        | LPAR exp RPAR  
	    | id1=ID {//cercare la dichiarazione
           int j=nestingLevel;
           STentry entry=null; 
           while (j>=0 && entry==null)
             entry=(symTable.get(j--)).get($id1.text);
           if (entry==null){
           		System.out.println("Id "+$id1.text+" at line "+$id1.line+" not declared");
            	System.exit(0);
            }  
	   		$ast=  new IdNode($id1.text,entry,nestingLevel);  ;
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
	   	 	$ast= new CallNode($id1.text,entry,arglist,nestingLevel);
	   	 }
	         | DOT id2=ID {
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
	         	$ast= new ClassCallNode ($id1.text, $id2.text, methodEntry, entry, arglistMethod, nestingLevel); // Da  controllare più avanti se c'è tutto
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
	}  (COMMA ht=hotype)* {
		parTypes.add($ht.ast);
	})? RPAR ARROW t=type {
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