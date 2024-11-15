import SwiftUI

public struct InformativeCard: View {
    @State var vm: InformativeCardViewModel
    
    public var body: some View {
        HStack {
            icon
            message
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(vm.colorBasedOnType)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
        )
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
        )
        .padding([.top, .bottom])
    }
    
    private var icon: some View {
        Image(systemName: vm.iconBasedOnType)
            .foregroundColor(vm.textColorBasedOnType)
            .font(.system(size: 20))
    }
    
    private var message: some View {
        Text(vm.text)
            .foregroundColor(vm.textColorBasedOnType)
            .font(.system(size: 12, weight: .medium, design: .default))
            .lineSpacing(6)
            .padding(.leading, 7)
            .fixedSize(horizontal: false, vertical: true)
    }
}

public extension InformativeCard {
    static var preview: some View {
        VStack {
            InformativeCard(vm: .init(text: "This is a base card", type: .BASE))
            InformativeCard(vm: .init(text: "This is a warning card", type: .WARNING))
            InformativeCard(vm: .init(text: "This is a danger card", type: .DANGER))
            InformativeCard(vm: .init(text: "This is a success card", type: .SUCCESS))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

#Preview {
    InformativeCard.preview
}


