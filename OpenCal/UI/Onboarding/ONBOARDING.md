# Onboarding Flow — AI Calorie Tracker

> Documentación de referencia del flujo de onboarding.
> Cubre cada pantalla: estructura, componentes, estilos y comportamiento.

---

## Arquitectura general

| Elemento | Detalle |
|---|---|
| Contenedor | `OnboardingContainerView` — ZStack con switch por `currentStep` |
| ViewModel | `OnboardingViewModel` — único, compartido entre todos los pasos |
| Navegación | `currentStep: Int` (1–5); al superar 5 se completa el onboarding |
| Transición | `.asymmetric(insertion: .move(.trailing), removal: .move(.leading))` + `.animation(.spring())` |
| Finalización | `UserProfile.save()` → `appState.completeOnboarding()` → app navega a `AppRootView` |
| Persistencia | `UserProfile` se guarda en **UserDefaults** como JSON (Phase 2 migra a SwiftData) |
| API Key | Se guarda en **Keychain** via `KeychainHelper` |

---

## Tokens de diseño usados

Todos los valores vienen de `AppConstants` en `Core/Constants.swift`.

### Colores
| Token | Valor | Uso |
|---|---|---|
| `backgroundPrimary` | `#F6F6F6` | Fondo de todas las pantallas |
| `backgroundSecondary` | `#E5E5EA` | Fondo de inputs y botón secundario |
| `backgroundCard` | `white` | Card seleccionado en goal picker |
| `textPrimary` | `#000000` | Títulos |
| `textSecondary` | `#8E8E93` | Subtítulos, labels de campo, placeholder |
| `textTertiary` | `#AEAEB2` | Step indicator, unidades, divisor |
| `ringFilled` | `#000000` | Tint del botón primario |

### Tipografía
| Token | Tamaño / Peso | Uso |
|---|---|---|
| `macroGoal` | 12pt regular | Step indicator ("1 of 5"), unidades |
| `userName` | 28pt bold | Título principal de cada pantalla |
| `mealSubtitle` | 14pt regular | Subtítulo, texto de inputs |
| `macroLabel` | 14pt semibold | Labels de campo, botón ✨ |

### Espaciado
| Token | Valor | Uso |
|---|---|---|
| `screenHorizontal` | 21pt | — (onboarding usa 32pt horizontal) |
| `cardCornerRadius` | 20pt | Corner radius de cards en goal picker |

---

## Pantalla 1 — "Let's get started"

**Archivo:** `UI/Onboarding/Steps/OnboardingStep1View.swift`

### Layout
```
VStack(alignment: .leading)
├── Text "1 of 5"               ← step indicator
├── Text "Let's get started"    ← título
├── Text "Tell us a bit..."     ← subtítulo
├── Label "Name"
├── TextField (nombre)
├── Label "Date of birth"
├── DatePicker
├── Label "Biological sex"
├── Picker segmented
├── Spacer
└── Button "Continue"
```

### Componentes

**Step indicator**
- Font: `macroGoal` (12pt regular)
- Color: `textTertiary`
- Padding bottom: 12pt

**Título**
- Font: `userName` (28pt bold)
- Color: `textPrimary`
- Padding bottom: 4pt

**Subtítulo**
- Font: `mealSubtitle` (14pt regular)
- Color: `textSecondary`
- Padding bottom: 40pt

**TextField — Nombre**
- Binding: `@State private var name` (local, se escribe a `viewModel.name` solo al avanzar)
- Modificadores: `.textInputAutocapitalization(.words)`, `.autocorrectionDisabled()`
- Submit label: `.done`
- Focus: `@FocusState` — se activa automáticamente en `.onAppear`
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 10)`
- Padding interno: 12pt

**DatePicker — Fecha de nacimiento**
- Binding: `@State private var birthDate`
- Style: `.compact`, `.labelsHidden()`
- Rango máximo: 13 años antes de hoy (no menores)
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 10)`
- Padding interno: 12pt

**Picker — Sexo biológico**
- Binding: `@State private var biologicalSex`
- Opciones: `BiologicalSex.allCases` → "Male", "Female", "Prefer not to say"
- Style: `.segmented`

**Botón primario — "Continue"**
- Style: `.borderedProminent`, tint `ringFilled` (negro)
- Size: `.large`, `maxWidth: .infinity`
- Deshabilitado cuando `name.trimmingCharacters(in: .whitespaces).isEmpty`
- Al tocar: escribe los 3 `@State` al viewModel → llama `viewModel.advance()`

### Padding contenedor
- Horizontal: 32pt
- Vertical: 48pt

---

## Pantalla 2 — "Your body"

