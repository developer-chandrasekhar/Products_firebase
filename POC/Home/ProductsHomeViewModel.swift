//
//  ProductsHomeViewModel.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import Foundation

@MainActor
final class ProductsHomeViewModel: ObservableObject {
    
    @Published var products: [ProductModel] = []
    @Published var productsCategories: [String] = []
    @Published var selectedCategory = ""
    private var mainProducts: [ProductModel] = []
    private let productsService: ProductsService
    private var defaultCategory = "All"
    
    init(productsService: ProductsService = ProductsWebService()) {
        self.productsService = productsService
        self.selectedCategory = defaultCategory
    }
}

extension ProductsHomeViewModel {
    func getAllProducts() {
        Task {
            do {
                self.mainProducts = try await productsService.getAllProducts()
                self.products = self.mainProducts
                self.getCategories()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getCategories() {
        let categories = Set(self.products.map { $0.category })
        productsCategories = [defaultCategory] + categories
    }
    
    func filterByCategory(category: String) {
        self.selectedCategory = category
        self.products = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if category == self.defaultCategory {
                self.products = self.mainProducts
                return
            }
            self.products = self.mainProducts.filter({ $0.category == category })
        }
    }
}
