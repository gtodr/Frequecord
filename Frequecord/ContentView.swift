//
//  ContentView.swift
//  Frequecord
//
//  Created by Derun on 2024/9/18.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedTaskForDetail: Task?
    
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
                        let _ = dataManager.addTask("新任务")
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
                        ForEach(dataManager.tasks) { task in
                            TaskCard(task: task, onTap: {
                                selectedTaskForDetail = task
                            })
                        }
                    }
                    .padding()
                }
            }
            .sheet(item: $selectedTaskForDetail) { task in
                TaskDetailView(task: task)
                    .environmentObject(dataManager)
            }
        }
        .environmentObject(dataManager)
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
