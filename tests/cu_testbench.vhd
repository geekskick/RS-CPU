library ieee;
library xil_defaultlib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use xil_defaultlib.cpu_constants.all;
use xil_defaultlib.control_unit_constants.all;
use xil_defaultlib.alu_commands.all;

entity cu_testbench is
end cu_testbench;

architecture Behavioral of cu_testbench is
    
    component top_model_cu is
        port( 
            z       : in  std_logic;
            clk     : in  std_logic;
            ir      : in  std_logic_vector(IR_WIDTH-1 downto 0); -- instruction register low nibble + 1
            error   : out std_logic;
            arload  : out std_logic;
            arinc   : out std_logic;
            rd      : out std_logic;
            wr      : out std_logic; 
            membus  : out std_logic;
            busmem  : out std_logic;
            pcinc   : out std_logic;
            pcload  : out std_logic;
            pcbus   : out std_logic;
            drlbus  : out std_logic;
            drhbus  : out std_logic;
            drload  : out std_logic;
            trload  : out std_logic; 
            trbus   : out std_logic;
            irload  : out std_logic;
            rload   : out std_logic; 
            rbus    : out std_logic;
            acload  : out std_logic;
            acbus   : out std_logic;
            zload   : out std_logic;
            alu_cmd : out alu_commands_t
        );
    end component;
    
    constant ldac   : std_logic_vector(7 downto 0) := X"01";
    constant period : time                         := 200ns;
    signal stop     : boolean                      := false;
    
    
    signal z       : std_logic;
    signal clk     : std_logic;
    signal ir      : std_logic_vector(IR_WIDTH-1 downto 0);
    signal error   : std_logic;
    signal arload  : std_logic;
    signal arinc   : std_logic;
    signal rd      : std_logic;
    signal wr      : std_logic;
    signal membus  : std_logic;
    signal busmem  : std_logic;
    signal pcinc   : std_logic;
    signal pcload  : std_logic;
    signal pcbus   : std_logic;
    signal drlbus  : std_logic;
    signal drhbus  : std_logic;
    signal drload  : std_logic;
    signal trload  : std_logic;
    signal trbus   : std_logic;
    signal irload  : std_logic;
    signal rload   : std_logic;
    signal rbus    : std_logic;
    signal acload  : std_logic;
    signal acbus   : std_logic;
    signal zload   : std_logic;
    signal alu_cmd : alu_commands_t;
    
    
begin
    uut : top_model_cu port map(
        z       => z,
        clk     => clk,
        ir      => ir,
        error   => error,
        arload  => arload,
        arinc   => arinc,
        rd      => rd,
        wr      => wr,
        membus  => membus,
        busmem  => busmem,
        pcinc   => pcinc,
        pcload  => pcload,
        pcbus   => pcbus,
        drlbus  => drlbus,
        drhbus  => drhbus,
        drload  => drload,
        trload  => trload,
        trbus   => trbus,
        irload  => irload,
        rload   => rload,
        rbus    => rbus,
        acload  => acload,
        acbus   => acbus,
        zload   => zload,
        alu_cmd => alu_cmd
    );
    
    
    clk_tick : process
    begin
        while stop = false loop
            clk <= '1';
            wait for period/2;
            clk <= '0';
            wait for period/2;
        end loop;
        wait;
    end process;
    
    stim : process
    begin
        -- LDAC
        ir <= "00001"; 
        
        -- allow for rising edge to be detected on first tick
        -- FETCH1
        wait for period/4;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        --FETCH2 
        wait for period;
--report "FETCH2";
        assert MEMBUS = '1' report "MEMBUS incorrect in FETCH2 : " & std_logic'image(MEMBUS)  severity failure;
        assert PCINC = '1' report "PCINC"  severity failure;
        assert DRLOAD = '1' report "DRLOAD"  severity failure;
        assert rd = '1' report "RD"  severity failure;
        
        -- FETCH3
        wait for period;
--report "FETCH3";
        assert PCBUS = '1' report "PCBUS"  severity failure;
        assert IRLOAD = '1' report "IRLOAD"  severity failure;
        assert ARLOAD = '1' report "ARLOAD" severity failure;
        
        --LDAC0
        wait for period;
--report "LDAC0";
        
        -- LDAC 1
        wait for period;
