CC=iverilog
EX=vvp
VIEWER=gtkwave
TARGET_LX2=${TARGET}.lx2
TARGET_VVP=${TARGET}.vvp


.PHONY: run view clean 

%.vvp:
	$(CC) -f ${TARGET}.f -o ${TARGET}.vvp

%.lx2: %.vvp
	$(EX) $*.vvp -lxt2 
	mv dump.lx2 $*.lx2	

run: ${TARGET_LX2}


view: $(TARGET_VVP) $(TARGET_LX2)
	$(VIEWER) $(TARGET_LX2)

clean:
	rm -rf *.vvp *.lxt *.lx2 *.vcd
