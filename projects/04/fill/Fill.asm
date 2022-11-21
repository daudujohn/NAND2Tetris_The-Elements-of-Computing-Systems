// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

//Turns screen to black
//      row_addr = SCREEN
//		for (col = 0; col < max_col; col++) {
//          row = 0
//			for (row = 0; row < max_row; row += 32) {
//				//set each word to -1
//              row_addr = row_addr + row + col
//				RAM[row_addr] = -1
//				row_addr = SCREEN
//			}
//		}
(LISTEN)
    @SCREEN
    D = A
    @rowAddr
    M = D 	//rowAddr = 16384, SCREEN
    @col
    M = 0 	//col = 0
    @row
    M = 0 	//row = 0
    @32
    D = A
    @max_col
    M = D 	//max_col = 32
    @8192
    D = A
    @max_row
    M = D 	//max_row = 8192
    @colour
    M = 0   //colour to white
    @KBD
    D = M   //probe the keyboard 
    @COLLOOP
    D; JEQ  //goto COLLOOP if no key is pressed

    @colour
    M = -1  //colour to black if key is pressed

    //color screen
    (COLLOOP)
        @col
        D = M
        @max_col
        D = D - M
        @LISTEN
        D; JGE	//if col >= max_col goto END

        @row
        M = 0 	//reset row = 0

        (ROWLOOP)
            @row
            D = M
            @max_row
            D = D - M
            @ADDTOCOL
            D; JGE 	//if row >= max_row goto ADDTOCOL

            @row
            D = M
            @rowAddr
            M = D + M
            @col
            D = M
            @rowAddr
            M = D + M   //rowAddr = rowAddr + row + col
            
                    @colour
                    D = M 	
                    @rowAddr
                    A = M
                    M = D   //RAM[rowAddr] = colour
                @ADDTOROW
                0; JMP  //goto ADDTOROW

            (ADDTOROW)
            @SCREEN
            D = A
            @rowAddr
            M = D 	// reset rowAddr = 16384, SCREEN
            @32
            D = A
            @row
            M = D + M 	//row = row + 32
        @ROWLOOP
        0; JMP 	//goto ROWLOOP

        (ADDTOCOL)
        @col
        M = M + 1 	//col = col + 1
    @COLLOOP
    0; JMP 	//goto COLLOOP