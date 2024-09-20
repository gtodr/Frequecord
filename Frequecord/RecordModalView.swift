import SwiftUI

struct RecordModalView: View {
    let task: Task
    @Binding var isPresented: Bool
    @State private var postscript = ""
    @State private var recordDate = Date()
    var onSave: (Record) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("记录 \(task.name)").font(.subheadline).foregroundColor(.gray)) {
                    TextField("附言（可选）", text: $postscript)
                    DatePicker("记录时间", selection: $recordDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationBarTitle("添加记录", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    isPresented = false
                }.foregroundColor(.red),
                trailing: Button("确认记录") {
                    let newRecord = Record(date: recordDate, postscript: postscript)
                    onSave(newRecord)
                    isPresented = false
                }.foregroundColor(.red)
            )
        }
    }
}

struct RecordModalView_Previews: PreviewProvider {
    static var previews: some View {
        RecordModalView(task: Task(name: "示例任务"), isPresented: .constant(true), onSave: { _ in })
    }
}
