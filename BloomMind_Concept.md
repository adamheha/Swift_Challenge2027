# BloomMind Concept

## One-Sentence Idea

BloomMind is a gentle SwiftUI reflection app that helps students turn daily emotions into small personal growth actions.

## Core Problem

Students often feel stress, pressure, or uncertainty, but they may not know how to describe what they feel or what small step to take next. Many wellness apps feel too heavy, too clinical, or too time-consuming for a quick daily check-in.

BloomMind focuses on a short, approachable experience: notice the feeling, name it, reflect on it, and choose one tiny action.

## Target User

The primary user is a student who wants a calm daily habit for emotional awareness and self-growth.

The user may:

- Have only one or two minutes available.
- Want encouragement without judgment.
- Prefer simple visual feedback instead of long forms.
- Need a small action, not a complex plan.

## App Experience

The app should feel calm, warm, and focused. It should avoid looking like a medical tool or a productivity dashboard.

Main experience flow:

1. The user opens the app and sees today's Bloom check-in.
2. The user chooses a current mood.
3. The user writes a short reflection.
4. The app suggests one small growth action.
5. The user's daily bloom visually grows based on completed check-ins.

## MVP Scope

The first version should include:

- A SwiftUI home screen with the BloomMind identity.
- A mood selection interface.
- A short reflection input.
- A generated or preset growth action based on mood.
- A simple visual bloom progress state.
- Local-only state during the first build.

The first version should not include:

- Accounts or sign-in.
- Cloud sync.
- Analytics or tracking.
- Medical claims.
- Network calls.

## First Build Target

The first build target is a working local SwiftUI prototype with three main screens:

1. Home
   - Shows app name, today's prompt, bloom progress, and a start check-in button.

2. Check-In
   - Lets the user select a mood and write a short reflection.

3. Growth Action
   - Shows one small action matched to the selected mood.
   - Lets the user complete the check-in and return home.

## Suggested Mood Set

The MVP can start with five moods:

- Calm
- Happy
- Tired
- Stressed
- Unsure

Each mood maps to a simple action:

- Calm: Write down one thing you want to protect today.
- Happy: Share one kind sentence with someone.
- Tired: Take three slow breaths and lower one expectation.
- Stressed: Choose the smallest next step and do only that.
- Unsure: Write one question you want to understand better.

## Visual Direction

The app should use a soft but not overly decorative interface.

Suggested design qualities:

- Clear readable typography.
- Calm color palette with green, blue, and warm accent colors.
- Rounded but restrained controls.
- A simple bloom illustration or progress symbol.
- Smooth state changes that make progress feel rewarding.

## Swift Challenge Fit

BloomMind fits the Swift Student Challenge because it can demonstrate:

- SwiftUI interface design.
- State management.
- User interaction flow.
- Accessibility-friendly controls.
- Local-first privacy.
- A meaningful student-centered idea.

The project should stay small enough to be polished, but complete enough to feel like a real app.

## Next Implementation Step

Create the initial SwiftUI project structure and build the MVP screens:

- `BloomMindApp`
- `HomeView`
- `CheckInView`
- `GrowthActionView`
- A simple `Mood` model
- Local state for selected mood, reflection text, and completed check-ins
