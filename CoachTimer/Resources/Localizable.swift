// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum App {
    /// CoachTimer
    internal static let name = L10n.tr("Localizable", "app.name")
    internal enum Search {
      /// owner
      internal static let owner = L10n.tr("Localizable", "app.search.owner")
      /// repo
      internal static let repo = L10n.tr("Localizable", "app.search.repo")
      internal enum Button {
        /// cancel
        internal static let cancel = L10n.tr("Localizable", "app.search.button.cancel")
        /// search
        internal static let search = L10n.tr("Localizable", "app.search.button.search")
      }
    }
    internal enum Stargazers {
      /// not found
      internal static let notfound = L10n.tr("Localizable", "app.stargazers.notfound")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
