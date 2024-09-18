import SwiftUI

struct TaskCard: View {
    let taskName: String
    let lastRecord: Record?
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            // 任务图标
            Circle()
                .fill(Color.red)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "circle.grid.3x3.fill")
                        .foregroundColor(.white)
                )
            
            // 任务名称和最后活动时间
            VStack(alignment: .leading) {
                Text(taskName)
                    .font(.headline)
                Text(lastRecordText)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 进度指示器
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(index < 3 ? Color.red : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(index < 2 ? Color.red : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture(perform: onTap)
    }
    
    private var lastRecordText: String {
        if let lastRecord = lastRecord {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return "上次发生：\(formatter.string(from: lastRecord.date))"
        } else {
            return "上次发生：无记录"
        }
    }
}