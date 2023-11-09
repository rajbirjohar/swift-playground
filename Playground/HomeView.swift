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
            List(filteredDirectories) { directory in
                NavigationLink(destination: directory.destinationView()) {
                    Text(directory.title)
                }
            }
            .navigationTitle("Explore the Galaxy")
            .searchable(text: $searchText) // Add searchable modifier
        }
    }
}

// Define previews and sample directory entries
#Preview {
    HomeView()
}
