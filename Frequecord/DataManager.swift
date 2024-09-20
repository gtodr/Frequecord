import Foundation

class DataManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let tasksKey = "tasks"
    
    init() {
        loadTasks()
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        }
    }
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }
    
    func addTask(_ taskName: String) -> Bool {
        guard !tasks.contains(where: { $0.name == taskName }) else {
            return false
        }
        let newTask = Task(name: taskName)
        tasks.append(newTask)
        saveTasks()
        return true
    }
    
    func addRecord(to taskName: String, record: Record) {
        if let index = tasks.firstIndex(where: { $0.name == taskName }) {
            tasks[index].records.append(record)
            saveTasks()
        }
    }
    
    func updateTaskName(oldName: String, newName: String) -> Bool {
        guard !tasks.contains(where: { $0.name == newName }) else {
            return false
        }
        if let index = tasks.firstIndex(where: { $0.name == oldName }) {
            tasks[index].name = newName
            saveTasks()
            return true
        }
        return false
    }
    
    func deleteTask(taskName: String) {
        tasks.removeAll(where: { $0.name == taskName })
        saveTasks()
    }
    
    func getTask(by name: String) -> Task? {
        return tasks.first(where: { $0.name == name })
    }
}