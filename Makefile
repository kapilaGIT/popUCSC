rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
SH_FILES := $(call rwildcard,./,*.sh)
PBS_FILES := $(call rwildcard,./,*.pbs)
all:
	@echo ""
	@touch ../test.sql
	@touch ../test.txt
	@echo "ucscInsPkg version 0.0.1"
	@echo ""
	@echo "At the moment not much to make"
	@echo ""
	@echo "Creating folders for log files"
	@mkdir -p ../log_files;
	@mkdir -p ../error_logs;
	@echo ""
	@echo "Now I will make the following scripts executable"
	@echo ""
	@echo $(SH_FILES)
	@echo ""
	@echo "How do I do it?"
	@echo ""
	@echo "chmod 777 xxx.sh"
	@echo ""
	@echo "And here we go"
	@echo ""
	@cp default_table.txt ../
	$(foreach var,$(SH_FILES),cp $(var) ../;)
	$(foreach var,$(PBS_FILES),cp $(var) ../;)
	$(foreach var,$(SH_FILES),chmod 777 ../$(var);)
.PHONY: install; clean
install:
	@echo ""
	@echo "Good we are ready to go"
	@echo ""
	@echo "Please key the following lines, each followed by enter"
	@echo ""
	@echo "cd ../"
	@echo ""	
	@echo "./installUCSCinstance.sh -h or --help"
	@echo ""
clean:
	$(foreach var,$(SH_FILES),rm ../$(var);)
	$(foreach var,$(PBS_FILES),cp $(var) ../;)
	@if [ -d "log_files" ]; then \
	echo "log_files folder exists"; \
	rm -r ../log_files/; \
	else \
	echo "log_files folder does not exists"; \
	fi
	@if [ -d "error_logs" ]; then \
	echo "error_logs folder exists"; \
	rm -r ../error_logs/; \
	else \
	echo "error_logs folder does not exists"; \
	fi
	@if [ -e "test.txt" ]; then \
	echo "test files exist"; \
	rm ../test.sql ../test.txt; \
	else \
	echo "test files do not exist"; \
	fi
