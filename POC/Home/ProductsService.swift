//
//  ProductsService.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation
import FirebaseFirestore

protocol ProductsService {
    func getAllProducts() async throws -> [ProductModel]
}

extension ProductsService {
    var productsCollection: CollectionReference {
        return Firestore.firestore().collection(FirCollectionNames.products.rawValue)
    }
    
    func productDocument(productId: String) -> DocumentReference {
        return productsCollection.document(productId)
    }
}

class ProductsWebService: ProductsService {
    func getAllProducts() async throws -> [ProductModel] {
        do {
            let snapshot = try await productsCollection.getDocuments()
            return try snapshot.documents.map { try $0.data(as: ProductModel.self) }
        }
        catch { throw error }
    }
}

class ProductsMockService: ProductsService {
    func getAllProducts() async throws -> [ProductModel] {
        do {
            let products: ProductList = try parseLocalJson(name: "Products")
            return products.products
        }
        catch { throw error }
    }
}
