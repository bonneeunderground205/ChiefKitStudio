# Architecture

The project uses a simple SwiftPM macOS app structure:

```text
Sources/ChiefKitStudio/
  App/
  Components/
  DemoData/
  Export/
  Models/
  Resources/
  ViewModels/
  Views/
```

## Responsibilities

- `App/`: app entry point and launch setup
- `Components/`: reusable UI pieces and assets
- `DemoData/`: sample snippets, JSON, and template data
- `Export/`: clipboard and file export support
- `Models/`: navigation, package, template, and flow models
- `Resources/`: app icon and logo assets
- `ViewModels/`: playground state and actions
- `Views/`: sidebar, demos, templates, code preview, and action bar

The app intentionally avoids external dependencies so it can compile cleanly
while presenting copyable examples for the ChiefKit packages.
