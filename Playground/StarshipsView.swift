//
//  StarshipsView.swift
//  Playground
//
//  Created by Rajbir Johar on 11/8/23.
//

import SwiftUI

struct StarshipsView: View {
    @State var starships: [Starship] = []
    @State var isLoading = false
    @State var errorMessage: String?
    @State var currentPage = 1
    @State var hasMoreData = true
    
    func loadMoreStarships() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        Task {
            do {
                let newStarships = try await StarWarsAPIManager.shared.fetchStarships(page: currentPage)
                if newStarships.isEmpty {
                    hasMoreData = false
                } else {
                    starships.append(contentsOf: newStarships)
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
        ScrollView {
            VStack {
                let firstFiveStarships = Array(starships.prefix(5))
                Text("Need a ride? Discover available starships for you today. X-Wing or Death Star!").font(.subheadline).foregroundStyle(Color(UIColor.secondaryLabel))
                    .safeAreaPadding(5)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding(10)
                CustomPagingSlider(data: .constant(firstFiveStarships)) {starship in
                    Image(.planet1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.01)
                } titleContent: {starship in
                    VStack(spacing: 5) {
                        Text(starship.name)
                            .font(.title2.bold())
                        Text("Check out the \(starship.name) capable of carrying \(starship.passengers) with a hyperdrive rating of \(starship.hyperdrive_rating).")
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .frame(height: 72)
                    }
                    .padding(.bottom, 35)
                }
                .safeAreaPadding([.horizontal, .vertical], 35)
                /// List of all starships
                LazyVStack {
                    ForEach(starships, id: \.name) { starship in
                        VStack(alignment: .leading, spacing: 0.5) {
                            Text(starship.name).font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Crew Capacity: \(starship.crew)").font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Credits: \(starship.cost_in_credits)").font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding() // Add padding inside the VStack
                        // Apply the background color
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10) // Rounded corners for the VStack
                        .onAppear {
                            // Safely check if this is the last item and load more if needed
                            if let lastStarship = starships.last, starship.id == lastStarship.id {
                                loadMoreStarships()
                            }
                        }
                    }
                    
                    if isLoading && !starships.isEmpty {
                        HStack {
                            Spacer()
                            ProgressView("Loading more starships...")
                            Spacer()
                        }
                    }
                }
                .padding([.horizontal], 15)
            }
        }
        .navigationTitle("Starships")
        .onAppear {
            if starships.isEmpty {
                loadMoreStarships()
            }
        }
        .overlay {
            if isLoading && starships.isEmpty {
                ProgressView("Loading...")
            }
        }
        .alert("Error", isPresented: Binding<Bool>.constant($errorMessage.wrappedValue != nil), actions: {}) {
            Text($errorMessage.wrappedValue ?? "")
        }
    }
}

#Preview {
    StarshipsView()
}
