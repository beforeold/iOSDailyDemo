//
//  GitHubSearchViewController.swift
//  TestRxSwift
//
//  Created by beforeold on 2022/10/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import SwiftyJSON

fileprivate func validStrig(_ string: String?) -> Bool {
  return (string?.count ?? 0) > 0
}

class GitHubSearchViewController: UIViewController {
  
  @IBOutlet weak var inputField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var bag = DisposeBag()
  
  var repoReplay = BehaviorRelay<[RepoModel]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(RepoCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    
    tableView.budDidSelectObservable.observe { tableView, indexPath in
      tableView.deselectRow(at: indexPath, animated: true)
    }.disposed(by: bag)
    
    self.inputField.rx.text
      .map { $0 ?? "" }
      .filter { $0.count > 2 }
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .flatMap { RepoModel.searchForGitHub($0) }
      .subscribe(onNext: _4_handle(repos:), onError: showError)
      .disposed(by: bag)
  }
  
  typealias SectionTableModel = SectionModel<String, RepoModel>
  typealias RepositoryModel = RepoModel
  
  let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel> { dataSource, tableView, indexPath, model in
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = model.full_name
    cell.detailTextLabel?.text = model.description
    return cell
  }
  
  private func createGithubSectionModel(
    repoInfo: [RepositoryModel]
  ) -> [SectionTableModel] {
    
    var ret: [SectionTableModel] = []
    var items: [RepositoryModel] = []
    
    if (repoInfo.count <= 10) {
      let sectionLabel = "Top 1 - 10"
      items = repoInfo
      
      ret.append(SectionTableModel(
        model: sectionLabel, items: items))
    }
    else {
      for i in 1...repoInfo.count {
        items.append(repoInfo[i - 1])
        
        if (i / 10 != 0 && i % 10 == 0) {
          let sectionLabel =
          "Top \(i - 9) - \(i)"
          
          ret.append(
            SectionTableModel(
              model: sectionLabel,
              items: items))
          
          items = []
        }
      }
    }
    
    return ret
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
    repoReplay.accept(repos)
  }
  
  private func _3_bindTableView() {
    repoReplay.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: RepoCell.self)) {_, model, cell in
      cell.textLabel?.text = model.full_name
      cell.detailTextLabel?.text = model.description
    }.disposed(by: bag)
  }
  
  /// 第四种，使用自定义的 dataSource
  private func _4_handle(repos: [RepoModel]) {
    self.tableView.dataSource = nil
    Observable
      .just(self.createGithubSectionModel(repoInfo: repos))
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.bag)
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

extension GitHubSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionCount = self.dataSource
        .numberOfSections(in: tableView)
    guard sectionCount != 0 else {
        return nil
    }

    let label = UILabel(frame: CGRect.zero)
    label.text = self.dataSource.sectionModels[section].model

    return label
  }
}

private extension Selector {
    static let didSelectRowAtIndexPath = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
}

fileprivate extension UITableView {
  var budDelegate: GitHubSearchViewController.MyDelegateProxy {
    return .proxy(for: self)
  }
  
  var budDidSelectObservable: Observable<(UITableView, IndexPath)> {
    return budDelegate
      .methodInvoked(.didSelectRowAtIndexPath)
      .map { params in
        return (params[0] as! Self, params[1] as! IndexPath)
      }
  }
}

extension GitHubSearchViewController {
  class MyDelegateProxy: DelegateProxy<UITableView, UITableViewDelegate>
  , DelegateProxyType
  , UITableViewDelegate {
    static func registerKnownImplementations() {
      self.register { parent in
        return MyDelegateProxy(parentObject: parent,
                               delegateProxy: MyDelegateProxy.self)
      }
    }
    
    static func currentDelegate(for object: UITableView) -> UITableViewDelegate? {
      object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UITableViewDelegate?, to object: UITableView) {
      object.delegate = delegate
    }
    
    
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
      let fullName = subJson["full_name"].stringValue
      let description = subJson["description"].stringValue
      let htmlUrl = subJson["html_url"].stringValue
      let avatarUrl = subJson["owner"]["avatar_url"].stringValue
      
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
