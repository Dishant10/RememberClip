//
//  SettingsView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 27/02/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    var body: some View {
        VStack{
            
        }
        .padding(.top, 10)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
        .frame(width: 300, height: 400)
    }
    static func showWindow() {
        let controller = NSHostingController(rootView: SettingsView())
        let windowController = NSWindowController(window: NSWindow(contentViewController: controller))
        
        if let window = windowController.window {
            window.title = "System Preferences!"
            window.titleVisibility = .visible
            window.makeKey()
            window.titlebarAppearsTransparent = true
            window.animationBehavior = .alertPanel
            window.styleMask = [.titled, .closable]
//            window.frame = NSRect(x: 900, y: 500, width: 700, height: 700)
           // window.isOpaque = false
           // window.backgroundColor = NSColor.clear

        }
        
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
