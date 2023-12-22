//
//  TabStateScrollView.swift
//  SocialMediaApp
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct TabStateScrollView<Content: View>: View {
    @Binding var tabState: Visibility
    
    var axis: Axis.Set
    var showsIndicator: Bool
    var content: Content
    
    init(
        axis: Axis.Set,
        showsIndicator: Bool,
        tabState: Binding<Visibility>,
        @ViewBuilder content: @escaping() -> Content
    ) {
        self.axis = axis
        self.showsIndicator = showsIndicator
        self._tabState = tabState
        self.content = content()
    }


    
    var body: some View {
        if #available(iOS 17, *) {
            ScrollView(axis) {
                content
            }
            .scrollIndicators(showsIndicator ? .visible : .hidden)
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        } else {
            ScrollView(axis, showsIndicators: showsIndicator, content: {
                content
            })
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        }
    }
    
    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let offsetY = gesture.translation(in: gesture.view).y
        let velocity = gesture.velocity(in: gesture.view).y
        
        if velocity < 0 {
            if -(velocity / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            if (velocity / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
    }
}

fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> ()
    
    private let gestureID = UUID().uuidString
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview, (superView.gestureRecognizers?.contains(where: {$0.name == gestureID}) ?? false) {
                
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                superView.addGestureRecognizer(gesture)
                
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> ()
        
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

struct TabStateScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
