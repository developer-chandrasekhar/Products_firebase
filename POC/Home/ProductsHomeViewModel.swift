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
    @Published var favouriteProducts: [Int] = []
    @Published var selectedCategory = ""
    private var mainProducts: [ProductModel] = []
    private var defaultCategory = "All"
    private let productsService: ProductsService
    private let userService: UserService

    init(productsService: ProductsService = ProductsWebService(), userService: UserService = UserWebService()) {
        self.productsService = productsService
        self.userService = userService
        self.selectedCategory = defaultCategory
        self.favouriteProducts = SessionManager.shared.user?.favouriteProducts ?? []
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

extension ProductsHomeViewModel {
    
    func isFavouriteProduct(_ id: Int) -> Bool {
        return favouriteProducts.contains(id)
    }
    
    func favouriteTapped(_ id: Int) {
        if isFavouriteProduct(id) {
            removeFavourite(productId: id)
        }
        else {
            addFavourite(productId: id)
        }
    }
    
    private func addFavourite(productId: Int) {
        guard let userId = SessionManager.shared.user?.userId else { return }
        Task {
            do {
                try await userService.addFavouriteProduct(userId: userId, productId: productId)
                self.favouriteProducts.append(productId)
                SessionManager.shared.user?.favouriteProducts = self.favouriteProducts
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func removeFavourite(productId: Int) {
        guard let userId = SessionManager.shared.user?.userId else { return }
        Task {
            do {
                try await userService.removeFavouriteProduct(userId: userId, productId: productId)
                self.favouriteProducts = self.favouriteProducts.filter({ $0 != productId })
                SessionManager.shared.user?.favouriteProducts = self.favouriteProducts
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
