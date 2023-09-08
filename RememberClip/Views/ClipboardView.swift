//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import SwiftUI
import OnPasteboardChange

struct ClipboardView: View {
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(), animation: .bouncy) var texts
    @Environment(\.managedObjectContext) var context
    
    
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    var clipboardCopyItems : [String] = []
    
    var body: some View {
        VStack(alignment: .leading)
        {
            Section(){
                Text("Select the clip you want to add to your clipboard")
                    .padding(.top,3)
                    .foregroundStyle(Color.secondary)
            }
            Divider()
                .padding(.bottom)
            ScrollView{
                
                ForEach(texts, id: \.self) { item in
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(item.hoverAvailable == true ? .blue : .clear)
                            Row(clipboardText: item.text)
                                .foregroundStyle(item.hoverAvailable == true ? .white : Color.primary)
                                .padding(.leading,4)
                                .padding([.top,.bottom],3)
                        }
                        //                        if item.hoverAvailable{
                        //                            Button {
                        //                                print("Tapped")
                        //                            } label: {
                        //                                Image(systemName: "ellipsis")
                        //                            }
                        //                        }
                    }
                    .onHover{ hovering in
                        if texts.count > 0 {
                            
                            ClipboardItem.update(text: item, hover: hovering)
                            
                        }
                    }
                    .onTapGesture(count:1) {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(item.text, forType: .string)
                        ClipboardItem.update(text: item, hover: false)
                        dismiss()
                    }
                    .onPasteboardChange {
                        readClipboardItems()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    
                }
            }
            .padding(.bottom)
            Button {
                
                ClipboardItem.deleteAll()
                
            } label: {
                Text("Clear")
                    .foregroundStyle(Color.secondary)
            }
            //            Button {
            //                readClipboardItems()
            //            } label: {
            //                Text("Refresh")
            //            }
        }
        
        .onAppear(perform: {
            texts.first?.hoverAvailable = false
            PersistenceController.shared.save2()
            readClipboardItems()
            
        })
    }
    
    func readClipboardItems() {
        let pasteboard = NSPasteboard.general
        let items = pasteboard.pasteboardItems!
        for item in items {
            if let string = item.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                if texts.count == 0{
                    _ = ClipboardItem(text: string, dateCopied: Date(), context: context)
                    PersistenceController.shared.save()
                }else if texts.first?.text == string {
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




