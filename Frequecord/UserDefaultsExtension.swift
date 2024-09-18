import Foundation

extension UserDefaults {
    var records: [Record] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "records") else { return [] }
            return (try? JSONDecoder().decode([Record].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue), forKey: "records")
        }
    }
}