**Archivo:** `UI/Onboarding/Steps/OnboardingStep2View.swift`

### Layout
```
VStack(alignment: .leading)
├── Text "2 of 5"
├── Text "Your body"
├── Text "This helps the AI..."
├── HStack
│   ├── VStack [Label "Weight" + TextField + "kg"]
│   └── VStack [Label "Height" + TextField + "cm"]
├── Spacer
└── VStack
    ├── Button "Continue"
    └── Button "Skip for now"
```

### Componentes

**Campos lado a lado (HStack spacing: 16)**

Cada campo:
- VStack(alignment: .leading, spacing: 8)
- Label: font `macroLabel`, color `textSecondary`
- HStack: `TextField` + texto de unidad
- TextField binding: `$viewModel.weightKg` / `$viewModel.heightCm`
- Keyboard: `.decimalPad`
- Unidad: font `mealSubtitle`, color `textSecondary`
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 10)`, padding 12pt
- Cada campo: `.frame(maxWidth: .infinity)`

**Botón primario — "Continue"**
- Style: `.borderedProminent`, tint negro, `.large`
- Siempre habilitado (campo opcional)
- Al tocar: `viewModel.advance()`

**Botón secundario — "Skip for now"**
- Style: `.plain`, color `textSecondary`
- Al tocar: `viewModel.skip()` (equivalente a `advance()`)

---

## Pantalla 3 — "Your daily goals"

**Archivo:** `UI/Onboarding/Steps/OnboardingStep3View.swift`

### Layout
```
VStack(alignment: .leading)
├── Text "3 of 5"
├── Text "Your daily goals"
├── Text "You can always change..."
├── Button "✨ Help me set these"
├── HStack [línea — "or set manually" — línea]
├── LazyVGrid (2 columnas)
│   ├── macroCell "Calories / kcal"
│   ├── macroCell "Protein / g"
│   ├── macroCell "Carbs / g"
│   └── macroCell "Fat / g"
├── Spacer
└── Button "Continue"
```

### Componentes

**Botón "✨ Help me set these"**
- Style: `.plain`
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 12)`
- Padding vertical interno: 14pt
- Al tocar: `viewModel.showGoalPicker = true` → presenta `FitnessGoalPickerView`

**Divisor con texto**
- HStack: `Rectangle(height: 1, color: backgroundSecondary)` — texto — `Rectangle`
- Texto: "or set manually", font `macroGoal`, color `textTertiary`

**LazyVGrid — 2 columnas, spacing: 16**

Cada `macroCell`:
- VStack(alignment: .leading, spacing: 6)
- Label: font `macroLabel`, color `textSecondary`
- HStack: `TextField` (decimalPad) + unidad
- TextField font: `mealSubtitle`
- Unidad: font `macroGoal`, color `textTertiary`
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 10)`, padding 12pt

**Botón primario — "Continue"**
- Deshabilitado cuando `calorieGoal` no es un número > 0

---

### Sheet — FitnessGoalPickerView

Presentado sobre el paso 3 cuando el usuario toca "✨ Help me set these".

**Presentación:**
- `.presentationDetents([.medium])`
- `.presentationCornerRadius(32)`

**Layout:**
```
VStack(alignment: .leading, spacing: 20)
├── Text "What's your goal?"
├── goalCard(.lose)
├── goalCard(.maintain)
└── goalCard(.gain)
```

**Cada goalCard:**
- HStack(spacing: 16): icono SF Symbol (28pt) + VStack [título, subtítulo] + Spacer
- Padding: 16pt, `maxWidth: .infinity`
- Fondo seleccionado: `backgroundCard` (blanco) + borde negro 2pt
- Fondo no seleccionado: `backgroundSecondary`, borde transparente
- Efecto: `.glassEffect()` sobre `RoundedRectangle(cornerRadius: 20)`
- Style: `.plain`

| Goal | Icono | Título | Subtítulo | Defaults |
|---|---|---|---|---|
| `.lose` | `flame.fill` | "Lose weight" | "Caloric deficit" | 1600 kcal / 160g P / 150g C / 55g F |
| `.maintain` | `equal.circle.fill` | "Maintain weight" | "Balanced intake" | 2000 kcal / 150g P / 200g C / 65g F |
| `.gain` | `bolt.fill` | "Gain muscle" | "Caloric surplus" | 2500 kcal / 180g P / 280g C / 80g F |

**Al seleccionar:** escribe los 5 valores al viewModel y cierra el sheet.

---

## Pantalla 4 — "Connect your AI"

**Archivo:** `UI/Onboarding/Steps/OnboardingStep4View.swift`

### Layout
```
VStack(alignment: .leading)
├── Text "4 of 5"
├── Text "Connect your AI"
├── Text "Used to analyze food photos..."
├── Label "Provider"
├── Picker segmented (OpenAI / Gemini)
├── Label "API Key"
├── SecureField
├── Button "How to get an API key →"
├── Spacer
└── VStack
    ├── Button "Continue"
    └── Button "Skip for now"
