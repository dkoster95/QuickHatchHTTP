import Testing
import QuickHatchHTTP
import Foundation

struct CertificatePinningStrategyTests {

    @Test(arguments: [(Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate), true),
                      (Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.davinciCertificate), false)])
    func validate_expectCertificateValidation(certificate: URLAuthenticationChallenge, testResult: Bool) throws {
        let sut = sut()
        let serverTrust = try #require(certificate.protectionSpace.serverTrust)
        
        let result = sut.validate(serverTrust: serverTrust)
        
        #expect(testResult == result)
    }
    
    private func sut() -> CertificatePinningStrategy {
        let sut = CertificatePinningStrategy(certificateBuilders: [ { return Stubs.CertificatePinner.certificate! } ])
        return sut
    }

}
