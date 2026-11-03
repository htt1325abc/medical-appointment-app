---
name: medical-appointment-ux-ui
description: Design, build, or review polished Flutter interfaces for the medical appointment application. Use for patient, doctor, or admin screens, design systems, UX flows, responsive behavior, accessibility, UI copy, and visual QA in this repository. Do not use for backend-only work with no user-interface impact.
---

# Medical Appointment UX UI

Create a healthcare experience that feels calm, precise, humane, and trustworthy. The product serves Vietnamese patients, doctors, and administrators. Clinical clarity matters more than decoration, but the result must feel intentionally designed rather than like a default Flutter template.

Before UI work, read `docs/figma-implementation-plan.md`. Treat it as the repository source of truth for screen scope, routes, UX flows, and implementation order. When exact Figma layer values are available, they override fallback visual values in this skill. Never invent a value marked `TBD-FIGMA` in that document.

## Visual direction

Use the concept **A calm path to care**. The signature element is a continuous care-path line that connects discovery, booking, confirmation, and completion. Reuse it selectively for appointment progress and status history; do not turn every screen into a timeline.

Use the extracted MediCare+ tokens from Figma:

- Primary `#069ACA` and deep `#006DA5`: actions, links, and active navigation.
- Ink `#101B32`: primary text and high-emphasis surfaces.
- Muted `#6F839E`: secondary text and inactive content.
- Soft `#EDF7FC`: input and supportive surfaces.
- Success `#20C98B`, danger `#F85663`, warning `#FFAF1A`.
- App background `#FAFDFF`; border `#DCE8F0`.

Use Inter for all text. The Figma type scale is 10, 11, 12, 14, 16, 18, 20, 24, 28, and 32 px with 145% line height for the inspected auth styles. Ensure complete Vietnamese glyph support and use tabular figures for times, dates, OTP, and appointment identifiers.

Use soft geometry with deliberate contrast: large surfaces may use 20-24 px radii, controls 12-16 px, and compact status chips fully rounded. Avoid stacking cards inside cards, excessive shadows, ornamental gradients, glass effects, or random radius values. Icons must communicate meaning without relying on emoji.

## Design by role

- Patient UI is mobile-first, reassuring, and task-focused. Keep one primary action per screen and make the next step obvious.
- Doctor UI prioritizes scanning appointments, status, patient identity, date, and time. Keep confirm and reject actions distinct and hard to trigger accidentally.
- Admin UI is adaptive and information-dense. Prefer lists or tables on wide screens and readable cards on narrow screens. Preserve search, filters, pagination, and clear destructive-action confirmation.

## Required UX behavior

Treat appointment state as a visible state machine:

`draft -> pending -> confirmed -> completed`

`pending -> rejected`, and `pending|confirmed -> cancelled`.

Do not label a pending request as a confirmed appointment. Show who must act next, what changed, and which actions remain available. Prevent rating until an appointment is completed.

Every data-driven screen must design loading, populated, empty, error, offline, and retry states. Forms must show inline Vietnamese validation and preserve valid input after failure. Destructive actions require confirmation; important actions should offer recovery when practical.

Write concise Vietnamese UI copy from the user's point of view. Use sentence case and consistent verbs. Button text must name the result, such as `Xác nhận lịch khám`, `Lưu hồ sơ`, or `Hủy lịch khám`; avoid vague labels such as `Gửi` or `OK` when a clearer action exists.

## Workflow

Before implementation:

1. State the screen's audience and single job.
2. Produce a compact plan covering color, type, layout, and the one signature interaction or visual.
3. Sketch the information hierarchy and primary action. Revise anything that could belong unchanged to a generic commerce or dashboard template.

During implementation:

- Build from shared theme tokens and reusable components; do not hard-code visual values repeatedly in feature screens.
- Keep business logic outside widgets. Screens render state and forward user intent to a view model or controller.
- Use responsive constraints rather than device-name checks. Support narrow phones, large phones, tablets, and wide admin layouts when the feature applies.
- Respect SafeArea, keyboard insets, text scaling, reduced motion, dark-mode requirements when requested, and platform interaction conventions.
- Give interactive targets at least 48 x 48 logical pixels and provide meaningful semantics labels.

After implementation:

1. Run formatter, analyzer, and relevant unit/widget tests.
2. Inspect screenshots at approximately 360 x 800, 412 x 915, and 768 px width; also inspect a wide layout for admin work.
3. Check overflow, keyboard obstruction, long Vietnamese text, empty/error states, contrast, focus order, and large text.
4. Remove one unnecessary decorative element and verify that hierarchy is still clear.

## Completion standard

A UI task is complete only when it matches the repository design tokens, covers non-happy states, works at applicable widths, uses production-quality Vietnamese copy, passes static analysis and relevant tests, and has been visually inspected. Do not claim visual completion from code inspection alone.
