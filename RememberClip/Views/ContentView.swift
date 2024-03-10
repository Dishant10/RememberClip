//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 20/08/23.
//

import SwiftUI


struct ContentView: View {
    
    @State var selectedType : Int = 1
    //@State var showPreferences = false
    @State private var isHoveringOverQuitButton : Bool = false
    @State private var isHoveringOverPreferencesButton : Bool = false
    
    var persistentController = PersistenceController.shared
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(), animation: .bouncy) var clips
    @Environment(\.managedObjectContext) var context
    @StateObject var appDelegate = AppDelegate()
    
    var body: some View {
        Section{
            Picker("", selection: $selectedType) {
                Text("Saved").tag(0)
                Text("Clipboard").tag(1)
            }
            .padding([.top,.leading,.trailing])
            .pickerStyle(.segmented)
            ViewType(selectedType: $selectedType)
                .padding([.leading,.trailing])
        }
            Divider()
            Section{

                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(isHoveringOverQuitButton ? .gray.opacity(0.3) : .clear)
                        .frame(maxWidth: .infinity,maxHeight:25)
                    
                    HStack{
                        Text("Quit")
                        Spacer()
                        Text(" ⌘ Q ")
                            .foregroundStyle(isHoveringOverQuitButton == true ? .white : Color.secondary)
                    }
                    
                    .padding([.leading,.trailing],7)
                     .padding([.top],3)
                }.onTapGesture {
                    NSApplication.shared.terminate(nil)
                    
                }
                .padding([.leading,.trailing],5)
                .padding(.bottom,7)
                .onHover(perform: { hovering in
                    isHoveringOverQuitButton = hovering
                })
                .keyboardShortcut("q")
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(isHoveringOverPreferencesButton ? .gray.opacity(0.3) : .clear)
                        .frame(maxWidth: .infinity,maxHeight:25)
                    
                    HStack{
                        Text("Preferences")
                        Spacer()
                        Text(" ⌘ , ")
                            .foregroundStyle(isHoveringOverPreferencesButton == true ? .white : Color.secondary)
                    }
                    
                    .padding([.leading,.trailing],7)
                     .padding([.bottom],3)
                }.onTapGesture {
                    SettingsView.showWindow()
                    
                }
                .padding([.leading,.trailing],5)
                .padding(.bottom,7)
                .onHover(perform: { hovering in
                    isHoveringOverPreferencesButton = hovering
                })
                .keyboardShortcut(",")
            }
            .onPasteboardChange {
                readClipboardItems()
            }
        .environment(\.managedObjectContext,persistentController.container.viewContext)
    }
    
    func readClipboardItems() {
            let pasteboard = NSPasteboard.general
            let items = pasteboard.pasteboardItems!
            for item in items {
                if let string = item.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                    if clips.count == 0{
                        _ = ClipboardItem(text: string, dateCopied: Date(), context: context)
                        PersistenceController.shared.save()
                    }else if clips.first?.text == string {
                        return
                    }
                    else{
                        _ = ClipboardItem(text: string, dateCopied: Date(), context: context)
                        PersistenceController.shared.save()
                    }
                }
            }
            
        }

}

struct ViewType:View {
    
    @State var searchText = ""
    @Binding var selectedType : Int
    var body: some View {
        switch selectedType{
        case 0:
            TextingView()
        case 1:
            ClipboardView()
        default:
            Text("Not selected anything")
        }
    }
}
