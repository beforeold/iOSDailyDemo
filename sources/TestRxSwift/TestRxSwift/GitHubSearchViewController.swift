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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(Cell.self, forCellReuseIdentifier: "cell")
    
    self.inputField.rx.text
      .map { $0 ?? "" }
      .filter { $0.count > 2 }
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .flatMap { RepoModel.searchForGitHub($0) }
      .observe { value in
        print(value)
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
  class Cell: UITableViewCell {
    
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
