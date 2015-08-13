describe "platforms", ->
	describe "javascript", ->
		describe "int", ->
			describe "arithmetic", ->
				arithmetic = undefined
				beforeEach ->
					arithmetic = require "./arithmetic"
				describe "imports", ->
					it "makeUnary", ->
						expect(arithmetic.makeUnary).toBe require "./../../helpers/makeUnary"
					it "makeOrderedBinary", ->
						expect(arithmetic.makeOrderedBinary).toBe require "./../../helpers/makeOrderedBinary"						
					it "makeUnorderedBinary", ->
						expect(arithmetic.makeUnorderedBinary).toBe require "./../../helpers/makeUnorderedBinary"						
				describe "defines", ->
					functions = unaries = unorderedBinaries = orderedBinaries = undefined
					beforeEach ->
						makeUnary = arithmetic.makeUnary
						makeOrderedBinary = arithmetic.makeOrderedBinary
						makeUnorderedBinary = arithmetic.makeUnorderedBinary
						arithmetic.makeUnary = jasmine.createSpy()
						arithmetic.makeOrderedBinary = jasmine.createSpy()
						arithmetic.makeUnorderedBinary = jasmine.createSpy()
						unaries = {}
						arithmetic.makeUnary.and.callFake (name) ->
							toReturn = makeUnary.apply this, arguments
							unaries[name] =
								args: (argument for argument in arguments) 
								result: toReturn
							return toReturn
						orderedBinaries = {}
						arithmetic.makeOrderedBinary.and.callFake (name) ->
							toReturn = makeOrderedBinary.apply this, arguments
							orderedBinaries[name] = 
								args: (argument for argument in arguments)
								result: toReturn
							return toReturn
						unorderedBinaries = {}							
						arithmetic.makeUnorderedBinary.and.callFake (name) ->
							toReturn = makeUnorderedBinary.apply this, arguments
							unorderedBinaries[name] = 
								args: (argument for argument in arguments)
								result: toReturn
							return toReturn							
						functions = arithmetic()
						arithmetic.makeUnary = makeUnary
						arithmetic.makeOrderedBinary = makeOrderedBinary
						arithmetic.makeUnorderedBinary = makeUnorderedBinary						
					describe "add", ->
						it "is returned", ->
							add = (func for func in functions when func.name is "add")
							expect(add.length).toEqual 1
							expect(add[0]).toBe unorderedBinaries.add.result
							expect unorderedBinaries.add.args
								.toEqual ["add", "int", "int", (jasmine.any Function), (jasmine.any Function)]
						
						it "supports constant inputs", ->
							expect(unorderedBinaries.add.args[3] 7, 8).toEqual 15 
							
						it "supports native code generation", ->				
							getCode = (value) ->
								switch value
									when "Test Input A" then "Test Code A"
									when "Test Input B" then "Test Code B"
									else expect(false).toBeTruthy()
							input = 
								properties:
									a: "Test Input A"
									b: "Test Input B"	
							expect unorderedBinaries.add.args[4] getCode, input
								.toEqual "(Test Code A) + (Test Code B)"
					it "subtract", ->
						it "is returned", ->
							subtract = (func for func in functions when func.name is "subtract")
							expect(subtract.length).toEqual 1
							expect(subtract[0]).toBe orderedBinaries.subtract.result
							expect orderedBinaries.subtract.args
								.toEqual ["subtract", "int", "int", (jasmine.any Function), (jasmine.any Function)]
						
						it "supports constant inputs", ->
							expect(orderedBinaries.subtract.args[3] 7, 8).toEqual -1 						
						
						it "supports native code generation", ->
							getCode = (value) ->
								switch value
									when "Test Input A" then "Test Code A"
									when "Test Input B" then "Test Code B"
									else expect(false).toBeTruthy()
							input = 
								properties:
									a: "Test Input A"
									b: "Test Input B"	
							expect orderedBinaries.subtract.generateCode getCode, input
								.toEqual "(Test Code A) - (Test Code B)"						
					it "multiply", ->
						it "is returned", ->
							multiply = (func for func in functions when func.name is "add")
							expect(multiply.length).toEqual 1
							expect(multiply[0]).toBe unorderedBinaries.add.result
							expect unorderedBinaries.multiply.args
								.toEqual ["multiply", "int", "int", (jasmine.any Function), (jasmine.any Function)]
						
						it "supports constant inputs", ->
							expect(unorderedBinaries.multiply.args[3] 7, 8).toEqual 56 
							
						it "supports native code generation", ->				
							getCode = (value) ->
								switch value
									when "Test Input A" then "Test Code A"
									when "Test Input B" then "Test Code B"
									else expect(false).toBeTruthy()
							input = 
								properties:
									a: "Test Input A"
									b: "Test Input B"	
							expect unorderedBinaries.multiply.args[4] getCode, input
								.toEqual "(Test Code A) * (Test Code B)"
					it "divide", ->
						it "is returned", ->
							divide = (func for func in functions when func.name is "divide")
							expect(divide.length).toEqual 1
							expect(divide[0]).toBe orderedBinaries.divide.result
							expect orderedBinaries.divide.args
								.toEqual ["divide", "int", "int", (jasmine.any Function), (jasmine.any Function)]
						
						it "supports constant inputs", ->
							expect(orderedBinaries.divide.args[3] 65, 3).toEqual 22	
						
						it "supports native code generation", ->
							getCode = (value) ->
								switch value
									when "Test Input A" then "Test Code A"
									when "Test Input B" then "Test Code B"
									else expect(false).toBeTruthy()
							input = 
								properties:
									a: "Test Input A"
									b: "Test Input B"	
							expect divide[0].generateCode getCode, input
								.toEqual "(Test Code A) / (Test Code B)"												
					it "negate", ->
						it "is returned", ->
							negate = (func for func in functions when func.name is "negate")
							expect(negate.length).toEqual 1
							expect(negate[0]).toBe unaries.negate.result
							expect unaries.negate.args
								.toEqual ["negate", "int", "int", (jasmine.any Function), (jasmine.any Function)]
						
						it "supports constant inputs", ->
							expect(unaries.negate.args[3] 65).toEqual -65
						
						it "supports native code generation", ->
							getCode = (value) ->
								expect(value).toEqual "Test Input"
								"Test Code"
							expect negate[0].generateCode getCode, "Test Input"
								.toEqual "-(Test Code)"																		