//
//  CollectionViewController.swift
//  TestDiffableCollectionView
//
//  Created by 席萍萍Brook.dinglan on 2021/10/29.
//

import UIKit

private let reuseIdentifier = "Cell"


class MyCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("create instance ---> \(self)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static var identifier: String {
        NSStringFromClass(self)
    }
}

@objc(CellA) class CellA: MyCell {}
@objc(CellB) class CellB: MyCell {}
@objc(CellC) class CellC: MyCell {}
@objc(CellD) class CellD: MyCell {}
@objc(CellE) class CellE: MyCell {}

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var count: Int {
        clzList.count
    }
    
    lazy var colors: [UIColor] = {
        [
            .blue,
            .black,
            .red,
            .yellow,
            .cyan,
//            .green,
//            .purple,
        ]
    }()
    
    let clzList: [MyCell.Type] = ["A", "B", "C", "D", "E"].map {
        NSClassFromString("Cell\($0)")! as! MyCell.Type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        clzList.forEach { clz in
            let id = clz.identifier
            self.collectionView.register(clz, forCellWithReuseIdentifier: id)
        }
        
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .zero
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        self.collectionView.isPagingEnabled = true

        // Do any additional setup after loading the view.
    }

    func diffable() {
        _ = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return nil;
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return count * 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let clz = clzList[self.index(indexPath: indexPath)]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: clz.identifier,
                                                      for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = colors[indexPath.item % colors.count]
    
        return cell
    }
    
    func index(indexPath: IndexPath) -> Int {
        indexPath.item % clzList.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height * 0.1)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
