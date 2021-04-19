//
//  ContentView.swift
//  Shared
//
//  Created by David Kanenwisher on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    
    let ISO_8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    
    @State private var start: String = ""
    @State private var end: String = ""
    @State private var differenceHours: String = ""
    @State private var totalDays: String = ""
    @State private var totalHours: String = ""
    @State private var totalMinutes: String = ""
    @State private var totalSeconds: String = ""
    @State private var totalTime: String = ""
    @State private var seconds: String = ""
    @State private var textTime: String = ""
    @State private var trivium: String = ""
    
    var body: some View {
        VStack {
            Group {
                VStack {
                    Text(trivium)
                    .padding()
                    .onAppear {
                        if trivium.isEmpty {
                            updateTrivium()
                        }
                    }
                    Text("😸")
                }
                HStack {
                    TextField("Start", text: $start)
                    TextField("End", text: $end)
                }
                Button("🧮") {
                    updateTrivium()
                    guard start.count > 0 && end.count > 0 else {
                        return
                    }
                    
                    let dateFormatter = DateFormatter()

                    dateFormatter.dateFormat = ISO_8601
                    
                    let startDate = dateFormatter.date(from: start)
                    let endDate = dateFormatter.date(from: end)
                    
                    if let difference = startDate?.distance(to: endDate!) {
                        totalSeconds = String(difference.rounded(precision: 2))
                        totalDays = String((difference.days.rounded(precision: 2)))
                        totalHours = String((difference.hours.rounded(precision: 2)))
                        totalMinutes = String((difference.minutes.rounded(precision: 2)))
                        totalTime = difference.totalTime()
                    }
                }
                HStack {
                    Text("Total Days:")
                    TextField("Total Days:", text: $totalDays)
                }
                HStack {
                    Text("Total Hours:")
                    TextField("Total Hours:", text: $totalHours)
                }
                HStack {
                    Text("Total Minutes:")
                    TextField("Total Minutes:", text: $totalMinutes)
                }
                HStack {
                    Text("Total Seconds:")
                    TextField("Total Seconds:", text: $totalSeconds)
                }
                HStack {
                    Text("Total Time:")
                    TextField("Total Time:", text: $totalTime)
                }
            }
            Group {
                Text("Break a pile of seconds down into days, hours, minutes, and seconds!🎉")
                    .padding()
                HStack{
                    TextField("Seconds", text: $seconds)
                }
                Button("🧮") {
                    updateTrivium()
                    guard seconds.count > 0 else {
                        return
                    }
                    
                    let interval = TimeInterval(Int(seconds)!)
                    
                    textTime = interval.totalTime()
                }
                HStack {
                    Text("Total Time:")
                    TextField("Total Time:", text: $textTime)
                }
            }
        }
    }
    
    private func updateTrivium() {
        guard let url = Bundle.main.url(forResource: "trivia", withExtension: ".json") else {
            print("couldn't find file😝.")
            trivium = "😵"
            return
        }
               
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let contents = try decoder.decode(Trivia.self, from: data)
            
            let length = contents.trivium.count
            trivium = contents.trivium[Int.random(in: 0..<length)]
        } catch {
            print("Couldn't read the file🚫📚. \(error)")
            trivium = "😵"
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension TimeInterval {
    
    var minutes: Double {
        return self / 60
    }
    
    var hours: Double {
        return self / 60 / 60
    }
    
    var days: Double {
        return self / 60 / 60 / 24
    }
    
    func totalTime() -> String {
        let allSeconds = rounded(precision: 0)
        let days = Int(allSeconds) / (24 * 60 * 60)
        let hours = (Int(allSeconds) % (24 * 60 * 60)) / (60 * 60)
        let minutes = (Int(allSeconds) % (60 * 60)) / (60)
        let seconds = (Int(allSeconds) % (60))
        return "\(days) days \(hours) hours \(minutes) minutes \(seconds) seconds"
    }
}

extension Double {
    func rounded(precision: Int) -> Double {
        let adjusted = self * pow(10.0, Double(precision))
        return (adjusted.rounded() / pow(10.0, Double(precision)))
    }
}

struct Trivia: Decodable {
    let trivium: [String]
}
