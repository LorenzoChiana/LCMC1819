grammar FOOL;

@lexer::members {
int lexicalErrors=0;
}
  
/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

prog  returns [Node ast]: {
		HashMap<String, STentry> hm = new HashMap<String, STentry>();
		symTable.add(hm);
	}
	( 
		LET (cllist (d=declist)? | d=declist) IN e=exp {
	    	$ast = new ProgLetInNode($d.astlist, $e.ast);
		}
		| e=exp {
			$ast = new ProgNode($e.ast);
		}
	) {
		symTable.remove(nestingLevel);
	} SEMIC;

cllist  returns [ArrayList<Node> classList]: {
		$classList = new ArrayList<Node>();
	} ( CLASS classID=ID (EXTENDS ID)? LPAR (ID COLON type (COMMA ID COLON type)* )? RPAR    
              CLPAR
                 ( FUN ID COLON type LPAR (ID COLON hotype (COMMA ID COLON hotype)* )? RPAR
	                     (LET (VAR ID COLON type ASS exp SEMIC)+ IN)? exp 
        	       SEMIC
        	     )*                
              CRPAR
          )+
        ; 

declist returns [ArrayList<Node> astlist]: {
		$astlist= new ArrayList<Node>();
		int offset=-2;
	} (
            ( VAR i=ID COLON ht=hotype ASS e=exp {
            	VarNode v = new VarNode($i.text,$ht.ast,$e.ast);  
             	$astlist.add(v);                                 
             	HashMap<String,STentry> hm = symTable.get(nestingLevel);
             	if (hm.put($i.text, new STentry(nestingLevel, $ht.ast,offset--)) != null  ) {
             		System.out.println("Var id "+$i.text+" at line "+$i.line+" already declared");
              		System.exit(0);
              	}  
            }
            | FUN i=ID COLON t=type {//inserimento di ID nella symtable
	               FunNode f = new FunNode($i.text,$t.ast);      
	               $astlist.add(f);                              
	               HashMap<String,STentry> hm = symTable.get(nestingLevel);
	               STentry entry=new STentry(nestingLevel, offset--);
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
                } (fid=ID COLON ht=hotype {
                	parTypes.add($ht.ast);
                  ParNode fpar = new ParNode($fid.text,$ht.ast); //creo nodo ParNode
                  f.addPar(fpar);                                 //lo attacco al FunNode con addPar
                  if ( hmn.put($fid.text,new STentry(nestingLevel,$ht.ast,paroffset++)) != null  ) //aggiungo dich a hmn
                  {System.out.println("Parameter id "+$fid.text+" at line "+$fid.line+" already declared");
                   System.exit(0);}
                } (COMMA id=ID COLON hty=hotype
                	{
                    parTypes.add($hty.ast);
                    ParNode par = new ParNode($id.text,$hty.ast);
                    f.addPar(par);
                    if ( hmn.put($id.text,new STentry(nestingLevel,$hty.ast,paroffset++)) != null  )
                    {System.out.println("Parameter id "+$id.text+" at line "+$id.line+" already declared");
                     System.exit(0);}
                    }
                )* )? RPAR {entry.addType(new ArrowTypeNode(parTypes,$t.ast));}
                  (LET d=declist IN{f.addDec($d.astlist);})? e=exp 
                  {f.addBody($e.ast);
	               //rimuovere la hashmap corrente poiché esco dallo scope               
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
			/*$ast= new MinusNode ($ast,$l.ast);*/
		}
        | OR l=term {
			/*$ast= new OrNode ($ast,$l.ast);*/
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
  	    	/*$ast= new DivNode($ast,	$l.ast);*/
  	    }
  	    | AND factor {
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
   	
  	
value	: INTEGER 
	    | TRUE      
	    | FALSE       
	    | NULL	    
	    | NEW ID LPAR (exp (COMMA exp)* )? RPAR         
	    | IF exp THEN CLPAR exp CRPAR ELSE CLPAR exp CRPAR     
	    | NOT LPAR exp RPAR 
	    | PRINT LPAR exp RPAR      
        | LPAR exp RPAR  
	    | ID ( LPAR (exp (COMMA exp)* )? RPAR 
	         | DOT ID LPAR (exp (COMMA exp)* )? RPAR 
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
 	    | ID                        
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