library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB is
end TB;  -- pas de ports !

architecture Behavioral of TB is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal Sample_in : signed(7 downto 0) := (others => '0');
    signal Sample_out : signed(7 downto 0);
    
    component TP_part1
        port(
            clk : in std_logic;
            rst : in std_logic;
            Sample_in : in signed(7 downto 0);
            Sample_out : out signed(7 downto 0)
        );
    end component;
    begin
        UT_inst : TP_part1
            port map (
                clk => clk,
                rst => rst,
                Sample_in => Sample_in,
                Sample_out => Sample_out
            );
        clk <= not clk after 5 ns;
        stimulus_process : process
        begin
            rst <= '1';
            wait for 20 ns;
            rst <= '0';
            wait for 20 ns;
            Sample_in <= to_signed(127, 8);
            wait for 10  ns;
            Sample_in <= to_signed(0, 8);
            wait for 10  ns;
            Sample_in <= to_signed(0, 8);
            wait for 310  ns;
            wait; -- fin de la simulation
        end process stimulus_process;
end Behavioral; 
