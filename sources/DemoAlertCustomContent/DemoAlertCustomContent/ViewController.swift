import UIKit

final class ViewController: UIViewController {
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Custom Alert Content"

        button.setTitle("Show alert with switch", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func showAlert() {
        let alert = UIAlertController(
            title: "Hidden Powers",
            message: "Custom content controller embedded below.",
            preferredStyle: .alert
        )

        let content = AlertContentViewController()
        alert.setValue(content, forKey: "contentViewController")

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
}
