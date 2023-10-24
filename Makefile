PACKAGE_NAME  := descent
CONDA_ENV_RUN := conda run --no-capture-output --name $(PACKAGE_NAME)

.PHONY: pip-install env lint format test test-examples

pip-install:
	$(CONDA_ENV_RUN) pip install --no-build-isolation --no-deps -e .

env:
	mamba create     --name $(PACKAGE_NAME)
	mamba env update --name $(PACKAGE_NAME) --file devtools/envs/base.yaml
	$(CONDA_ENV_RUN) pip install --no-build-isolation --no-deps -e .
	$(CONDA_ENV_RUN) pre-commit install || true

lint:
	$(CONDA_ENV_RUN) isort --check-only $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) black --check      $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) flake8             $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) nbqa isort   --check-only  examples
	$(CONDA_ENV_RUN) nbqa black   --check       examples
	$(CONDA_ENV_RUN) nbqa flake8  --ignore=E402 examples

format:
	$(CONDA_ENV_RUN) isort  $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) black  $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) flake8 $(PACKAGE_NAME)
	$(CONDA_ENV_RUN) nbqa isort                examples
	$(CONDA_ENV_RUN) nbqa black                examples
	$(CONDA_ENV_RUN) nbqa flake8 --ignore=E402 examples

test:
	$(CONDA_ENV_RUN) pytest -v --cov=$(PACKAGE_NAME) --cov-report=xml --color=yes $(PACKAGE_NAME)/tests/
