import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// @main
// 实现 ExpressionMacro 协议
struct SimpleMacro: ExpressionMacro {
  // 实现 required 方法
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {    // 返回一个整数常量 42
    return ExprSyntax(
      IntegerLiteralExprSyntax(42)
    )
  }
}

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    guard let argument = node.argumentList.first?.expression else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    return "(\(argument), \(literal: argument.description))"
  }
}

public struct DoubleMacro: ExpressionMacro {
  public static func expansion(
    of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> SwiftSyntax.ExprSyntax {
    guard let argument = node.argumentList.first?.expression.as(IntegerLiteralExprSyntax.self.self) else {
      throw MacroExpansionError(message: "Expected an integer literal")
    }

    guard let int = Int(argument.literal.text) else {
      throw MacroExpansionError(message: "Expected an integer literal")
    }

    return ExprSyntax(IntegerLiteralExprSyntax(int * 2))
  }
}

struct MacroExpansionError: Error {
  var message: String
}

public struct GreetMacro: DeclarationMacro {
  public static func expansion(
    of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.DeclSyntax] {
    return [
    """
    func greet() -> String {
      return "Hello, Swift Macro! 2"
    }
    """
    ]
  }
}

//struct GreetMacro: DeclarationMacro {
//    static func expansion(
//        of node: some FreestandingMacroExpansionSyntax,
//        in context: some MacroExpansionContext
//    ) throws -> [DeclSyntax] {
//        // 生成 greet 函数的代码
//        let functionDecl = FunctionDeclSyntax { builder in
//            builder.useFuncKeyword(SyntaxFactory.makeFuncKeyword())
//            builder.useIdentifier(SyntaxFactory.makeIdentifier("greet"))
//            builder.useSignature(FunctionSignatureSyntax { sigBuilder in
//                sigBuilder.useOutput(ReturnClauseSyntax { returnBuilder in
//                    returnBuilder.useArrow(SyntaxFactory.makeArrow())
//                    returnBuilder.useReturnType(TypeSyntax(SimpleTypeIdentifierSyntax {
//                        $0.useName(SyntaxFactory.makeIdentifier("String"))
//                    }))
//                })
//            })
//            builder.addBodyStatement(CodeBlockItemSyntax { stmtBuilder in
//                stmtBuilder.useItem(SyntaxFactory.makeReturnStmt(
//                    returnKeyword: SyntaxFactory.makeReturnKeyword(),
//                    expression: ExprSyntax(SyntaxFactory.makeStringLiteralExpr("Hello, Swift Macro!"))
//                ))
//            })
//        }
//
//        return [DeclSyntax(functionDecl)]
//    }
//}

@main
struct MacrosPackagePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
    DoubleMacro.self,
    GreetMacro.self,
    SimpleMacro.self
  ]
}
