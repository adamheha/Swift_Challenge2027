import SwiftUI

struct BloomBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.96, green: 0.99, blue: 0.95),
                Color(red: 0.93, green: 0.97, blue: 0.98),
                Color(red: 1.00, green: 0.97, blue: 0.91)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    func bloomPage(maxWidth: CGFloat = 560, padding: CGFloat = 24) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                BloomBackground()
            }
    }

    func bloomPanel(padding: CGFloat = 18) -> some View {
        self
            .padding(padding)
            .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.85), lineWidth: 1)
            }
            .shadow(color: .green.opacity(0.08), radius: 18, x: 0, y: 8)
    }
}
