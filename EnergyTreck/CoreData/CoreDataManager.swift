//
//  CoreDataManager.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import Foundation
import CoreData

class CoreDataStory: ObservableObject {
    
    static var shared = CoreDataStory()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "StoryCoreData")
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else { print("Error of loading: \(error!.localizedDescription)"); return }
        }
    }
    
    
    func removeEllement(point: StoryModel){
        persistentContainer.viewContext.delete(point)
        
        do{
            try persistentContainer.viewContext.save()
        }catch let error {
            persistentContainer.viewContext.rollback()
            print("Error: \(error.localizedDescription)")
        }
    }

    
    func saveElement(coffein: Int, imageName: String, name: String, taste: String, time: Date = .now, volume: Int) {

        let point = StoryModel(context: persistentContainer.viewContext)
        point.coffein = Int64(coffein)
        point.imageName = imageName
        point.name = name
        point.taste = taste
        point.time = time
        point.volume = Int64(volume)
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
//    func deleateData() {
//        do {
//            try persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "OxygenDataModel")))
//            try persistentContainer.viewContext.save()
//            print("Removed all elements PI")
//        } catch let error {
//            print("Error: \(error.localizedDescription)")
//            persistentContainer.viewContext.rollback()
//        }
//    }
//
    
    func getAllElements() -> [StoryModel] {
        let fetchRequest: NSFetchRequest<StoryModel> = StoryModel.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
//    
//    func getLastElement() -> OxygenDataModel? {
//        let fetchRequest: NSFetchRequest<OxygenDataModel> = OxygenDataModel.fetchRequest()
//        do {
//            return try persistentContainer.viewContext.fetch(fetchRequest).last
//        } catch let error {
//            print("Error: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
}
