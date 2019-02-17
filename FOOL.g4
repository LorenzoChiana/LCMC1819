grammar FOOL;

@lexer::members {
int lexicalErrors=0;
}
  
/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

prog  : ( LET ( cllist (declist)? 
        	  | declist
              ) IN exp
        | exp
        ) SEMIC
      ;

cllist  : ( CLASS ID (EXTENDS ID)? LPAR (ID COLON type (COMMA ID COLON type)* )? RPAR    
              CLPAR
                 ( FUN ID COLON type LPAR (ID COLON hotype (COMMA ID COLON hotype)* )? RPAR
	                     (LET (VAR ID COLON type ASS exp SEMIC)+ IN)? exp 
        	       SEMIC
        	     )*                
              CRPAR
          )+
        ; 

declist : (
            ( VAR ID COLON hotype ASS exp
            | FUN ID COLON type LPAR (ID COLON hotype (COMMA ID COLON hotype)* )? RPAR 
                  (LET declist IN)? exp 
            ) SEMIC 
          )+
        ;

exp	: term ( PLUS term  
           | MINUS term 
           | OR term    
           )* 
    ;  

term	: factor ( TIMES factor 
  	             | DIV  factor 
  	             | AND  factor 
  	             )*
  	    ;
  	
factor  : value ( EQ value 
	            | GE value 
	            | LE value 
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
               
hotype  : type
        | arrow 
        ;

type    : INT     		      
        | BOOL  		      	
 	    | ID                        
 	    ;  
 	  
arrow 	: LPAR (hotype (COMMA hotype)* )? RPAR ARROW type ;          
		  
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