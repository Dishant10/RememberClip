//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import SwiftUI
import OnPasteboardChange

struct ClipboardItemsView: View {
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(), animation: .bouncy) var texts
    @Environment(\.managedObjectContext) var context
    
    @State var placeholderText = "Tap on the clip you want to copy or search here...."
    @Environment(\.dismiss) private var dismiss
    
    @Binding var closed : Bool
    
    init(searchText : String, closed: Binding<Bool>){
        self._closed = closed
        let request =  ClipboardItem.fetch()
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "text_", searchText as CVarArg)
        }
        else{
            request.predicate = nil
        }
        self._texts = FetchRequest(fetchRequest: request,animation: .bouncy)
    }
    
    var body: some View {
        VStack(alignment: .leading)
        {
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
                        closed.toggle()
                        dismiss()
                    }
                    .onPasteboardChange {
                        readClipboardItems()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    
                }
            }
            //.padding(.bottom)
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




