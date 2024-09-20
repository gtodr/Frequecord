import Foundation

struct Task: Codable, Identifiable {
    let id: UUID
    var name: String
    var records: [Record]
    
    init(id: UUID = UUID(), name: String, records: [Record] = []) {
        self.id = id
        self.name = name
        self.records = records
    }
}