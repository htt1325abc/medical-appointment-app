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

Start the SQLite appointment API:

```bash
cd backend
cp .env.example .env
npm install
npm run db:setup
npm run dev
```

Then run Flutter in another terminal:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

For a physical Android device, run `adb reverse tcp:3000 tcp:3000` first.
The real API covers specialties, doctors, available slots, booking, patient
appointments, and doctor confirmation/rejection. Other showcase modules remain
mocked for the UX/UI course scope. See [`backend/README.md`](backend/README.md).

## Quality checks

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
cd backend && npm test
```
