//
//  ContentView.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 09/08/23.
//

import SwiftUI
import OnPasteboardChange

struct ClipboardView: View {
    
    @StateObject var clipboardItems = ClipboardItems()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
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
                ForEach(0..<25, id: \.self) { item in
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(clipboardItems.clipboardSavedItems[item].hoverAvailable == true ? .blue : .clear)
                            Row(clipboardText:clipboardItems.clipboardSavedItems[item].text)
                                .foregroundStyle(clipboardItems.clipboardSavedItems[item].hoverAvailable == true ? .white : Color.primary)
                                .padding(.leading,4)
                                .padding([.top,.bottom],3)
                        }
                        if clipboardItems.clipboardSavedItems[item].hoverAvailable{
                            Button {
                                print("Tapped")
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                    .onHover{ hovering in
                        if clipboardItems.clipboardSavedItems.count > 0 {
                            clipboardItems.clipboardSavedItems[item].hoverAvailable = hovering
                        }
                    }
                    .onTapGesture(count:1) {
                        clipboardItems.copyItem(text: clipboardItems.clipboardSavedItems[item].text)
                        clipboardItems.clipboardSavedItems[item].hoverAvailable = false
                        dismiss()
                    }
                    .onPasteboardChange {
                        clipboardItems.readClipboardItems()
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: 0))
                    
                }
            }
            .padding(.bottom)
            Button {
                clipboardItems.clipboardSavedItems.removeAll()
                clipboardItems.saveData()
            } label: {
                Text("Clear")
                    .foregroundStyle(Color.secondary)
            }
            //            Button {
            //                clipboardItems.readClipboardItems()
            //            } label: {
            //                Text("Refresh")
            //            }
            
            //Spacer()
        }
        //.padding(.bottom)
        .onAppear(perform: {
            
            clipboardItems.readClipboardItems()
            clipboardItems.loadSavedData()
            
        })
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ClipboardView()
    }
}



