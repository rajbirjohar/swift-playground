//
//  ContentView.swift
//  Playground
//
//  Created by Rajbir Johar on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var items: [Item] = [
        .init(
            color: .red,
            title: "World Clock",
            subTitle: "View the time in multiple cities around the world."
        ),
        .init(
            color: .blue,
            title: "City Digital",
            subTitle: "Add a clock for a city to check the time at that location."
        ),
        .init(
            color: .green,
            title: "City Analogue",
            subTitle: "Add a clock for a city to check the time at that location."
        ),
        .init(
            color: .yellow,
            title: "Next Alarm",
            subTitle: "Dusplay upcoming alarms."
        )
    ]
    
    /// Customization Properties
    @State private var showPagingControl: Bool = false
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat = 20
    @State private var titleScrollSpeed: CGFloat = 0.6
    @State private var stretchContent: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                CustomPagingSlider(
                    showPagingControl: showPagingControl,
                    disablePagingInteraction: disablePagingInteraction,
                    titleScrollSpeed: titleScrollSpeed,
                    pagingControlSpacing: pagingSpacing,
                    data: $items
                ) { $item in
                    /// Content View
                    RoundedRectangle(cornerRadius: 25)
                        .fill(item.color.gradient)
                        .frame(width: stretchContent ? nil : 150, height: stretchContent ? 220 : 120)
                        .animation(.default, value: stretchContent)
                } titleContent: {$item in
                    /// Title View
                    VStack(spacing: 5) {
                        Text(item.title)
                            .font(.largeTitle.bold())
                        Text(item.subTitle)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .frame(height: 45)
                    }
                    .padding(.bottom, 35)
                }
                .safeAreaPadding([.horizontal, .top], 35)
                
                VStack {
                    Toggle("Show Paging Control", isOn: $showPagingControl)
                    Divider()
                    Toggle("Disable Page Interaction", isOn: $disablePagingInteraction)
                    Divider()
                    Toggle("Stretch Content", isOn:
                            $stretchContent.animation(.default)
                    )
                    Divider()
                    Section("Title Scroll Speed") {
                        Slider(value: $titleScrollSpeed)
                    }
                    Divider()
                    Section("Paging Spacing") {
                        Slider(value: $pagingSpacing, in: 20...40)
                    }
                }
                .padding(15)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
                .padding(15)
            }
        }
    }
   
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
