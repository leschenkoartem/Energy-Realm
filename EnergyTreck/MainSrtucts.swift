//
//  MainSrtucts.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import Foundation

struct EnergyCompany {
    var name: String
    var choises: [TypeEnergy]
}

struct TypeEnergy {
    var imageName: String
    var mgCofein: Int
    var taste: String
    var mlVolume: [Int]
}

extension EnergyCompany {
    static var data = [
        "PitBull" : EnergyCompany(name: "PitBull", choises: [TypeEnergy(imageName: "PitBullBlack", mgCofein: 32, taste: "Strawberry 32mg", mlVolume: [1000, 500, 250]), TypeEnergy(imageName: "PitBullBlack", mgCofein: 35, taste: "Strawberry 35mg", mlVolume: [1000, 500, 250])]),
        "Battery Energy" : EnergyCompany(name: "Battery Energy", choises: [TypeEnergy(imageName: "BatteryBlack", mgCofein: 32, taste: "Clasic", mlVolume: [500, 330]), TypeEnergy(imageName: "BatteryExotic", mgCofein: 32, taste: "Exotic", mlVolume: [500, 330]), TypeEnergy(imageName: "BatteryMix", mgCofein: 32, taste: "Mix", mlVolume: [500, 330])]),
        "Engri Energy" : EnergyCompany(name: "Engri Energy", choises: [TypeEnergy(imageName: "EngriYellow", mgCofein: 24, taste: "Mango", mlVolume: [900, 500]), TypeEnergy(imageName: "EngriRed", mgCofein: 24, taste: "Watermelon", mlVolume: [900, 500]), TypeEnergy(imageName: "EngriGreen", mgCofein: 24, taste: "Apple", mlVolume: [900, 500])]),
        "NonStop" : EnergyCompany(name: "NonStop", choises: [TypeEnergy(imageName: "NonStopBlue", mgCofein: 32, taste: "Original", mlVolume: [250, 500, 750])]),
        "Black Energy" : EnergyCompany(name: "Black Energy", choises: [TypeEnergy(imageName: "BlackBlue", mgCofein: 32, taste: "Clasic", mlVolume: [1000])])
        
    ]
}
