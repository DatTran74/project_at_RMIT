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
import MapKit


struct MapView: View {
    var coordinate: CLLocationCoordinate2D


    var body: some View {
        Map(position: .constant(.region(region)))
    }


    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)
        )
    }
}


#Preview {
    MapView(coordinate: CLLocationCoordinate2D(latitude: 16.4769, longitude: 107.5740))
}
