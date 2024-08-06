//
//  ProductsUploadManager.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation
import FirebaseFirestore

enum LocalJsonParseError: Error {
    case unableToDecode
    case wrongResource
}

struct ProductsUploadManager {
    
    func uploadProducts() {
        Task {
            let products: ProductList = try parseLocalJson(name: "Products")
            print(products.products.count)
            products.products.forEach { product in
                Task {
                    try ProductsUploadService().uploadProduct(product: product)
                }
            }
        }
    }
}

func parseLocalJson<T: Codable>(name: String) throws -> T {
    if let url = Bundle.main.url(forResource: name, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let jsonData: T = try JSONDecoder().decode(T.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
            throw(LocalJsonParseError.unableToDecode)
        }
    }
    throw(LocalJsonParseError.wrongResource)
}

class ProductsUploadService: ProductsWebService {
    func uploadProduct(product: ProductModel) throws {
        var productWithDate = product
        productWithDate.setDate()
        try productDocument(productId: String(product.id)).setData(from: productWithDate, merge: false)
    }
}
