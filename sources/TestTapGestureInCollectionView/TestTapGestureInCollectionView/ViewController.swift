//
//  ViewController.swift
//  TestTapGestureInCollectionView
//
//  Created by 席萍萍Brook.dinglan on 2021/7/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }

    class Cell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            contentView.backgroundColor = .blue
            
            let view = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
            view.backgroundColor = .red
            
            let label = UILabel(frame: .init(x: 50, y: 50, width: 50, height: 50))
            label.backgroundColor = .lightGray
            view.addSubview(label)
            
            contentView.addSubview(view)
            
            let tap =  UITapGestureRecognizer(target: self, action: #selector(onTap))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }
        
        @objc
        func onTap() {
            print("on tap")
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("did select")
    }
}
