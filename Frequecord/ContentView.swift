//
//  ContentView.swift
//  Frequecord
//
//  Created by 徐德润 on 2024/9/18.
//
import SwiftUI

struct ContentView: View {
    @State private var isAddingRecord = false
    @State private var selectedTask: String?
    @State private var tasks: [String: [Record]] = [:]
    @State private var selectedTaskForDetail: TaskIdentifier?
    
    var body: some View {
        NavigationView {
            VStack {
                // 标题和操作按钮
                HStack {
                    Button(action: {
                        // 设置按钮操作
                    }) {
                        Image(systemName: "gear")
                    }
                    
                    Button(action: {
                        // 日历按钮操作
                    }) {
                        Image(systemName: "calendar")
                    }
                    
                    Spacer()
                    
                    Text("Frequecord")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        // 添加任务按钮操作
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
                
                // 任务列表
                ScrollView {
                    VStack(spacing: 20) {
                         ForEach(Array(tasks.keys), id: \.self) { taskName in
                             TaskCard(taskName: taskName, lastRecord: tasks[taskName]?.last, onTap: {
                                 selectedTaskForDetail = TaskIdentifier(name: taskName)
                             })
                         }
                    }
                    .padding()
                }
            }
            .sheet(item: $selectedTaskForDetail) { taskIdentifier in
                TaskDetailView(taskName: taskIdentifier.name)
            }
            .sheet(isPresented: $isAddingRecord) {
                if let task = selectedTask {
                    RecordModalView(taskName: task, isPresented: $isAddingRecord, onSave: addRecord)
                }
            }
            .onAppear(perform: loadRecords)
        }
    }
    
    private func loadRecords() {
        let allRecords = UserDefaults.standard.records
        tasks = Dictionary(grouping: allRecords, by: { $0.taskName })
    }
    
    private func addRecord(_ record: Record) {
        if tasks[record.taskName] != nil {
            tasks[record.taskName]?.append(record)
        } else {
            tasks[record.taskName] = [record]
        }
        UserDefaults.standard.records = Array(tasks.values).flatMap { $0 }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// 在 ContentView 结构体外部添加这个新的结构体
struct TaskIdentifier: Identifiable {
    let id = UUID()
    let name: String
}
