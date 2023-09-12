//
//  CDSavedTexts.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 08/09/23.
//

import Foundation
import CoreData

extension SavedText {
    
    var savedText : String {
        
        get { savedText_  ?? "" }
        set { savedText_ = newValue }
        
    }
    
    convenience init(savedText : String,context : NSManagedObjectContext){
        
        self.init(context: context)
        self.savedText = savedText
        
    }
    
    static func delete(text:SavedText){
        guard let context = text.managedObjectContext else{ return }
        
        context.delete(text)
    }
    
    static func fetch() -> NSFetchRequest<SavedText> {
        let request = SavedText.fetchRequest()
        //request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SavedText.savedText_, ascending: true)]
        
        return request
    }
    
}
