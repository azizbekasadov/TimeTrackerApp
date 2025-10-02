//
//  TimeFormatTests.swift
//  TimeTrackerAppTests
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import Testing

@testable import TimeTrackerApp

@Suite("TimeFormatTests")
struct TimeFormatTests {
    
    @Test("test_roundtrip_parse_then_hhmm_then_parse")
    @MainActor
    func roundtripParseFormatHHMMAndParse() async {
        let samples = [
            "2", "8.5", "0.25", "10",
            "15", "99", "150",
            "02:00", "08:30", "00:15", "2:05"
        ]

        for s in samples {
            guard let minutes = TimeFormat.parse(s) else {
                Issue.record("Expected parse to succeed for \(s)")
                continue
            }
            let hhmm = TimeFormat.hhmm(from: minutes)
            let reparsed = TimeFormat.parse(hhmm)
            #expect(reparsed == minutes, "Roundtrip failed for \(s) -> \(hhmm)")
        }
    }
    
    @Test("test_roundtrip_parse_then_hhmm_then_parse")
    @MainActor
    func test_parse_invalidFormats_returnNil() async {
        #expect((TimeFormat.parse("") == nil))
        #expect(TimeFormat.parse("   ") == nil)
        #expect(TimeFormat.parse("abc") == nil)
        #expect(TimeFormat.parse("2::30") == nil)
        #expect(TimeFormat.parse("2:75") == nil)
        #expect(TimeFormat.parse("2: -1") == nil)
        #expect(TimeFormat.parse("10:") == nil)
        #expect(TimeFormat.parse(":10") == nil)
        #expect(TimeFormat.parse("8.5.1") == nil)
    }
        
}
