//
//  ViewController.swift
//  TestTableView
//
//  Created by dinglan on 2020/11/26.
//

import UIKit


class MyCell: UITableViewCell {
    static let count: Int = 3
    static let base: CGFloat = 30
    static let height: CGFloat = CGFloat(count) * 30
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(y: CGFloat, text: String) {
        let width = UIScreen.main.bounds.width
        let label2 = UILabel(frame: CGRect(x: 0, y: y, width: width, height: Self.base))
        label2.text = text
        contentView.addSubview(label2)
    }
    
    func setupView() {
        for i in 0..<Self.count {
            addLabel(y: CGFloat(i) * Self.base, text: "label:\(i)")
        }
    }
    
    func bindData(_ data: Any) {
        let control: UIControl
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
    }

    private func createTableView() {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MyCell.self, forCellReuseIdentifier: "mycell")
        
        view.addSubview(tableView)
        
        
    }
    
    @objc func onTap(_ gesture: Any?) {
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "cell: at: \(indexPath.section) - \(indexPath.row)"
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        
        return cell
    }
   
    private func createLabel(text: String, backgroundColor: UIColor) -> UILabel {
        let label = UILabel()
        label.backgroundColor = backgroundColor
        label.textColor = .white
        label.text = text
        
        return label
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        createLabel(text: "Header", backgroundColor: .red)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        createLabel(text: "Footer", backgroundColor: .green)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         MyCell.height
//        44
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
