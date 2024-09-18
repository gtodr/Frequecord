import Foundation

struct Record: Codable, Identifiable {
    var id = UUID()
    let taskName: String
    let date: Date
    let postscript: String
}