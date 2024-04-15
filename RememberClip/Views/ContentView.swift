//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 20/08/23.
//

import SwiftUI


struct ContentView: View {
    
    @State var selectedType : Int = 1
    @State private var isHoveringOverQuitButton : Bool = false
    @State private var isHoveringOverPreferencesButton : Bool = false
    
    var persistentController = PersistenceController.shared
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(numberOfClipsTobeFetched: 50), animation: .bouncy) var clips
    @Environment(\.managedObjectContext) var context
    @ObservedObject var preferences = Preferences()
    @StateObject var appDelegate = AppDelegate()
    
    //@State var preferencesWindow: NSWindow!
    
    @AppStorage("pinClip") var pinClip: Bool = false
    @AppStorage("pinText") var pinText: String = ""
    @AppStorage("dontPaste") var dontPaste: Bool = false
    
    var body: some View {
        VStack{
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
            VStack(spacing:1){
                
                
                Button {
                    SettingsView.showWindow()
//                    if let preferencesWindow {
//                        
//                        // if a window is already open, focus on it instead of opening another one.
//                        NSApplication.shared.activate(ignoringOtherApps: true)
//                        preferencesWindow.makeKeyAndOrderFront(nil)
//                        return
//                    } else {
//                        let window = NSWindow(
//                            contentRect: NSRect(x: 0, y: 0, width: 280, height: 350),
//                            styleMask: [.closable, .titled],
//                            backing: .buffered,
//                            defer: false
//                        )
//                        
//                        window.title = "RememberClip Preferences"
//                        window.contentView = NSHostingView(rootView: SettingsView())
//                        window.makeKeyAndOrderFront(nil)
//                        window.level = .floating
//                        NSApplication.shared.activate(ignoringOtherApps: true)
//                        
//                        let controller = NSWindowController(window: window)
//                        controller.showWindow(self)
//                        window.makeKeyAndOrderFront(nil)
//                        window.center()
//                        window.orderFrontRegardless()
//                        self.preferencesWindow = window
//                    }

                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(isHoveringOverPreferencesButton ? .gray.opacity(0.3) : .clear)
                            .frame(maxWidth: .infinity,maxHeight:24)
                        
                        HStack{
                            Text("Preferences")
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text(" ⌘ , ")
                                .foregroundStyle(isHoveringOverPreferencesButton == true ? .white : Color.secondary)
                        }
                        .padding([.leading,.trailing],8)
                    }
                    .onHover(perform: { hovering in
                        isHoveringOverPreferencesButton = hovering
                    })
                }
                .buttonStyle(.borderless)
                .padding([.leading,.trailing],4)
                .keyboardShortcut(",")
                
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(isHoveringOverQuitButton ? .gray.opacity(0.3) : .clear)
                            .frame(maxWidth: .infinity,maxHeight:24)
                        
                        HStack{
                            Text("Quit RememberClip")
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text(" ⌘ Q ")
                                .foregroundStyle(isHoveringOverQuitButton == true ? .white : Color.secondary)
                        }
                        
                        .padding([.leading,.trailing],8)
                    }
                    .onHover(perform: { hovering in
                        isHoveringOverQuitButton = hovering
                    })
                }
                .buttonStyle(.borderless)
                .padding([.leading,.trailing],4)
                .keyboardShortcut("q")
            }
            
        }
        .preferredColorScheme(preferences.getPreferredColorScheme())
        .padding(.bottom,4)
        .onPasteboardChange {
                if preferences.dontRemember == false {
                    if !pinClip {
                        readClipboardItems()
                    } else if pinClip {
                        if dontPaste {
                            dontPaste = false
                        }else if dontPaste == false {
                            readClipboardItems()
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(pinText, forType: .string)
                        }
                    }
                }
            }
        .environment(\.managedObjectContext,persistentController.container.viewContext)
    }
    
    func readClipboardItems() {
        let pasteboard = NSPasteboard.general
        let items = pasteboard.pasteboardItems!
        for item in items {
            if let string = item.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                if string == pinText {
                    return
                }
               else if clips.count == 0{
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
