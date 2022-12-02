//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import Vapor

public struct PublicConfiguration: Codable {
    public static let current: PublicConfiguration = {
        do {
            let messageMaximumContentSize = try Environment.require(
                key: "MESSAGE_MAX_CONTENT_SIZE",
                using: Int.init
            )
            let messageMaximumHeadersSize = try Environment.require(
                key: "MESSAGE_MAX_HEADERS_SIZE",
                using: Int.init
            )
            let messageMaximumMaxAge = try Environment.require(
                key: "MESSAGE_MAX_MAX_AGE",
                using: Int.init
            )
            let messageDefaultMaxAge = try Environment.require(
                key: "MESSAGE_DEFAULT_MAX_AGE",
                using: Int.init
            )

            return PublicConfiguration(
                messageMaximumContentSize: messageMaximumContentSize,
                messageMaximumHeadersSize: messageMaximumHeadersSize,
                messageMaximumMaxAge: messageMaximumMaxAge,
                messageDefaultMaxAge: messageDefaultMaxAge
            )

        } catch {
            fatalError("Failed to load configuration because: \(error)")
        }
    }()

    public let messageMaximumContentSize: Int
    public let messageMaximumHeadersSize: Int
    public let messageMaximumMaxAge: Int
    public let messageDefaultMaxAge: Int
}
