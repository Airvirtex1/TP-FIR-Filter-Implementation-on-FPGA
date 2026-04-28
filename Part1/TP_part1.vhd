library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TP_part1 is
    port(
        clk : in std_logic;
        rst : in std_logic;
        Sample_in : in signed(7 downto 0);
        Sample_out : out signed(7 downto 0)
    );
end TP_part1;

architecture Behavioral of TP_part1 is

    type rom_type is array (0 to 30) of signed(7 downto 0);
    constant coeffs : rom_type := (
        to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8),
        to_signed(1, 8), to_signed(1, 8), to_signed(1, 8), to_signed(-1, 8), to_signed(-3, 8), to_signed(-3, 8),
        to_signed(2, 8), to_signed(9, 8), to_signed(16, 8), to_signed(19, 8), to_signed(16, 8), to_signed(9, 8),
        to_signed(2, 8), to_signed(-3, 8), to_signed(-3, 8), to_signed(-1, 8), to_signed(1, 8), to_signed(1, 8),
        to_signed(1, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8),
        to_signed(0, 8)
    );
    type ram_type is array (0 to 30) of signed(7 downto 0);
    signal samples : ram_type;
    begin 
        decale : process(clk, rst)
        begin
            if rst = '1' then
                samples <= (others => (others => '0'));
            elsif rising_edge(clk) then
                for i in 30 downto 1 loop
                    samples(i) <= samples(i-1);
                end loop;
                samples(0) <= Sample_in;
            end if;
        end process decale;
        fir : process(samples)
            variable acc : signed(20 downto 0);
        begin
            acc := (others => '0');
            for i in 0 to 30 loop
                acc := acc + resize(samples(i) * coeffs(i), acc'length);    
            end loop;
            Sample_out <= resize(shift_right(acc, 7), 8);
        end process fir;
end Behavioral;

        