import SwiftUI

public struct BasicCellWithIcon: View {
    let vm: BasicCellWithIconViewModel
    
    public var body: some View {
        HStack {
            vm.icon?
                .renderingMode(.template)
                .foregroundColor(vm.iconColor)
            Text(vm.title)
                .font(.system(size: 20))
                .fontWeight(.bold)
            Spacer()
            Text(vm.text)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(vm.textColor)
                .frame(alignment: .trailing)
                .padding(.trailing, 16)
                .padding(.leading, 10)
        }
    }
}

// MARK: - Preview

public extension BasicCellWithIcon {
    static var preview: some View {
        VStack(spacing: 20) {
            BasicCellWithIcon(vm: .init(
                icon: Image(systemName: "star.fill"),
                iconColor: .yellow,
                title: "Favorites",
                text: "5 items",
                textColor: .gray
            ))
            .padding()
            
            BasicCellWithIcon(vm: .init(
                icon: Image(systemName: "bell.fill"),
                iconColor: .red,
                title: "Notifications",
                text: "3 unread",
                textColor: .blue
            ))
            .padding()
            
            BasicCellWithIcon(vm: .init(
                icon: Image(systemName: "person.circle.fill"),
                iconColor: .green,
                title: "Profile",
                text: "Active",
                textColor: .black
            ))
            .padding()
            
            BasicCellWithIcon(vm: .init(
                icon: nil,
                title: "No Icon Example",
                text: "Sample Text",
                textColor: .purple
            ))
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    BasicCellWithIcon.preview
}
