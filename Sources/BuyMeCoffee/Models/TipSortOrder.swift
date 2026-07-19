import Foundation

/// The order in which tip products are displayed, sorted by price.
public enum TipSortOrder: Sendable, Equatable {
    /// Smallest price first, ascending to the highest.
    case ascending
    /// Highest price first, descending to the smallest.
    case descending
}
