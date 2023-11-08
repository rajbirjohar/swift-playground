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
            title: "Explore Tattoine",
            subTitle: "View the time in multiple cities around the world."
        ),
        .init(
            color: .blue,
            title: "Explore Dagobah",
            subTitle: "Add a clock for a city to check the time at that location."
        ),
        .init(
            color: .green,
            title: "Explore Naboo",
            subTitle: "Add a clock for a city to check the time at that location."
        ),
        .init(
            color: .yellow,
            title: "Explore Coruscant",
            subTitle: "Dusplay upcoming alarms."
        )
    ]
    
    /// Customization Properties
    @State private var showPagingControl: Bool = true
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat = 20
    @State private var titleScrollSpeed: CGFloat = 0.6
    @State private var stretchContent: Bool = true
    
    @State var planets: [Planet] = []
    @State var isLoading = false
    @State var errorMessage: String?
    @State var currentPage = 1
    @State var hasMoreData = true
    
    func loadMorePlanets() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        Task {
            do {
                let newPlanets = try await StarWarsAPIManager.shared.fetchPlanets(page: currentPage)
                if newPlanets.isEmpty {
                    hasMoreData = false
                } else {
                    planets.append(contentsOf: newPlanets)
                    currentPage += 1
                }
            } catch {
                // Handle specific error codes if needed
                if let urlError = error as? URLError, urlError.code == .badServerResponse {
                    // This might be the end of the collection
                    hasMoreData = false
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CustomPagingSlider(
                        showPagingControl: showPagingControl,
                        disablePagingInteraction: disablePagingInteraction,
                        titleScrollSpeed: titleScrollSpeed,
                        pagingControlSpacing: pagingSpacing,
                        data: $items
                    ) { $item in
                        Image(.planet1)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        // You can remove the explicit width to allow the padding to control the size
                            .frame(height: 200)
                            .cornerRadius(10)
                        // Apply horizontal padding to make the image take a percentage of the width.
                        // For example, applying padding of 10% of the screen width on each side makes the image take 80% of the width.
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.01)
                    } titleContent: {$item in
                        /// Title View
                        VStack(spacing: 5) {
                            Text(item.title)
                                .font(.title2.bold())
                            Text(item.subTitle)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .frame(height: 45)
                        }
                        .padding(.bottom, 35)
                    }
                    .safeAreaPadding([.horizontal, .vertical], 35)
                    LazyVStack {
                        ForEach(planets, id: \.name) { planet in
                            VStack(alignment: .leading, spacing: 0.5) {
                                Text(planet.name).font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Population: \(planet.population)").font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Population: \(planet.terrain)").font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding() // Add padding inside the VStack
                            // Apply the background color
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10) // Rounded corners for the VStack
                            .onAppear {
                                // Safely check if this is the last item and load more if needed
                                if let lastPlanet = planets.last, planet.id == lastPlanet.id {
                                    loadMorePlanets()
                                }
                            }
                        }
                        
                        if isLoading && !planets.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView("Loading more planets...")
                                Spacer()
                            }
                        }
                    }
                    .padding([.horizontal], 15)
                }
            }
            .navigationTitle("Planets")
            .onAppear {
                if planets.isEmpty {
                    loadMorePlanets()
                }
            }
            .overlay {
                if isLoading && planets.isEmpty {
                    ProgressView("Loading...")
                }
            }
            .alert("Error", isPresented: Binding<Bool>.constant($errorMessage.wrappedValue != nil), actions: {}) {
                Text($errorMessage.wrappedValue ?? "")
            }
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
