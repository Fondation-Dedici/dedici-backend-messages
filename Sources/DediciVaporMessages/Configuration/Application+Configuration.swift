//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporToolbox
import Vapor

extension Application {
    public func configure() throws {
        try apply(DatabaseConfiguration())
            .apply(MiddlewaresConfiguration())
            .apply(MigrationsConfiguration())
            .apply(RoutesConfiguration())
            .apply(ContentConfiguration())
    }
}
