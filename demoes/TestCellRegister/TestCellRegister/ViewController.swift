//
//  ViewController.swift
//  TestCellRegister
//
//  Created by 席萍萍Brook.dinglan on 2021/12/31.
//

import UIKit


class MyCell: UICollectionViewCell {
    
}

struct Person {
    var name: String
}

class ViewController: UIViewController {

    let count = 2
    
    var registerArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRegisterArray()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = MyCollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func setupRegisterArray() {
        let register1 = UICollectionView.CellRegistration<UICollectionViewCell, Person> { cell, indexPath, itemIdentifier in
            cell.contentView.backgroundColor = .yellow
        }
        
        let register2 = UICollectionView.CellRegistration<UICollectionViewCell, Person> { cell, indexPath, itemIdentifier in
            cell.contentView.backgroundColor = .blue
        }
        
        registerArray.append(register1)
        registerArray.append(register2)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // return collectionView.getRegisterFrom(indexPath, of: registerArray, item: indexPath.item)
        let regis = registerArray[indexPath.item] as! UICollectionView.CellRegistration<UICollectionViewCell, Person>
        
        return collectionView.dequeueConfiguredReusableCell(using: regis, for: indexPath, item: Person(name: "Brook"))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
}



protocol Cell {
    associatedtype ViewModel
    func bind(viewModel: ViewModel)
}


class FirstViewModel {
    
}

class FirstCell: UICollectionViewCell, Cell {
    func bind(viewModel: FirstViewModel) {
        
    }
}

class SomeDataSource {
    
}
