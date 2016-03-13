-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
port( addr: in std_logic_vector(5 downto 0);
	output: out std_logic_vector(17 downto 0)
);
end entity;

architecture struct of rom is

    -- conditions 
    -- 1  11
    -- Z  00  
    -- nZ 01
    -- xx 10

    -- branch types
    -- JUMP 00
    -- MAP  10  
    -- CALL 01
    -- RET  11

   --         M1              M2              M3  
   -- 0000    NOP         000 NOP         0   NOP 
   -- 0001    ARIN        001 PCIN        1   DRM 
   -- 0010    ARDT        010 PCDT                
   -- 0011    ARPC        011 IRDR                
   -- 0100    ACIN        100 RAC             
   -- 0101    ACZO        101 MDR             
   -- 0110    ACR         110 DRAC                
   -- 0111    ACDR        111 ZALU                
   -- 1000    MINU                            
   -- 1001    PLUS                            
   -- 1010    AND                         
   -- 1011    OR                          
   -- 1100    XOR                         
   -- 1101    NOT                         
   -- 1110    TRDR                            
   -- 1111    ERROR                           

type mem is array (0 to 63) of std_logic_vector(17 downto 0); 
constant microcode : mem := ( 
--location => bt & condition & M1 & M2 & M3 & next address
0 => "00" & "11" & "0000" & "000" & "0" & "000001",
1 => "00" & "11" & "0011" & "000" & "0" & "000010",
2 => "00" & "11" & "0000" & "001" & "1" & "000011",
3 => "10" & "10" & "0011" & "011" & "0" & "000001",
4 => "01" & "11" & "0000" & "000" & "0" & "001101",
5 => "00" & "11" & "0000" & "000" & "1" & "000110",
6 => "00" & "11" & "0111" & "000" & "0" & "000001",
7 => "00" & "11" & "1111" & "000" & "0" & "000111",
8 => "01" & "11" & "0000" & "000" & "0" & "001101",
9 => "00" & "11" & "0000" & "110" & "0" & "001010",
10 => "00" & "11" & "0000" & "101" & "0" & "000001",
11 => "00" & "11" & "1111" & "000" & "0" & "000111",
12 => "00" & "11" & "0000" & "100" & "0" & "000001",
13 => "00" & "11" & "0001" & "001" & "1" & "001110",
14 => "00" & "11" & "0000" & "001" & "1" & "001111",
15 => "11" & "10" & "0010" & "000" & "0" & "000001",
16 => "00" & "11" & "0110" & "000" & "0" & "000001",
17 => "00" & "11" & "1111" & "000" & "0" & "000111",
18 => "00" & "11" & "1111" & "000" & "0" & "000111",
19 => "00" & "11" & "1111" & "000" & "0" & "000111",
20 => "00" & "11" & "0001" & "000" & "1" & "010101",
21 => "00" & "11" & "1110" & "000" & "1" & "010110",
22 => "00" & "11" & "0000" & "010" & "0" & "000001",
23 => "00" & "11" & "1111" & "000" & "0" & "000111",
24 => "00" & "00" & "0000" & "000" & "0" & "010100",
25 => "00" & "11" & "0000" & "001" & "0" & "011010",
26 => "00" & "11" & "0000" & "001" & "0" & "000001",
27 => "00" & "11" & "1111" & "000" & "0" & "000111",
28 => "00" & "01" & "0000" & "000" & "0" & "010100",
29 => "00" & "11" & "0000" & "001" & "0" & "011010",
30 => "00" & "11" & "1111" & "000" & "0" & "000111",
31 => "00" & "11" & "1111" & "000" & "0" & "000111",
32 => "00" & "11" & "1001" & "111" & "0" & "000001",
33 => "00" & "11" & "1111" & "000" & "0" & "000111",
34 => "00" & "11" & "1111" & "000" & "0" & "000111",
35 => "00" & "11" & "1111" & "000" & "0" & "000111",
36 => "00" & "11" & "1000" & "111" & "0" & "000001",
37 => "00" & "11" & "1111" & "000" & "0" & "000111",
38 => "00" & "11" & "1111" & "000" & "0" & "000111",
39 => "00" & "11" & "1111" & "000" & "0" & "000111",
40 => "00" & "11" & "0100" & "111" & "0" & "000001",
41 => "00" & "11" & "1111" & "000" & "0" & "000111",
42 => "00" & "11" & "1111" & "000" & "0" & "000111",
43 => "00" & "11" & "1111" & "000" & "0" & "000111",
44 => "00" & "11" & "0101" & "111" & "0" & "000001",
45 => "00" & "11" & "1111" & "000" & "0" & "000111",
46 => "00" & "11" & "1111" & "000" & "0" & "000111",
47 => "00" & "11" & "1111" & "000" & "0" & "000111",
48 => "00" & "11" & "1010" & "111" & "0" & "000001",
49 => "00" & "11" & "1111" & "000" & "0" & "000111",
50 => "00" & "11" & "1111" & "000" & "0" & "000111",
51 => "00" & "11" & "1111" & "000" & "0" & "000111",
52 => "00" & "11" & "1011" & "111" & "0" & "000001",
53 => "00" & "11" & "1111" & "000" & "0" & "000111",
54 => "00" & "11" & "1111" & "000" & "0" & "000111",
55 => "00" & "11" & "1111" & "000" & "0" & "000111",
56 => "00" & "11" & "1100" & "111" & "0" & "000001",
57 => "00" & "11" & "1111" & "000" & "0" & "000111",
58 => "00" & "11" & "1111" & "000" & "0" & "000111",
59 => "00" & "11" & "1111" & "000" & "0" & "000111",
60 => "00" & "11" & "1101" & "111" & "0" & "000001",
61 => "00" & "11" & "1111" & "000" & "0" & "000111",
62 => "00" & "11" & "1111" & "000" & "0" & "000111",
63 => "00" & "11" & "1111" & "000" & "0" & "000111"
); 


begin

output <= microcode(to_integer(unsigned(addr)));


end architecture;
