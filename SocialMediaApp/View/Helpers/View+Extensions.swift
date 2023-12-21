//
//  View+Extensions.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 20.12.2023.
//

import SwiftUI

extension View {
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition: Bool)->some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alligment: Alignment)->some View {
        self.frame(maxWidth: .infinity, alignment: alligment)
    }
    
    func vAlign(_ alligment: Alignment)->some View {
        self.frame(maxHeight: .infinity, alignment: alligment)
    }
    
    func border(_ width: CGFloat,_ color: Color)-> some View {
        self.padding(.horizontal, 15).padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    func fillView(_ color: Color)-> some View {
        self.padding(.horizontal, 15).padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}

