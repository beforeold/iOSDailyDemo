//
//  ViewController.swift
//  TestScrollHitch
//
//  Created by BrookXy on 2022/4/21.
//

import UIKit

class ViewController: UIViewController {

    var thread: OOLiveThread!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let fpsLabel = OOFPSLabel(frame: CGRect(x: 60, y: 0, width: 55, height: 20))
        view.addSubview(fpsLabel)
        
        thread = OOLiveThread(target: self, selector: #selector(onThreadRun), object: nil)
        thread.start()
    }
    
    @objc func onThreadRun() {
        thread.loop()
    }
    
    func task() {
        let timer = Timer(timeInterval: 0.05, repeats: true) { _ in
            Thread.sleep(forTimeInterval: 0.05)
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "row: \(indexPath.row)"
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
        
//        if indexPath.row % 5 == 0 {
//            print("sleep begin \(indexPath.row)")
//            Thread.sleep(forTimeInterval: 0.1)
//            print("sleep end \(indexPath.row)")
//        }
        
        cell.contentView.backgroundColor = .init(red: (CGFloat(indexPath.row % 10) / 10.0),
                                                 green: (CGFloat(10 - indexPath.row % 10) / 10.0),
                                                 blue: (CGFloat(indexPath.row % 10) / 10.0),
                                                 alpha: 1)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 
    }
}
