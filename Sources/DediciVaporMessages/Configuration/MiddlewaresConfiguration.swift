//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MiddlewaresConfiguration: AppConfiguration {
    func configure(_ application: Application) throws {
        let middlewares: [Middleware] = [
            MessageExpirationMiddleware(),
        ]

        middlewares.forEach { application.middleware.use($0) }
    }
}
