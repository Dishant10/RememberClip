//
//  CDClipboardItems.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 08/09/23.
//

import Foundation
import CoreData
import Cocoa

extension ClipboardItem {
    
    var text : String {
        get { text_ ?? "" }
        set { text_ = newValue }
    }
    
    var dateCopied : Date {
        
        get{ dateCopied_ ?? Date() }
        set{ dateCopied_ = newValue }
        
    }
    
    convenience init(text : String, dateCopied : Date, context : NSManagedObjectContext){
        
        self.init(context: context)
        self.text = text
        self.dateCopied = dateCopied
        
    }
    
    static func update(text:ClipboardItem,hover:Bool){
        text.hoverAvailable = hover
        PersistenceController.shared.save()
    }
    
    static func delete(text:ClipboardItem){
        
        guard let context = text.managedObjectContext else{ return }
        
        context.delete(text)
    }
    
    
    static func fetch() -> NSFetchRequest<ClipboardItem> {
        let request = ClipboardItem.fetchRequest()
        //request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ClipboardItem.dateCopied_, ascending: false)]
        
        return request
    }
    
    static func deleteAll(){
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "ClipboardItem")

        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let context = PersistenceController.shared.container.viewContext
        
        do {
            let batchDelete = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            ) 
        } catch {
            print("Delete All error : \(error)")
        }
        
    }
    
    
    
    }
