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
    
    static let placeholderText = "Tap on the clip you want to copy or search here...."
    @Binding var closed : Bool
    
    @AppStorage("pinClip") var pinClip: Bool = false
    @AppStorage("pinText") var pinText: String = ""
    @AppStorage("dontPaste") var dontPaste: Bool = false
    @AppStorage("totalClips") var totalClips: String = ""
    
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
            if pinClip && preferences.allowPinning {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.clear)
                    HStack {
                        Text(pinText)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                            .foregroundStyle(Color.primary)
                            .padding(.leading,4)
                            .padding([.top,.bottom],3)
                        
                            Button {
                                print("Clip unppined")
                                 if pinClip {
                                     if texts.first?.text != pinText {
                                         _ = ClipboardItem(text: pinText, dateCopied: Date(), context: context)
                                         PersistenceController.shared.save()
                                     }
                                     withAnimation {
                                         pinClip = false
                                         pinText = ""
                                     }
                                }
                            } label: {
                                Image(systemName:"pin.slash.fill")
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing,2)
                    }
                    .frame(minHeight: 20, maxHeight: 20)
                }
                .frame(height: 25)
                .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
            }
            ScrollView(showsIndicators: preferences.scrollIndication){
                
                LazyVStack{
                    ForEach(texts, id: \.self) { item in
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(item.hoverAvailable == true ? preferences.themeColor : .clear)
                            HStack {
                                Text(item.text)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
                                    .foregroundStyle(item.hoverAvailable == true ? .white : Color.primary)
                                    .padding(.leading,4)
                                    .padding([.top,.bottom],3)
                                if preferences.allowPinning {
                                    if item.hoverAvailable && pinClip == false {
                                        Button {
                                            print("Clip pinned")
                                            if pinClip == false {
                                                withAnimation {
                                                    pinClip = true
                                                    pinText = item.text
                                                    dontPaste = true
                                                    let pasteboard = NSPasteboard.general
                                                    pasteboard.declareTypes([.string], owner: nil)
                                                    pasteboard.setString(item.text, forType: .string)
                                                    ClipboardItem.delete(text: item)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "pin.fill")
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.trailing,2)
                                    }
                                }
                                    
                            }
                            .frame(minHeight: 20, maxHeight: 20)
                        }
                        .onHover{ hovering in
                            if texts.count > 0 {
                                ClipboardItem.update(text: item, hover: hovering)
                            }
                        }
                        .onTapGesture(count:1) {
                            withAnimation {
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([.string], owner: nil)
                                pasteboard.setString(item.text, forType: .string)
                                ClipboardItem.update(text: item, hover: false)
                                closed.toggle()
                                dismiss()
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    }
                }
            }
            HStack {
                Button {
                    ClipboardItem.deleteAll()
                    pinClip = false
                    pinText = ""
                } label: {
                    Text("Clear")
                        .foregroundStyle(Color.secondary)
                }
                Spacer()
                Text(String(texts.count))
                    .foregroundStyle(Color.secondary)
            }
            // Referesh button, important for debugging and testing core data
            //            Button {
            //                readClipboardItems()
            //            } label: {
            //                Text("Refresh")
            //            }
        }
        .onChange(of: preferences.allowPinning) { newValue in
            if newValue == false {
                pinClip = false
                pinText = ""
            }
        }
    }
}

