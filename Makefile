.PHONY: format format-check format-diff help

# Find all C and H files in main/ directory only
# Exclude components/ (vendor library code), build/, managed_components/, etc.
C_FILES := $(shell find main -type f \( -name "*.c" -o -name "*.h" \) 2>/dev/null)

# Find all JS files in main/webapp/ and process-cli/ directories
JS_FILES := $(shell find main/webapp process-cli -type f -name "*.js" 2>/dev/null | grep -v node_modules)

help:
	@echo "Available targets:"
	@echo "  format        - Format all C/H/JS files with clang-format and prettier"
	@echo "  format-check  - Check if files need formatting (non-zero exit if changes needed)"
	@echo "  format-diff   - Show what would change without modifying files"

format:
	@echo "Formatting C/H files..."
	@clang-format -i $(C_FILES)
	@echo "Done! Formatted $(words $(C_FILES)) C/H files."
	@echo "Formatting JS files..."
	@npx prettier --write $(JS_FILES)
	@echo "Done! Formatted $(words $(JS_FILES)) JS files."

format-check:
	@echo "Checking C/H files formatting..."
	@clang-format --dry-run --Werror $(C_FILES)
	@echo "Checking JS files formatting..."
	@npx prettier --check $(JS_FILES)
	@echo "All files are properly formatted!"

format-diff:
	@echo "Showing formatting differences for C/H files..."
	@for file in $(C_FILES); do \
		echo "=== $$file ==="; \
		clang-format "$$file" | diff -u "$$file" - || true; \
	done
	@echo "Showing formatting differences for JS files..."
	@for file in $(JS_FILES); do \
		echo "=== $$file ==="; \
		npx prettier "$$file" | diff -u "$$file" - || true; \
	done
