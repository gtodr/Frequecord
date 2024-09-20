import SwiftUI

struct AddRecordView: View {
    let task: Task
    let onSave: (Record) -> Void
    
    @State private var note: String = ""
    @State private var date: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("任务名称")) {
                    Text(task.name)
                }
                
                Section(header: Text("记录日期和时间")) {
                    DatePicker("日期", selection: $date, displayedComponents: [.date])
                    DatePicker("时间", selection: $date, displayedComponents: [.hourAndMinute])
                        .environment(\.locale, Locale(identifier: "zh_CN"))
                        .environment(\.calendar, Calendar(identifier: .gregorian))
                        .environment(\.timeZone, TimeZone.current)
                }
                
                Section(header: Text("备注")) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
            }
            .navigationTitle("添加记录")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    let newRecord = Record(date: date, postscript: note)
                    onSave(newRecord)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(task: Task(name: "Demo"), onSave: { _ in })
    }
}
