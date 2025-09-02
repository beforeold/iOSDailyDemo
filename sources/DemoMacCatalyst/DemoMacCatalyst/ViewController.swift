import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupButton()
    
    #if targetEnvironment(macCatalyst)
    setupMacNotifications()
    #endif
  }
  
  #if targetEnvironment(macCatalyst)
  private func setupMacNotifications() {
    // 监听Mac专有功能启用通知
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleMacFeaturesEnabled),
      name: NSNotification.Name("MacFeaturesEnabled"),
      object: nil
    )
  }
  
  @objc private func handleMacFeaturesEnabled() {
    print("ViewController: Mac专有功能已启用")
    // 可以在这里添加Mac专有的UI更新
  }
  
  // 添加Mac专有的键盘快捷键支持
  override var keyCommands: [UIKeyCommand]? {
    return [
      UIKeyCommand(
        input: "m",
        modifierFlags: .command,
        action: #selector(showMacOnlyFeature),
        discoverabilityTitle: "Mac专有功能"
      ),
      UIKeyCommand(
        input: "n",
        modifierFlags: .command,
        action: #selector(showNewWindowFeature),
        discoverabilityTitle: "新建窗口"
      ),
      UIKeyCommand(
        input: "w",
        modifierFlags: .command,
        action: #selector(showCloseWindowFeature),
        discoverabilityTitle: "关闭窗口"
      )
    ]
  }
  
  @objc private func showNewWindowFeature() {
    let alert = UIAlertController(title: "新建窗口", message: "这是Mac专有的新建窗口功能！\n\n通过键盘快捷键 Cmd+N 触发", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "确定", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
  
  @objc private func showCloseWindowFeature() {
    let alert = UIAlertController(title: "关闭窗口", message: "这是Mac专有的关闭窗口功能！\n\n通过键盘快捷键 Cmd+W 触发", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "确定", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
  
  deinit {
    #if targetEnvironment(macCatalyst)
    NotificationCenter.default.removeObserver(self)
    #endif
  }
  #endif
  
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
    
    // Mac专有功能按钮
    #if targetEnvironment(macCatalyst)
    let macButton = UIButton(type: .system)
    macButton.setTitle("Mac专有功能", for: .normal)
    macButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    macButton.backgroundColor = UIColor.systemPurple
    macButton.setTitleColor(.white, for: .normal)
    macButton.layer.cornerRadius = 8
    macButton.translatesAutoresizingMaskIntoConstraints = false
    
    macButton.addTarget(self, action: #selector(showMacOnlyFeature), for: .touchUpInside)
    
    view.addSubview(macButton)
    
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 50),
      
      macButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      macButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
      macButton.widthAnchor.constraint(equalToConstant: 200),
      macButton.heightAnchor.constraint(equalToConstant: 50)
    ])
    #else
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 50)
    ])
    #endif
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
  
  #if targetEnvironment(macCatalyst)
  @objc private func showMacOnlyFeature() {
    let alert = UIAlertController(title: "Mac专有功能", message: "🎉 这是Mac专有功能！\n\n• Mac风格的窗口标题\n• 键盘快捷键支持\n• Mac原生交互体验\n• 系统集成\n\n这个功能只在Mac上显示！", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "太棒了！", style: .default) { _ in
      print("用户体验了Mac专有功能")
    }
    
    let shortcutAction = UIAlertAction(title: "查看快捷键", style: .default) { _ in
      self.showKeyboardShortcuts()
    }
    
    alert.addAction(okAction)
    alert.addAction(shortcutAction)
    
    present(alert, animated: true)
  }
  
  private func showKeyboardShortcuts() {
    let alert = UIAlertController(title: "Mac键盘快捷键", message: "您可以使用以下Mac专有快捷键：\n\n• Cmd+N: 新建窗口\n• Cmd+W: 关闭窗口\n• Cmd+M: Mac专有功能\n• Cmd+Q: 退出应用\n\n这些快捷键只在Mac上有效！", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "了解", style: .default)
    alert.addAction(okAction)
    
    present(alert, animated: true)
  }
  #endif

}

