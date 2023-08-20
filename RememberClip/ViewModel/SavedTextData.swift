//
//  SavedTextData.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 12/08/23.
//

import Foundation

class SavedTextData : ObservableObject{
    
    @Published var savedTexts : [String] = []
    
    init(){
        loadSavedData()
    }
    func saveData(){
        UserDefaults.standard.set(savedTexts, forKey: "savedTexts")
        
    }
    
    func loadSavedData() {
        if let storedInput = UserDefaults.standard.array(forKey: "savedTexts") as? [String] {
            savedTexts = storedInput
        }
    }
    
}
