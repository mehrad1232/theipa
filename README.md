# NOVA Calculator — iOS 12 Edition

Native Swift/UIKit integer calculator designed for iOS 12 and iPhone 5s. It avoids SwiftUI and external dependencies.

Features:
- Persian dark-neon interface
- Full arithmetic expressions and nested parentheses
- Positive and negative integers and unary sign handling
- Automatic parentheses balance feedback
- Addition, subtraction, multiplication and integer-only division
- Rejects divide-by-zero, fractional division, malformed expressions, and overflow

Open NOVACalculator.xcodeproj in Xcode on macOS. GitHub Actions builds an unsigned IPA and attaches it with a source ZIP to the workflow run. The IPA must be signed before installation. The workflow result and a physical iOS 12 device test are the final compatibility checks.
