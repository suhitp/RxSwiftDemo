//
//  GithubSearchTableViewController.swift
//  RxSwiftDemo
//
//  Created by Suhit on 18/12/16.
//  Copyright © 2016 Suhit. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya

fileprivate let reuseIdentifier = "Cell"

class GithubSearchTableViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated (protect against retain cycle)
    
    var provider: MoyaProvider<GitHub>!
    var githubIssueTracker: GithubIssueTracker!
    
    var repositoryName: Observable<String> {
        return searchBar.rx.text
            .filterNil()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        provider = MoyaProvider<GitHub>()
        githubIssueTracker = GithubIssueTracker(provider: provider, repositoryName: repositoryName)
        
        githubIssueTracker.trackIssues()
            .bindTo(tableView.rx.items) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.title
                
                return cell
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe { indexPath in
                if self.searchBar.isFirstResponder == true {
                    self.view.endEditing(true)
                }
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
