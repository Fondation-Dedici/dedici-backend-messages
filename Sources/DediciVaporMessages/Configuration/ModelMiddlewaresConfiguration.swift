//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct ModelMiddlewaresConfiguration: AppConfiguration {
    func configure(_ application: Application) throws {
        let middlewares: [AnyModelMiddleware] = [
            ResourceModelMiddleware<Message>(),
        ]

        middlewares.forEach { application.databases.middleware.use($0) }
    }
}
