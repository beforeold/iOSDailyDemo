//
//  ViewController.swift
//  TestPageViewController
//
//  Created by dinglan on 2020/12/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pageVC = UIPageViewController(transitionStyle: .scroll,
                                          navigationOrientation: .vertical,
                                          options: nil)
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .purple
        
        
        pageVC.setViewControllers([vc],
                                  direction: .reverse,
                                  animated: true,
                                  completion: nil)
        
        pageVC.delegate = self
        pageVC.dataSource = self
        
        view.addSubview(pageVC.view)
        addChild(pageVC)
    }
}

extension ViewController: UIPageViewControllerDelegate {
    
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        var frame = UIScreen.main.bounds
        frame.size.height = 100
        vc.view.frame = frame
        return vc
    }
    
    
}

