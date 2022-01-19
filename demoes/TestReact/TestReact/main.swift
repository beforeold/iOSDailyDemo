//
//  main.swift
//  TestReact
//
//  Created by 席萍萍Brook.dinglan on 2021/12/12.
//

import Foundation

public protocol PropsProtocol {
    var children: Array<ElementProtocol>? { get }
}

public protocol RenderableProtocol {
    func render() -> ElementProtocol?
}

public protocol ComponentProtocol: RenderableProtocol {
    associatedtype P: PropsProtocol
    var props: P { get set }
    init(props: P)
}

public protocol ElementProtocol {
    func createComponent() -> RenderableProtocol
}

struct Element<T: ComponentProtocol>: ElementProtocol {
    let componentClass = T.self
    let props: T.P
    
    func createComponent() -> RenderableProtocol {
        return componentClass.init(props: props)
    }
}

class Component<Props: PropsProtocol>: ComponentProtocol {
    var props: Props

    required init(props: Props) {
        self.props = props
    }
    
    func render() -> ElementProtocol? {
        return nil
    }
}

struct User {
    let name: String
}

struct NameCardProps: PropsProtocol {
    let children: Array<ElementProtocol>?
    let user: User
}

class NameCard: Component<NameCardProps> {
    override func render() -> ElementProtocol? {
        return nil
    }
}

let brook = User(name: "brook")
let nancy = User(name: "nancy")

let result = Element<NameCard>(props: NameCardProps(children: nil, user: brook))
print(result)


struct NameCardListProps: PropsProtocol {
    var children: Array<ElementProtocol>?
    let users: [User]
}


struct ViewProps: PropsProtocol {
    var children: Array<ElementProtocol>?
}

class View: Component<ViewProps> {
    
}

class NameCardList: Component<NameCardListProps> {
    override func render() -> ElementProtocol? {
        let children = props.users.map { user in
            Element<NameCard>(props: NameCardProps(children: nil, user: user))
        }
        return Element<View>(props: ViewProps(children: children))
    }
}

let root = Element<NameCardList>(props: .init(
    children: nil,
    users: [brook, nancy]))
print(root)

// print(root.createComponent().render()!)

struct Node {
    let component: RenderableProtocol
    let children: [Node]
}

func render(_ root: ElementProtocol) -> Node {
    let component = root.createComponent()
    var children: Array<Node> = []
    if let childElement = component.render() {
        children = [render(childElement)]
    }
    return Node(component: component, children: children)
}

print(render(root))
