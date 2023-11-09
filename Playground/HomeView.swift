//
//  ContentView.swift
//  Playground
//
//  Created by Rajbir Johar on 11/7/23.
//

import SwiftUI

// Define the struct for DirectoryEntry
struct DirectoryEntry<Destination: View>: Identifiable {
    let id = UUID()
    let title: String
    let destinationView: () -> Destination
}

struct DirectoryCardView<Destination: View>: View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack (alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.white)
                // Add more details or styling here
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemPink))
            .cornerRadius(12)
        }
    }
}

// Update the HomeView to make it searchable
struct HomeView: View {
    let directories: [DirectoryEntry<AnyView>] = [
        DirectoryEntry(title: "Planets", destinationView: { AnyView(PlanetsView()) }),
        DirectoryEntry(title: "Starships", destinationView: { AnyView(StarshipsView()) }),
        // Add more entries as needed...
    ]
    @State private var searchText = ""
    
    // Filtered directories based on search text
    var filteredDirectories: [DirectoryEntry<AnyView>] {
        if searchText.isEmpty {
            return directories
        } else {
            return directories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(filteredDirectories) { directory in
                        DirectoryCardView(title: directory.title, destination: directory.destinationView())
                    }
                }
                .padding()
            }
            .navigationTitle("Star Wars Directory")
            .searchable(text: $searchText, prompt: "Search directories") // Add the searchable modifier
        }
    }
}

// Define previews and sample directory entries
#Preview {
    HomeView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/).accentColor(Color(UIColor.systemPink))
}
