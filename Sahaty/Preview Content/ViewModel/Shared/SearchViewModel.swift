//
//  SearchViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/22/24.
//


import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { query in
                print("Search query updated: \(query)")
            }
            .store(in: &cancellables)
    }
}
