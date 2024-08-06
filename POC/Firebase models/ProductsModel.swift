//
//  ProductsModel.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import Foundation

struct ProductList: Codable {
    let products: [ProductModel]
    
    enum CodingKeys: String, CodingKey {
        case products
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        products = try container.decode([ProductModel].self, forKey: .products)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(products, forKey: .products)
    }
}

struct ProductModel: Codable {
    let id: Int
    let title: String
    let description: String?
    let category: String
    let price: Double
    let images: [String]?
    let thumbnail: String?
    let stock: Int?
    let rating: Double?
    let availableLocation: String?
    var createdDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, category, price, images, thumbnail, stock, rating
        case availableLocation = "available_location"
        case createdDate = "crated_date"
    }
    
    // Decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        price = try container.decode(Double.self, forKey: .price)
        images = try container.decodeIfPresent([String].self, forKey: .images)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        stock = try container.decodeIfPresent(Int.self, forKey: .stock)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        availableLocation = try container.decodeIfPresent(String.self, forKey: .availableLocation)
        createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate)
    }
    
    // Encode to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(price, forKey: .price)
        try container.encode(images, forKey: .images)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(stock, forKey: .stock)
        try container.encode(rating, forKey: .rating)
        try container.encode(availableLocation, forKey: .availableLocation)
        try container.encode(createdDate, forKey: .createdDate)
    }
}

extension ProductModel {
    mutating func setDate() {
        self.createdDate = Date()
    }
}

