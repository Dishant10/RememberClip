//
//  RememberClipApp.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 20/08/23.
//

import SwiftUI
import AppKit
import Cocoa

@main
struct RememberClipApp: App {
    //    @State var selectedType: Int = 1
    //    @StateObject var clipboardItems = ClipboardItems()
    //    @State var showPreferences : Bool = false
    //    @StateObject var savedTextData = SavedTextData()
    //    @FocusState private var focusedField: Bool
    //    @State var inputText : String = ""
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var persistentController = PersistenceController.shared
    
    var body: some Scene {
        
        
        Settings {
            EmptyView().frame(width:.zero)
                .environment(\.managedObjectContext,persistentController.container.viewContext)
        }
    }
}

//        if showPreferences{
//            WindowGroup {
//
//                    Text("Settings Page")
//
//            }
//        }
//        MenuBarExtra("RememberClip", systemImage: "list.clipboard.fill") {
//            VStack{
//                VStack(alignment: .leading)
//                {
//                    //            Button {
//                    //                clipboardItems.readClipboardItems()
//                    //            } label: {
//                    //                Text("Refresh")
//                    //                    .foregroundStyle(Color.secondary)
//                    //            }
//                    //            .padding(.bottom)
//                    Section(){
//                        Text("Select the clip you want to add to your clipboard")
//                            .foregroundStyle(Color.secondary)
//                    }
//                    Divider()
//                    //.padding(.bottom)
//                    //            List{
//
//                        ForEach(0..<clipboardItems.clipboardSavedItems.count, id: \.self) { item in
//                            VStack{
//                                //                        RoundedRectangle(cornerRadius: 5)
//                                //                            .foregroundStyle(clipboardItems.clipboardSavedItems[item].hoverAvailable == true ? .blue : .clear)
//                                Button(action: {
//                                    print("\(clipboardItems.clipboardSavedItems[item].text)")
//                                }, label: {
//                                    Row(clipboardText:clipboardItems.clipboardSavedItems[item].text)
//                                        .foregroundStyle(Color.primary)
//                                        .lineLimit(...1)
//                                })
//
//                            }
//                            .lineLimit(1)
//                            .frame(width: 100,height: 50)
//                        }
//                        //                            .padding(.leading,4)
//                        //                            .padding([.top,.bottom],3)
//
//                }
//                Menu("Saved"){
//                    ForEach(savedTextData.savedTexts,id: \.self){ text in
//                        Button {
//                            print(text)
//                        } label: {
//                            Text(text)
//                        }
//
//                    }
//                    TextField("Text", text: $inputText)
//                        .focused($focusedField)
//                    Button {
//                        if inputText != "" {
//                            savedTextData.savedTexts.append(inputText)
//                            savedTextData.saveData()
//                            inputText = ""
//                            focusedField = false
//                        }
//                        else {
//                            focusedField = false
//                        }
//                    } label: {
//                        Text("Save")
//                            .foregroundStyle(Color.secondary)
//                    }
//
//                }
//                .menuStyle(BorderlessButtonMenuStyle())
//                .menuIndicator(.hidden)
//                .fixedSize()
//                //                            } label: {
//                //                                Text("Saved")
//                //                            }
//
//                //                            .onHover{ hovering in
//                //                                if clipboardItems.clipboardSavedItems.count > 0 {
//                //                                    clipboardItems.clipboardSavedItems[item].hoverAvailable = hovering
//                //                                }
//                //                            }
//                //                            .onTapGesture(count:1) {
//                //                                clipboardItems.copyItem(text: clipboardItems.clipboardSavedItems[item].text)
//                //                                clipboardItems.clipboardSavedItems[item].hoverAvailable = false
//                //                            }
//            }
//            .onPasteboardChange {
//                clipboardItems.readClipboardItems()
//            }
//            .onAppear(perform: {
//
//                clipboardItems.readClipboardItems()
//                clipboardItems.loadSavedData()
//
//            })
//
//
//            //                .listRowSeparator(.hidden)
//            //                .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
//            //                .listStyle(PlainListStyle())
//            //Spacer()
//            //}
//            //.padding(.bottom)
//            Button {
//                clipboardItems.clipboardSavedItems.removeAll()
//                clipboardItems.saveData()
//            } label: {
//                Text("Clear")
//                    .foregroundStyle(Color.secondary)
//            }
//            Button {
//                clipboardItems.readClipboardItems()
//            } label: {
//                Text("Refresh")
//            }
//
//            //Spacer()
//
//            //.padding(.bottom)
//            //                Picker("", selection: $selectedType) {
//            //                    Text("Saved").tag(0)
//            //                    Text("Clipboard").tag(1)
//            //                }
//            //                .pickerStyle(.segmented)
//            //                //.animation(.easeIn)
//            //                //.animation(.easeInOut,value: 30)
//            //
//            //                //Spacer()
//            //                withAnimation(.easeInOut(duration: 50)) {
//            //                    ViewType(selectedType: $selectedType)
//            //                        //.animation(.easeInOut(duration: 5), value: 60)
//            //                }
//            //Spacer()
//            //Divider()
//            //ClipboardView()
//            //                HStack{
//            Button {
//                NSApplication.shared.terminate(nil)
//            }
//        label:{
//            Text("Quit")
//                .foregroundStyle(Color.primary)
//        }.keyboardShortcut("q")
//            Button {
//                showPreferences = true
//                print("YES")
//            }
//        label:{
//            Text("Preferences")
//                .foregroundStyle(Color.primary)
//        }.keyboardShortcut(",")
//            //                    Spacer()
//            //                }
//            //                VStack(alignment: .trailing){
//            //                    Text("Quit")
//            //                        .foregroundStyle(Color.primary)
//            //                        .keyboardShortcut("q")
//            //                        .onTapGesture {
//            //                            NSApplication.shared.terminate(nil)
//            //                        }
//            //                    Text("Preferences")
//            //                        .foregroundStyle(Color.primary)
//            //                        .keyboardShortcut(",")
//            //                        .onTapGesture {
//            //                            print("Preferences Tapped")
//            //                        }
//            //                }
//
//            //.padding()
//            //.animation(.easeInOut, value: 50)
//
//        }
//        .menuBarExtraStyle(.menu)





