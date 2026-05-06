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
        modifier(BloomPageModifier(maxWidth: maxWidth, padding: padding))
    }

    func bloomPanel(padding: CGFloat = 18) -> some View {
        modifier(BloomPanelModifier(padding: padding))
    }
}

private struct BloomPageModifier: ViewModifier {
    let maxWidth: CGFloat
    let padding: CGFloat

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var horizontalPadding: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? max(16, padding * 0.75) : padding
    }

    func body(content: Content) -> some View {
        ScrollView {
            content
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, padding)
                .frame(maxWidth: maxWidth)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            BloomBackground()
        }
    }
}

private struct BloomPanelModifier: ViewModifier {
    let padding: CGFloat

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var backgroundOpacity: Double {
        colorSchemeContrast == .increased ? 0.9 : 0.68
    }

    private var strokeColor: Color {
        colorSchemeContrast == .increased ? .green.opacity(0.32) : .white.opacity(0.85)
    }

    private var shadowOpacity: Double {
        colorSchemeContrast == .increased ? 0 : 0.08
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.white.opacity(backgroundOpacity), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 1)
            }
            .shadow(color: .green.opacity(shadowOpacity), radius: 18, x: 0, y: 8)
    }
}
