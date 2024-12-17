import SwiftUI

import SwiftUI

struct vTime : Codable {
    var hour : Int
    var min  : Int
}

struct RecDate : Codable {
    var day  : Int
    var start: vTime
    var end  : vTime

    private enum CodingKeys : String, CodingKey {
        case day
        case start
        case end
    }

    func duration() -> CGFloat {
        let dTime : CGFloat = abs(CGFloat(end.hour - start.hour) * 4.0 + CGFloat(end.min - start.min) &#x2F; 15.0)
        return dTime
    }
}

class Record : Hashable, Equatable, Identifiable, ObservableObject {
    let vID = UUID()
    @Published var subject : String
    @Published var date   : RecDate

    init(subject: String, date : RecDate) {
        self.subject = subject
        self.date = date
    }

    static func == (lhs: Record, rhs: Record) -> Bool {
        var r = lhs.subject.compare(rhs.subject) == .orderedSame
        r = r &amp;&amp; lhs.date.start.hour == rhs.date.start.hour
        r = r &amp;&amp; lhs.date.start.min == rhs.date.start.min
        r = r &amp;&amp; lhs.date.end.hour == rhs.date.end.hour
        r = r &amp;&amp; lhs.date.end.min == rhs.date.end.min
        r = r &amp;&amp; lhs.vID == rhs.vID
        return r
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(subject)
        hasher.combine(date.start.hour)
        hasher.combine(date.start.min)
        hasher.combine(date.end.hour)
        hasher.combine(date.end.min)
        hasher.combine(vID)
    }

    func isSelected(appSelection : UUID?) -> Bool {
        return appSelection == vID
    }

    public func incDate() {
        if !(self.date.end.hour == 19 &amp;&amp; self.date.end.min == 0) {
            self.date.start.min += 15
            self.date.end.min += 15
            if self.date.start.min == 60 {
                self.date.start.min = 0
                self.date.start.hour += 1
            }
            if self.date.end.min == 60 {
                self.date.end.min = 0
                self.date.end.hour += 1
            }
        }
    }

    public func decDate() {
        if !(self.date.start.hour == 8 &amp;&amp; self.date.start.min == 0) {
            self.date.start.min -= 15
            self.date.end.min -= 15
            if self.date.start.min &lt; 0 {
                self.date.start.min = 45
                self.date.start.hour -= 1
            }
            if self.date.end.min &lt; 0 {
                self.date.end.min = 45
                self.date.end.hour -= 1
            }
        }
    }

}

public class RecordHandler : ObservableObject {
    @Published var records : [Record] = [
        Record(subject: "banana", date: RecDate(day: 0, start: vTime(hour: 8, min: 0), end: vTime(hour: 10, min: 0))),
        Record(subject: "strawberry", date: RecDate(day: 1, start: vTime(hour: 11, min: 0), end: vTime(hour: 14, min: 0)))
    ]
    @Published var selectedID  : UUID? = nil

    func setSel(newID : UUID) {
        if selectedID == nil {
            selectedID = newID
        } else {
            if selectedID == newID {
                selectedID = nil
            } else {
                selectedID = newID
            }
        }
    }
}

struct EntryView: View {
    @EnvironmentObject var appData : RecordHandler
    @ObservedObject var setup : Record
    @State private var showDataView : Bool = false

    struct SelView : View {
        var body: some View {
            Rectangle()
                .inset(by: -2)
                .stroke(.blue, lineWidth: 5.0)
        }
    }

    var body: some View {
        let qCount = setup.date.duration()
        let height = qCount * 10.0
        let xPos   = 100.0
        let yPos   = 7.0 + (CGFloat(setup.date.start.hour) - 8.0) * 40.0 + CGFloat(setup.date.start.min) &#x2F; 1.5 + (qCount - 1.0) * 5.0
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.red.opacity(0.80))
            Text(setup.subject)
            if setup.isSelected(appSelection: appData.selectedID) {
                SelView()
            }
        }
        .frame(width: 200, height: height)
        .position(x: xPos, y: yPos)
        .onTapGesture(count: 1) {
            appData.setSel(newID: setup.vID)
        }
    }
}

struct DayView: View {
    @EnvironmentObject var appData : RecordHandler
    var day : Int

    var body: some View {
        VStack {
            ForEach(appData.records, id: \.self) { value in
                if value.date.day == day {
                    EntryView(setup: value)
                        .environmentObject(appData)
                }
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appData : RecordHandler

    var body: some View {
        NavigationStack {
            HStack {
                DayView(day: 0)
                    .environmentObject(appData)
                DayView(day: 1)
                    .environmentObject(appData)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button("↑") {
                    if let ds = appData.records.first(where: { $0.vID == appData.selectedID!}) {
                        ds.decDate()
                    }
                }
                .disabled(appData.selectedID == nil)
                Button("↓") {
                    if let ds = appData.records.first(where: { $0.vID == appData.selectedID!}) {
                        ds.incDate()
                    }
                }
                .disabled(appData.selectedID == nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var previewData = RecordHandler()

    static var previews: some View {
        ContentView()
            .environmentObject(previewData)
    }
}
#Preview {
    ContentView()
}
