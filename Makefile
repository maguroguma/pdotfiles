# 色の定義
RESET := \033[0m
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m

.PHONY: help

help: ## このヘルプメッセージを表示
	@echo "$(BOLD)$(PROJECT_NAME) $(VERSION)$(RESET)"
	@echo ""
	@echo "$(BOLD)使用可能なコマンド:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)使用例:$(RESET)"
	@echo "  make setup    # 初期セットアップ"
	@echo "  make build    # プロジェクトをビルド"
	@echo "  make test     # テストを実行"
