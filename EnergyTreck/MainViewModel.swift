//
//  MainViewModel.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var pickedView = Tab.already
    @Published var pickedCompany = EnergyCompany.data.keys.first ?? "Error" {
        didSet {
            self.pickedDrink = EnergyCompany.data[pickedCompany]!.choises.first
        }
    }
    
    @Published var pickedDrink = EnergyCompany.data.values.first!.choises.first {
        didSet { self.pickedVolume = pickedDrink?.mlVolume.first }
    }
    
    @Published var pickedVolume = EnergyCompany.data.values.first!.choises.first?.mlVolume.first
    
    //MARK: - For custom
    @Published var companyName = ""
    @Published var taste = ""
    @Published var mlVolume = ""
    @Published var mgCoffeinPer100 = ""
    
    @Published var datalist = [StoryModel]()
    
    @Published var showAlert = false
    @Published var textAlert = "" { didSet { showAlert = true } }
    
    func updateData() {
        datalist = CoreDataStory.shared.getAllElements()
    }
    
    func deleteItems(with items: [StoryModel]) {
            for item in items {
                if let index = datalist.firstIndex(where: { $0.id == item.id }) {
                    // Викликаємо функцію для видалення з бази даних
                    CoreDataStory.shared.removeEllement(point: datalist[index])
                    datalist.remove(at: index)
                }
            }
        }
    
    func formatVolumeString(_ volume: Double) -> String {
        let formattedString = String(format: "(%.2f L)", volume)
        let trimmedString = formattedString.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        return trimmedString
    }
    
    func saveDrink() {
        if pickedView == .already {
            guard let picked = pickedDrink else { textAlert = "Something went wrong."; return }
            CoreDataStory.shared.saveElement(coffein: picked.mgCofein,
                                             imageName: picked.imageName,
                                             name: pickedCompany,
                                             taste: picked.taste,
                                             volume: pickedVolume ?? 500)
            
        } else {
            guard let cofeinInt = Int(mgCoffeinPer100) else { textAlert = "Incorrect amount of caffeine"; return }
            guard let mlVolumeInt = Int(mlVolume) else { textAlert = "Incorrect amount of drink"; return }
            CoreDataStory.shared.saveElement(coffein: cofeinInt, imageName: "Placeholder", name: companyName, taste: taste, volume: mlVolumeInt)
            
            withAnimation {
                companyName = ""
                taste = ""
                mlVolume = ""
                mgCoffeinPer100 = ""
            }
        }
        
        updateData()
    }
}


enum Tab {
    case custom
    case already
}
