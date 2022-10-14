//
//  GitHubSearchViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

fileprivate func validStrig(_ string: String?) -> Bool {
  return (string?.count ?? 0) > 0
}

class GitHubSearchViewController: UIViewController {
  
  @IBOutlet weak var inputField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var bag = DisposeBag()
  
  var listSubject = BehaviorRelay<[RepoModel]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(RepoCell.self, forCellReuseIdentifier: "cell")
    
    self.inputField.rx.text
      .map { $0 ?? "" }
      .filter { $0.count > 2 }
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .flatMap { RepoModel.searchForGitHub($0) }
      .subscribe(onNext: handle(repos:), onError: showError)
      .disposed(by: bag)
  }
  
  private func showError(_ error: Error) {
    let vc = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    vc.addAction(action)
    
    present(vc, animated: true)
  }
  
  /// 第一种方式：先声明变量，再通过 just 绑定
  private func handle(repos: [RepoModel]) {
    typealias List = [RepoModel]
    typealias O = Observable<List>
    typealias CC = (Int, RepoModel, RepoCell) -> Void
    typealias BinderType = (O) -> (@escaping CC) -> Disposable
    
    let binder: BinderType = self.tableView.rx.items(cellIdentifier: "cell")
    
    let configure: CC = { index, model, cell -> Void in
      cell.textLabel?.text = model.full_name
      cell.detailTextLabel?.text = model.description
    }
    
    // clear before binding
    self.tableView.dataSource = nil
    Observable.just(repos).bind(to: binder, curriedArgument: configure)
      .disposed(by: self.bag)
  }
  
  /// 第二种，优化第一种，更清晰的实现
  private func _2_handle(repos: [RepoModel]) {
    // clear before binding
    self.tableView.dataSource = nil
    
    Observable
      .just(repos)
      .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: RepoCell.self)) { index, model, cell in
        cell.textLabel?.text = model.full_name
        cell.detailTextLabel?.text = model.description
      }
      .disposed(by: self.bag)
  }
  
  /// 第三种，借用一个 BehaviorRelay，事先进行绑定，只需要在请求结束时传入数据
  private func _3_handle(repos: [RepoModel]) {
    listSubject.accept(repos)
  }
  
  private func _3_bindTableView() {
    listSubject.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: RepoCell.self)) {_, model, cell in
      cell.textLabel?.text = model.full_name
      cell.detailTextLabel?.text = model.description
    }.disposed(by: bag)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension GitHubSearchViewController {
  class RepoCell: UITableViewCell {
    
  }
}

struct RepoModel {
  var full_name: String
  var description: String
  var html_url: String
  var avatar_url: String
  
  static func parseModel(_ value: Any) -> [RepoModel] {
    let json = JSON(value)
    let items = json["items"]
    
    var info = [RepoModel]()
    
    for (_, subJson): (String, JSON) in items {
      let fullName = subJson["full_name"].string!
      let description = subJson["description"].string!
      let htmlUrl = subJson["html_url"].string!
      let avatarUrl = subJson["owner"]["avatar_url"].string!
      
      info.append(.init(full_name: fullName,
                        description: description,
                        html_url: htmlUrl,
                        avatar_url: avatarUrl))
    }
    
    return info
  }
}

extension RepoModel {
  fileprivate static func searchForGitHub(_ repo: String) -> Observable<[RepoModel]> {
    return .create { sub in
      let url = "https://api.github.com/search/repositories"
      let parameters = [
        "q": repo + " stars:>=2000"
      ]
      let request = AF.request(url, parameters: parameters)
        .responseJSON { resp in
          if let error = resp.error {
            sub.onError(error)
            return
          }
          
          enum NilError: Error { case none }
          
          guard let value = resp.value else {
            sub.onError(NilError.none)
            return;
          }
          
          sub.onNext(RepoModel.parseModel(value))
          sub.onCompleted()
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
}
