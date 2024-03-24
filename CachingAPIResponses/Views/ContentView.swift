//
//  ContentView.swift
//  CachingAPIResponses
//
//  Created by Etienne Grey on 3/23/24 @ 7:52 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("lastFetched") private var lastFetched: Double = Date.now.timeIntervalSince1970
    
    @Query(sort: \Photo.id) private var photos: [Photo]
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(photos, id: \.id) { item in
                    
                    VStack(alignment: .leading) {
                        
                        AsyncImage(url: .init(string: item.url)) { image in
                            
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .clipped()
                            
                        } placeholder: {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .frame(height: 300)
                                Spacer()
                            }
                            
                        }
                        
                        Text(item.title)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                    }
                    .padding(.bottom)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Posts")
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .task {
                do {
                    isLoading = true
                    defer { isLoading = false }
                    if photos.isEmpty {
                        clearPhotos()
                        try await fetchPhotos()
                    }
                }
                catch {
                    print(error)
                }
            }
            .overlay {
                if isLoading {
                  ProgressView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: [Photo.self])
}

extension ContentView {
    
    func fetchPhotos() async throws {
        print("Fetching Photos")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            print("Error Occured")
            return
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let photos = try decoder.decode([Photo].self, from: data)
        let limitedPhotos = Array(photos.prefix(10)) // Adjust the number as needed
        
        
        await MainActor.run {limitedPhotos.forEach { modelContext.insert($0)} }
        
    }
    
    func clearPhotos() {
        _ = try? modelContext.delete(model: Photo.self)
    }
    
}
