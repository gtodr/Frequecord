import Foundation

struct Record: Codable, Identifiable {
    let id: UUID
    let date: Date
    let postscript: String
    
    init(id: UUID = UUID(), date: Date, postscript: String) {
        self.id = id
        self.date = date
        self.postscript = postscript
    }
}