class AppDelegate : NSObject, NSApplicationDelegate, ObservableObject {
    
    private var statusItem : NSStatusItem!
    private var popover : NSPopover!
    //    @StateObject var clipboardItems = ClipboardItems()
    var persistentController = PersistenceController.shared
    
    
    // @MainActor
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "list.clipboard.fill", accessibilityDescription: "Clipboard Manager")
            statusButton.action = #selector(togglePopover)
            //statusButton.image?.isTemplate = true
        }
        self.popover = NSPopover()
        popover.animates = true
        self.popover.contentSize = NSSize(width: 410, height: 390)
        self.popover.contentViewController?.view.window?.makeKey()
        self.popover.behavior = NSPopover.Behavior.transient
        self.popover.contentViewController = NSHostingController(rootView: ContentView())
        //self.popover.appearance = NSAppearance(named: .accessibilityHighContrastVibrantDark)
        
    }
    
    @objc func togglePopover(){
        
        //self.clipboardItems.loadSavedData()
        
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
                return
            }else{
                popover.show(relativeTo: button.bounds,of: button,preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.makeKey()
                self.popover.behavior = NSPopover.Behavior.transient
            }
        }
    }
    func applicationWillResignActive(_ notification: Notification) {
        if popover.isShown{
            self.popover.performClose(nil)
         }
     }
    
    func closePopover(){
        
        if popover.isShown{
//            self.popover.performClose(nil)
            //dismiss(animated: true, completion: nil)
            return
        }
    }
    
}
