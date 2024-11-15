import SwiftUI

@available(iOS 15.0, *)
public struct DashedSeparatorLine: View {
    public init (lineColor: Color? = nil) {
        self.lineColor = lineColor
    }
    
    let lineColor: Color?
    
    public var body: some View {
        Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
            .frame(height: 1)
            .foregroundColor(lineColor)
            .padding(.trailing, -16)
            .listRowSeparator(.hidden)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