```

### Componentes

**Picker — Provider**
- Binding: `$viewModel.apiProvider`
- Opciones: `AIProvider.allCases` → "OpenAI", "Gemini"
- Style: `.segmented`
- Padding bottom: 20pt

**SecureField — API Key**
- Binding: `$viewModel.apiKey`
- Modificadores: `.textContentType(.password)`, `.autocorrectionDisabled()`
- Placeholder: "Paste your API key"
- Fondo: `backgroundSecondary` + `RoundedRectangle(cornerRadius: 10)`, padding 12pt

**Link — "How to get an API key →"**
- Style: `.plain`
- Color: `.blue`
- Font: `macroGoal`
- URL dinámica según provider:
  - OpenAI: `https://platform.openai.com/api-keys`
  - Gemini: `https://aistudio.google.com/apikey`
- Abre en Safari via `@Environment(\.openURL)`

**Botón primario — "Continue"**
- Siempre habilitado
- Al tocar: si `apiKey` no está vacío → `KeychainHelper.save(key, for: AppConstants.Keychain.apiKeyIdentifier)` → `viewModel.advance()`

**Botón secundario — "Skip for now"**
- Al tocar: `viewModel.skip()`

---

## Pantalla 5 — "Connect Health"

**Archivo:** `UI/Onboarding/Steps/OnboardingStep5View.swift`

### Layout
```
VStack(alignment: .leading)
├── Text "5 of 5"
├── Image "heart.fill" (60pt, rojo, centrado)
├── Text "Connect Health"
├── Text "Sync calories burned..."
├── VStack
│   ├── HStack [checkmark.circle.fill (verde) | "Active calories burned"]
│   ├── HStack [checkmark.circle.fill (verde) | "Steps"]
│   └── HStack [checkmark.circle.fill (verde) | "Workouts"]
├── Spacer
└── VStack
    ├── Button "Allow Health Access"
    └── Button "Skip"
```

### Componentes

**Icono hero**
- SF Symbol: `heart.fill`
- Tamaño: 60pt
- Color: `.red`
- Alineado al centro horizontalmente

**Lista de datos de salud**
- VStack(spacing: 16)
- Cada item: HStack(spacing: 12) con `checkmark.circle.fill` (verde, 20pt) + texto
- Font: `mealSubtitle`, color `textPrimary`

**Botón primario — "Allow Health Access"**
- Al tocar: `print("HealthKit request — Phase 3")` + `viewModel.advance()`
- ⚠️ Implementación real de HealthKit pendiente para Phase 3

**Botón secundario — "Skip"**
- Al tocar: `viewModel.advance()`

**Al avanzar desde el paso 5:**
`currentStep` pasa a 6 → `OnboardingContainerView.onChange` detecta `6 > totalSteps (5)` → `UserProfile.save(profile)` + `appState.completeOnboarding()` → app muestra `AppRootView`.

---

## Flujo completo

```
Paso 1 ──► Paso 2 ──► Paso 3 ──► Paso 4 ──► Paso 5 ──► AppRootView
 Perfil     Cuerpo     Goals      AI Key     HealthKit
 (req.)    (skip ok)  (req.)    (skip ok)   (skip ok)
```

- Los pasos con "skip ok" tienen botón "Skip for now" que llama `viewModel.skip()` (idéntico a `advance()`).
- El paso 1 requiere nombre para habilitar "Continue".
- El paso 3 requiere calorías > 0 para habilitar "Continue".
- La transición entre pasos es un slide horizontal (entrada desde la derecha, salida hacia la izquierda).

---

## Archivos relacionados

| Archivo | Rol |
|---|---|
| `UI/Onboarding/OnboardingContainerView.swift` | Contenedor, switch de pasos, lógica de finalización |
| `UI/Onboarding/OnboardingViewModel.swift` | Estado de todos los pasos, navegación |
| `Domain/Models/OnboardingModels.swift` | Enums: `BiologicalSex`, `FitnessGoal`, `AIProvider` |
| `Core/Utilities/KeychainHelper.swift` | Guardar/leer/borrar API key en Keychain |
| `Core/AppState.swift` | `hasCompletedOnboarding`, `completeOnboarding()` |
| `Domain/Models/UserProfile.swift` | Modelo + extensión `save()`/`load()` via UserDefaults |
