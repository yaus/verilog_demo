# Assignment 002
To demonstrate ability of writing a useful code. This assignment require to design a synchronous FIFO.
The assign provided a memory model. To compile the FIFO design, few signal require to be implemented.

## FIFO signals & Parameter
| Parameter | Description |
| -         | -           |
| WID       | data bus width | 
| DEPTH     | FIFO depth  |
| DEP_WID   | ceiling(log2(FIFO depth0)) |

| Bus/Signals | Width | Description |
| ----------- | ------| ----------- |
| full        | 1     | indicate no space to push the new data |
| empty       | 1     | indicate no data in the memory |
| din         | WID**     | data input port |
| din_push    | 1     | data input valid | 
| dout        | WID**     | data output port |
| dout_pop    | 1| data output acquired | 

** as input parameter 