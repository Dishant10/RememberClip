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
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var persistentController = PersistenceController.shared
    
    var body: some Scene {
        
        Settings {
            EmptyView().frame(width:.zero)
                .environment(\.managedObjectContext,persistentController.container.viewContext)
        }
    }
}



class AppDelegate : NSObject, NSApplicationDelegate, ObservableObject {
    
    private var statusItem : NSStatusItem!
    private var popover : NSPopover!
    
    var persistentController = PersistenceController.shared
    
    // @MainActor
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            if #available(macOS 13.0, *) {
                statusButton.image = NSImage(systemSymbolName: "list.clipboard.fill", accessibilityDescription: "Clipboard Manager")
            }
            else{
                statusButton.image = NSImage(systemSymbolName: "rectangle.and.paperclip", accessibilityDescription: "Clipboard Manager")
            }
            statusButton.action = #selector(togglePopover)
            //statusButton.image?.isTemplate = true
        }
        self.popover = NSPopover()
        popover.animates = true
        self.popover.contentSize = NSSize(width: 385, height: 370)
        self.popover.contentViewController?.view.window?.makeKey()
        self.popover.behavior = NSPopover.Behavior.transient
        self.popover.contentViewController = NSHostingController(rootView: ContentView().environment(\.managedObjectContext,persistentController.container.viewContext))
        //self.popover.appearance = NSAppearance(named: .accessibilityHighContrastVibrantDark)
    }
    
    @objc func togglePopover(){
        
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
