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

@main
struct MacrosPackagePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
    SimpleMacro.self
  ]
}
