import SwiftUI

public struct EventCard: View {
    @State var viewModel: EventCardViewModel

    public var body: some View {
        GeometryReader { geometry in
            let cornerRadius = geometry.size.width * 0.04
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.clear)
                .background(
                    eventImage(cornerRadius: cornerRadius)
                        .overlay(eventDetails)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                )
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(10)
        }
    }

    private func eventImage(cornerRadius: CGFloat) -> some View {
        ZStack {
            Group {
                switch viewModel.imageLoader.state {
                    case .loading:
                        ElementLoadingPlaceholderView()
                    case .failure:
                        Image(systemName: "tree")
                            .resizable()
                            .scaledToFill()
                    case .success(let image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                        
                }
                gradientOverlay(cornerRadius: cornerRadius)
            }.frame(maxWidth: .infinity, maxHeight: 150)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }

    private func gradientOverlay(cornerRadius: CGFloat) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .mask(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            eventDate
            Spacer()
            Text(viewModel.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
            Text(viewModel.location ?? "Undefined location")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding([.vertical, .horizontal], 16)
    }

    private var eventDate: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                if let startDate = viewModel.startDate {
                    Text(startDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                if let endDate = viewModel.endDate {
                    Text(endDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

public extension EventCard {
    static var preview: some View {
        VStack {
            EventCard(viewModel: EventCardViewModel(
                title: "Event 1",
                location: "Location 1",
                startDate: "01/01/2023",
                endDate: "02/01/2023",
                imageLoader: ImageLoader(imageSource: .url(URL(string: "https://www.obbstartersandalternators.com/images/test.png")!))
            ))
            .frame(width: 300, height: 150)
            
            EventCard(viewModel: EventCardViewModel(
                title: "Event 2",
                location: nil,
                startDate: "01/02/2023",
                endDate: "02/02/2023",
                imageLoader: ImageLoader(imageSource: .url(URL(string: "https://cdn.pixabay.com/photo/2014/06/03/19/38/board-361516_640.jpg")!))
            ))
            .frame(width: 300, height: 200)
            
            EventCard(viewModel: EventCardViewModel(
                title: "Event 2",
                location: nil,
                startDate: "01/02/2023",
                endDate: "02/02/2023",
                imageLoader: ImageLoader(imageSource: .none)))
            .frame(width: 300, height: 200)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

#Preview {
    EventCard.preview
}