--report "LDAC1";
        assert DRLOAD = '1' report "DRLOAD"  severity failure;
        assert MEMBUS = '1' report "MEMBUS"  severity failure;
        assert rd = '1' report "RD"  severity failure;
        assert PCINC = '1' report "PCINC"  severity failure;
        assert ARINC = '1' report "ARINC"  severity failure;
        
        -- LDAC 2
        wait for period;
--report "LDAC2";
        assert TRLOAD = '1' report "TRLOAD"  severity failure;
        assert DRLOAD = '1' report "DRLOAD"  severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert Rd = '1' report "RD" severity failure;
        assert PCINC = '1' report "PCINC" severity failure;
        
        -- LDAC 3
        wait for period;
--report "LDAC3";
        assert ARLOAD = '1' report "ARLOAD" severity failure;
        assert TRBUS = '1' report "TRBUS" severity failure;
        assert DRHBUS = '1' report "DRHBUS" severity failure;
        
        --LDAC 4
        wait for period;
--report "LDAC4";
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        
        --LDAC 5
        wait for period;
--report "LDAC5";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert DRLBUS = '1' report "DRLBUS" severity failure;
        assert alu_cmd = alu_op2_thru report "ALU command" severity failure;
        
        --FETCH1
        ir <= "00000";
        wait for period;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        wait for period;
--report "NOP";
        assert error = '0' and ARLOAD = '0' and ARINC= '0' and RD= '0' and WR= '0' and MEMBUS = '0' and BUSMEM = '0' and PCINC= '0' and PCLOAD= '0' and PCBUS= '0' and DRLBUS= '0' and DRHBUS= '0' and DRLOAD= '0' and TRLOAD= '0' and TRBUS= '0' and IRLOAD= '0' and RLOAD= '0' and RBUS= '0' and ACLOAD= '0' and ACBUS = '0' and ZLOAD = '0' severity failure;
        
        --FETCH1
        ir <= "00010";
        wait for period;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        wait for period;
--report "STAC0";
        
        wait for period;
--report "STAC1";
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD";
        assert PCINC = '1' report "PCINC";
        assert ARINC = '1' report "ARINC";
        
        wait for period;
--report "STAC2";
        assert TRLOAD = '1' report "TRLOAD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert PCINC = '1' report "PCINC" severity failure;
        
        wait for period;
--report "STAC3" severity failure;
        assert ARLOAD = '1' report "ARLOAD" severity failure;
        assert TRBUS = '1' report "TRBUS" severity failure;
        assert DRHBUS = '1' report "DRHBUS" severity failure;
        
        wait for period;
--report "STAC4";
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        assert ACBUS = '1' report "ACBUS" severity failure;
        
        wait for period;
--report "STAC5";
        assert DRLBUS = '1' report "DRLBUS" severity failure;
        assert BUSMEM = '1' report "BUSMEM" severity failure;
        assert WR = '1' report "WR" severity failure;
        
        --FETCH1
        ir <= "00011"; --MVAC
        wait for period;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        wait for period;
--report "MVAC1";
        assert RLOAD = '1' report "RLOAD" severity failure;
        assert ACBUS = '1' report "ACBUS" severity failure;
        assert ALU_CMD = alu_dont_care report "ALU_CMD cmds" severity failure;
        
        ir <= "00100"; --MOVR
        wait for period;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        wait for period;
--report "MOVR1";
        assert RBUS = '1' report "RBUS" severity failure;
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_op2_thru report "ALU_CMD cmds" severity failure;
        
        wait for period;
        ir <= "00101"; -- JMP1
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        wait for period;
--report "JMP1";
        assert ARINC = '1' report "ARINC" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
--report "JMP2";
        assert TRLOAD = '1' report "TRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
--report "JMP3";
        assert PCLOAD = '1' report "PCLOAD" severity failure;
        assert TRBUS = '1' report "TRBUS" severity failure;
        assert DRHBUS = '1' report "DRLBUS" severity failure;
        
        wait for period;
        ir <= "00110"; -- JMPZ
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
--report "FETCH3";
        
        z <= '0';
        wait for period;
--report "JMPZ";
        
        wait for period;
--report "JMPZN1";
        assert PCINC = '1' report "PCINC" severity failure;
        
        wait for period;
