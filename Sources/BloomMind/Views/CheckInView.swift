import SwiftUI
#if os(macOS)
import AppKit
#endif

struct CheckInView: View {
    @Binding var checkInState: CheckInState
    let onContinue: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var reflectionMinHeight: CGFloat = 140

    private var moodButtonMinimumWidth: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 180 : 130
    }

    private var moodGridColumns: [GridItem] {
        [GridItem(.adaptive(minimum: moodButtonMinimumWidth), spacing: 12)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            StepProgressView(currentStep: 2)
                .bloomPanel(padding: 12)

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your mood")
                    .font(.title.bold())

                Text("Pick the closest feeling. It does not need to be perfect.")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LazyVGrid(columns: moodGridColumns, spacing: 12) {
                ForEach(Mood.allCases) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: checkInState.selectedMood == mood
                    ) {
                        checkInState.selectedMood = mood
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Reflection")
                        .font(.headline)

                    Spacer()

                    Text("\(checkInState.reflectionCharacterCount)/\(CheckInState.reflectionCharacterLimit)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(checkInState.isReflectionWithinLimit ? Color.secondary : Color.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Reflection")
                .accessibilityValue(checkInState.reflectionAccessibilityValue)
                .accessibilityHint(checkInState.reflectionAccessibilityHint)

                ZStack(alignment: .topLeading) {
                    ReflectionTextView(
                        text: $checkInState.reflectionText,
                        minHeight: reflectionMinHeight
                    )
                    .frame(maxWidth: .infinity, minHeight: reflectionMinHeight, alignment: .topLeading)

                    if checkInState.reflectionText.isEmpty {
                        Text(CheckInState.reflectionPromptText)
                            .foregroundStyle(.secondary)
                            .padding(12)
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                }
                .accessibilityLabel("Reflection")
                .accessibilityValue(checkInState.reflectionAccessibilityValue)
                .accessibilityHint(checkInState.reflectionAccessibilityHint)
                .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.green.opacity(0.2), lineWidth: 1)
                }

                if !checkInState.isReflectionWithinLimit {
                    Label("Keep this reflection short enough for a one-minute check-in.", systemImage: "exclamationmark.circle")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityHint("Shorten your reflection before continuing.")
                }
            }

            Spacer()

            Button(action: onContinue) {
                Label("Continue", systemImage: "arrow.right")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!checkInState.canContinueToAction)
            .accessibilityHint(checkInState.continueActionAccessibilityHint)
        }
        .bloomPage(maxWidth: 620)
        .navigationTitle("Check-In")
    }
}

#if !os(macOS)
private struct ReflectionTextView: View {
    @Binding var text: String
    let minHeight: CGFloat

    var body: some View {
        TextEditor(text: $text)
            .font(.body)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .topLeading)
    }
}
#else
private struct ReflectionTextView: NSViewRepresentable {
    @Binding var text: String
    let minHeight: CGFloat

    func makeNSView(context: Context) -> FocusableReflectionNSTextView {
        let textView = FocusableReflectionNSTextView()
        textView.delegate = context.coordinator
        textView.string = text
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .labelColor
        textView.insertionPointColor = .controlAccentColor
        textView.backgroundColor = .clear
        textView.drawsBackground = false
        textView.isRichText = false
        textView.importsGraphics = false
        textView.allowsUndo = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width, .height]
        textView.minSize = NSSize(width: 0, height: minHeight)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainerInset = NSSize(width: 12, height: 12)
        textView.textContainer?.widthTracksTextView = true
        return textView
    }

    func updateNSView(_ textView: FocusableReflectionNSTextView, context: Context) {
        context.coordinator.parent = self

        if textView.string != text {
            textView.string = text
        }

        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .labelColor
        textView.insertionPointColor = .controlAccentColor
        textView.minSize = NSSize(width: 0, height: minHeight)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: ReflectionTextView

        init(parent: ReflectionTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            parent.text = textView.string
        }
    }
}

private final class FocusableReflectionNSTextView: NSTextView {
    override var acceptsFirstResponder: Bool {
        true
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        super.mouseDown(with: event)
    }
}
#endif

private struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    @ScaledMetric(relativeTo: .body) private var buttonMinHeight: CGFloat = 92
    @ScaledMetric(relativeTo: .title2) private var iconSize: CGFloat = 24

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: mood.symbolName)
                    .font(.system(size: iconSize, weight: .regular))
                Text(mood.rawValue)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, minHeight: buttonMinHeight)
            .foregroundStyle(isSelected ? .white : mood.tint)
            .background(isSelected ? mood.tint.gradient : mood.tint.opacity(0.12).gradient, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .white.opacity(0.7) : mood.tint.opacity(0.22), lineWidth: 1)
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mood.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(mood.accessibilityHint)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                CheckInView(
                    checkInState: .constant(CheckInState()),
                    onContinue: {}
                )
            }
            .previewDisplayName("Check-In - Empty")

            NavigationStack {
                CheckInView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .calm,
                            reflectionText: "I feel steady enough to start small."
                        )
                    ),
                    onContinue: {}
                )
            }
            .previewDisplayName("Check-In - Selected")
        }
    }
}
