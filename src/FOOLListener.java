// Generated from FOOL.g4 by ANTLR 4.7

import java.util.ArrayList;
import java.util.HashMap;
import lib.FOOLlib;
import ast.*;

import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link FOOLParser}.
 */
public interface FOOLListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link FOOLParser#prog}.
	 * @param ctx the parse tree
	 */
	void enterProg(FOOLParser.ProgContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#prog}.
	 * @param ctx the parse tree
	 */
	void exitProg(FOOLParser.ProgContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#cllist}.
	 * @param ctx the parse tree
	 */
	void enterCllist(FOOLParser.CllistContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#cllist}.
	 * @param ctx the parse tree
	 */
	void exitCllist(FOOLParser.CllistContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#declist}.
	 * @param ctx the parse tree
	 */
	void enterDeclist(FOOLParser.DeclistContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#declist}.
	 * @param ctx the parse tree
	 */
	void exitDeclist(FOOLParser.DeclistContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#exp}.
	 * @param ctx the parse tree
	 */
	void enterExp(FOOLParser.ExpContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#exp}.
	 * @param ctx the parse tree
	 */
	void exitExp(FOOLParser.ExpContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#term}.
	 * @param ctx the parse tree
	 */
	void enterTerm(FOOLParser.TermContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#term}.
	 * @param ctx the parse tree
	 */
	void exitTerm(FOOLParser.TermContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#factor}.
	 * @param ctx the parse tree
	 */
	void enterFactor(FOOLParser.FactorContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#factor}.
	 * @param ctx the parse tree
	 */
	void exitFactor(FOOLParser.FactorContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValue(FOOLParser.ValueContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValue(FOOLParser.ValueContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#hotype}.
	 * @param ctx the parse tree
	 */
	void enterHotype(FOOLParser.HotypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#hotype}.
	 * @param ctx the parse tree
	 */
	void exitHotype(FOOLParser.HotypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#type}.
	 * @param ctx the parse tree
	 */
	void enterType(FOOLParser.TypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#type}.
	 * @param ctx the parse tree
	 */
	void exitType(FOOLParser.TypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link FOOLParser#arrow}.
	 * @param ctx the parse tree
	 */
	void enterArrow(FOOLParser.ArrowContext ctx);
	/**
	 * Exit a parse tree produced by {@link FOOLParser#arrow}.
	 * @param ctx the parse tree
	 */
	void exitArrow(FOOLParser.ArrowContext ctx);
}