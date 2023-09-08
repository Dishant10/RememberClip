//
//  Row.swift
//  RememberClip
//
//  Created by Dishant Nagpal on 12/08/23.
//

import SwiftUI

struct Row : View{
    var clipboardText : String
    var body: some View{
        VStack(alignment:.leading){
            Text(clipboardText)
            //.foregroundStyle(Color.primary)
                .lineLimit(1)
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        }
    }
}
