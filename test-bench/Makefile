CC = iverilog
FLAGS = -Wall
SIM=vvp

SRCS_DIR = ..

SRCS = $(SRCS_DIR)/als-pmod-controller.v \
       $(SRCS_DIR)/clock-divider.v

TEST_BENCH = als-functinal-model.v \
             tb.v

OUT = tb.out

als_test: $(SOURCES) $(TEST_BENCH)
	@$(CC) $(FLAGS) -I .. -o $(OUT) -s tb $(TEST_BENCH)
	@$(SIM) $(OUT)

clean:
	rm -vf $(OUT) *.vcd
