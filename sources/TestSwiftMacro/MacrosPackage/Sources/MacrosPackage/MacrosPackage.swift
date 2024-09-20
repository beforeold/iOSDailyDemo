// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "MacrosPackageMacros", type: "StringifyMacro")


@freestanding(expression)
public macro simpleMacro() -> Int = #externalMacro(module: "MacrosPackageMacros", type: "SimpleMacro")

@freestanding(expression)
public macro doubleMacro(_ value: Int) -> Int = #externalMacro(module: "MacrosPackageMacros", type: "DoubleMacro")

@freestanding(declaration, names: arbitrary)
public macro generateGreetFunction() = #externalMacro(module: "MacrosPackageMacros", type: "GreetMacro")
