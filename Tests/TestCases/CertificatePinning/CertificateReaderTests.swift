import Testing
import QuickHatchHTTP
import Foundation

struct CertificateReaderTests {
    
    @Test
    func open_whenFileNotFoundInBundle_expectNilResult() throws {
        let sut = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
        
        #expect(throws: CertificateError.pathNotFound, "Path not found in main bundle") {
            try sut.open(name: "nonexistentFile", type: "pem", bundle: Bundle.module)
        }
    }
    
    @Test
    func open_whenPathIsCorrectInBundle_expectFileOpenedCorrectly() throws {
        let sut = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
        
        let resultGenerator = { try sut.open(name: "certificate", type: "der", bundle: .module) }
        let result = try #require(try resultGenerator())
        
        #expect(result != nil)
    }
    
    @Test
    func openContent_whenFileInCorrectFormatAndPathCorrect_expectContentLoaded() throws {
        let sut = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
        
        let result = try sut.openContent(name: "cacert", type: "pem", bundle: .module)
        
        #expect(result != nil)
    }
    
    @Test
    func openContent_whenFileDoesntExistInMainBundle_expectError() throws {
        let sut = QHCertificateReader(logger: Log(LogsShortcuts.certificatePinner))
        
        #expect(throws: CertificateError.pathNotFound, "Path not found in main bundle") {
            try sut.openContent(name: "nonexistentFile", type: "pem", bundle: Bundle.module)
        }
    }

}
