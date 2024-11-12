/*
  RMIT University Vietnam
  Course: COSC2659|COSC2813 iOS Development
  Semester: 2024B
  Assessment: Assignment 1
  Author: Tran Xuan Hoang Dat
  ID: s3651550
  Created date: 19/07/2024
  Last modified: 25/07/2024 (e.g. 05/08/2024)
  Acknowledgement: https://developer.apple.com/tutorials/swiftui/handling-user-input
*/

import SwiftUI

struct LandmarkList: View {
    @Environment(ModelData.self) var modelData
    @State private var showFavoritesOnly = false
    @State private var searchText = ""
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite) &&
            (searchText.isEmpty || landmark.name.lowercased().contains(searchText.lowercased()))
        }
    }

    var body: some View {
        // NavigationSplitView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }

                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .animation(.default, value: filteredLandmarks)
            .navigationTitle("Landmarks")
            .searchable(text: $searchText, prompt: "Search Landmarks")
        // } detail: {
        //     Text("Select a Landmark")
        // }
    }
}

#Preview {
    LandmarkList()
        .environment(ModelData())
}
