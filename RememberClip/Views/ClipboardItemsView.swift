//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import SwiftUI
import OnPasteboardChange

struct ClipboardItemsView: View {
    
    @ObservedObject var preferences = Preferences()
    
    @FetchRequest(fetchRequest: ClipboardItem.fetch(numberOfClipsTobeFetched: 50), animation: .bouncy) var texts
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State var placeholderText = "Tap on the clip you want to copy or search here...."
    @Binding var closed : Bool
    
    init(searchText : String, closed: Binding<Bool>){
        self._closed = closed
        let request =  ClipboardItem.fetch( numberOfClipsTobeFetched: Int(preferences.numberOfClips) ?? 25)
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
            ScrollView(showsIndicators: preferences.scrollIndication){
                
                ForEach(texts, id: \.self) { item in
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(item.hoverAvailable == true ? preferences.themeColor : .clear)
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
                    .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    
                }
            }
            .onAppear(perform: {
                print("Count of copied items \(texts.count)")
            })
            
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

    }


}




