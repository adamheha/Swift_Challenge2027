import SwiftUI

struct BloomBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [
                Color(red: 0.05, green: 0.11, blue: 0.08),
                Color(red: 0.05, green: 0.12, blue: 0.15),
                Color(red: 0.16, green: 0.12, blue: 0.07)
            ]
        }

        return [
            Color(red: 0.96, green: 0.99, blue: 0.95),
            Color(red: 0.93, green: 0.97, blue: 0.98),
            Color(red: 1.00, green: 0.97, blue: 0.91)
        ]
    }

    var body: some View {
        LinearGradient(
            colors: backgroundColors,
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

    func bloomCardBackground(tint: Color = .green) -> some View {
        modifier(BloomCardBackgroundModifier(tint: tint))
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

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color.black.opacity(colorSchemeContrast == .increased ? 0.78 : 0.58)
        }

        return Color.white.opacity(colorSchemeContrast == .increased ? 0.94 : 0.72)
    }

    private var strokeColor: Color {
        if colorScheme == .dark {
            return Color.white.opacity(colorSchemeContrast == .increased ? 0.26 : 0.12)
        }

        return colorSchemeContrast == .increased ? .green.opacity(0.32) : .white.opacity(0.85)
    }

    private var shadowOpacity: Double {
        colorSchemeContrast == .increased ? 0 : 0.08
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 1)
            }
            .shadow(color: .green.opacity(shadowOpacity), radius: 18, x: 0, y: 8)
    }
}

private struct BloomCardBackgroundModifier: ViewModifier {
    let tint: Color

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color.black.opacity(colorSchemeContrast == .increased ? 0.66 : 0.48)
        }

        return Color.white.opacity(colorSchemeContrast == .increased ? 0.92 : 0.72)
    }

    private var strokeColor: Color {
        tint.opacity(colorScheme == .dark ? 0.42 : 0.24)
    }

    func body(content: Content) -> some View {
        content
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 1)
            }
    }
}
