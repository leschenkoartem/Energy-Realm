//
//  CoreDataManager.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import Foundation
import RealmSwift

final class StoryObject: Object {
    @Persisted var id = UUID()
    @Persisted var coffein: Int 
    @Persisted var imageName: String
    @Persisted var name: String
    @Persisted var taste: String
    @Persisted var volume: Int
    @Persisted var time: Date
}

class RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    func addObjectToRealm(coffein: Int, imageName: String, name: String, taste: String, volume: Int) {
        do {
            let realm = try Realm()
            let toAdd = StoryObject()
            
            toAdd.coffein = coffein
            toAdd.imageName = imageName
            toAdd.name = name
            toAdd.taste = taste
            toAdd.volume = volume
            toAdd.time = .now
            print(toAdd)
            try realm.write {
                realm.add(toAdd)
            }
        } catch {
            print("Помилка при додаванні об'єкта в Realm: \(error)")
        }
    }
    
    func getAllObjectsFromRealm() -> [StoryObject] {
        do {
            let realm = try Realm()
            return Array(realm.objects(StoryObject.self))
        } catch {
            print("Помилка при отриманні об'єктів з Realm: \(error)")
            return []
        }
    }
    
    func deleteObjectFromRealm(storyObject: StoryObject) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(storyObject)
            }
        } catch {
            print("Помилка при видаленні об'єкта з Realm: \(error)")
        }
    }
}
