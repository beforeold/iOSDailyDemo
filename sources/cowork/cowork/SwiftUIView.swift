import SwiftUI
import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 1500 // 25 minutes in seconds
    @State private var isActive = false
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text(timeString(time: timeRemaining))
                .font(.system(size: 80, weight: .bold, design: .monospaced))
                .padding()

            HStack {
                Button(action: {
                    self.startTimer()
                }) {
                    Text("Start")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(isActive)

                Button(action: {
                    self.resetTimer()
                }) {
                    Text("Reset")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        self.isActive = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.isActive = false
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func resetTimer() {
        self.isActive = false
        self.timeRemaining = 1500
        self.timer?.invalidate()
        self.timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
