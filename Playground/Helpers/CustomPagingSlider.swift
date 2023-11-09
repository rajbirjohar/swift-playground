//
//  CustomPagingSlider.swift
//  Playground
//
//  Created by Rajbir Johar on 11/7/23.
//

import SwiftUI


struct CustomPagingSlider<Content: View, TitleContent: View, DataItem: Identifiable, DataCollection: RandomAccessCollection>: View where DataCollection.Element == DataItem {
    
    /// Customization Properties
    var showIndicator:ScrollIndicatorVisibility = .hidden
    var showPagingControl: Bool = true
    var disablePagingInteraction: Bool = false
    var titleScrollSpeed = 0.6
    var pagingControlSpacing: CGFloat = 20
    var spacing: CGFloat = 10
    
    @Binding var data: DataCollection
    @ViewBuilder var content: (DataItem) -> Content
    @ViewBuilder var titleContent: (DataItem) -> TitleContent
    
    /// View Properties
    @State private var activeID: DataItem.ID?
    
    var body: some View {
        VStack(spacing: pagingControlSpacing) {
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach(data, id: \.id) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(x: scrollOffset(geometryProxy))
                                }
                            content(item)
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                }
                /// Adding Paging
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeID)
            .scrollIndicators(showIndicator)
            
            
        }
    }
    
    var activePage: Int {
        guard let activeID = activeID,
              let index = data.firstIndex(where: { $0.id == activeID }) else {
            return 0
        }
        return data.distance(from: data.startIndex, to: index)
    }

    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        
        return -minX * min(titleScrollSpeed, 1.0)
    }
}

struct PagingControl: UIViewRepresentable {
    var numberOfPages: Int
    var activePage: Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPage = activePage
        view.numberOfPages = numberOfPages
        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.primary)
        view.pageIndicatorTintColor = UIColor.placeholderText
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        /// Updating Outside Event Changes
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc
        func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}

#Preview {
    PlanetsView()
}
