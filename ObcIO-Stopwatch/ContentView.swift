import SwiftUI

struct RingStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    Circle()
      .fill()
      .overlay(
        Circle()
          .fill(Color.white)
          .opacity(configuration.isPressed ? 0.3 : 0)
      )
      .overlay(
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(.white)
          .padding(4)
      )
      .overlay(
        configuration.label
          .foregroundColor(.white)
      )
  }
}

struct ContentView: View {
  var body: some View {
    HStack {
      Button(action: {}) {
        Text("Stop")
      }
      .foregroundColor(.red)
      .frame(width: 75, height: 75, alignment: .center)
      Button(action: {}) {
        Text("Start")
      }
      .foregroundColor(.green)
      .frame(width: 75, height: 75, alignment: .center)
    }.buttonStyle(RingStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
