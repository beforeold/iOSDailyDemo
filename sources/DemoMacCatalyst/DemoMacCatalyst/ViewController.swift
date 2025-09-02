import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupButton()
  }
  
  private func setupButton() {
    let button = UIButton(type: .system)
    button.setTitle("显示弹出警告", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    button.backgroundColor = UIColor.systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.addTarget(self, action: #selector(showPopoverAlert), for: .touchUpInside)
    
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  @objc private func showPopoverAlert() {
    let alert = UIAlertController(title: "弹出警告", message: "这是一个弹出式警告视图控制器", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "确定", style: .default) { _ in
      print("用户点击了确定按钮")
    }
    
    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
      print("用户点击了取消按钮")
    }
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    // 在iPad和Mac Catalyst上设置为popover样式
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
      popover.permittedArrowDirections = []
    }
    
    present(alert, animated: true)
  }

}

