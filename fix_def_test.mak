all:
	@echo "LIBRARY dummy.dll" > test.def
	@echo "EXPORTS" >> test.def
	@echo "dummy_sym" >> test.def
