@testable import GridCollectionView
import Quick
import Nimble

class MatrixSpec: QuickSpec {
    override func spec() {

        var sut: Matrix<Int>!

        describe("initialisation") {

            describe("valid parameters") {

                it("returns a non-nil object") {
                    sut = Matrix(columns: 0, rows: 0, items: [])
                    expect(sut).toNot(beNil())
                }

                it("returns a non-nil object") {
                    sut = Matrix(columns: 1, rows: 1, items: [2])
                    expect(sut).toNot(beNil())
                }

                it("returns a non-nil object") {
                    sut = Matrix(columns: 3, rows: 1, items: [3, 2, 1])
                    expect(sut).toNot(beNil())
                }

                it("returns a non-nil object") {
                    sut = Matrix(columns: 1, rows: 3, items: [3, 2, 1])
                    expect(sut).toNot(beNil())
                }
            }

            describe("invalid parameters") {

                it("returns a nil object") {
                    sut = Matrix(columns: 1, rows: 1, items: [2, 2])
                    expect(sut).to(beNil())
                }

                it("returns a nil object") {
                    sut = Matrix(columns: 1, rows: 0, items: [])
                    expect(sut).to(beNil())
                }

                it("returns a nil object") {
                    sut = Matrix(columns: 0, rows: 1, items: [])
                    expect(sut).to(beNil())
                }
            }
        }

        describe("subscript") {
            beforeEach {
                sut = Matrix(columns: 3, rows: 4, items: [1, 2, 3, 4,
                                                          5, 6, 7, 8,
                                                        100, 20, 55, 32]
                )

            }

            describe("valid parameters") {

                it("returns a non-nil object") {
                    expect(sut[0, 0]).to(equal(1))
                    expect(sut[0, 3]).to(equal(4))
                    expect(sut[1, 1]).to(equal(6))
                    expect(sut[2, 2]).to(equal(55))
                }
            }

            describe("invalid parameters") {

                it("throws an assertion") {
                    expect(sut[0, 4]).to(throwAssertion())
                    expect(sut[3, 0]).to(throwAssertion())
                }
            }
        }
    }
}
