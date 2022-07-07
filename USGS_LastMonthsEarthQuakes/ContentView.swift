//
//  ContentView.swift
//  USGS_LastMonthsEarthQuakes
//
//  Created by Peter Harding on 7/7/2022.
//

import SwiftUI

struct YellowBackgroundLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .padding()
            .background(Color.yellow)
    }
}

struct ContentView: View {
    
    @State private var valuex: String = "XXXX"
    @State private var date = Date() // <1>
    
    @ObservedObject var quakesProvider: QuakesProvider = .shared
    
    @State private var lastUpdated = Date.distantFuture.timeIntervalSince1970
    @State private var selection: Set<String> = []
    @State private var isLoading = false
    @State private var error: QuakeError?
    @State private var hasError = false

    static var df: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    
    var body: some View {
        VStack {
            Label {
                Text("SwiftUI")
                    .foregroundColor(Color.red)
            } icon: {
                Image(systemName: "keyboard")
                    .foregroundColor(Color.blue)
            }
            Spacer()
            Text("USGD Earthquake API Example!")
                .padding()
            Button(action: {
                Task {
                    await fetchQuakes()
                }
            })
            {
                HStack {
                    Spacer()
                    Image(systemName: "play.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text("Fetch Quakes")
                    Spacer()
                }

            }
            Spacer()
            if (quakesProvider.isProcessing) {
                Text("API call in progress")
                ProgressView().progressViewStyle(CircularProgressViewStyle())
            } else {
                Text(quakesProvider.processedMessage)
            }

            Spacer()
            Label("SwiftUI Tutorials", systemImage: "book.fill").labelStyle(YellowBackgroundLabelStyle()).padding()
        }
    }
}

extension ContentView {
    private func fetchQuakes() async {
        isLoading = true
        do {
            try await quakesProvider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
