//
//  ClipboardItems.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 12/08/23.
//

import Foundation
import Cocoa
//import OnPasteboardChange

class ClipboardItems : ObservableObject {
    
    @Published var clipboardSavedItems = [TextType]()
    
    init(){
        loadSavedData()
    }
    
    func copyItem(text : String){
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }
    
    func readClipboardItems() {
        let pasteboard = NSPasteboard.general
        let items = pasteboard.pasteboardItems!
        for item in items {
            if let string = item.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                if clipboardSavedItems.count==0{
                    let newString = TextType(text: string, hoverAvailable: false)
                    clipboardSavedItems.append(newString)
                    saveData()
                }
                else if  clipboardSavedItems.count > 0 && string != clipboardSavedItems[0].text{
                    let newString = TextType(text: string, hoverAvailable: false)
                    clipboardSavedItems.insert(newString, at: 0)
                    //clipboardSavedItems.append(newString)
                    saveData()
                }
            }
        }
    }
    
    func saveData(){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(clipboardSavedItems)
            UserDefaults.standard.set(data, forKey: "clipboardItems")
        }catch{
            print(error)
        }
        
    }
    
    func loadSavedData() {
        if let storedInput = UserDefaults.standard.data(forKey: "clipboardItems"){
            do{
                let decoder = JSONDecoder()
                let items = try decoder.decode([TextType].self, from: storedInput)
                clipboardSavedItems = items
            }
            catch{
                print(error)
            }
        }
    }
    
}
