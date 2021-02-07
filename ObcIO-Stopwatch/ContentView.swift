import SwiftUI

struct SizeKey: PreferenceKey {
  static let defaultValue: [CGSize] = []
  static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
    value.append(contentsOf: nextValue())
  }
}

struct ButtonCircle: ViewModifier {
  @State var size: CGSize? = nil

  let isPressed: Bool

  func body(content: Content) -> some View {
    let background = Circle()
      .fill()
      .overlay(
        Circle()
          .fill(Color.white)
          .opacity(isPressed ? 0.3 : 0)
      )
      .overlay(
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(.white)
          .padding(4)
      )

    let foreground =
      content
      .fixedSize()
      .padding(15)
      .equalSize()
      .foregroundColor(.white)

    return foreground
      .background(background)
  }
}

struct SizeEnvironmentKey: EnvironmentKey {
  static var defaultValue: CGSize? = nil
}

extension EnvironmentValues {
  var size: CGSize? {
    get {
      self[SizeEnvironmentKey.self]
    }
    set {
      self[SizeEnvironmentKey.self] = newValue
    }
  }
}

fileprivate struct EqualSize: ViewModifier {
  @Environment(\.size) private var size

  func body(content: Content) -> some View {
    content.overlay(GeometryReader { proxy in
      Color.clear.preference(key: SizeKey.self, value: [proxy.size])
    })
    .frame(width: size?.width, height: size?.width)
  }
}

fileprivate struct EqualSizes: ViewModifier {
  @State var width: CGFloat?

  func body(content: Content) -> some View {
    content.onPreferenceChange(SizeKey.self, perform: { sizes in
      self.width = sizes.map { $0.width }.max()
    }).environment(\.size, width.map { CGSize(width: $0, height: $0) })
  }
}

extension View {
  func equalSize() -> some View {
    self.modifier(EqualSize())
  }

  func equalSizes() -> some View {
    self.modifier(EqualSizes())
  }
}

struct RingStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label.modifier(ButtonCircle(isPressed: configuration.isPressed))
  }
}

struct ContentView: View {
  var body: some View {
    HStack {
      Button(action: {}) {
        Text("Detener")
      }
      .foregroundColor(.red)

      Button(action: {}) {
        Text("GO")
      }
      .foregroundColor(.green)
    }
    .equalSizes()
    .buttonStyle(RingStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
