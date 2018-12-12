// Copyright (c) 2018 Arcsinus. All rights reserved.
// Description: TODO

import Foundation

import RxSwift

class APIManager {
    
    static func repositoriesBy(_ username: String) -> Observable<[Repository]> {
        if !username.isEmpty, let url = URL(string: "https://api.github.com/users/\(username)/repos") {
            return URLSession.shared.rx.json(url: url).retry(3).map(SearchViewModel.parseJSON)
        } else {
            return Observable.just([])
        }
    }
    
}

