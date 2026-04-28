library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB is
end TB;  -- pas de ports !

architecture Behavioral of TB is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal sample_clk : std_logic := '0';
    signal Sample_in : signed(7 downto 0) := (others => '0');
    signal Sample_out : signed(7 downto 0);
    signal mux1, mux2 : unsigned(4 downto 0);
    signal en_In, en_Out : std_logic;
    signal en_acc : std_logic;
    signal resetAcc : std_logic;
    
    component UT is
        port(
            clk : in std_logic;
            rst : in std_logic;
            Sample_in : in signed(7 downto 0);
            Sample_out : out signed(7 downto 0);
            Sample_clk : in std_logic;     
            mux1, mux2 : in unsigned(4 downto 0);  
            en_In, en_Out : in std_logic;   
            en_acc : in std_logic;          
            resetAcc : in std_logic
        );
    end component;
    component UC is
        port(
            clk : in std_logic;
            rst : in std_logic;
            sample_clk : in std_logic;
            mux1, mux2 : out unsigned(4 downto 0);
            en_In, en_Out : out std_logic;
            en_acc : out std_logic;
            resetAcc : out std_logic
        );
    end component;
    begin
        UT_inst : UT
            port map (
                clk => clk,
                rst => rst,
                Sample_in => Sample_in,
                Sample_out => Sample_out,
                Sample_clk => sample_clk,
                en_In => en_In,
                en_Out => en_Out,
                en_acc => en_acc,
                resetAcc => resetAcc,
                mux1 => mux1,
                mux2 => mux2
            );
        UC_inst : UC
            port map (
                clk => clk,
                rst => rst,
                sample_clk => sample_clk,
                mux1 => mux1,
                mux2 => mux2,
                en_In => en_In,
                en_Out => en_Out,
                en_acc => en_acc,
                resetAcc => resetAcc
            );
        clk <= not clk after 161 ps;
        sample_clk <= not sample_clk after 5 ns;
        stimulus_process : process
        begin
        rst <= '1';
    
        wait for 20 ns;
        rst <= '0';
         Sample_in <= to_signed(127, 8);  -- envoie AVANT le reset
        wait for 20 ns;  -- maintiens 127 pendant plusieurs cycles
        Sample_in <= to_signed(0, 8);
        wait for 500 ns;
        wait;
        end process stimulus_process;
end Behavioral; 
