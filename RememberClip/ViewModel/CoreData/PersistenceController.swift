//
//  PersistenceController.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 08/09/23.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container : NSPersistentContainer
    
    init(){
        
        self.container = NSPersistentContainer(name: "CDRememberClip")
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError?{
                fatalError("Error loading container : \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func save(){
        
        let context = container.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do{
            try context.save()
        }
        catch{
            print("Error saving content : \(error)")
        }
        
    }
    
    func save2(){
        let context = container.viewContext
                
        do{
            try context.save()
        }
        catch{
            print("Error saving content : \(error)")
        }

    }
    
}
