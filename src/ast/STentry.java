package ast;
public class STentry {
   
  private int nl; //nesting level
  private Node type;
  private int offset;
  private boolean isMethod;
  
  public STentry (int n, int os) {
	  nl=n;
	  offset=os;
	  this.isMethod = false;
  } 

  public STentry (int n, Node t, int os) {
	  nl=n;
	  type=t;
	  offset=os;
	  this.isMethod = false;
  }
  
  public STentry (int n, Node t, int os, boolean isMethod) {
	  nl=n;
	  type=t;
	  offset=os;
	  this.isMethod = isMethod;
  }
  
  public void addType(Node t) {
	  type=t;
  }

  public Node getType() {
	  return type;
  }

  public int getOffset() {
	  return offset;
  }
  
  public int getNestinglevel() {
	  return nl;
  }
  
  public void setIsMethod(boolean m){
	  isMethod = m;
  }
  
  public boolean getIsMethod() {
	  return isMethod;
  }
  
  public String toPrint(String s) {
	   return s+"STentry: nestlev " + Integer.toString(nl) +"\n"+
			  s+"STentry: type\n " +
			      type.toPrint(s+"  ") +
		      s+"STentry: offset " + offset + "\n";    
  }
  
}  