--report "JMPZN2";
        assert PCINC = '1' report "PCINC";
        
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        z <= '1';
        
        wait for period;
----report "JMPZ";
        
        wait for period;
----report "JMPZY1";
        assert ARINC = '1' report "ARINC" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
----report "JMPZY2";
        assert TRLOAD = '1' report "TRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
----report "JMPZY3";
        assert PCLOAD = '1' report "PCLOAD" severity failure;
        assert TRBUS = '1' report "TRBUS" severity failure;
        assert DRHBUS = '1' report "DRHBUS" severity failure;
        
        wait for period;
        ir <= "00111"; -- JMPNZ
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        z <= '0';
        wait for period;
----report "JMPNZ";
        
        wait for period;
----report "JMPNZY1";
        assert ARINC = '1' report "ARINC" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
----report "JMPNZY2";
        assert TRLOAD = '1' report "TRLOAD" severity failure;
        assert MEMBUS = '1' report "MEMBUS" severity failure;
        assert RD = '1' report "RD" severity failure;
        assert DRLOAD = '1' report "DRLOAD" severity failure;
        
        wait for period;
----report "JMPNZY3";
        assert PCLOAD = '1' report "PCLOAD" severity failure;
        assert TRBUS = '1' report "TRBUS" severity failure;
        assert DRHBUS = '1' report "DRHBUS" severity failure;
        
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        z <= '1';
        wait for period;
----report "JMPNZ";
        
        wait for period;
----report "JMPNZY1";
        assert PCINC = '1' report "PCINC" severity failure;
        
        wait for period;
----report "JMPNZY2";
        assert PCINC = '1' report "PCINC" severity failure;
        
        ir <= "01000"; --ADD
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "ADD1";
        assert RBUS = '1' report "RBUS";
        assert ACLOAD = '1' report "ACLOAD";
        assert ALU_CMD = alu_add1 report "ALU_CMD" severity failure;
        
        ir <= "01001"; --ADD
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "SUB1";
        assert RBUS = '1' report "RBUS" severity failure;
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_sub1 report "ALU_CMD" severity failure;
        
        ir <= "01010"; --INAC
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "INAC1";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_inac1 report "ALU_CMD" severity failure;
        
        ir <= "01011"; --CLAC
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
--report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "CLAC1";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_clac1 report "ALU_CMD" severity failure;
        
        ir <= "01100"; --AND
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "AND1";
        assert RBUS = '1' report "RBUS" severity failure;
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_and1 report "ALU_CMD" severity failure;
        
        ir <= "01101"; --OR
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "OR1";
        assert RBUS = '1' report "RBUS" severity failure;
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_or1 report "ALU_CMD" severity failure;
                
        ir <= "01110"; -- XOR
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
----report "FETCH3";
        
        wait for period;
----report "XOR1";
        assert RBUS = '1' report "RBUS" severity failure;
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_xor1 report "ALU_CMD"  severity failure;
        
        ir <= "01111"; --NOT
        wait for period;
----report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
----report "FETCH2";
        
        wait for period;
        --report "FETCH3";
        
        wait for period;
        --report "NOT1";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_not1 report "ALU_CMD" severity failure;
        
        ir <= "10000"; --LSHIFT
        wait for period;
        --report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
        --report "FETCH2";
        
        wait for period;
        --report "FETCH3";
        
        wait for period;
        --report "LSHIFT";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_lshift report "LSHIFT ALU_CMD" severity failure;
        
        ir <= "10001"; --RSHIFT
        wait for period;
--report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        
        wait for period;
        --report "FETCH2";
        
        wait for period;
        --report "FETCH3";
        
        wait for period;
        --report "RSHIFT";
        assert ACLOAD = '1' report "ACLOAD" severity failure;
        assert ALU_CMD = alu_rshift report "RSHIFT ALU_CMD" severity failure;
        
        wait for period;
        --report "FETCH1";
        assert PCBUS = '1' report "PCBUS incorrect in FETCH1   : " & std_logic'image(PCBUS) severity failure;
        assert ARLOAD = '1' report "ARLOAD incorrect in FETCH1 : " & std_logic'image(ARLOAD) severity failure;
        stop <= true;
        report "-------------DONE--------------";
        wait;
    end process;
    
end Behavioral;
