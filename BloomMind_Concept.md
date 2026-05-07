# BloomMind Concept

This document describes the original 1.x BloomMind direction. The active 2.0 direction is documented in `BloomMind_2_Concept.md`.

## One-Sentence Idea

BloomMind is a privacy-first interactive reflection garden that helps students turn overwhelming school emotions into one tiny, doable next step.

## Stage 4 Product Positioning

BloomMind should not feel like a generic mood tracker. Its strongest version is a short, memorable student experience:

1. Notice the emotion.
2. Name it without judgment.
3. Reflect for one minute.
4. Receive one small action.
5. Watch the emotion become part of a growing garden.

The project should be framed as student self-awareness and personal growth, not therapy, diagnosis, or clinical mental health support.

## Core Problem

Students often feel stress, pressure, or uncertainty, but they may not know how to describe what they feel or what small step to take next. Many wellness apps feel too heavy, too clinical, too data-driven, or too time-consuming for a quick daily check-in.

BloomMind focuses on a short, approachable experience: notice the feeling, name it, reflect on it, and choose one tiny action that can be done immediately.

## Target User

The primary user is a student who wants a calm daily habit for emotional awareness and self-growth.

The user may:

- Have only one or two minutes available.
- Want encouragement without judgment.
- Prefer simple visual feedback instead of long forms.
- Need a small action, not a complex plan.

## Challenge-Worthy Direction

To become stronger for the Swift Student Challenge, BloomMind should show three qualities clearly:

- Technical accomplishment: native SwiftUI interactions, local state, accessible controls, and a local rule-based reflection engine.
- Creativity: an emotion garden where different feelings grow into different animated visual forms.
- Meaningful impact: a student-centered tool that turns overwhelming feelings into a tiny action without collecting private data.

## Product Pillars

1. Private by default
   - No accounts.
   - No network calls.
   - Reflections stay on-device in the prototype.

2. One-minute useful
   - The full flow should be understandable in under one minute.
   - The app should never ask the user to complete a long form.

3. Feelings become growth
   - A completed check-in should visibly transform the garden.
   - Different moods should have different plant shapes, colors, and movement.

4. Small action over big advice
   - The app should suggest a tiny, concrete next step.
   - It should avoid medical claims or broad life advice.

5. Inclusive and calm
   - VoiceOver, Dynamic Type, Reduce Motion, and readable contrast should be treated as product features.
   - The tone should be warm, direct, and non-judgmental.

## App Experience

The app should feel calm, warm, and focused. It should avoid looking like a medical tool or a productivity dashboard.

Main experience flow:

1. The user opens the app and sees today's Bloom check-in.
2. The user chooses a current mood.
3. The user can write a short reflection, or skip it to continue quickly.
4. The app detects a simple reflection theme locally, when possible.
5. The app suggests one small growth action.
6. The user's daily bloom visually grows based on completed check-ins.

## MVP Scope

The current MVP includes:

- A SwiftUI home screen with the BloomMind identity.
- A mood selection interface.
- A short reflection input.
- A generated or preset growth action based on mood.
- A simple visual bloom progress state.
- Local-only state during the first build.

The next build should add:

- A more memorable emotion garden visual system.
- Mood-specific plant forms and animations.
- A local action engine that considers mood and reflection theme.
- A clear low-energy path for tired or overwhelmed students.
- Stronger accessibility and submission-ready wording.

The app should not include:

- Accounts or sign-in.
- Cloud sync.
- Analytics or tracking.
- Medical claims.
- Network calls.

## Current Build Target

The current build target is a working local SwiftUI prototype with three main screens:

1. Home
   - Shows app name, today's prompt, bloom progress, and a start check-in button.

2. Check-In
   - Lets the user select a mood and optionally write a short reflection.

3. Growth Action
   - Shows one small action matched to the selected mood.
   - Lets the user complete the check-in and return home.

## Award-Level Target

The award-level version should feel complete in a very short demo:

1. The reviewer opens BloomMind and sees a living garden instead of a static progress tracker.
2. The reviewer chooses a mood and can optionally write a short reflection.
3. The app extracts a simple local theme such as school, friendship, rest, pressure, or uncertainty.
4. The app creates one small action from mood plus theme.
5. A mood-specific plant grows into the garden with an accessible animation.
6. The reviewer understands the project story without needing extra explanation.

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

## Reflection Themes

The local action engine can start with a small, transparent rule set:

- School: homework, test, grade, class, deadline, project.
- Friendship: friend, family, team, group, lonely, conversation.
- Rest: tired, sleep, break, energy, exhausted.
- Pressure: stress, worried, rush, too much, overwhelmed.
- Uncertainty: maybe, unsure, confused, question, unclear.

These themes should never diagnose the user. They only help BloomMind choose a more useful tiny action.

## Visual Direction

The app should use a soft but not overly decorative interface.

Suggested design qualities:

- Clear readable typography.
- Calm color palette with green, blue, and warm accent colors.
- Rounded but restrained controls.
- A simple bloom illustration or progress symbol.
- Smooth state changes that make progress feel rewarding.

The next visual upgrade should make the garden the central object:

- Calm: steady leaf shape with gentle growth.
- Happy: bright flower shape with warm accent.
- Tired: moonlit sprout with slower motion.
- Stressed: wind-bent stem that settles after completion.
- Unsure: seedling with a small question-shaped curve.

## Swift Challenge Fit

BloomMind fits the Swift Student Challenge because it can demonstrate:

- SwiftUI interface design.
- State management.
- User interaction flow.
- Accessibility-friendly controls.
- Local-first privacy.
- A meaningful student-centered idea.
- A creative animated visual metaphor.
- Local natural-language-inspired rule logic without a server.

The project should stay small enough to be polished, but complete enough to feel like a real app.

## Next Implementation Steps

Stage 4 focuses on planning and product direction:

1. Update concept and roadmap documentation.
2. Lock the award-level direction around an interactive reflection garden.
3. Define the local action engine shape before implementing it.
4. Move into Stage 5 with a new thread and focus on the emotion garden UI.
