// Copyright (c) 2018 Arcsinus. All rights reserved.
// Description: TODO

import RxSwift
import RxCocoa

class SearchViewModel {
    
    let searchText = Variable("")
    
    lazy var data: Driver<[Repository]> = {
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(APIManager.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func parseJSON(json: Any) -> [Repository] {
        if let items = json as? [[String : Any]] {
            var repositories: [Repository] = []
            for i in items {
                if let name = i["name"] as? String, let url = i["html_url"] as? String {
                    repositories.append(Repository(repoName: name, repoURL: url))
                }
            }
            
            return repositories
        } else {
            return []
        }
    }
    
}
