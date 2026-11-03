# Medical Appointment App

A Flutter application for discovering doctors and hospitals, booking medical appointments, and managing appointment workflows for patients, doctors, and administrators.

## Product direction

The interface follows the **A calm path to care** visual concept: clear clinical information, warm guidance, accessible interactions, and an explicit appointment journey from discovery to completion.

The repository includes a project-scoped Codex skill at [`.agents/skills/medical-appointment-ux-ui/SKILL.md`](.agents/skills/medical-appointment-ux-ui/SKILL.md). Codex can use it automatically for design, implementation, and UI review tasks in this project.

The captured Figma screen map, UX decisions, and Flutter implementation phases live in [`docs/figma-implementation-plan.md`](docs/figma-implementation-plan.md). Read this file before implementing a feature; exact visual values still marked `TBD-FIGMA` must be taken from Figma layers rather than guessed from the compressed canvas thumbnail.

## Supported platforms

- Android
- iOS
- Web

## Run locally

```bash
flutter pub get
flutter run
```

## Quality checks

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```
