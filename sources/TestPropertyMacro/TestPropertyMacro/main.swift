import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@attached(extension, conformances: [])
macro TypedProperty<T>(_: T.Type) = #externalMacro(module: "YourMacroModule", type: "TypedPropertyMacro")

public enum EventProperty: String {
    @TypedProperty(String.self)
    case action = "action"

    @TypedProperty(Double.self)
    case amount = "amount"

    @TypedProperty(String.self)
    case appStartPos = "app_start_pos"

    @TypedProperty(Int.self)
    case code = "code"

    @TypedProperty(Int.self)
    case count = "count"

    @TypedProperty(TimeInterval.self)
    case duration = "duration"

    @TypedProperty(TimeInterval.self)
    case elapsed = "elapsed"

    @TypedProperty(String.self)
    case error = "error"

    @TypedProperty(Int.self)
    case errorCount = "error_count"

    @TypedProperty(String.self)
    case gender = "gender"
}

public struct TypedPropertyMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingExtensionsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            return []
        }

        var extensions: [ExtensionDeclSyntax] = []

        for caseDecl in enumDecl.members.members {
            guard let caseDecl = caseDecl.decl.as(EnumCaseDeclSyntax.self),
                  let caseElement = caseDecl.elements.first,
                  let propertyType = attribute.argumentList?.first?.expression.as(SimpleTypeIdentifierSyntax.self)?.name.text
            else {
                continue
            }

            let extensionSyntax = ExtensionDeclSyntax {
                $0.useExtensionKeyword(SyntaxFactory.makeExtensionKeyword())
                $0.addInheritedType(IdentifierTypeSyntax { $0.useName(caseElement.identifier) })
                $0.useMembers(MemberDeclBlockSyntax { memberDeclBlock in
                    memberDeclBlock.useLeftBrace(SyntaxFactory.makeLeftBraceToken())
                    memberDeclBlock.addMember(MemberDeclListItemSyntax { memberDeclListItem in
                        memberDeclListItem.useDecl(SyntaxFactory.makeVariableDecl(
                            attributes: nil,
                            modifiers: nil,
                            letOrVarKeyword: SyntaxFactory.makeLetKeyword(),
                            bindings: SyntaxFactory.makePatternBindingList([
                                SyntaxFactory.makePatternBinding(
                                    pattern: IdentifierPatternSyntax { identifierPattern in
                                        identifierPattern.useIdentifier(SyntaxFactory.makeIdentifier("get\(caseElement.identifier.text.capitalized)"))
                                    },
                                    typeAnnotation: TypeAnnotationSyntax { typeAnnotation in
                                        typeAnnotation.useColon(SyntaxFactory.makeColonToken())
                                        typeAnnotation.useType(SyntaxFactory.makeTypeIdentifier(propertyType))
                                    },
                                    initializer: nil,
                                    accessor: nil,
                                    trailingComma: nil
                                )
                            ])
                        ))
                    })
                    memberDeclBlock.addMember(MemberDeclListItemSyntax { memberDeclListItem in
                        memberDeclListItem.useDecl(SyntaxFactory.makeFunctionDecl(
                            attributes: nil,
                            modifiers: nil,
                            funcKeyword: SyntaxFactory.makeFuncKeyword(),
                            identifier: SyntaxFactory.makeIdentifier("set\(caseElement.identifier.text.capitalized)"),
                            signature: FunctionSignatureSyntax { signature in
                                signature.useInput(SyntaxFactory.makeParameterClause(
                                    leftParen: SyntaxFactory.makeLeftParenToken(),
                                    parameterList: SyntaxFactory.makeFunctionParameterList([
                                        FunctionParameterSyntax { parameter in
                                            parameter.useFirstName(SyntaxFactory.makeIdentifier("value"))
                                            parameter.useColon(SyntaxFactory.makeColonToken())
                                            parameter.useType(SyntaxFactory.makeTypeIdentifier(propertyType))
                                        }
                                    ]),
                                    rightParen: SyntaxFactory.makeRightParenToken()
                                ))
                                signature.useOutput(SyntaxFactory.makeReturnClause(
                                    arrow: SyntaxFactory.makeArrowToken(),
                                    returnType: SyntaxFactory.makeTypeIdentifier("Void")
                                ))
                            }
                        ) { function in
                            function.useBody(CodeBlockSyntax { body in
                                body.useLeftBrace(SyntaxFactory.makeLeftBraceToken())
                                body.addStatement(CodeBlockItemSyntax {
                                    $0.useItem(SyntaxFactory.makeReturnStmt(expression: FunctionCallExprSyntax {
                                        $0.useCalledExpression(IdentifierExprSyntax { $0.useIdentifier(SyntaxFactory.makeIdentifier("dictionary[.\(caseElement.identifier.text)] = value")) })
                                    }))
                                })
                                body.useRightBrace(SyntaxFactory.makeRightBraceToken())
                            })
                        })
                    })
                    memberDeclBlock.useRightBrace(SyntaxFactory.makeRightBraceToken())
                })
            }
            extensions.append(extensionSyntax)
        }

        return extensions
    }
}
