//
//  GithubIssueTracker.swift
//  RxSwiftDemo
//
//  Created by Suhit on 18/12/16.
//  Copyright © 2016 Suhit. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxOptional

struct GithubIssueTracker {
    
    let provider: MoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self
                    .findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }

    
    internal func findIssues(_ repository: Repository) -> Observable<[Issue]?> {
        
           return Observable<[Issue]?>.create { (observer) -> Disposable in
                
                self.provider.request(GitHub.issues(repositoryFullName: repository.fullName), completion: { (result) in
                    
                    switch result {
                        
                    case let .success(response):
                        do {
                            guard let JSON = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [[String: AnyObject]] else {
                                observer.onNext(nil)
                                return observer.onCompleted()
                            }
                           
                            let issues = JSON.flatMap { Issue.init(json: $0) }
                            
                            observer.onNext(issues)
                            observer.onCompleted()
                            
                        } catch {
                            observer.onError(error)
                        }
                        
                    case let .failure(error):
                        observer.onError(error)
                    }
                    
                })
            
                return Disposables.create {}
           }
    }

    internal func findRepository(_ name: String) -> Observable<Repository?> {
    
       return Observable<Repository?>.create { (observer) -> Disposable in
            
            self.provider.request(GitHub.repo(fullName: name),
                completion: { (result) in
                
                switch result {
                    
                case let .success(response):
                    
                    do {
                        
                        guard let JSON = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: AnyObject] else {
                            observer.onNext(nil)
                            return observer.onCompleted()
                        }
                        
                        let repo = Repository.init(json: JSON)
                        observer.onNext(repo)
                        observer.onCompleted()
                        
                    } catch {
                        observer.onError(error)
                    }

                case let .failure(error):
                    observer.onError(error)
                }
                
            })
        
            return Disposables.create {}
        
        }
    }
}
