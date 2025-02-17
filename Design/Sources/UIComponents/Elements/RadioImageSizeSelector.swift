import SwiftUI

public struct RadioImageSizeSelector: View {
    public init(icon: Image?,
                iconSize: CGSize,
                iconSelectionColor: Color?,
                iconDefaultColor: Color = .gray,
                selectionCircleSize: CGSize = CGSize(width: 80, height: 80),
                circleSelectionColor: Color?,
                circleDefaultColor: Color = .clear,
                selectWhenSizeIs: Size,
                currentSize: Size,
                yOffset: CGFloat = 0) {
        self.icon = icon
        self.iconSize = iconSize
        self.iconSelectionColor = iconSelectionColor
        self.iconDefaultColor = iconDefaultColor
        self.selectionCircleSize = selectionCircleSize
        self.circleSelectionColor = circleSelectionColor
        self.circleDefaultColor = circleDefaultColor
        self.selectedSize = selectWhenSizeIs
        self.currentSize = currentSize
        self.yOffset = yOffset
    }
    
    let icon: Image?
    let iconSize: CGSize
    let iconSelectionColor: Color?
    let iconDefaultColor: Color
    var selectionCircleSize: CGSize = CGSize(width: 80, height: 80)
    let circleSelectionColor: Color?
    let circleDefaultColor: Color
    let selectedSize: Size
    let yOffset: CGFloat
    @State var currentSize: Size
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(currentSize == selectedSize ? circleSelectionColor : circleDefaultColor)
                .frame(width: selectionCircleSize.width, height: selectionCircleSize.height)
            
            icon?
                .resizable()
                .foregroundColor(currentSize == selectedSize ? iconSelectionColor : iconDefaultColor)
                .frame(width: iconSize.width, height: iconSize.height)
                .offset(y: yOffset)
        }
    }
}
import SwiftUI



struct RadioImageSizeSelector_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            RadioImageSizeSelector(
                icon: Image(systemName: "star.fill"),
                iconSize: CGSize(width: 40, height: 40),
                iconSelectionColor: .yellow,
                iconDefaultColor: .gray,
                selectionCircleSize: CGSize(width: 80, height: 80),
                circleSelectionColor: .blue,
                circleDefaultColor: .clear,
                selectWhenSizeIs: .small,
                currentSize: .small
            )
            
            RadioImageSizeSelector(
                icon: Image(systemName: "bell.fill"),
                iconSize: CGSize(width: 40, height: 40),
                iconSelectionColor: .red,
                iconDefaultColor: .gray,
                selectionCircleSize: CGSize(width: 80, height: 80),
                circleSelectionColor: .green,
                circleDefaultColor: .clear,
                selectWhenSizeIs: .medium,
                currentSize: .medium
            )
            
            RadioImageSizeSelector(
                icon: Image(systemName: "person.circle.fill"),
                iconSize: CGSize(width: 40, height: 40),
                iconSelectionColor: .green,
                iconDefaultColor: .gray,
                selectionCircleSize: CGSize(width: 80, height: 80),
                circleSelectionColor: .purple,
                circleDefaultColor: .clear,
                selectWhenSizeIs: .large,
                currentSize: .large
            )
            
            RadioImageSizeSelector(
                icon: Image(systemName: "photo"),
                iconSize: CGSize(width: 40, height: 40),
                iconSelectionColor: .blue,
                iconDefaultColor: .gray,
                selectionCircleSize: CGSize(width: 80, height: 80),
                circleSelectionColor: .orange,
                circleDefaultColor: .clear,
                selectWhenSizeIs: .small,
                currentSize: .large // Icono no seleccionado
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
