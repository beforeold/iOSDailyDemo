import Cocoa

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }

  @objc
  func paste(_ sender: Any?) {
      let pasteboard = NSPasteboard.general
    let classes = [NSString.self, NSImage.self] // Specify the types of data you want to handle
      let options = [NSPasteboard.ReadingOptionKey: Any]()

      if pasteboard.canReadObject(forClasses: classes, options: options) {
          if let copiedItems = pasteboard.readObjects(forClasses: classes, options: options) as? [String] {
              let pastedString = copiedItems.first

              if let pastedString = pastedString {
                  // Handle the pasted string
                  print("Pasted string: \(pastedString)")
              }
          }
      }
  }
}
