//
//  Preferences.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 10/03/24.
//

import Foundation
import SwiftUI

class Preferences: ObservableObject {
    
    @AppStorage("launchAtLoginToggle") var launchAtLoginToggle: Bool = false
    @AppStorage("scrollIndication") var scrollIndication: Bool = true
    @AppStorage("numberOfClips") var numberOfClips: String = "25"
    @AppStorage("appearanceSelection") var appearanceSelection: String = "Dark"
    @AppStorage("showSearchBar") var showSearchBar: Bool = true
    @AppStorage("themeColor") var themeColor: Color = .blue
    
    let pickerValues = ["Dark","Light","Automatic"]
    
    func getPreferredColorScheme() -> ColorScheme? {
        switch appearanceSelection {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil
        }
    }
    
    func limitText(_ upper: Int) {
        if numberOfClips.count > upper {
            self.numberOfClips  = String(numberOfClips.prefix(upper))
        }
    }
    
}



extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }
    
    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }
    
}
