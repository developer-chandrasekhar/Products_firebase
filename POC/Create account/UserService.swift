//
//  UserService.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation
import FirebaseFirestore

enum FirCollectionNames: String {
    case users
    case products
}

protocol UserService {
    func createUserProfile(user: UserModel) async throws -> UserModel
    func getUserProfile(userId: String) async throws -> UserModel
    func deleteUser(userId: String) async throws -> Bool
    func addFavouriteProduct(userId: String, productId: Int) async throws
    func removeFavouriteProduct(userId: String, productId: Int) async throws
}

extension UserService {
    
    var userCollection: CollectionReference {
        return Firestore.firestore().collection(FirCollectionNames.users.rawValue)
    }
    
    func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
}

struct UserWebService: UserService {
    func getUserProfile(userId: String) async throws -> UserModel {
        do {
           return try await userCollection.document(userId).getDocument(as: UserModel.self)
        }
        catch { throw error }
    }
    
    func createUserProfile(user: UserModel) async throws -> UserModel {
        do {
            try userDocument(userId: user.userId).setData(from: user, merge: false)
            return user
        }
        catch { throw error }
    }
    
    func deleteUser(userId: String) async throws -> Bool {
        do {
            try await userDocument(userId: userId).delete()
            return true
        } catch { throw error }
    }

    func addFavouriteProduct(userId: String, productId: Int) async throws {
        let data = [UserModel.CodingKeys.favouriteProducts.rawValue : FieldValue.arrayUnion([productId])]
        do {
           try await userDocument(userId: userId).updateData(data)
        } catch { throw error }
    }
    
    func removeFavouriteProduct(userId: String, productId: Int) async throws {
        let data = [UserModel.CodingKeys.favouriteProducts.rawValue : FieldValue.arrayRemove([productId])]
        do {
           try await userDocument(userId: userId).updateData(data)
        } catch { throw error }
    }
}
