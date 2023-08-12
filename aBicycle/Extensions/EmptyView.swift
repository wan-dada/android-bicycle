//
//  EmptyView.swift
//  aBicycle
//
//  Created by 1 on 8/3/23.
//

import SwiftUI

struct EmptyView: View {
    let text: String
    let rightMenu: String?
    let action: (() -> Void)?
    
    init(text: String, rightMenu: String? = nil, action: (() -> Void)? = nil) {
        self.text = text
        self.rightMenu = rightMenu
        self.action = action
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("android")
                .resizable()
                .frame(width: 24, height: 24)
            Text(text)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .contextMenu {
            if let rightMenu = rightMenu, !rightMenu.isEmpty, let action = action {
                Button(rightMenu) {
                    action()
                }
            }
        }
    }
}
