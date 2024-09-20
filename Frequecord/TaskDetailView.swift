import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var task: Task
    @State private var selectedTimeFilter: TimeFilter = .lastMonth
    @State private var isEditing = false
    @State private var isAddingRecord = false
    @Environment(\.presentationMode) var presentationMode
    
    init(task: Task) {
        _task = State(initialValue: task)
    }
    
    enum TimeFilter: String, CaseIterable {
        case lastMonth = "上月"
        case lastQuarter = "上季度"
        case lastYear = "去年"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(task.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    taskSummary
                    
                    timeFilterButtons
                    
                    frequencyVisualization
                    
                    taskRecordList
                }
                .padding()
            }
            .navigationBarTitle("记录", displayMode: .inline)
            .navigationBarItems(
                leading: Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: HStack {
                    Button(action: {
                        // 实现分享功能
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Button(action: {
                        // 编辑
                        isEditing = true
                    }) {
                        Image(systemName: "pencil")
                    }
                    Button(action: {
                        // 新增
                        isAddingRecord = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
        }
        .sheet(isPresented: $isAddingRecord) {
            AddRecordView(task: task, onSave: { newRecord in
                dataManager.addRecord(to: task.name, record: newRecord)
                if let updatedTask = dataManager.getTask(by: task.name) {
                    task = updatedTask
                }
                isAddingRecord = false
            })
        }
        .onAppear {
            if let updatedTask = dataManager.getTask(by: task.name) {
                task = updatedTask
            }
        }
    }
    
    private var taskSummary: some View {
        VStack(alignment: .leading) {
            Text("总计 \(task.records.count) 次")
            Text("平均间隔：\(averageInterval) 天")
        }
        .font(.subheadline)
        .foregroundColor(.gray)
    }
    
    private var timeFilterButtons: some View {
        HStack {
            ForEach(TimeFilter.allCases, id: \.self) { filter in
                Button(action: {
                    selectedTimeFilter = filter
                }) {
                    Text(filter.rawValue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(selectedTimeFilter == filter ? Color.red : Color.gray.opacity(0.2))
                        .foregroundColor(selectedTimeFilter == filter ? .white : .black)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private var frequencyVisualization: some View {
        // 这里实现日历视图
        Text("频率可视化")
    }
    
    private var taskRecordList: some View {
        ForEach(filteredRecords) { record in
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "circle.grid.3x3.fill")
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading) {
                    Text(formatDate(record.date))
                    Text(formatTime(record.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 5)
        }
    }
    
    private var averageInterval: String {
        guard task.records.count > 1 else { return "N/A" }
        let sortedRecords = task.records.sorted { $0.date < $1.date }
        let totalInterval = sortedRecords.last!.date.timeIntervalSince(sortedRecords.first!.date)
        let averageInterval = totalInterval / Double(task.records.count - 1) / 86400 // 转换为天
        return String(format: "%.2f", averageInterval)
    }
    
    private func isInSelectedTimeRange(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        switch selectedTimeFilter {
        case .lastMonth:
            return calendar.date(byAdding: .month, value: -1, to: now)! <= date
        case .lastQuarter:
            return calendar.date(byAdding: .month, value: -3, to: now)! <= date
        case .lastYear:
            return calendar.date(byAdding: .year, value: -1, to: now)! <= date
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private var filteredRecords: [Record] {
        task.records.filter { isInSelectedTimeRange($0.date) }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: Task(name: "示例任务"))
            .environmentObject(DataManager())
    }
}
