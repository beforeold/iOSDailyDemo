//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import UIKit
import Combine

var greeting = "Hello, playground"

func fa() {
    let publisher = PassthroughSubject<Int, Never>()
    
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
    
    publisher.sub()
    
    publisher.send(3)
    publisher.send(completion: .finished)
}

class Global {
    static var publisher: Any?
    static var cancel: Any?
}


extension Publisher {
    func sub() {
        Swift.print("开始订阅")
        let publisher = self
        let cancel = publisher.sink(
            receiveCompletion: { complete in
                Swift.print(complete)
            },
            receiveValue: { value in
                Swift.print(value)
            }
        )
        
//        Global.publisher = publisher
//        Global.cancel = cancel
    }
}

func fb() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    publisher.value = 1
    publisher.value = 2
    publisher.send(completion: .finished)
    
    publisher.sub()
}

func fc() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    
    publisher.sub()
    
    publisher.value = 1
    publisher.value = 2
    publisher.send(3)
    publisher.send(completion: .finished)
    print("--- \(publisher.value) ---")
}

//fa()
//fb()
 fc()


class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

