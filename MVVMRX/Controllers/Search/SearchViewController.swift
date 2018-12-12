// Copyright (c) 2018 Arcsinus. All rights reserved.
// Description: TODO

import UIKit

import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    
    var searchViewModel: SearchViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel = SearchViewModel()
        
        setupRx()
        setupSearchBar()
    }
    
    func setupRx() {
        searchViewModel?.data
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.repoName
                cell.detailTextLabel?.text = repository.repoURL
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.isSelected = false
                    
                    if let url = URL(string: cell.detailTextLabel?.text ?? "") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: searchViewModel!.searchText)
            .disposed(by: disposeBag)
        
        searchViewModel!.data.asDriver()
            .map { "\($0.count) репозиториев"}
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = ""
        searchBar.placeholder = "MoriDaffy"
        searchBar.autocapitalizationType = .none
        tableView.tableHeaderView = searchController.searchBar
    }
    
}
